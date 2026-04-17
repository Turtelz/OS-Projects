/*
 * bst.c Binary Search Tree
 *
 * TODO: Add fine-grained locking to make this thread-safe.
 *
 * The current implementations are correct sequential code but NOT thread-safe.
 * You must use the tree-level lock (tree->lock) and per-node locks via the
 * NODE_LOCK(node) / NODE_UNLOCK(node) macros to make these operations safe
 * for concurrent access.
 *
 * You may add static helper functions as needed.
 */

#include "bst.h"

#include <errno.h>
#include <stdlib.h>

// for debugging
#include <stdio.h>

//Node allocation / deallocation

//omg binary search trees my favorite
static bst_node_t *bst_node_create(int key, int value) {
    bst_node_t *node = (bst_node_t *)malloc(sizeof(*node));
    if (node == NULL) {
        return NULL;
    }

    node->key = key;
    node->value = value;
    node->lock_count = 0;
    node->left = NULL;
    node->right = NULL;

    if (pthread_mutex_init(&node->lock, NULL) != 0) {
        free(node);
        return NULL;
    }

    return node;
}

//Free a node that is being physically removed from the tree.
static void bst_node_free(bst_node_t *node) {
    pthread_mutex_destroy(&node->lock);
    free(node);
}

//Tree init/destroy

bst_t *bst_init(void) {
    bst_t *tree = (bst_t *)malloc(sizeof(*tree));
    if (tree == NULL) {
        return NULL;
    }

    tree->root = NULL;
    if (pthread_mutex_init(&tree->lock, NULL) != 0) {
        free(tree);
        return NULL;
    }

    return tree;
}

//Called after all threads have joined - no locking needed.
static void bst_destroy_node(bst_node_t *node) {
    if (node == NULL) {
        return;
    }

    bst_destroy_node(node->left);
    bst_destroy_node(node->right);
    pthread_mutex_destroy(&node->lock);
    free(node);
}

void bst_destroy(bst_t *tree) {
    if (tree == NULL) {
        return;
    }

    bst_destroy_node(tree->root);
    pthread_mutex_destroy(&tree->lock);
    free(tree);
}

/*
 * Insert a key-value pair. Returns 0 on success, -1 on duplicate key
 * or allocation failure.
 */
int bst_insert(bst_t *tree, int key, int value) {
    //fprintf(stderr,"STARTING BST_INSERT\n");
    if (tree == NULL) {
        errno = EINVAL;
        //fprintf(stderr,"ENDING BST_INSERT\n");
        return -1;
    }


    //get the tree wide lock
    pthread_mutex_lock(&(tree->lock));
    if (tree->root == NULL) {
        //make a new node!
        bst_node_t *root = bst_node_create(key, value);
        if (root == NULL) {
            //we've failed get out of here
            pthread_mutex_unlock(&(tree->lock));
            //fprintf(stderr,"ENDING BST_INSERT\n");
            return -1;
        }
        tree->root = root;
        //ok we're done get out of here
        pthread_mutex_unlock(&(tree->lock));
        //fprintf(stderr,"ENDING BST_INSERT\n");
        return 0;
    }

    //if not, obtain the specific root lock
    NODE_LOCK(tree->root);
    pthread_mutex_unlock(&(tree->lock));

    //current, same logic as the lookup one
    bst_node_t *cur = tree->root;

    while (1) {
        if (key == cur->key) {
            //nope! not allowed get out
            NODE_UNLOCK(cur);
            //fprintf(stderr,"ENDING BST_INSERT\n");
            return -1;
        }

        if (key < cur->key) {
            if (cur->left == NULL) {
                //okay put the child there then
                bst_node_t *node = bst_node_create(key, value);
                if (node == NULL) {
                    //oh we failed whatever
                    NODE_UNLOCK(cur);
                    //fprintf(stderr,"ENDING BST_INSERT\n");
                    return -1;
                }
                cur->left = node;
                //ok we're done get out
                NODE_UNLOCK(cur);
                //fprintf(stderr,"ENDING BST_INSERT\n");
                return 0;
            }
            //but if we're not! get the next lock and let's go
            bst_node_t *next = cur->left;
            NODE_LOCK(next);
            NODE_UNLOCK(cur);
            cur = next;
        } else {
            if (cur->right == NULL) {
                //okay put the child there then
                bst_node_t *node = bst_node_create(key, value);
                if (node == NULL) {
                    //oh we failed whatever
                    NODE_UNLOCK(cur);
                    //fprintf(stderr,"ENDING BST_INSERT\n");
                    return -1;
                }
                cur->right = node;
                //ok we're done get out
                NODE_UNLOCK(cur);
                //fprintf(stderr,"ENDING BST_INSERT\n");
                return 0;
            }
            //but if we're not! get the next lock and let's go
            bst_node_t *next = cur->right;
            NODE_LOCK(next);
            NODE_UNLOCK(cur);
            cur = next;
        }
    }
    //fprintf(stderr,"ENDING BST_INSERT\n");
}

