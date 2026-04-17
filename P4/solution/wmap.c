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

#include "memlayout.h"
#include "wmap.h"

// DEBUG
#include "debug.h"

// ====================================================================
// Function Declarations
// ====================================================================

int validate_input(uint addr, int length, int flags, int fd, struct file *f);
struct mmap_region *fix_addr_place_mmap(struct proc *proc, uint addr, int length, int flags);
struct mmap_region *find_addr_place_mmap(struct proc *proc, int length, int flags);
struct mmap_region *find_unused_mmap(struct proc *proc);
void init_one_mmap(struct mmap_region *mmap);
void init_mmaps(struct proc *proc);
uint get_physical_page(struct proc *p, uint va, pte_t **pte);
int count_loaded_pages(struct proc *p, uint start, uint end);
int write_to_file(struct file *f, uint va, int offset, int n_bytes);
int remove_map(uint addr);
int remove_physical_map(int addr, int length, int remove, struct mmap_region* map);

// ====================================================================
// System Calls
// ====================================================================

/**
 * @brief System call to create a new memory mapping in the process's address space.
 *
 * @return Returns the starting address of the mapping if successful, or FAILED if an error occurs.
 */
int sys_wmap(void) {
    uint addr;
    int length, flags;
    int fd;
    struct file *f;
    // Integer arguements
    if (argint(0, (int *)&addr) < 0 || argint(1, &length) < 0 || argint(2, &flags) < 0) {
        cprintf("wmap arg ERROR: size or flags\n");
        return FAILED;
    }
    // File descriptor arguement
    if (argfd(3, &fd, &f) < 0) {
        fd = -1;
        f = 0;
    } else {
        // NOTE: without filedup(), if the file is closed before pgfault handler
        // reads the file, xv6 will panic. Close it in munmap in case of full unmapping.
        f = filedup(f);
    }

    // Validate input
    if (validate_input(addr, length, flags, fd, f) < 0) {
        cprintf("wmap ERROR: invalid input\n");
        return FAILED;
    }

    // TODO: implement your memory mapping
    // Getting flags
    int fixed         = (flags & MAP_FIXED)     != 0; 
    int shared        = (flags & MAP_SHARED)    != 0; 
    int priv          = (flags & MAP_PRIVATE)   != 0; 
    int anon          = (flags & MAP_ANONYMOUS) != 0;

    // non file-backed mapping BS
    struct mmap_region* mapping;
    if(fixed)
    {
        DPRINT("XV6: Flag fixed is set running fix_addr_place_mmap\n");
        mapping = fix_addr_place_mmap(myproc(),addr,length,flags);
    }
    else
    {
        DPRINT("XV6: Flag fixed is NOT set running find_addr_place_mmap\n");
        mapping = find_addr_place_mmap(myproc(),length,flags);
    }

    if(mapping == 0)
        return FAILED;
    mapping->f  = f;
    mapping->fd = fd;


    if(shared)
    {
        
    }

    if(priv)
    {
        // TODO
    }

    if(!anon)
    {

    }

    return mapping->addr;
}

