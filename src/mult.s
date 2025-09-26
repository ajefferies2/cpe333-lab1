.data
mat_a: .word 0, 3, 2, 0, 3, 1, 0, 3, 2
mat_b: .word 1, 1, 0, 3, 1, 2, 0, 0, 0
mat_c: .word 101, 101, 101, 101, 101, 101, 101, 101, 101

.text
main:	li	sp,0x10000	#init sp
	la	a0,mat_a	#get &a
    	la	a1,mat_b	#get &b
    	la	a2,mat_c	#get &c
    	addi	a3,zero,3	#create matrix size
    	call	mult_matrix	#call matrix multiply function
die:	j	die    		#freeze


#a0 = m1, a1 = m2, a2 = mResult, a3 = matrixSize
mult_matrix:	addi	sp,sp,-56	#allocate context save
		sw	s0,0(sp)	#save s0
		sw	s1,4(sp)	#save s1
		sw	s2,8(sp)	#save s2
		sw	s3,12(sp)	#save s3
		sw	s4,16(sp)	#save s4
		sw	s5,20(sp)	#save s5
		sw	s6,24(sp)	#save s6
		sw	a0,28(sp)	#save a0
		sw	a1,32(sp)	#save a1
		sw	t0,36(sp)	#save t0
		sw	t2,40(sp)	#save t2
		sw	t3,44(sp)	#save t3
		sw	t4,48(sp)	#save t4
		sw	ra,52(sp)	#save ra

		mv	s0,a0		#preserve a0
		mv	s1,a1		#preserve a1
		mv	s2,a2		#preserve a2
		mv	s3,a3		#preserve a3
		
		mv	s4,zero		#int i = 0
rowLoop:	bge	s4,s3,rDone	#if i >= matrixSize, exit loop
		mv	s5,zero		#int j = 0
		
colLoop:	bge	s5,s3,cDone	#if j >= matrixSize, exit loop
		mv	s6,zero		#int k = 0
		mv	t0,zero		#int result = 0
		
inLoop:		bge	s6,s3,iDone	#if k >= matrixSize, exit loop
		
fetch_m1:	slli	a0,s4,2		#a0 = i * 4
		mv	a1,s3		#a1 = matrixSize
		call	mult_nums	#a0 = (i*4) * matrixSize 
		add	t2,s0,a0	#t2 = m1 row address
		slli	t3,s6,2		#t3 = k * 4
		add	t2,t2,t3	#t2 = &m1[i][k]
		lw	t2,0(t2)	#t2 = m1[i][k]
		
fetch_m2:	slli	a0,s6,2		#a0 = k * 4
		mv	a1,s3		#a1 = matrixSize
		call	mult_nums	#a0 = (k*4) * matrixSize
		add	t3,s1,a0	#t3 = m2 row address
		slli	t4,s5,2		#t4 = j * 4
		add	t3,t3,t4	#t3 = &m2[k][j]
		lw	t3,0(t3)	#t3 = m2[k][j]
		
add_result:	mv	a0,t2		#a0 = m1[i][k]
		mv	a1,t3		#a1 = m2[k][j]
		call	mult_nums	#a0 = m1[i][k] * m2[k][j]
		add	t0,t0,a0	#result += m1[i][k] * m2[k][j]
		
		addi	s6,s6,1		#k++
		j	inLoop		#restart loop
		
iDone:		slli	a0,s4,2		#a0 = i * 4
		mv	a1,s3		#a1 = matrixSize
		call	mult_nums	#a0 = (i*4) * matrixSize
		add	t2,s2,a0	#t2 = mResult row address
		slli	t3,s5,2		#t3 = j * 4
		add	t2,t2,t3	#t2 = &mResult[i][j]
		sw	t0,0(t2)	#mResult[i][j] = result

		addi	s5,s5,1		#j++
		j	colLoop		#restart loop
		
cDone:		addi	s4,s4,1		#i++
		j	rowLoop		#restart loop
		
rDone:		lw	s0,0(sp)	#restore s0
		lw	s1,4(sp)	#restore s1
		lw	s2,8(sp)	#restore s2
		lw	s3,12(sp)	#restore s3
		lw	s4,16(sp)	#restore s4
		lw	s5,20(sp)	#restore s5
		lw	s6,24(sp)	#restore s6
		lw	a0,28(sp)	#restore a0
		lw	a1,32(sp)	#restore a1
		lw	t0,36(sp)	#restore t0
		lw	t2,40(sp)	#restore t2
		lw	t3,44(sp)	#restore t3
		lw	t4,48(sp)	#restore t4
		lw	ra,52(sp)	#restore ra
		addi	sp,sp,56	#deallocate context save

		ret
		
		
		
    
#a0 = int x, a1 = int y, returns int z to a0
mult_nums:	addi	sp,sp,-8	#allocate context save
		sw	t0,0(sp)	#save t0
		sw	t2,4(sp)	#save t2

		mv	t0,zero		#int result = 0
		mv	t2,zero		#int i = 0
mloop:		bge	t2,a0,mult_done	#if i >= x, exit loop
		add	t0,t0,a1	#result += y
		addi	t2,t2,1		#i++
		j	mloop		#restart loop
		
mult_done:	mv	a0,t0		#move result to return register

		lw	t0,0(sp)	#restore t0
		lw	t2,4(sp)	#restore t2
		addi	sp,sp,8		#deallocate context save
		
		ret
		
		
		
