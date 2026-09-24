#ifndef PARSER_H
#define PARSER_H

#define MAX_ARGS 128

/* * struct command
 * Represents a single command, e.g., "ls -l"
 */
struct command {
  char **argv; // Argument vector, NULL terminated
};

/* * struct pipeline
 * Represents a sequence of commands connected by pipes, e.g., "ls | grep foo"
 * If num_commands == 1, it is a simple command (no pipe).
 */
struct pipeline {
  struct command *commands; // Array of commands
  int num_commands;         // Length of the array
};

/* * struct command_line
 * Represents the full input line, separated by semicolons, e.g.,
 "cmd1 | cmd2 ; cmd3". Pipelines should be executed sequentially.
 */
struct command_line {
  struct pipeline *pipelines; // Array of pipelines
  int num_pipelines;          // Length of the array
};

/* Functions */
struct command_line *parse_input(char *line);
void free_command_line(struct command_line *cl);

/* Hook functions for variable and command substitution.
 * Students must implement these in wsh.c.
 * The parser provides weak default implementations that return empty strings.
 */
char *get_variable(const char *var);

#endif