/**
 * @brief System call to remove an existing memory mapping from the process's address space.
 *
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int sys_wunmap(void) {
    uint addr;
    // validate input
    if (argint(0, (int *)&addr) < 0) {
        cprintf("wunmap arg ERROR: addr\n");
        return FAILED;
    }
    if (addr % PGSIZE != 0) {
        cprintf("wunmap ERROR: addr not page aligned\n");
        return FAILED;
    }

    
    if (remove_map(addr) < 0) {
        cprintf("wunmap ERROR: unmap failed\n");
        return FAILED;
    }
    

    // TODO: implement your unmap her
    return 0;
}

/**
 * @brief System call to partially remove a part of existing memory mapping from the process's address space.
 *
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int sys_wpunmap(void) {
    uint addr;
    int length;
    // validate input
    if (argint(0, (int *)&addr) < 0 || argint(1, &length) < 0) {
        cprintf("wpunmap arg ERROR: size or flags\n");
        return FAILED;
    }
    if ((addr+length) % PGSIZE != 0) {
        cprintf("wpunmap ERROR: partial unmap addr end not page aligned\n");
        return FAILED;
    }
    if (length <= 0){
        cprintf("wpunmap ERROR: partial unmap length <= 0\n");
        return FAILED;
    }
    
    // TODO: implement your partial unmap here
    DPRINT("XV6: called partial unmap with addr: 0x%x | length: 0x%x \n",addr,length);
    // FIRST: find mapping that it exists on
    
    struct proc* p = myproc();
    struct mmap_region* cur_node = p->mmap_head;
    struct mmap_region* prev_node = 0;
    for(int i = 0; cur_node != 0;i++)
    {
        int lower_bound = addr          >= cur_node->addr;
        int upper_bound = addr + length <= cur_node->addr + cur_node->length;
        
        if(lower_bound && upper_bound)
            break;

        prev_node = cur_node;
        cur_node = cur_node->next;
    }
    
    // SECOND find three cases to test how many mappings to create
    int lower_is_equal = addr == cur_node->addr;
    int upper_is_equal = addr + length == cur_node->addr + cur_node->length;
    if(lower_is_equal && upper_is_equal)
    {
        DPRINT("XV6: both are equal\n");
        cur_node->n_loaded_pages -= remove_physical_map(addr,length,1,cur_node);
        // REMOVE CUR_NODE
        if(prev_node == 0) // this means its first :D
        {
            p->mmap_head->next = cur_node->next;
        }
        return 0;
    }
    else if(!lower_is_equal && upper_is_equal)
    {
        DPRINT("XV6: upper and not lower\n");
        uint addr1  = cur_node->addr;
        int length1 = length;

        cur_node->addr   = addr1;
        cur_node->length = length1;
        cur_node->n_loaded_pages -= remove_physical_map(addr,length,1,cur_node);
        remove_physical_map(addr,length,1,cur_node);

        return 0;
    }
    else if(lower_is_equal && !upper_is_equal)
    {   
        DPRINT("XV6: lower but not upper\n");

        uint addr1  = addr + length;
        int length1 = (cur_node->addr + cur_node->length) - (addr+length);

        cur_node->addr   = addr1;
        cur_node->length = length1;
        cur_node->n_loaded_pages -= remove_physical_map(addr,length,1,cur_node);

        return 0;
    }
    else if (!lower_is_equal && !upper_is_equal)
    {
        DPRINT("XV6: both are not equal\n");
        struct mmap_region* unused_map = find_unused_mmap(myproc()); 
        //if there is no space then we just remove everything :p
        if (unused_map == 0)
        {
            DPRINT("XV6: removing everything\n");
            cur_node->n_loaded_pages -= remove_physical_map(cur_node->addr,cur_node->length,1,cur_node);
            // REMOVE CUR_NODE
            if(prev_node == 0) // this means its first :D
            {
                p->mmap_head->next = cur_node->next;
            }
            return 0;
        }

        init_one_mmap(unused_map);
        

        // code gets here meaning there is space :D
        uint addr1   = cur_node->addr;
        uint length1 = addr - cur_node->addr;
        DPRINT("XV6: addr1: 0x%x | length1: 0x%x\n", addr1,length1);

        uint addr2   = addr+length;
        uint length2 = (cur_node->addr + cur_node->length) - (addr+length);
        DPRINT("XV6: addr2: 0x%x | length2: 0x%x\n", addr2,length2);

        cur_node->addr   = addr1;
        cur_node->length = length1;
        cur_node->n_loaded_pages = remove_physical_map(cur_node->addr,cur_node->length,0,cur_node);


        // creating new mapping for 2
        unused_map->addr   = addr2;
        unused_map->length = length2;
        unused_map->f      = cur_node->f;
        unused_map->flags  = cur_node->flags;
        unused_map->refcnt = cur_node->refcnt;

        unused_map->fd     = cur_node->fd;
        unused_map->n_loaded_pages = remove_physical_map(unused_map->addr,unused_map->length,0,cur_node);

        unused_map->refcnt = cur_node->refcnt; 

        remove_physical_map(addr,length,1,cur_node);


        struct mmap_region* temp = cur_node->next;
        cur_node->next   = unused_map;
        unused_map->next = temp;


        return 0;
    }

    return 0;
}


/**
 * @brief System call to retrieve detailed information about all memory mappings in the process's address space.
 *
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int sys_getwmapinfo(void) {
    struct wmapinfo *info;
    if (argptr(0, (void *)&info, sizeof(*info)) < 0) {
        cprintf("getwmapinfo arg ERROR\n");
        return FAILED;
    }

    // TODO: get mmap information into the buffer
    struct proc* p = myproc();
    int count = 0;
    struct mmap_region* cur_node = p->mmap_head;
    for(int i = 0; cur_node != 0;i++)
    {
        
        info->addr[i]           = cur_node->addr;
        info->length[i]         = cur_node->length;
        info->flags[i]          = cur_node->flags;
        info->fd[i]             = cur_node->fd;
        info->refcnt[i]         = cur_node->refcnt;
        info->n_loaded_pages[i] = cur_node->n_loaded_pages;
 
        cur_node = cur_node->next;
        count++;
    }
    info->total_mmaps = count;


    return 0;
}

/**
 * @brief System call to retrieve information about the current page directory.
 *
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int sys_getpgdirinfo(void) 
{
    struct pgdirinfo *info;
    if (argptr(0, (void *)&info, sizeof(*info)) < 0) 
    {
        return FAILED;
    }

    // TODO: get page directory information into the buffer

    struct proc* p = myproc();
    struct mmap_region* cur_node = p->mmap_head;
    int count = 0;

    for(int i = 0; cur_node != 0;i++)
    {
        uint length = cur_node->length;
        uint addr   = cur_node->addr;
        int repeat = (length%PGSIZE == 0) ? length/PGSIZE : (length/PGSIZE)+1;

        for(int j = 0; j < repeat; j++)
        {
            info->va[count] = cur_node->addr + j * PGSIZE;

            pte_t *pte = walkpgdir(p->pgdir, (void*)(addr + j * PGSIZE), 0);
            if (pte == 0)
            {
                info->pa[count] = -1;
                count++;

                continue;
            }
            if ((*pte & PTE_P) == 0) 
            {
                info->pa[count] = 0;
                count++;
                continue;
            }
            uint physical_address = PTE_ADDR(*pte);
            info->pa[count] = physical_address;         
            count++;
        }
        cur_node = cur_node->next;
    }

    info->n_upages = count;


    return 0;
}

// ====================================================================
// Functions related to wmap
// ====================================================================

/**
 * @brief validates input parameters for memory mapping.
 *
 * @return 0 if input is valid, or a negative error code if validation fails.
 */
int validate_input(uint addr, int length, int flags, int fd, struct file *f) 
{
    // Getting flags
    int fixed  = (flags & MAP_FIXED)     != 0; 
    int shared = (flags & MAP_SHARED)    != 0; 
    int priv   = (flags & MAP_PRIVATE)   != 0; 
    int anon   = (flags & MAP_ANONYMOUS) != 0;
 
    // Private and shared flag cannot be both set
    if(priv && shared)
        return -1;

    // if flag is fixed then addr has to be multiple of PGSIZE 
    int is_addr_multiple_page_size = addr % PGSIZE == 0; 
    if(fixed && !is_addr_multiple_page_size)
        return -1;

    // if you not in anonymous flag then the file stuff needs to be valid
    // in the wmap function when the argfd fails to get file then 
    // it sets fd to -1 and f to 0 
    if(!anon && fd == -1 && f == 0)
        return -1;

    if(length <= 0)
        return -1;

    return 0;
}

/**
 * @brief searches for an unused mmap structure in the process's mmap list
 * and returns a pointer to it.
 *
 * @return Pointer to the unused mmap structure if found, or NULL if not found.
 */
struct mmap_region *find_unused_mmap(struct proc *proc) 
{
    
    for(int i = 0; i < MAX_NMMAP;i++)
    {
        // checking if a map is valid or not by checking if address > 0
        int valid = proc->mmaps[i].addr > 0;
        if (!valid)
        {
            return &proc->mmaps[i];
        }
    }
    return (struct mmap_region*)0;
}

/**
 * @brief places an mmap structure in the process's mmap list at a fixed address
 * if the address is available and does not overlap with existing mappings.
 *
 * @param addr The fixed address for the mapping.
 * @param length The length of the mapping.
 * @return Pointer to the placed mmap structure if successful, or NULL if failed.
 */
struct mmap_region *fix_addr_place_mmap(struct proc *proc, uint addr, int length, int flags) 
{
    // This means that there is no valid maps or that all of the map slots are taken 
    struct mmap_region* unused_map = find_unused_mmap(proc);
    if (unused_map == 0)
    {
        DPRINT("XV6: couldn't find space in mmaps\n");
        return (struct mmap_region*)0;
    }
    init_one_mmap(unused_map);

    struct mmap_region* cur;

    // this for loop will find the last pointer of curent 
    // or find the pointer in which addr is between next and curent
    // for loops stops when 1. if the list was empty 2. if this value is the last one 3. the next address is less than the fixed addr
    for(cur = proc->mmap_head; cur != 0 && cur->next != 0 && (cur->next->addr < addr); cur = cur->next) { }

    int is_empty     = cur == 0;

    int is_first     = is_empty                ? 1           : cur->addr > addr; 
    int is_last      = is_empty                ? 1           : cur->next == 0;
    uint upper_bound = is_last                 ? 0x80000000  : cur->next->addr;
    uint lower_bound = is_first                ? 0x60000000  : cur->addr + cur->length;
    upper_bound      = (!is_empty && is_first) ? cur->addr   : upper_bound;

    DPRINT("XV6: lowerbound: 0x%x | upperbound: 0x%x | addr: 0x%x | addr + length: 0x%x \n", lower_bound,upper_bound,addr,addr+length);
    // lower bound dection
    if(lower_bound > addr)
    {
        DPRINT("XV6: Failed lower bound detection\n");
        return (struct mmap_region*)0;
    }
    // upper bound dection
    if(addr + length > upper_bound)
    {
        DPRINT("XV6: Failed upper bound detection\n");
        return (struct mmap_region*)0;
    }

    // PLACING MAP HERE
    unused_map->addr   = addr;
    unused_map->flags  = flags;
    unused_map->length = length;
    
    if(!is_empty && cur->addr > addr)
    {
        proc->mmap_head = unused_map;
        unused_map->next = cur;
    }
    else if(!is_empty && cur->next == 0)
    {
        cur->next = unused_map;
        unused_map->next = 0;
    }
    else if(!is_empty)
    {
        struct mmap_region* temp = cur->next;
        cur->next = unused_map;
        unused_map->next = temp;
    }
    else
    {
        proc->mmap_head = unused_map;
        unused_map->next = 0;
    }

    DPRINT("XV6: fix_addr_place_mmap: 0x%x fd:0x%x\n", unused_map->addr, unused_map->fd);
    return unused_map;
}

/**
 * @brief finds a suitable address for the mapping and places an mmap structure
 * in the process's mmap list.
 *
 * @param length The length of the mapping.
 * @return Pointer to the placed mmap structure if successful, or NULL if failed.
 */
