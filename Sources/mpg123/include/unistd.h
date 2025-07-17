/*
 * Windows compatibility header for unistd.h
 * Provides POSIX functions that mpg123 needs on Windows
 */

#ifndef UNISTD_H
#define UNISTD_H

#ifdef _WIN32

#include <io.h>
#include <process.h>
#include <direct.h>
#include <windows.h>

/* POSIX file operations */
#define access _access
#define chdir _chdir
#define close _close
#define dup _dup
#define dup2 _dup2
#define execl _execl
#define execle _execle
#define execlp _execlp
#define execlpe _execlpe
#define execv _execv
#define execve _execve
#define execvp _execvp
#define execvpe _execvpe
#define getcwd _getcwd
#define getpid _getpid
#define isatty _isatty
#define lseek _lseek
#define read _read
#define rmdir _rmdir
#define setmode _setmode
#define sleep(seconds) Sleep((seconds) * 1000)
#define unlink _unlink
#define write _write

/* POSIX constants */
#define F_OK 0
#define R_OK 4
#define W_OK 2
#define X_OK 1

#define STDIN_FILENO 0
#define STDOUT_FILENO 1
#define STDERR_FILENO 2

/* POSIX types */
typedef int ssize_t;

/* Function declarations */
#ifdef _WIN32
int close(int fd);
ssize_t read(int fd, void *buf, size_t count);
ssize_t write(int fd, const void *buf, size_t count);
#endif

#else
/* On non-Windows platforms, include the real unistd.h */
#include <unistd.h>
#endif

#endif /* UNISTD_H */ 