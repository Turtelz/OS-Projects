//
// File-system system calls.
// Mostly argument checking, since we don't trust
// user code, and calls into file.c and fs.c.
//

#include "types.h"
#include "defs.h"
#include "param.h"
#include "stat.h"
#include "mmu.h"
#include "proc.h"
#include "fs.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "file.h"
#include "fcntl.h"
#include "buf.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}

int
sys_dup(void)
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}

int
sys_read(void)
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
  return fileread(f, p, n);
}

int
sys_write(void)
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
  return filewrite(f, p, n);
}

int
sys_close(void)
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}

int
sys_fstat(void)
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
  return filestat(f, st);
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;

bad:
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
}

//PAGEBREAK!
int
sys_unlink(void)
{
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
    return -1;
  }

  ilock(dp);

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
  ilock(dp);

  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");

  ilock(ip);
  ip->major = major;
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}

int
sys_open(void)
{
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
      iunlockput(ip);
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}

int
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
  end_op();
  return 0;
}

int
sys_mknod(void)
{
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
  end_op();
  return 0;
}

int
sys_chdir(void)
{
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}

int
sys_exec(void)
{
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}

int
sys_pipe(void)
{
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}

//xattr system calls

//how does this associate with the fs.c file?
// int fgetxattr(int fd, const char *key, void *val, uint capacity);

int 
sys_fgetxattr(void)
{
  cprintf("FAIL: starting syscall fgetxattr\n");
  int fd;
  char* key;
  void* val;
  uint capacity;
  struct file* file;
  struct inode* ip; 
  if (argint(0,&fd) < 0 ||  argfd(0,&fd,&file) < 0)
  {
    cprintf("FAIL: failed to get arg ip\n");
    return -1;
  }
  ip = file->ip;
  if(argstr(1,&key) < 0 || argptr(2,(char**)(&val),sizeof(struct buf*)) < 0 || argint(3,(int*)(&capacity)) < 0)
  {
    cprintf("FAIL: failed to get other args");
    return -1;
  }

  if (!file->readable)
  {
    return -1;
  }

  if(fd < 0)
  {
    cprintf("FAIL: fd is invalid\n");
    return -1;
  }

  // TODO CHECK THIS
  if(key == 0) // check this cuz it says it says on the instructions that 0 is not null????
  {
    cprintf("FAIL: key is 0\n");
    return -1;
  }

  if(key[0] == '\0')
  {
    cprintf("FAIL: key is empty string\n");
    return -1;
  }

  if(capacity < 0 && val == 0)
  {
    cprintf("FAIL: The capacity is greater than 0, but val is null.\n");
    return -1;
  }

  // The capacity is greater than 0, but strictly smaller than the actual size of the stored value
  if(capacity > 0 && capacity < strlen((char*)(((struct buf*)val)->data) ))
  {
    cprintf("FAIL: The capacity is greater than 0 \n");
    return -1;
  }


  // in this function check for 
  // The specified key does not exist on the file.

  // TODO LOCK INODE 
  
  ilock(ip);
  cprintf("FAIL: fgetxattr ip:0x%x key:0x%x val:0x%x capacity:0x%x\n",ip,key,val,capacity);
  int result = xattr_get(ip, key, val, capacity); //throw them all into fs.c
    cprintf("FAIL: xattr_get returned: 0x%x\n", result);
  iunlock(ip);
  return result;
}