//Look up a key. Returns 0 and writes *value on success, -1 if not found.
int bst_lookup(bst_t *tree, int key, int *value) {
    //fprintf(stderr,"STARTING BST_LOOCKUP\n");
    if (tree == NULL || value == NULL) {
        errno = EINVAL;
        //fprintf(stderr,"ENDING BST_LOOCKUP\n");
        return -1;
    }

    pthread_mutex_lock(&(tree->lock)); //use the main tree-wide lock
    if (tree->root == NULL) {
        pthread_mutex_unlock(&(tree->lock));
        //fprintf(stderr,"ENDING BST_LOOCKUP\n");
        return -1;
    }

    NODE_LOCK(tree->root); //now get the specific root lock
    pthread_mutex_unlock(&(tree->lock)); //let go of the tree-wide one

    bst_node_t *cur = tree->root;
    //start of current as the root
    //remember that it's locked!

    while (1) {
        if (key == cur->key) {
            *value = cur->value;
            NODE_UNLOCK(cur); //ok we got the value we need we're done
            //fprintf(stderr,"ENDING BST_LOOCKUP\n");
            return 0;
        }

        bst_node_t *next = (key < cur->key) ? cur->left : cur->right;
        if (next == NULL) {
            NODE_UNLOCK(cur); //oh we reached the end, there's nothing here, move on
            //fprintf(stderr,"ENDING BST_LOOCKUP\n");
            return -1;
        }

        //moving on by locking the next one
        NODE_LOCK(next);
        //and unlocking the one we had...hand in hand locking!
        NODE_UNLOCK(cur);
        //and move on
        cur = next;
    }
    //fprintf(stderr,"ENDING BST_LOOCKUP\n");
}

/*two
 * Helper: handle the two-children case.
 *
 * Called with cur being the node whose key/value will be replaced.
 * Finds the in-order successor (leftmost node in right subtree), copies
 * its key/value into cur, then removes the successor.
 */
static void delete_two_children(bst_node_t *cur) {
    //I'm pretty sure the problem is somewhere in this method
    //fprintf(stderr,"STARTING DELELTE_TWO_CHILDREN\n");
    bst_node_t *succ_parent = cur;
    bst_node_t *succ = cur->right;

    NODE_LOCK(cur->right);    

    while (succ->left != NULL) {
        NODE_LOCK(succ->left);
        if(succ_parent != cur){
            NODE_UNLOCK(succ_parent);
        }
        succ_parent = succ;
        succ = succ->left;
    }
    // after this while loop only sucessor should be locked
    // cur should be locked and successor's parent is locked

    /* Copy successor's data into the node being "deleted" */
    cur->key = succ->key;
    cur->value = succ->value;

    /* Remove successor. Successor has at most a right child. */
    if (succ_parent == cur) {
        succ_parent->right = succ->right;
    } else {
        succ_parent->left = succ->right;
    }

    NODE_UNLOCK(cur);
    if(succ_parent != cur){
        NODE_UNLOCK(succ_parent);
    }
    NODE_UNLOCK(succ);
    bst_node_free(succ);
    //fprintf(stderr,"ENDING DELELTE_TWO_CHILDREN\n");
}

