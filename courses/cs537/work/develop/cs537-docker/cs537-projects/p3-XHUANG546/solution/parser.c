#include "parser.h"
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Helper: Frees a single command struct */
static void free_command(struct command *cmd) {
  if (!cmd)
    return;
  if (cmd->argv) {
    for (int i = 0; cmd->argv[i] != NULL; i++) {
      free(cmd->argv[i]);
    }
    free(cmd->argv);
  }
}

/* Helper: Frees a pipeline struct */
static void free_pipeline(struct pipeline *pl) {
  if (!pl)
    return;
  if (pl->commands) {
    for (int i = 0; i < pl->num_commands; i++) {
      free_command(&pl->commands[i]);
    }
    free(pl->commands);
  }
}

/* Public: Frees the entire command_line structure */
void free_command_line(struct command_line *cl) {
  if (!cl)
    return;
  if (cl->pipelines) {
    for (int i = 0; i < cl->num_pipelines; i++) {
      free_pipeline(&cl->pipelines[i]);
    }
    free(cl->pipelines);
  }
  free(cl);
}

// --- HOOKS ---
// Weak symbols allow linking to succeed without these functions defined in
// wsh.c yet. Once defined in wsh.c, those definitions will override these.

__attribute__((weak)) char *get_variable(const char *var) {
  (void)var;
  return ""; // Default: empty string
}

// --- STATE MACHINE PARSER ---

// Helper struct to manage the dynamic building of a token
struct token_builder {
  char *buffer;
  int size;
  int capacity;
};

static void tb_init(struct token_builder *tb) {
  tb->capacity = 64;
  tb->buffer = malloc(tb->capacity);
  tb->size = 0;
  tb->buffer[0] = '\0';
}

static void tb_append_char(struct token_builder *tb, char c) {
  if (tb->size + 1 >= tb->capacity) {
    tb->capacity *= 2;
    tb->buffer = realloc(tb->buffer, tb->capacity);
  }
  tb->buffer[tb->size++] = c;
  tb->buffer[tb->size] = '\0';
}

static void tb_append_str(struct token_builder *tb, char *str) {
  if (!str)
    return;
  int len = strlen(str);
  while (tb->size + len + 1 >= tb->capacity) {
    tb->capacity *= 2;
    tb->buffer = realloc(tb->buffer, tb->capacity);
  }
  strcpy(tb->buffer + tb->size, str);
  tb->size += len;
}

static char *tb_finalize(struct token_builder *tb) {
  return tb->buffer; // Caller takes ownership
}

// Parses a single argument from the input string [cursor, end)
// Returns a dynamically allocated string for the argument, or NULL if no more
// args. Updates *cursor to point after the argument.
static char *get_next_argument(char **cursor, char *end) {
  char *p = *cursor;

  // Skip leading whitespace
  while (p < end && isspace((unsigned char)*p)) {
    p++;
  }

  if (p >= end) {
    *cursor = p;
    return NULL;
  }

  struct token_builder tb;
  tb_init(&tb);

  int inside_double = 0;
  int inside_single = 0;

  while (p < end) {
    char c = *p;

    // 1. Whitespace Delimiter
    if (isspace((unsigned char)c) && !inside_double && !inside_single) {
      break; // End of argument
    }

    // 2. Single Quotes (Strong Quote)
    if (c == '\'' && !inside_double) {
      inside_single = !inside_single;
      p++;
      continue;
    }

    // 3. Double Quotes (Weak Quote)
    if (c == '\"' && !inside_single) {
      inside_double = !inside_double;
      p++;
      continue;
    }

    // 4. Escape Character
    if (c == '\\' && !inside_single) {
      p++; // consume backslash
      if (p < end) {
        tb_append_char(&tb, *p);
        p++;
      }
      continue;
    }

    // Substitutions ($)
    if (c == '$' && !inside_single) {
      p++; // Consume '$'
      if (p >= end) {
        tb_append_char(&tb, '$'); // Trailing $, allow literal
        continue;
      }

      // $VAR (simple)
      // Alphanumeric + _
      char *var_start = p;
      while (p < end && (isalnum((unsigned char)*p) || *p == '_')) {
        p++;
      }
      int var_len = p - var_start;
      if (var_len > 0) {
        char *var_name = malloc(var_len + 1);
        strncpy(var_name, var_start, var_len);
        var_name[var_len] = '\0';
        char *val = get_variable(var_name);
        tb_append_str(&tb, val);
        free(var_name);
      } else {
        // Just a standalone $
        tb_append_char(&tb, '$');
      }
      continue;
    }
    // Regular character
    tb_append_char(&tb, c);
    p++;
  }
  *cursor = p;
  return tb_finalize(&tb);
}

