#define _GNU_SOURCE
#include <ctype.h>
#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *line;
    char *key_start; // pointer to the kth word inside line
    size_t key_len; // to compare with the kth word
                    // instead of the rest string
} Sentence;

static int g_k = 0; // global k

static int parse_k(char *k_str, int *k);
int read_sentences(char *file, int k, Sentence **out_arr,size_t *out_n);
static int process_kth_word(Sentence *s, int k);
static void free_sentences(Sentence *arr, size_t n);
static int cmp_sentences(const void *a, const void *b);

int main(int argc, char *argv[]) {
    // Check the inputs
    int unique = 0;    
    char *file = NULL;
    char *k_str = NULL;

    if (argc == 3) {
        file = argv[1];
        k_str = argv[2];
    } else if (argc == 4) {
        if (strcmp(argv[1], "-u") != 0) return 1;
        unique = 1;
        file = argv[2];
        k_str = argv[3];
    } else {
        return 1;
    }

    // get the legal global int k
    if (!parse_k(k_str, &g_k)) return 1;

    // read lines from file to a buffer
    Sentence *arr = NULL;
    size_t n = 0; // the amount of sentences

    if (read_sentences(file, g_k, &arr, &n))
        return 1;

    if (n == 0) {
        free(arr);
        return 0;
    }

    // quick sort the sentences
    qsort(arr, n, sizeof(*arr), cmp_sentences);

    // print to the terminal
    if (!unique) {
        for (size_t i = 0; i < n; i++) {
            printf("%s\n", arr[i].line);
        }
    } else {
        printf("%s\n", arr[0].line);
        for (size_t i = 1; i < n; i++) {
            if (strcmp(arr[i - 1].line, arr[i].line) != 0) {
                printf("%s\n", arr[i].line);
            }
        }
    }

    free_sentences(arr, n);
    return 0;
}

// k should be 4-byte signed integer, must not be 0
static int parse_k(char *k_str, int *k) {
    // long strtol(const char *nptr, char **endptr, int base);
    // I can't use `atoi()` to detect non-digital input
    errno = 0; // long overflow/underflow sets errno = ERANGE
    char *end = NULL;
    long v = strtol(k_str, &end, 10);

    if (end == k_str) return 0;
    if (*end != '\0') return 0;
    if (errno == ERANGE) return 0;
    if (v < INT_MIN || v > INT_MAX) return 0;
    if (v == 0) return 0;

    *k = (int) v;

    return 1;
}

// Returns 0 on success, 1 on error.
int read_sentences(char *file, int k, Sentence **out_arr,
        size_t *out_n) {
    FILE *fp = fopen(file, "r");
    if (!fp) return 1;

    Sentence *arr = NULL;
    size_t count = 0, cap = 0; // for dynamical upsize
    
    size_t n = 0;
    char *line = NULL;
    ssize_t r;

    while ((r = getline(&line, &n, fp)) != -1) {
        // Make sure it's complete string sentence
        if (r > 0 && line[r - 1] == '\n') line[r - 1] = '\0';

        char *dup = strdup(line);
        if (!dup) goto allocation_fail;

        Sentence s = {.line = dup};

        int is_good_k = process_kth_word(&s, k);
        // not a good k
        // allocation fail
        if (is_good_k < 0) {
            free(dup);
            goto allocation_fail;
        }
        // k is out of boundry
        if (is_good_k == 0) {
            free(dup);
            continue; // skip this sentence
        }

        // dynamically extend
        if (count == cap) {
            size_t newcap = cap ? 2 * cap : 16;
            Sentence *temp = realloc(arr, newcap * sizeof(*arr));
            if (!temp) {
                free(dup);
                goto allocation_fail;
            }
            arr = temp;
            cap = newcap;
        }

        arr[count++] = s;
    }

    // free the buffer   
    free(line);
    fclose(fp);

    *out_arr = arr;
    *out_n = count;

    return 0;


// Bunch of allocation fail cases could happen        
allocation_fail:
        free(line);
        fclose(fp);
        free_sentences(arr, count);
        return 1;
}


// 1. build a 2D array to store the starts of each word
// 2. check if the kth word accessable
// return -1 -> allocation fail
// return 0 -> k out of bound
// return 1 -> good
static int process_kth_word(Sentence *s, int k) {
    // set dynamical array
    size_t count = 0;
    size_t cap = 8;
    // store pointers to the words start
    char **word_starts = malloc(cap * sizeof(*word_starts));
    if (!word_starts) return -1;

    char *p = s -> line;

    // 1. collect pointers to the start of each word
    while (*p) {
        while (*p == ' ') p++;

        if (*p == '\0') break;

        if (count == cap) {
            cap *= 2;
            char **temp = realloc(word_starts, 
                    cap * sizeof(*word_starts));
            if (!temp) {
                free(word_starts);
                return -1;
            }
            word_starts = temp;
        }

        word_starts[count++] = p;

        // skip the rest of word or hit the end of the sentence
        while (*p && *p != ' ') p++;
    }

    // 2. check whether the k-th word exists
    size_t abs_k = (k < 0) ? (size_t)(-(long)k) : (size_t)k; 
    if (count < abs_k) {
        free(word_starts);
        return 0;   // sentence too short -> drop
    }

    // locate the k-th word
    size_t index;
    if (k > 0)
        index = abs_k - 1;        // k-th from the front
    else
        index = count - abs_k;    // |k|-th from the end

    char *start = word_starts[index];
    char *end = start;

    while (*end && *end != ' ')
        end++;

    s->key_start = start;
    s->key_len   = (size_t)(end - start);

    // we no longer need the array, just for looking up once
    free(word_starts);
    return 1;
}

static void free_sentences(Sentence *arr, size_t n) {
    if (!arr) return;
    for (size_t i = 0; i < n; i++) free(arr[i].line);
    free(arr);
}

static int cmp_sentences(const void *a, const void *b) {
    const Sentence *sa = (const Sentence *)a;
    const Sentence *sb = (const Sentence *)b;

    char *akey = sa -> key_start;
    char *bkey = sb -> key_start;
    size_t alen = sa -> key_len;
    size_t blen = sb -> key_len;
    // get the smaller one as comparing size
    char a_less_b = alen < blen;
    size_t len = a_less_b ? alen : blen;

    int cmp = memcmp(akey, bkey, len);

    // first len char decide
    if (cmp) return cmp;

    // if tie and same length, check from header
    if (alen == blen) return strcmp(sa->line, sb->line);

    // if not same length, shorter the prior
    if (a_less_b) return -1;
    else return 1;
}



