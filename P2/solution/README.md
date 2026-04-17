NAME: Sheldon Huynh
CS login: SHUYNH6
WISC ID: 908 739 6512
WISC EMAIL: shuynh6@wisc.edu

# Changes
Added .vscode folder with launch.json and tasks.json to run in vscode
launch.json attaches gdb to vscode
tasks.json runs make qemu-nox-gdb before gdb is run

defs.h
needed for bc include statemtn for proc.c

proc.c
added function getrusage in here

proc.h
changed the proct struct to contain rusage 

stat.h
added an r usage struct

sysproc.c
added a sys_getrusages()

sysfile.c
incrimates write counter when write is called

syscall.c
added the boilerplate? for sys_getrusage() (the extern and adding it to the syscall array)

syscall.h
added sys-getrusage's syscall number

trap.c
added incrimiting stime and time to the timer interupt depending if in kernel or user mode (in kernel mode ignore procID of 0 bc thats like the trap handler or something idk the exact details)

usys.S
added something to the symbol table so that it can compile idk how this works tho

user.h
added the header for getRusage and a struct of rusage so getrusage knows that rusage exists.