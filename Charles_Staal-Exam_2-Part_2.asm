.data

# two given array 

sectionA:	.word  56, 70, 90, 84, 45, 78, 96, 80, 88, 67, 58, 92, 0
sectionB:	.word  74, 59, 49, 88, 92, 76, 88, 72, 90,  50, 82, 0




.align 2

.macro print_ready_string(%str)
	.data
		Label: .asciiz %str
	.text
		li $v0, 4
		la $a0, Label
		syscall
.end_macro

.macro print_int(%int)
	li $v0, 1
	move $a0, %int
	syscall
.end_macro

.text
main:
	print_ready_string("Name: Charles Staal\n\n")
	print_ready_string("\t\tNo. of Student\tFail\tPass\tAverage\n")
	print_ready_string("--------------------------------------------------------------\n")
	print_ready_string("Section A\t\t")
	la $a0, sectionA
	jal Get_Results
	move $t0, $v0
	move $t1, $v1
	add $t2, $t0, $t1
	print_int($t2)
	print_ready_string("\t")
	print_int($t1)
	print_ready_string("\t")
	print_int($t0)
	print_ready_string("\t")
	la $a0, sectionA
	jal Get_Average
	move $t4, $v0
	print_int($t4)
	print_ready_string("\nSection B\t\t")
	la $a0, sectionB
	jal Get_Results
	move $t0, $v0
	move $t1, $v1
	add $t2, $t0, $t1
	print_int($t2)
	print_ready_string("\t")
	print_int($t1)
	print_ready_string("\t")
	print_int($t0)
	print_ready_string("\t")
	la $a0, sectionB
	jal Get_Average
	move $t4, $v0
	print_int($t4)
	
	j exit

Get_Results:
# a0 = address of section
# s0 = address of section
# v0 = passing grades
# v1 = failing grades
	move $s0, $a0
	li $v0, 0
	li $v1, 0

	loop:
		lw $t1, 0($s0)
		beqz $t1, end_results
		blt $t1, 60, failing
		addi $v0, $v0, 1
		return_from_failing:
		addi $s0, $s0, 4
		b loop

	failing:
		addi $v1, $v1, 1
		b return_from_failing

	end_results:
	jr $ra

Get_Average:
# a0 = address of section
# s0 = address of section
# s1 = total
# s2 = amount of grades

	move $s0, $a0
	li $s1, 0
	li $s2, 0
	li $v0, 0
	
	loop2:
		lw $t1, 0($s0)
		beqz $t1, end_average
		addi $s2, $s2, 1
		add $s1, $t1, $s1
		addi $s0, $s0, 4
		b loop2
		
	end_average:
	divu $t0, $s1, $s2
	move $v0, $t0
	jr $ra
	
exit:
	li	$v0,10
	syscall
	
	
