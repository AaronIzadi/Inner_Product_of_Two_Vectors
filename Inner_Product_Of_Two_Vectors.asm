.data
		EnterN: .asciiz "Enter n:"
		EnterAi: .asciiz "Enter Ai:"
		EnterBi: .asciiz "Enter Bi:"
		Error: .asciiz "Error."
		Ans: .asciiz "answer is:"
.text
main:		# main program.
		la 	$a0, EnterN
		addi	$v0, $zero, 4		# print EnterN
		syscall
		addi 	$v0, $zero, 5 		# read int
		syscall 			# cin >> n;
		add 	$t4, $v0, $zero 	# t4 = n;
		sll	$t4, $t4, 2		# t4 = 4n;
		add 	$a0, $t4, $zero         # a0 = 4n;
		slti 	$t0, $v0 , 1		#if n<1
		bne	$t0, $zero , Error1
		addi  	$v0, $zero, 9		# syscall 9 aloc heap mem
		syscall
		add	$a1, $v0, $zero		# a1 = a.address;
		addi  	$v0, $zero, 9		# syscall 9 aloc heap mem
		syscall
		add	$a2, $v0, $zero		# a2 = b.address;
		addi	$t0, $zero, 0		# t0 = 0;
while1:
		beq	$t0, $t4, while1End	# if (t0 == n) break; // actually it is (4i == 4n)
		la 	$a0, EnterAi
		addi	$v0, $zero, 4		# print EnterAi
		syscall
		addi	$v0, $zero, 5		# read int
		syscall				# v0 = a[t0];
		add	$t1, $t0, $a1		# t1 = &a[t0];
		sw	$v0, 0($t1)
		addi 	$t0, $t0, 4
		j 	while1
while1End:
		addi	 $t0, $zero, 0		# t0 = 0;
while2:
		beq	$t0, $t4, while2End	# if (t0 == n) break;
		la 	$a0, EnterBi
		addi	$v0, $zero, 4		# print EnterBi
		syscall
		addi	$v0, $zero, 5		# read int
		syscall				# v0 = a[t0];
		add	$t1, $t0, $a2		
		sw	$v0, 0($t1)
		addi 	$t0, $t0, 4		# i++;
		j 	while2
while2End:
		jal	dotproduct
		add	$t5, $v0, $zero		# t5 = v0; // the answer
		la 	$a0, Ans
		addi	$v0, $zero, 4		# print Ans
		syscall	
		add	$a0, $t5, $zero		# a0 = t5; // the answer
		addi	$v0, $zero, 1		# print int
		syscall
		j 	exit

dotproduct:
		addi	$t0, $zero, 0
		addi	$v0, $zero, 0
while3:
		beq	$t0, $t4, while3End
		add	$t1, $t0, $a1		# t1 = &a[i];
		lw	$t2, 0($t1)		# t2 = a[i];
		add	$t1, $t0, $a2		# t1 = &b[i];
		lw	$t3, 0($t1)		# t3 = b[i];
		mult	$t2, $t3
		mflo	$t1			#t1 = a[i] * b[i] % (1 >> 32); // only first 32 bits
		add	$v0, $v0, $t1		# v0 += $t1;
		addi	$t0, $t0, 4		# i++;
		j 	while3
while3End:	
		jr	$ra
Error1:		la 	$a0, Error
		addi	$v0, $zero, 4		# print Error
		syscall		
exit:
