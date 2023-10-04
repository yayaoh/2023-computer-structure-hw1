.data
data_set_1:.word 5, 15, 23, 56, 89, 14, 45, 21, 73, 32
data_set_2:.word 120, 215, 89, 354, 26, 123, 4151, 258, 53, 221
data_set_3:.word 512, 215, 631, 786, 910, 612, 453, 823, 174, 328
.text
text1:
    # Initialize your data pointer
    la a0, data_set_1 
    lw t0, 0(a0) # Set first value as default maximum number of set1
    li t2, 27    # Set loop counter = 3*each set we need to offset
    li t3, 18    # Set1 done, move on to next set
    j main_loop
text2:    
    la a0, data_set_2 
    lw t0, 0(a0) # Set first value as default maximum number of set2 
    li t3, -1    # Set a signed number in case no beq at anytime 
    li t4, 9     # Set2 done, move on to last set
    j main_loop
text3:
    la a0, data_set_3
    lw t0, 0(a0) # set first value as default maximum number of set3
    li t4, -1    # Set a signed number in case beq at anytime 

    
main_loop:
    beq  t2, t3, text2  # if t2=t3, move on to data set2
    beq  t2, t4, text3  # if t3=t4, move on to data set3
    beqz t2, exit       # all task done
    addi t2, t2, -1     # Decrement loop counter and increment data pointer
    addi a0, a0, 4      # move on to next number's address
    lw t1, 0(a0)        # Load next number
    call maximum_of_two # Call maximum_of_two function

    
    
   


maximum_of_two:
    call count_leading_zeros     # call count_leading_zeros 

    # Compare and determine the maximum value by numbers of leading zeros
    blt t0, t1, t0_is_greater    #t0 > t1 means ori number set[i+1] > set[i]
    bgt t0, t1, t1_is_greater    #t1 > t1 means ori number set[i] > set[i+1]

    # If leading zeros count is the same, use direct comparison
    bgt a6, a7, t0_is_greater    #a6 > a7 means set[i] > set[i+1], very straight forward
    j t1_is_greater              #last case, so use jump
    

t0_is_greater:
    mv t0,a6      #remain maximun number as default
    j main_loop   #back to the loop

t1_is_greater:
    mv t0,a7      #change maximum number
    j main_loop   #back to the loop

count_leading_zeros:
    mv a6,t0    #store original number
    mv a7,t1      
    
    #x |= (x>>1)
    srli a1, t0, 1
    or  t0, t0, a1
    srli a1, t1, 1
    or  t1, t1, a1
    
    #x |= (x>>2)
    srli a1, t0, 2
    or  t0, t0, a1
    srli a1, t1, 2
    or  t1, t1, a1
    
    #x |= (x>>4)
    srli a1, t0, 4
    or  t0, t0, a1
    srli a1, t1, 4
    or  t1, t1, a1
    
    #x |= (x>>8)
    srli a1, t0, 8
    or  t0, t0, a1
    srli a1, t1, 8
    or  t1, t1, a1
    
    #x |= (x>>16)
    srli a1, t0, 16
    or  t0, t0, a1
    srli a1, t1, 16
    or  t1, t1, a1

    # x -= ((x >> 1) & 0x55555555)
    li   a1, 0x55555555
    srli  a2, t0, 1
    and  a2, a2, a1
    sub  t0, t0, a2
    
    srli  a2, t1, 1
    and  a2, a2, a1
    sub  t1, t1, a2

    # x = ((x >> 2) & 0x33333333) + (x & 0x33333333)
    li   a1, 0x33333333
    srli  a2, t0, 2
    and  a2, a2, a1
    and  a3, t0, a1
    add  t0, a2, a3
    
    srli  a2, t1, 2
    and  a2, a2, a1
    and  a3, t1, a1
    add  t1, a2, a3

    # x = ((x >> 4) + x) & 0x0f0f0f0f
    li   a1, 0x0f0f0f0f
    srli  a2, t0, 4
    add  t0, a2, t0
    and  t0, t0, a1

    srli  a2, t1, 4
    add  t1, a2, t1
    and  t1, t1, a1
    
    # x += (x >> 8)
    srli  a1, t0, 8
    add  t0, t0, a1
    
    srli  a1, t1, 8
    add  t1, t1, a1

    # x += (x >> 16)
    srli  a1, t0, 16
    add  t0, t0, a1
    
    srli  a1, t1, 16
    add  t1, t1, a1

    # Subtract from 32 to get count of leading zeros
    li   a1, 32
    sub  t0, a1, t0
    sub  t1, a1, t1

    ret
    
exit:
     nop 






