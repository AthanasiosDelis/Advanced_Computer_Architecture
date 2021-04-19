#ifndef LOCK_H_
#define LOCK_H_

#include <stdio.h>

typedef volatile int spinlock_t;

#define UNLOCKED  0
#define LOCKED    1

static inline void spin_lock_init(spinlock_t *spin_var)
{
    *spin_var = UNLOCKED;
}

static inline void spin_lock_tas_cas(spinlock_t *spin_var)
{
    while (__sync_val_compare_and_swap(spin_var, UNLOCKED, LOCKED) != UNLOCKED) {}
    // spin until previous was UNLOCKED and then set it to LOCKED
}

static inline void spin_lock_ttas_cas(spinlock_t *spin_var)
{
    do {
        while (*spin_var != UNLOCKED) {} // spin until it's UNLOCKED
    } while (__sync_val_compare_and_swap(spin_var, UNLOCKED, LOCKED) != UNLOCKED);
      // if someone else locked it before me start again
}

static inline void spin_lock_tas_ts(spinlock_t *spin_var)
{
    while (__sync_lock_test_and_set(spin_var, LOCKED) != UNLOCKED) {}
    // spin until previous was UNLOCKED, setting it to locked each time
}

static inline void spin_lock_ttas_ts(spinlock_t *spin_var)
{
    do {
        while (*spin_var != UNLOCKED) {} // spin until it's UNLOCKED
    } while (__sync_lock_test_and_set(spin_var, LOCKED) != UNLOCKED);
      // if someone else locked it before me start again
}

static inline void spin_unlock(spinlock_t *spin_var)
{
    __sync_lock_release(spin_var);
}


#endif
