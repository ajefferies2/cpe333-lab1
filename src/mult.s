.data
a: 00, 01, 02, 10, 11, 12, 20, 21, 22
b: 00, 01, 02, 10, 11, 12, 20, 21, 22
c: 00, 01, 02, 10, 11, 12, 20, 21, 22
LEN 3

.text
main:
    
    lw a0, LEN
    lw a1, a
    lw a2, b


     

mult_matrix: 
    # a0: n/m a1: &a a2: &b, a3: &c
    addi sp, sp, -20 # make space on stack
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw a3, 16(sp)
    
    

mult_row:

mult_nums:
    # a0: &a[x] a1: &b[y]
    lw t0, 0(a0)
    lw t1, 0(a1)
    li t2, 0 # working sum
    li t3, 0 # mult cnt
    
    _mult_nums_loop:
        bgt t3, t1, _mult_nums_ret
        add t2, t2, t1
        j _mult_nums_loop

    _mult_nums_ret:
        mv a0, r2
        jr sp

mult_row:

