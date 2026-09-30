/*
 * Port of the active recursive algorithm in part2.rb.
 * Build: clang -std=c11 -O2 -Wall -Wextra -Werror part2.c -o part2
 * Run:   ./part2 < input.txt
 *
 * Each source is a suffix of one unchanged input line. Its position
 * identifies its content, so the memo key is (digit, suffix, remaining).
 * Cached values are the concatenated strings, as in the Ruby program.
 * Keep the recursive search even when remaining is zero or negative.
 * Input is digit lines from the puzzle. A terminal CR is also preserved.
 */
#define _POSIX_C_SOURCE 200809L

#include <errno.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum { DIGITS = 12 };

typedef struct {
    size_t suffix;
    int64_t remaining;
    unsigned char digit;
    bool used;
    char answer[DIGITS + 1];
} Entry;

typedef struct {
    Entry *entries;
    size_t capacity;
    size_t size;
    const char *source;
    size_t length;
} Memo;

static void fail(const char *message) {
    fprintf(stderr, "%s\n", message);
    exit(EXIT_FAILURE);
}

static Entry *allocate_entries(size_t count) {
    if (count > SIZE_MAX / sizeof(Entry)) fail("memo table is too large");
    Entry *entries = calloc(count, sizeof(Entry));
    if (!entries) fail("cannot allocate memo table");
    return entries;
}

static uint64_t key_hash(unsigned char digit, size_t suffix, int64_t remaining) {
    uint64_t h = (uint64_t)suffix * UINT64_C(0x9e3779b97f4a7c15);
    h ^= (uint64_t)remaining * UINT64_C(0xbf58476d1ce4e5b9);
    h ^= (uint64_t)digit * UINT64_C(0x94d049bb133111eb);
    h ^= h >> 30;
    h *= UINT64_C(0xbf58476d1ce4e5b9);
    h ^= h >> 27;
    h *= UINT64_C(0x94d049bb133111eb);
    return h ^ (h >> 31);
}

static size_t find_slot(const Memo *memo, unsigned char digit,
                        size_t suffix, int64_t remaining) {
    size_t slot = (size_t)key_hash(digit, suffix, remaining) & (memo->capacity - 1);
    while (memo->entries[slot].used) {
        const Entry *entry = &memo->entries[slot];
        if (entry->digit == digit && entry->suffix == suffix &&
            entry->remaining == remaining) break;
        slot = (slot + 1) & (memo->capacity - 1);
    }
    return slot;
}

static void grow(Memo *memo) {
    size_t old_capacity = memo->capacity;
    Entry *old_entries = memo->entries;
    if (old_capacity > SIZE_MAX / 2) fail("memo table is too large");
    memo->capacity = old_capacity ? old_capacity * 2 : 256;
    memo->entries = allocate_entries(memo->capacity);
    for (size_t i = 0; i < old_capacity; i++) {
        if (!old_entries[i].used) continue;
        Entry entry = old_entries[i];
        size_t slot = find_slot(memo, entry.digit, entry.suffix, entry.remaining);
        memo->entries[slot] = entry;
    }
    free(old_entries);
}

static void store(Memo *memo, unsigned char digit, size_t suffix,
                  int64_t remaining, const char *answer) {
    if (memo->size >= memo->capacity - memo->capacity / 4) grow(memo);
    size_t slot = find_slot(memo, digit, suffix, remaining);
    Entry *entry = &memo->entries[slot];
    if (!entry->used) memo->size++;
    entry->used = true;
    entry->digit = digit;
    entry->suffix = suffix;
    entry->remaining = remaining;
    memcpy(entry->answer, answer, strlen(answer) + 1);
}

static void largest(Memo *memo, size_t start, int64_t remaining,
                    char answer[DIGITS + 1]) {
    answer[0] = '\0';
    for (size_t right_index = start; right_index < memo->length; right_index++) {
        unsigned char digit = (unsigned char)memo->source[right_index];
        size_t suffix = right_index + 1;
        int64_t new_remaining = remaining - 1;
        size_t slot = find_slot(memo, digit, suffix, new_remaining);
        char candidate[DIGITS + 1];
        if (memo->entries[slot].used) {
            memcpy(candidate, memo->entries[slot].answer,
                   strlen(memo->entries[slot].answer) + 1);
        } else {
            char rest[DIGITS + 1];
            largest(memo, suffix, new_remaining, rest);
            size_t rest_length = strlen(rest);
            if (rest_length >= DIGITS) fail("memo result exceeds twelve characters");
            candidate[0] = (char)digit;
            memcpy(candidate + 1, rest, rest_length + 1);
            /* Recursion can grow the table. Do not retain an entry pointer. */
            store(memo, digit, suffix, new_remaining, candidate);
        }
        if ((int64_t)strlen(candidate) == remaining && strcmp(candidate, answer) > 0)
            memcpy(answer, candidate, strlen(candidate) + 1);
    }
}

static void print_line(const char *line, size_t length, uint64_t answer) {
    fputs("[\"", stdout);
    for (size_t i = 0; i < length; i++) {
        if (line[i] == '\r') fputs("\\r", stdout);
        else putchar((unsigned char)line[i]);
    }
    printf("\", %" PRIu64 "]\n", answer);
}

int main(void) {
    char *line = NULL;
    size_t capacity = 0;
    ssize_t count;
    uint64_t total = 0;
    while ((count = getline(&line, &capacity, stdin)) >= 0) {
        size_t length = (size_t)count;
        /* readlines(chomp: true) removes CR only when it precedes LF. */
        if (length && line[length - 1] == '\n') {
            length--;
            if (length && line[length - 1] == '\r') length--;
        }
        line[length] = '\0';
        for (size_t i = 0; i < length; i++) {
            if ((line[i] < '0' || line[i] > '9') && line[i] != '\r')
                fail("input must contain digit lines");
        }
        if (length > INT64_MAX - DIGITS) fail("input line is too long");
        Memo memo = {.source = line, .length = length};
        grow(&memo);
        char result[DIGITS + 1];
        largest(&memo, 0, DIGITS, result);
        errno = 0;
        uint64_t answer = strtoull(result, NULL, 10);
        if (errno == ERANGE || total > UINT64_MAX - answer) fail("answer overflow");
        print_line(line, length, answer);
        total += answer;
        free(memo.entries);
    }
    free(line);
    if (!feof(stdin) || ferror(stdin)) fail("cannot read standard input");
    printf("\n%" PRIu64 "\n", total);
    if (fflush(stdout) == EOF) fail("cannot write standard output");
    return EXIT_SUCCESS;
}