struct mmap_region *find_addr_place_mmap(struct proc *proc, int length, int flags) 
{
    // This means that there is no valid maps or that all of the map slots are taken 
    struct mmap_region* unused_map = find_unused_mmap(proc);
    if (unused_map == 0)
    {
        DPRINT("XV6: couldn't find space in mmaps\n");
        return (struct mmap_region*)0;
    }
    init_one_mmap(unused_map);


    struct mmap_region* cur;
    // this for loop will find the last pointer of curent 
    // or find the pointer in which addr is between next and curent
    // for loops stops when 1. if the list was empty 2. if this node is the last one
    uint addr = 0x60000000;
    for(cur = proc->mmap_head; cur != 0 && cur->next != 0; cur = cur->next) 
    {
        if (addr + length < cur->next->addr)
        {
            break;
        }
        addr = cur->next->addr + cur->next->length;
    }

    // round up addr to nearest pagesize
    addr = (addr%PGSIZE==0) ? addr :(addr/PGSIZE+1) * PGSIZE; 

    int is_empty     = cur == 0;

    // PLACING MAP HERE
    unused_map->addr          = addr;
    unused_map->flags         = flags;
    unused_map->length        = length;
    
    if(!is_empty && cur->addr > addr)
    {
        proc->mmap_head = unused_map;
        unused_map->next = cur;
    }
    else if(!is_empty && cur->next == 0)
    {
        cur->next = unused_map;
        unused_map->next = 0;
    }
    else if(!is_empty)
    {
        struct mmap_region* temp = cur->next;
        cur->next = unused_map;
        unused_map->next = temp;
    }
    else
    {
        proc->mmap_head = unused_map;
        unused_map->next = 0;
    }

    DPRINT("XV6: find_addr_place_mmap: 0x%x\n", unused_map->addr);
    return unused_map;
}

// ====================================================================
// Functions related to unmapping
// ====================================================================

/**
*   @brief removes the physical mapping if the present bit is there 
*
*   @param remove if 1 then it does actually remove if 0 then it just returns a count
*   @return amount of pages freed.
*/
int remove_physical_map(int addr, int length,int remove,struct mmap_region* map)
{
    DPRINT("XV6: removing physical addresses from 0x%x to 0x%x\n",addr,addr+length);
    int repeat = (length%PGSIZE == 0) ? length/PGSIZE : (length/PGSIZE)+1;
    int count = 0;
    for(int i = 0; i < repeat;i++)
    {
        pte_t *pte = walkpgdir(myproc()->pgdir, (void*)(addr + i * PGSIZE), 0);
        if (pte == 0) continue;
        if ((*pte & PTE_P) == 0) continue;

        count++;

        if(remove == 1)
        {
            if ((map->flags & MAP_ANONYMOUS) == 0 && (map->flags & MAP_SHARED) == 0)
            {
                DPRINT("XV6: writing to file: 0x%x\n",map->f);
                write_to_file(map->f,map->addr + i * PGSIZE,map->f->off * i * PGSIZE,PGSIZE);
            }

            uint physical_address = PTE_ADDR(*pte);

            *pte = 0;
            kfree(P2V(physical_address));
        }
    }
    DPRINT("XV6: count: 0x%x\n",count);
    return count;
}

/**
 * @brief removes a memory mapping at a given virtual address from the process's
 * address space. It deallocates physical pages if necessary, decrements reference counts,
 * and updates the process's memory mapping list.
 *
 * @param addr The virtual address of the memory mapping to remove.
 * @return 0 if successful, or a negative error code if an error occurs.
 */
