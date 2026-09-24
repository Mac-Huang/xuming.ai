// Author:  Vojtech Aschenbrenner <asch@cs.wisc.edu>, Fall 2023
// Revised: John Shawger <shawgerj@cs.wisc.edu>, Spring 2024
// Revised: Vojtech Aschenbrenner <asch@cs.wisc.edu>, Fall 2024
// Revised: Leshna Balara <lbalara@cs.wisc.edu>, Spring 2025
// Revised: Pavan Thodima <thodima@cs.wisc.edu>, Spring 2026

#include "parser.h"
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>

char *get_variable(const char *var);

static int is_builtin(const char *s);

static int builtin_cd(char **argv);

static int builtin_env(char **argv);

static int run_builtin_parent(struct command *cmd);

static void run_external(char **argv);

static int run_cmd(struct command *cmd);

static int run_ppl(struct pipeline *pl);

int main(int argc, char **argv) {
    int last_status = 0;

    FILE *file = stdin;
    int interactive = 0;

    // Interactive or Batch Mode
    if (argc == 1) {
        // interactive only if reading from a terminal
        interactive = isatty(STDIN_FILENO);
    } else if (argc == 2) {
        file = fopen(argv[1], "r");
        if (!file) { perror("fopen"); exit(1); }
    } else {
        fprintf(stderr, "Usage: ../solution/wsh [file]\n");
        exit(1);
    }

    // Shell Loop:
    char *input = NULL;
    size_t cap = 0;

    while (1) {
        // interactive mode
        // prints the prompt `wsh> `
        if (interactive) { printf("wsh> "); fflush(stdout); }

        // **Read**: Get the next command line from the user/file.
        ssize_t n = getline(&input, &cap, file);
        if (n == -1) break;

        // **Parse**: Break the command line into arguments
        struct command_line *cl = parse_input(input);
        if (!cl) continue;

        // **Execute**: Run the parsed command
        int num_ppl = cl->num_pipelines;

        // iterate command lines -> pipelines -> commands 
        for (int p = 0; p < num_ppl; p++) {

            struct pipeline *pl = &cl->pipelines[p];

            int num_cmd = pl->num_commands; 

            if (num_cmd == 1) { // single command
                struct command *cmd = &pl->commands[0];
                if (is_builtin(cmd->argv[0])) {
                    last_status = run_builtin_parent(cmd);
                } else {
                    last_status = run_cmd(cmd);
                }
            } else { // pipeline
                last_status = run_ppl(pl);
            }
        }

        free_command_line(cl);
    }

    free(input);
    if (file != stdin) fclose(file);
    return last_status;
}

// Parser hook for variable substitution.
char *get_variable(const char *var) {
    char *v = getenv(var);
    return v ? v : "";
}


static int run_ppl(struct pipeline *pl) {
    int n = pl->num_commands;
    if (n <= 0) return 0;

    pid_t *pids = (pid_t *)malloc(sizeof(pid_t) * n);
    if (!pids) { perror("malloc"); exit(1); }

    int prev_read = -1; // read-end of previous pipe (becomes stdin of current cmd)

    for (int i = 0; i < n; i++) {
        int fd[2] = {-1, -1}; // current pipe: fd[0]=read, fd[1]=write

        // create a pipe for all but the last command
        if (i < n - 1) {
            if (pipe(fd) < 0) { perror("pipe"); exit(1); }
        }

        pid_t rc = fork();
        if (rc < 0) { perror("fork"); exit(1); }

        if (rc == 0) { // child
                       // if there is a previous pipe, connect it to stdin
            if (prev_read != -1) {
                if (dup2(prev_read, STDIN_FILENO) < 0) { perror("dup2"); _exit(1); }
            }
            // if not last command, connect stdout to current pipe write end
            if (i < n - 1) {
                if (dup2(fd[1], STDOUT_FILENO) < 0) { perror("dup2"); _exit(1); }
            }

            // close fds in child (after dup2)
            if (prev_read != -1) close(prev_read);
            if (i < n - 1) { close(fd[0]); close(fd[1]); }

            struct command *cmd = &pl->commands[i];

            // builtins in a pipeline run in the child (do not affect parent shell)
            if (cmd->argv && cmd->argv[0] && is_builtin(cmd->argv[0])) {
                int st = 0;
                if (!strcmp(cmd->argv[0], "exit")) st = 0;
                else if (!strcmp(cmd->argv[0], "cd")) st = builtin_cd(cmd->argv);
                else if (!strcmp(cmd->argv[0], "env")) st = builtin_env(cmd->argv);
                fflush(stdout);
                _exit(st);
            }

            run_external(cmd->argv);
            _exit(1);
        }

        // parent
        pids[i] = rc;

        // parent must close fds it doesn't need
        if (prev_read != -1) close(prev_read);
        if (i < n - 1) { close(fd[1]); prev_read = fd[0]; }
        else prev_read = -1;
    }

    int last_status = 0;
    for (int i = 0; i < n; i++) {
        int st;
        if (waitpid(pids[i], &st, 0) < 0) { perror("waitpid"); exit(1); }
        if (i == n - 1) {
            last_status = WIFEXITED(st) ? WEXITSTATUS(st) : 1;
        }
    }

    free(pids);
    return last_status;


}