//very rough draft lol
// int fsetxattr(int fd, const char *key, const void *val, uint size, int flags);
int 
sys_fsetxattr(void)
{
  cprintf("FAIL: starting syscall sys_fsetxattr\n");
  int fd;
  char* key;
  void* val;
  uint size;
  int  flags;
  struct file* file;
  struct inode* ip; 
  if (argint(0,&fd) < 0 ||  argfd(0,&fd,&file) < 0)
  {
    cprintf("FAIL: failed to get arg ip\n");
    return -1;
  }
  ip = file->ip;
  if(argstr(1,&key) < 0 || argptr(2,(char**)(&val),sizeof(struct buf*)) < 0 || argint(3,(int*)(&size)) < 0 || argint(4,&flags) < 0)
  {
    cprintf("FAIL: failed to get other args\n");
    return -1;
  }

  if (!file->writable)
  {
    cprintf("FAIL: file is unwritable\n");
    return -1;
  }

  if(fd < 0)
  {
    cprintf("FAIL: fd is invalid\n");
    return -1;
  }

  // TODO CHECK THIS
  if(key == 0)
  {
    cprintf("FAIL: key is 0\n");
    return -1;
  }

  if(key[0] == '\0')
  {
    cprintf("FAIL: key is empty string\n");
    return -1;
  }

  if(strlen(key) > 8)
  {
    cprintf("FAIL: key's length > 8\n");
    return -1;
  }

  if(size > 0 && val == 0)
  {
    cprintf("FAIL: size > 0, but the val is null.\n");
    return -1;
  }

  if (size > 512)
  {
    cprintf("FAIL: size > 512\n");
    return -1;
  }

  if(flags != 0)
  {
    cprintf("FAIL: flag is invalid\n");
    return -1;
  }

  cprintf("FAIL: xattr_set ip:0x%x key:0x%x val:0x%x size:0x%x\n",ip,key,val,size);

  ilock(ip);
  begin_op();
  int result = xattr_set(ip, key, val, size, flags);
  cprintf("FAIL: xattr_set returned: 0x%x\n", result);
  end_op();
  iunlock(ip);

  return result;
}


//int fremovexattr(int fd, const char *key);
int 
sys_fremovexattr(void)
{
  int fd;
  char* key;
  struct file* file;
  struct inode* ip; 
  if (argint(0,&fd) < 0 || argfd(0,&fd,&file) < 0)
  {
    cprintf("FAIL: failed to get arg ip\n");
    return -1;
  }
  ip = file->ip;
  if(argstr(1,&key) < 0)
  {
    cprintf("FAIL: failed to get other args");
    return -1;
  }

  if (!file->writable)
  {
    return -1;
  }

  if(fd < 0)
  {
    cprintf("FAIL: fd is invalid\n");
    return -1;
  }

  if(key == 0)
  {
    cprintf("FAIL: key is 0\n");
    return -1;
  }

  if(key[0] == '\0')
  {
    cprintf("FAIL: key is empty string\n");
    return -1;
  }

  if(strlen(key) > 8)
  {
    cprintf("FAIL: key's length > 8\n");
    return -1;
  }

  // TODO CHECK IF IT DOESN"T EXISTS
<<<<<<< HEAD
  cprintf("xattr_del ip:0x%x key:0x%x \n",ip,key);
  ilock(ip);
  begin_op();
  int result = xattr_del(ip, key);
  end_op();
  iunlock(ip);
  return result;
=======
  cprintf("FAIL: xattr_del ip:0x%x key:0x%x \n",ip,key);
  return xattr_del(ip, key);
>>>>>>> ca34adfee5abd0e29a3c2104d907578efc6595d3
}

int 
sys_flistxattr(void)
{
  int fd;
  char* list; 
  uint capacity;
  struct file* file;
  struct inode* ip; 
  if (argint(0,&fd) < 0 || argfd(0,&fd,&file) < 0)
  {
    cprintf("FAIL: failed to get arg ip\n");
    return -1;
  }

  if (!file->readable)
  {
    return -1;
  }

  ip = file->ip;
  if(ip == 0){
    return -1;
  }
  
  if(argptr(1,&list,sizeof(char*)) < 0 || argint(2,(int*)(&capacity)) < 0)
  {
    cprintf("FAIL: failed to get other args");
    return -1;
  }

  cprintf("FAIL: xattr_del list:0x%x key:0x%x capacity:0x%x\n",ip,list,capacity);
  ilock(ip);
  int result = xattr_list(ip, list, capacity);
  iunlock(ip);
  return result;
}

int 
sys_countusedb(void)
{
  // Implementation for counting used blocks
  return bcountused();
}