int remove_map(uint addr) 
{
    DPRINT("XV6: Starting to remove_map with addr: 0x%x\n", addr);
    struct proc* p = myproc();
    struct mmap_region* cur_node = p->mmap_head;
    for(int i = 0; cur_node != 0 && cur_node->next != 0;i++)
    {
        DPRINT("XV6: Start loop\n");
        if(cur_node->addr > addr)
        {
            DPRINT("XV6: Could not find addr to remove\n");
            // since the linked list is sorted from smallest to largest
            // we know that it doesn't exist in here
            // this is for omptizations stuff :P
            return FAILED;
        }
        if(cur_node->next->addr == addr)
        {
            int should_remove = cur_node->refcnt<=0;
            DPRINT("XV6: found addr to remove thats not the start should remove: 0x%x\n",should_remove);
            // found so we start the removal process
            cur_node->next->n_loaded_pages -= should_remove * remove_physical_map(addr,cur_node->next->length,should_remove,cur_node);
            cur_node->next = cur_node->next->next;   
            return 0;
        }

        cur_node = cur_node->next;
    }
    
    if(cur_node->addr == addr)
    {
        int should_remove = cur_node->refcnt<=0;
        DPRINT("XV6: removing start addr should remove: 0x%x\n",should_remove);

        // found but this will only run if the node is the first one
        cur_node->next->n_loaded_pages -= should_remove * remove_physical_map(addr,cur_node->length,should_remove,cur_node);
        p->mmap_head = cur_node->next;
        return 0;
    }


    DPRINT("XV6: Could not find addr to remove\n");
    return FAILED;
}

/**
 * @brief writes the contents of a memory region to a file at the specified offset.
 *
 * @return The number of bytes written if successful, or -1 if an error occurs.
 */
int write_to_file(struct file *f, uint va, int offset, int n_bytes) {
    int r;
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * 512;
    int i = 0;
    while (i < n_bytes) {
        int n1 = n_bytes - i;
        if (n1 > max)
            n1 = max;
        begin_op();
        ilock(f->ip);
        if ((r = writei(f->ip, (char *)va + i, offset, n1)) > 0)
            offset += r;
        iunlock(f->ip);
        end_op();

        if (r < 0)
            break;
        if (r != n1)
            panic("wmap: short filewrite");
        i += r;
    }
    r = (i == n_bytes ? n_bytes : -1);
    return r;
}

// ====================================================================
// Common Functions
// ====================================================================

/**
 * @brief resets the fields of an mmap_region struct to their default values.
 *
 * @param mmap Pointer to the mmap_region struct to reset.
 */
void init_one_mmap(struct mmap_region *mmap) {
    mmap->addr = 0; // note to future changed this from a 0 to a -1
    mmap->length = -1;
    mmap->flags = -1;
    mmap->fd = -1;
    mmap->f = 0;
    mmap->refcnt = 0;
    mmap->n_loaded_pages = 0;
    mmap->next = 0;
}

/**
 * @brief initializes memory maps for a process by resetting its mmap structures.
 *
 * @param proc Pointer to the process structure to initialize.
 */
void init_mmaps(struct proc *proc) 
{
    for(int i = 0; i < MAX_NMMAP;i++)
    {
        init_one_mmap(&proc->mmaps[i]);
    }
}

/**
 * @brief retrieves the physical address of a page from its virtual address in the process's address space.
 *
 * @param va Virtual address of the page.
 * @param pte Pointer to the page table entry. this will be updated with the address of the page table entry.
 * @return Physical address of the page if found, or 0 if not found.
 */
uint get_physical_page(struct proc *p, uint va, pte_t **pte) 
{
    return 0;
}

/**
 * @brief find the loaded pages number of a virtual address range
 *
 * @param start Virtual address start.
 * @param end Virtual address end.
 * @return number of loaded pages.
 */
int count_loaded_pages(struct proc *p, uint start, uint end) {
    return 0;
}

// ====================================================================
// Functions related to demand allocation
// ====================================================================

