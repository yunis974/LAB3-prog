
    .syntax unified
    .cpu cortex-m3
    .thumb

    /* Symboles fournis par le linker script */
    .word _sidata
    .word _sdata
    .word _edata
    .word _sbss
    .word _ebss

        .section .text.Reset_Handler
        .weak Reset_Handler
        .type Reset_Handler, %function
    Reset_Handler:
        /* Copie .data de la flash vers la RAM */
        ldr r0, =_sdata
        ldr r1, =_edata
        ldr r2, =_sidata
        movs r3, #0
        b LoopCopyDataInit

    CopyDataInit:
        ldr r4, [r2, r3]
        str r4, [r0, r3]
        adds r3, r3, #4

    LoopCopyDataInit:
        adds r4, r0, r3
        cmp r4, r1
        bcc CopyDataInit

        /* Met .bss à zéro */
        ldr r2, =_sbss
        ldr r4, =_ebss
        movs r3, #0
        b LoopFillZerobss

    FillZerobss:
        str r3, [r2]
        adds r2, r2, #4

    LoopFillZerobss:
        cmp r2, r4
        bcc FillZerobss

        /* Appel du programme principal */
        bl main
        b Infinite_Loop

    Infinite_Loop:
        b Infinite_Loop
        .size Reset_Handler, .-Reset_Handler

    /* Handler par défaut pour tout ce qui n'est pas défini ailleurs */
        .section .text.Default_Handler,"ax",%progbits
    Default_Handler:
    Infinite_Loop_Default:
        b Infinite_Loop_Default
        .size Default_Handler, .-Default_Handler

    /* Table des vecteurs */
        .section .isr_vector,"a",%progbits
        .type g_pfnVectors, %object
        .size g_pfnVectors, .-g_pfnVectors

    g_pfnVectors:
        .word _estack
        .word Reset_Handler
        .word NMI_Handler
        .word HardFault_Handler
        .word MemManage_Handler
        .word BusFault_Handler
        .word UsageFault_Handler
        .word 0
        .word 0
        .word 0
        .word 0
        .word SVC_Handler
        .word DebugMon_Handler
        .word 0
        .word PendSV_Handler
        .word SysTick_Handler
        /* IRQ périphériques à rajouter au besoin (EXTI, USART, TIM, etc.) */

    /* Alias vers Default_Handler pour tous les handlers non redéfinis */
        .weak NMI_Handler
        .thumb_set NMI_Handler,Default_Handler

        .weak HardFault_Handler
        .thumb_set HardFault_Handler,Default_Handler

        .weak MemManage_Handler
        .thumb_set MemManage_Handler,Default_Handler

        .weak BusFault_Handler
        .thumb_set BusFault_Handler,Default_Handler

        .weak UsageFault_Handler
        .thumb_set UsageFault_Handler,Default_Handler

        .weak SVC_Handler
        .thumb_set SVC_Handler,Default_Handler

        .weak DebugMon_Handler
        .thumb_set DebugMon_Handler,Default_Handler

        .weak PendSV_Handler
        .thumb_set PendSV_Handler,Default_Handler

        .weak SysTick_Handler
        .thumb_set SysTick_Handler,Default_Handler
    