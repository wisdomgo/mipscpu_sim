    .data
    .text
    .globl main

main:
    # 初始化寄存器值
    lui   $t0, 0x1         # $t0 = 0x10000
    ori   $t0, $t0, 0x1FF  # $t0 = 0x101FF
    lui   $t1, 0x2         # $t1 = 0x20000

    # 立即数逻辑与位操作
    andi  $t2, $t0, 0xFF   # $t2 = $t0 AND 0xFF, $t2 = 0x1FF
    slti  $t3, $t2, 0x200  # $t3 = $t2 < 0x200 (1为true)

    # 移位操作
    sll   $t4, $t3, 2      # $t4 = $t3 << 2
    srl   $t5, $t4, 1      # $t5 = $t4 >> 1

    # 变量移位
    sllv  $t6, $t4, $t3    # $t6 = $t4 << $t3
    srlv  $t7, $t6, $t3    # $t7 = $t6 >> $t3

    # 逻辑操作
    nor   $t8, $t6, $t7    # $t8 = ~($t6 | $t7)

    # 分支和跳转
    bne   $t7, $t8, skip   # 如果 $t7 != $t8，跳转到标签skip
    nop                    # 延迟槽填充nop

    # 跳转寄存器
    jr    $ra              # 跳转回调用者
    nop                    # 延迟槽填充nop

skip:
    # 跳转和链接寄存器
    jalr  $ra, $t1         # 跳转到$t1地址，并且链接地址放入$ra
    nop                    # 延迟槽填充nop