/**
 * @brief This function is called when a page fault occurs. It allocates a physical page,
 * maps it to the corresponding virtual address, and reads content from a file if necessary.
 *
 * @param pgflt_vaddr The virtual address that caused the page fault.
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int handle_page_fault(uint pgflt_vaddr) 
{  
    DPRINT("XV6: Handle Page Fault Start at 0x%x\n",pgflt_vaddr);
    struct mmap_region* cur_node = myproc()->mmap_head;
    int found = 0;
    for(int i = 0; cur_node != 0;i++)
    {
        int lower_bound = pgflt_vaddr >= cur_node->addr;
        int upper_bound = pgflt_vaddr < cur_node->addr + cur_node->length;
        if(lower_bound && upper_bound)
        {  
            found = 1;
            break;
        }

        cur_node = cur_node->next;
    }

    if(found)
    {
        DPRINT("XV6: Handle Page Fault: Page Sucessfully found\n");
        pgflt_vaddr = pgflt_vaddr/PGSIZE * PGSIZE; 

        char *mem = kalloc();

        int flags   = cur_node->flags;
        int anon    = (flags & MAP_ANONYMOUS) != 0;

        DPRINT("XV6: pgdr: 0x%x\n",myproc()->pgdir);
        if (mappages(myproc()->pgdir, (void*)pgflt_vaddr, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0)
        {
          DPRINT("XV6: failed to physically allocate a page");
          return -1;
        }
        DPRINT("XV6: page is physically allocated here: 0x%x\n",V2P(mem));

        cur_node->n_loaded_pages++;

        struct file* f    = cur_node->f;

        if(!anon && f != 0)
        {
            DPRINT("XV6: Handle Page Fault: Starting file-backed-mapping\n");
            int r;
            ilock(cur_node->f->ip);
            uint offset = pgflt_vaddr-cur_node->addr;
            r = readi(cur_node->f->ip, (char *)mem, offset, PGSIZE);
            iunlock(cur_node->f->ip);
            if (r < 0) 
            {
                cprintf("handle_page_fault ERROR: readi failed\n");
                return FAILED;
            }
        }


        return pgflt_vaddr;
    }
    DPRINT("XV6: Handle Page Fault: Page Was not found\n");
    return 0;
}

// ====================================================================
// Functions related to fork
// ====================================================================

/**
 * @brief given two page tables copies the physical memory in one to the other
 * note bc i am overdue and out of time i will not be implementing copy on write
 * 
 * if I were to implement it I would just have this function call whenever a write
 * is read in the parent or a write in its child
 * for its parent if I write I will copy the mapping to all of its children before writing
 * if its a child then I will only copy the mapping before writing
 */
