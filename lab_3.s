.extern print_result

.section .data
prompt1: .ascii "Enter first string:\n"
prompt1_len = . - prompt1
prompt2: .ascii "Enter second string:\n"
prompt2_len = . - prompt2

.section .bss
input1: .space 32
input2: .space 32
len1: .space 8
len2: .space 8

.section .text
.global main

main:

    # prompt for first string
    mov $1, %rax # sys_write
    mov $1, %rdi #stdout
    mov $prompt1, %rsi
    mov $prompt1_len, %rdx
    syscall

    ### Read first string
    mov $0, %rax    # sys_read
    mov $0, %rdi    #stdin
    mov $input1, %rsi   # store in input1 buffer
    mov $255, %rdx
    syscall
    sub $1, %rax
    mov %rax, len1   # max bytes to be Read

    # prompt for second string
    mov $1, %rax # sys_write
    mov $1, %rdi #stdout
    mov $prompt2, %rsi
    mov $prompt2_len, %rdx
    syscall

    ### Read second string
    mov $0, %rax    # sys_read
    mov $0, %rdi    #stdin
    mov $input2, %rsi   # store in input2 buffer
    mov $255, %rdx   # max bytes to be Read
    syscall
    sub $1, %rax
    mov %rax, len2

    ### Find Shorter Length
    mov len1, %rcx      # move len1 to %rcx
    cmp len2, %rcx      # compare len2 to value in %rcx
    jle start_compare   # jump is less or equal (JLE), if len1 < len2, jump over next line
    mov len2, %rcx      # if above jle failed, len2 is smaller

start_compare:
    # checks if empty string
    cmp $0, %rcx        # rcx holds the length of the shorter string, it it's 0, it finishes the program
    jle finish

    mov $input1, %rsi   # source index, puts address of first string
    mov $input2, %rdi   # dest index, puts address of second string
    xor %r12, %r12      # stores the total number of bit differences

char_loop:
    movzb (%rsi), %rax
    movzb (%rdi), %rbx
    xor %rbx, %rax

    mov $8, %rdx

bit_loop:
    test $1, %rax
    jz next_bit
    inc %r12
next_bit:
    shr $1, %rax
    dec %rdx
    jnz bit_loop

    inc %rsi
    inc %rdi
    dec %rcx
    jnz char_loop

finish:
    mov %r12, %rdi
    call print_result
    mov $60, %rax
    mov $0, %rdi
    syscall

    
    .section .note.GNU-stack,"",@progbits
