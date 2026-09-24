#ifndef RUNTIME_SYSCALLS_H
#define RUNTIME_SYSCALLS_H

#include <sys/syscall.h>

#include "container.h"


#if defined(SYS_readlink)
#define CT_SYSCALL_READLINK SYS_readlink
#elif defined(SYS_readlinkat)
#define CT_SYSCALL_READLINK SYS_readlinkat
#else
#error "No readlink-like syscall available on this platform"
#endif

#if defined(SYS_mkdir)
#define CT_SYSCALL_MKDIR SYS_mkdir
#elif defined(SYS_mkdirat)
#define CT_SYSCALL_MKDIR SYS_mkdirat
#else
#error "No mkdir-like syscall available on this platform"
#endif

#if defined(SYS_dup2)
#define CT_SYSCALL_DUP SYS_dup2
#elif defined(SYS_dup3)
#define CT_SYSCALL_DUP SYS_dup3
#else
#error "No dup-like syscall available on this platform"
#endif

#ifdef SYS_arch_prctl
#define CT_SYSCALL_ARCH_PRCTL SYS_arch_prctl
#else
#define CT_SYSCALL_ARCH_PRCTL CT_SYSCALL_READLINK
#endif

#ifdef SYS_rseq
#define CT_SYSCALL_RSEQ SYS_rseq
#else
#define CT_SYSCALL_RSEQ CT_SYSCALL_READLINK
#endif

#endif