// Parses a single command string into a struct command
// Handles quotes, arguments, and substitutions.
static void parse_single_command(char *start, char *end, struct command *cmd) {
  cmd->argv = malloc(sizeof(char *) * (MAX_ARGS + 1));
  int argc = 0;
  char *cursor = start;
  while (cursor < end && argc < MAX_ARGS) {
    char *arg = get_next_argument(&cursor, end);
    if (!arg) {
      break;
    }
    cmd->argv[argc++] = arg;
  }
  cmd->argv[argc] = NULL;
}

static char *find_next_delimiter(char *start, char *end, char delim) {
  char *p = start;
  int inside_double = 0;
  int inside_single = 0;
  while (p < end) {
    char c = *p;
    if (c == '\'' && !inside_double) {
      inside_single = !inside_single;
    } else if (c == '\"' && !inside_single) {
      inside_double = !inside_double;
    } else if (c == '\\' && !inside_single) {
      p++;
    } else if (c == delim && !inside_single && !inside_double) {
      return p;
    }
    p++;
  }
  return p;
}

// Parses a pipeline string (e.g. "ls | grep foo") into a struct pipeline
static void parse_pipeline_segment(char *start, char *end,
                                   struct pipeline *pl) {
  pl->num_commands = 0;
  int cmd_cap = 2;
  pl->commands = malloc(sizeof(struct command) * cmd_cap);
  char *p_cursor = start;
  while (p_cursor < end) {
    char *cmd_start = p_cursor;
    char *cmd_end = find_next_delimiter(p_cursor, end, '|');
    if (pl->num_commands >= cmd_cap) {
      cmd_cap *= 2;
      pl->commands = realloc(pl->commands, sizeof(struct command) * cmd_cap);
    }
    // Parse the single command string [cmd_start, cmd_end)
    parse_single_command(cmd_start, cmd_end, &pl->commands[pl->num_commands++]);
    p_cursor = cmd_end + 1; // Skip the pipe
  }
}

struct command_line *parse_input(char *line) {
  if (!line)
    return NULL;
  // Remove trailing newline
  line[strcspn(line, "\n")] = 0;

  // Skip empty lines or comments (simple check)
  char *p = line;
  while (*p && isspace((unsigned char)*p))
    p++;
  if (*p == '\0' || *p == '#')
    return NULL;
  struct command_line *cl = malloc(sizeof(struct command_line));
  memset(cl, 0, sizeof(struct command_line));

  // Level 1: Split by Semicolon
  char *cursor = line;
  int len = strlen(line);
  char *end_of_input = line + len;
  int pl_cap = 2;
  cl->pipelines = malloc(sizeof(struct pipeline) * pl_cap);
  cl->num_pipelines = 0;
  while (cursor < end_of_input) {
    char *pl_start = cursor;
    char *pl_end = find_next_delimiter(cursor, end_of_input, ';');
    if (cl->num_pipelines >= pl_cap) {
      pl_cap *= 2;
      cl->pipelines = realloc(cl->pipelines, sizeof(struct pipeline) * pl_cap);
    }
    struct pipeline *pl = &cl->pipelines[cl->num_pipelines++];
    parse_pipeline_segment(pl_start, pl_end, pl);
    cursor = pl_end + 1; // Skip the semicolon
  }
  return cl;
}