//Delete a key from the BST. Returns 0 on success, -1 if key not found.
int bst_delete(bst_t *tree, int key) {
    //I have a feeling this method might eat me alive
    //fprintf(stderr,"STARTING DELETE\n");
    if (tree == NULL) {
        errno = EINVAL;
        //fprintf(stderr,"ENDING DELETE\n");
        return -1;
    }

    //let's do what we have been doing. for the next few lines refer to previous methods for my logic. 
    pthread_mutex_lock(&(tree->lock));

    if (tree->root == NULL) {
        pthread_mutex_unlock(&(tree->lock));
        //fprintf(stderr,"ENDING DELETE\n");
        return -1;
    }

    NODE_LOCK(tree->root);
    //keep the tree wide lock for a little bit in case things go wrong

    bst_node_t *cur = tree->root;

    //time for freaky ahh code
    //Deleting the root node
    if (cur->key == key) {
        /* Leaf */
        if (cur->left == NULL && cur->right == NULL) {
            tree->root = NULL;
            //ok we're done get OUT!
            NODE_UNLOCK(cur);
            pthread_mutex_unlock(&(tree->lock));
            bst_node_free(cur);
            //fprintf(stderr,"ENDING DELETE\n");
            return 0;
        }

        //One child
        if (cur->left == NULL || cur->right == NULL) {
            tree->root = (cur->left != NULL) ? cur->left : cur->right;
            NODE_UNLOCK(cur);
            pthread_mutex_unlock(&(tree->lock));
            bst_node_free(cur);
            //fprintf(stderr,"ENDING DELETE\n");
            return 0;
        }

        
        pthread_mutex_unlock(&(tree->lock));
        //Two children
        //fprintf(stderr,"INSIDE DELETE CALLING DELETE_TWO_CHILDREN LINE 330\n");
        delete_two_children(cur);
        //ill just handle this in the method for efficiency
        //fprintf(stderr,"ENDING DELETE\n");
        return 0;
    }

    //Step one level down from root so we have parent + cur.
    bst_node_t *parent = cur;
    int is_left;

    if (key < cur->key) {
        if (cur->left == NULL) {
            //ok get out
            NODE_UNLOCK(cur);
            pthread_mutex_unlock(&(tree->lock));
            //fprintf(stderr,"ENDING DELETE\n");
            return -1;
        }
        //lock the next child
        NODE_LOCK(cur->left);

        //because the root isn't used anymore, we can just let it go!!!
        pthread_mutex_unlock(&(tree->lock));
        cur = cur->left;
        is_left = 1;
    } else {
        if (cur->right == NULL) {
            //ok get out
            NODE_UNLOCK(cur);

            pthread_mutex_unlock(&(tree->lock));
            //fprintf(stderr,"ENDING DELETE\n");
            return -1;
        }
        NODE_LOCK(cur->right);

        pthread_mutex_unlock(&(tree->lock));
        cur = cur->right;
        is_left = 0;
    }

    while (cur->key != key) {
        bst_node_t *next;
        if (key < cur->key) {
            next = cur->left;
            is_left = 1;
        } else {
            next = cur->right;
            is_left = 0;
        }

        if (next == NULL) {
            //unlock both locks we have
            NODE_UNLOCK(cur);
            NODE_UNLOCK(parent);
            //fprintf(stderr,"ENDING DELETE\n");
            return -1;
        }

        NODE_LOCK(next);
        NODE_UNLOCK(parent);
        parent = cur;
        cur = next;
    }

    //Leaf: remove node, relink parent to NULL
    if (cur->left == NULL && cur->right == NULL) {
        if (is_left) parent->left = NULL;
        else         parent->right = NULL;
        //it's all fine!
        NODE_UNLOCK(parent);
        NODE_UNLOCK(cur);
        bst_node_free(cur);
        //fprintf(stderr,"ENDING DELETE\n");
        return 0;
    }

    //One child: splice out cur, relink parent to cur's child
    if (cur->left == NULL || cur->right == NULL) {
        bst_node_t *child = (cur->left != NULL) ? cur->left : cur->right;
        if (is_left) parent->left = child;
        else         parent->right = child;
        //it's all fine!
        NODE_UNLOCK(parent);
        NODE_UNLOCK(cur);
        bst_node_free(cur);
        //fprintf(stderr,"ENDING DELETE\n");
        return 0;
    }

    //Two children: delegate to helper
    NODE_UNLOCK(parent);
    //fprintf(stderr,"INSIDE DELETE CALLING DELETE_TWO_CHILDREN LINE 429\n");
    delete_two_children(cur);
    //yeah, we got this already
    //fprintf(stderr,"ENDING DELETE\n");
    return 0;
}
