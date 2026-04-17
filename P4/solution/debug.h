// Comment this out to turn off DEBUG
//#define DEBUG 

#ifdef DEBUG
    #define DPRINT(fmt, ...) cprintf(fmt, ##__VA_ARGS__)
#else
    #define DPRINT(fmt, ...) do {} while (0)
#endif