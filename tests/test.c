#include <stdio.h>
#include <string.h>

#include "dataset10.h"
#include "dataset16.h"
#include "dataset3.h"
#include "dataset50.h"

extern void mult_matrix(int *a, int *b, int *c, int n);

void ref_mult(int *a, int *b, int *c, int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            int sum = 0;
            for (int k = 0; k < n; k++) {
                sum += a[i*n + k] * b[k*n + j];
            }
            c[i*n + j] = sum;
        }
    }
}

int main() {
    int out_asm[ARRAY_SIZE];
    int out_ref[ARRAY_SIZE];

    memset(out_asm, 0, sizeof(out_asm));
    memset(out_ref, 0, sizeof(out_ref));

    mult_matrix(input1_data, input2_data, out_asm, DIM_SIZE);
    ref_mult(input1_data, input2_data, out_ref, DIM_SIZE);

    int errors = 0;
    for (int i = 0; i < ARRAY_SIZE; i++) {
        if (out_asm[i] != out_ref[i]) {
            printf("Mismatch at %d: asm=%d, ref=%d\n",
                   i, out_asm[i], out_ref[i]);
            errors++;
        }
    }

    if (errors == 0) {
        printf("Dataset verified: results match\n");
    } else {
        printf("%d mismatches\n", errors);
    }
    return errors;
}

