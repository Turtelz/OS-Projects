#include <stdlib.h>
#include <pthread.h>
#include "threadpool.h"

static void *spawn_worker(void* args)
{
    threadpool_t* pool = (threadpool_t* )args;

    //while the worker thread is, like, alive
    while(1){
        //attempt to get lock from threadpool
        pthread_mutex_lock(&(pool->lock));
        //if not, start spinning
        while((pool->queue_size == 0) && (pool->shutdown == 0) )
        {
            pthread_cond_wait(&(pool->not_empty),&(pool->lock));
        }

        //if everything is gone, release lock and return
        if((pool->shutdown == 1) && pool->queue_size == 0)
        {
            pthread_mutex_unlock(&(pool->lock));
            return NULL;
        }

        //obtain the task
        task_t task;
        task = pool->queue[pool->queue_head];
        //reset the task that used to be in the queue and decrement
        pool->queue[pool->queue_head].arg  = NULL;
        pool->queue[pool->queue_head].func = NULL;
        pool->queue_head = (pool->queue_head + 1) % pool->queue_capacity;
        pool->queue_size--;
        pthread_cond_signal(&(pool->not_full));
        pthread_mutex_unlock(&(pool->lock));

        //do the task
        task.func(task.arg);
    }
}

/**
pov the job description: 
Allocate, initialize, and return a ready-to-use thread pool.

- Allocate the `threadpool_t` struct, the `threads` array, and the `queue` array on the heap.
- Initialize all integer fields, the mutex, and both condition variables.
- Spawn exactly `num_threads` worker threads. Each worker loops: when a task is available in the queue, it dequeues and executes it. When the queue is empty and the pool is not shutting down, the worker sleeps, it does **not** spin.
- Return a pointer to the pool, or `NULL` if any allocation or initialization fails.
- If `num_threads <= 0` or `queue_capacity <= 0`, return `NULL`.
 */
threadpool_t *threadpool_create(int num_threads, int queue_capacity) 
{
    //check valid input
    if (num_threads <= 0 || queue_capacity <= 0)
        return NULL;

    //allocate proper memory for the following
    threadpool_t* pool   = calloc(1,sizeof(threadpool_t));
    pool->queue          = calloc(queue_capacity,sizeof(task_t));
    pool->threads        = calloc(num_threads,sizeof(pthread_t));
    if (pool == NULL || pool->queue == NULL || pool->threads == NULL)
        return NULL;

    //assign proper values to the following data members
    pool->num_threads    = num_threads;
    pool->queue_capacity = queue_capacity;

    //and initialize the rest
    pool->queue_head     = 0;
    pool->queue_size     = 0;
    pool->queue_tail     = 0;
    pool->shutdown       = 0;

    //
    if (pthread_cond_init(&(pool->not_full),NULL) != 0)
        return NULL;
    if (pthread_cond_init(&(pool->not_empty),NULL) != 0)
        return NULL;
    if (pthread_mutex_init(&(pool->lock),NULL) != 0)
        return NULL; 

    for(int i = 0; i < num_threads;i++) {
        pthread_create(&(pool->threads[i]),NULL, spawn_worker,(void*)pool);
    }

    return pool;

}

 

/*
Add a task to the pool's queue.

- If the queue is at capacity, the caller **blocks** until a worker frees a slot.
- After adding the task, wake a sleeping worker so it can execute it.
- Returns `0` on success.
- If the pool is being destroyed (e.g. a blocked submitter is woken by `threadpool_destroy`), return `-1` without adding the task.

*/
int threadpool_submit(threadpool_t *pool, void (*func)(void *), void *arg) 
{
    pthread_mutex_lock(&(pool->lock));

    //ok i trust that this part is right
    //there was some debugging that had to happen however it works
    while((pool->queue_size == pool->queue_capacity) && (pool->shutdown == 0)) 
    {
        pthread_cond_wait(&(pool->not_full),&(pool->lock));
        if(pool->shutdown == 1)
        {
            pthread_mutex_unlock(&(pool->lock));
            return -1;
        }
    }

    //you swapped these two around that was a little silly
    pool->queue[pool->queue_tail].arg  = arg;
    pool->queue[pool->queue_tail].func = func;
    pool->queue_tail = (pool->queue_tail + 1) % pool->queue_capacity;
    pool->queue_size++;    

    pthread_cond_signal(&(pool->not_empty));
    pthread_mutex_unlock(&(pool->lock));
    return 0;
}

/*
Shut down the pool cleanly. After this call returns, no pool resources remain.

- Every task already in the queue **must** run to completion. Nothing is dropped.
- All worker threads are joined (waited on).
- The mutex and condition variables are destroyed.
- All heap memory is freed, the queue, the threads array, and the pool struct itself.
*/
void threadpool_destroy(threadpool_t *pool) 
{
    //good boy sheldon
    pthread_mutex_lock(&(pool->lock));
    pool->shutdown = 1;
    /**pool->queue_size = -1;
    pool->queue_head = -1;
    pool->queue_tail = -1; the threads still need these fields */
    pthread_mutex_unlock(&(pool->lock));

    pthread_cond_broadcast(&(pool->not_empty));
    pthread_cond_broadcast(&(pool->not_full));
    for(int i = 0; i < pool->num_threads;i++)
    {
        pthread_join(pool->threads[i],NULL);
    }
    pthread_cond_destroy(&(pool->not_empty));
    pthread_cond_destroy(&(pool->not_full));
    pthread_mutex_destroy(&(pool->lock));

    free(pool->queue);
    free(pool->threads);
    free(pool);
}