void copy_phyiscal_maps(pde_t* dst, pde_t* src, struct mmap_region* mapping)
{
    DPRINT("XV6: copy phyiscal pgdir from 0x%x to 0x%x\n",dst,src);
    int length = mapping->length;
    uint addr  = mapping->addr;
    int repeat = (length%PGSIZE == 0) ? length/PGSIZE : (length/PGSIZE)+1;
    for(int i = 0; i < repeat;i++)
    {
        pte_t *pte = walkpgdir(dst, (void*)(addr + i * PGSIZE), 0);
        if (pte == 0) continue;
        if ((*pte & PTE_P) == 0) continue;

        char* mem = kalloc();
        void* va = (void*)(addr + i * PGSIZE);
        uint pa = PTE_ADDR(*pte);
        if (mappages(src, va, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0)
        {
            DPRINT("XV6: failed to physically allocate a page");
            return;
        }

        // this line below would be removed and replaced by some code in the pgflt handler if 
        // i was implementing copy on write
        memmove(mem, (char *)P2V(pa), PGSIZE);
    }
}

/**
 * @brief copies memory mappings from the parent process to the child process.
 * It also copies the physical pages if the memory mapping is MAP_PRIVATE.
 * It also increments the reference count of the memory mapping if it is MAP_SHARED.
 *
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int copy_maps(struct proc *parent, struct proc *child) 
{
    // copying over mmapings
    DPRINT("XV6: Fork() starting to copy mappings from parent: 0x%x to child 0x%x\n",parent->pid,child->pid);   
 
    struct mmap_region* cur_mapping  = parent->mmap_head;
    struct mmap_region* prev_mapping = 0;
    if(cur_mapping == 0)
    {
        DPRINT("XV6: parent has no mappings to copy\n");
        return FAILED;
    }
    init_mmaps(child);

    while(cur_mapping != 0)
    {
        struct mmap_region* unused_map = find_unused_mmap(child);
        if(unused_map == 0)
        {
            DPRINT("XV6: fork() failed to find an unused map in child\n");
            return FAILED;
        }
        init_one_mmap(unused_map);
        DPRINT("XV6: found an unused map in child\n");

        int shared  = (cur_mapping->flags&MAP_SHARED) !=0;
        int private = (cur_mapping->flags&MAP_PRIVATE)!=0;

        // deep copy of cur_mapping into unused_map
        unused_map->addr           = cur_mapping->addr;
        unused_map->f              = cur_mapping->f;
        unused_map->fd             = cur_mapping->fd;
        unused_map->flags          = cur_mapping->flags;
        unused_map->length         = cur_mapping->length;
        unused_map->n_loaded_pages = cur_mapping->n_loaded_pages;
        unused_map->refcnt         = cur_mapping->refcnt;
        

        int is_first = prev_mapping == 0; 
        if(is_first)
        {
            child->mmap_head = unused_map;
        }
        else
        {
            prev_mapping->next = unused_map;
        }
        

        if (shared)
        {
            DPRINT("XV6: shared flag is set\n");

            unused_map->refcnt++;
            //copy page table :D
            //child->pgdir = parent->pgdir;
            // apparently this code above no works >:C

            DPRINT("XV6: copy pgdir from 0x%x to 0x%x\n",parent->pgdir,child->pgdir);
            int length = unused_map->length;
            uint addr  = unused_map->addr;
            int repeat = (length%PGSIZE == 0) ? length/PGSIZE : (length/PGSIZE)+1;
            for(int i = 0; i < repeat;i++)
            {
                pte_t *pte = walkpgdir(parent->pgdir, (void*)(addr + i * PGSIZE), 0);
                if (pte == 0) continue;
                if ((*pte & PTE_P) == 0) continue;

                void* va = (void*)(addr + i * PGSIZE);
                uint pa = PTE_ADDR(*pte);
                if (mappages(child->pgdir, va, PGSIZE, pa, PTE_W | PTE_U) < 0)
                {
                    DPRINT("XV6: failed to physically allocate a page");
                    return FAILED;
                }
            }
        }

        if(private)
        {   
            // copy physical pages
            DPRINT("XV6: private flag is set\n");
            copy_phyiscal_maps(parent->pgdir,child->pgdir,cur_mapping);
        }

        prev_mapping = unused_map;
        cur_mapping  = cur_mapping->next;
    }
    return 0;
}

// ====================================================================
// Functions related to exit
// ====================================================================

/**
 * @brief deletes memory mappings of a process during its exit.
 * It removes mappings with zero reference count and resets the mmap_region struct.
 *
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int delete_mmaps(struct proc *curproc) 
{
    struct mmap_region* cur_node = curproc->mmap_head;
    while(cur_node != 0)
    {
        if(cur_node->refcnt <= 0)
        {
            // delete mapping
            // delete phyiscacly in memory if it exitsts
            remove_map(cur_node->addr);
        }

        int length = cur_node->length;
        int repeat = (length%PGSIZE == 0) ? length/PGSIZE : (length/PGSIZE)+1;

        for(int i = 0; i < repeat;i++)
        {
            pte_t *pte = walkpgdir(curproc->pgdir, (void*)(cur_node->addr + i * PGSIZE), 0);
            if (pte != 0  && (*pte & PTE_P) != 0) 
            {
                // deleting all of the physical mapping so when the os deletes everything
                // it cannot find the ones with refcnt > 1 or something so that the parent
                // can still use this stuff :D
                *pte = 0;
            }
        }

        cur_node->refcnt--;
        cur_node = cur_node->next;
    }

    init_mmaps(curproc);


    return 0;
}