static int run_cmd(struct command *cmd) {

    int rc = fork();

    if (rc < 0) { perror("fork"); exit(1); }
    if (rc == 0) { run_external(cmd->argv); _exit(1);}

    int st;
    if (waitpid(rc, &st, 0) < 0) { perror("waitpid"); exit(1); }

    if (WIFEXITED(st)) return WEXITSTATUS(st);


    return 1;
}

static void run_external(char **argv) {
    if (!argv || !argv[0]) _exit(0);

    // absolute path
    if (argv[0][0] == '/') {
        execv(argv[0], argv);
        fprintf(stderr, "%s: Command not found\n", argv[0]);
        _exit(1); // `_exit()` used in child to avoid flush buffer twice
                  // cuz `exit()` called in parent will do that
                  // so child just need to do nothing but exit
    }

    char *path = getenv("PATH");

    if (!path || path[0] == '\0') {
        if (setenv("PATH", "/bin", 1) != 0) { perror("setenv"); _exit(1); }
        path = getenv("PATH");            // re-fetch
        if (!path) { 
            path = "/bin";
        }
    }

    // `strtok` can modify string
    char *cpy_path = strdup(path);

    if (!cpy_path) {
        perror("strdup");
        _exit(1);
    }

    char *saveptr = NULL;
    char *dir;

    // `strtok_r` is safer than `strtok`
    dir = strtok_r(cpy_path, ":", &saveptr);

    while (dir) {
        size_t path_len = strlen(dir) + 1 + strlen(argv[0]) + 1;
        char *candidate = (char *)malloc(path_len);
        if (!candidate) { perror("malloc"); _exit(1); }

        // Build "dir/command"
        snprintf(candidate, path_len, "%s/%s", dir, argv[0]);


        if (access(candidate, X_OK) == 0) {
            execv(candidate, argv);
            fprintf(stderr, "%s: Command not found\n", argv[0]);            _exit(1);
            // Once either success or fail
            // memory leak is not considered
            // because the child procces will die soon
        }

        free(candidate);
        // next token
        dir = strtok_r(NULL, ":", &saveptr);
    }

    free(cpy_path);

    fprintf(stderr, "%s: Command not found\n", argv[0]);
    _exit(1);
}

static int is_builtin(const char *s) {
    return s && (!strcmp(s, "exit") || !strcmp(s, "cd") || !strcmp(s, "env"));
}

// `cd [dir]`
// success return 0
static int builtin_cd(char **argv) {
    const char *path = NULL;
    char *dir = argv[1];

    if (!dir) { // No Arg case
        path = getenv("HOME");

        if (!path) { fprintf(stderr, "cd: HOME not set\n"); return 1;}
    } else {
        path = dir;
    }

    if (chdir(path) != 0) { perror("cd"); return 1;}

    return 0;
}

extern char **environ;
// `env [VAR=val]`
// success return 0
static int builtin_env(char **argv) {

    if (!argv[1]) { // No arguments
        for (char **e = environ; *e; e++) puts(*e);
        return 0;
    }

    for (int i = 1; argv[i]; i++) {
        const char *arg = argv[i];
        const char *eq = strchr(arg, '=');

        if (!eq) {
            // env VAR  => set VAR to empty
            if (setenv(arg, "", 1) != 0) { perror("setenv"); return 1; }
        } else {
            // env VAR=val
            size_t name_len = (size_t)(eq - arg);
            char *name = (char *)malloc(name_len + 1);
            if (!name) { perror("malloc"); return 1; }
            memcpy(name, arg, name_len);
            name[name_len] = '\0';

            const char *val = eq + 1; // may be ""
            int r = setenv(name, val, 1);
            free(name);
            if (r != 0) { perror("setenv"); return 1; }
        }
    }
    return 0;
}

// success return 0; otherwise, 1
static int run_builtin_parent(struct command *cmd) {
    char **argv = cmd->argv;

    if (!argv || !argv[0]) return 0;

    if (!strcmp(argv[0], "exit")) exit(0);
    if (!strcmp(argv[0], "cd")) return builtin_cd(argv);
    if (!strcmp(argv[0], "env")) return builtin_env(argv);

    return 0;
}

