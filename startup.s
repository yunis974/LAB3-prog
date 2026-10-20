/* startup.s — STM32F103xB (Cortex-M3), bare-metal */

    .syntax unified
    .cpu cortex-m3
    .thumb

/* ------------------------------------------------------------------ */
/* Reset_Handler : copie .data, met .bss à zéro, appelle main         */
/* ------------------------------------------------------------------ */
    .section .text.Reset_Handler,"ax",%progbits
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

Infinite_Loop:
    b Infinite_Loop
    .size Reset_Handler, .-Reset_Handler

/* ------------------------------------------------------------------ */
/* Default_Handler : boucle infinie pour toute IRQ non définie        */
/* ------------------------------------------------------------------ */
    .section .text.Default_Handler,"ax",%progbits
    .type Default_Handler, %function
Default_Handler:
    b Default_Handler
    .size Default_Handler, .-Default_Handler

/* ------------------------------------------------------------------ */
/* Table des vecteurs                                                 */
/* ------------------------------------------------------------------ */
    .section .isr_vector,"a",%progbits
    .type g_pfnVectors, %object

g_pfnVectors:
    /* Exceptions système */
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

    /* IRQ périphériques (RM0008, STM32F10x medium density) */
    .word WWDG_IRQHandler              /* 0  */
    .word PVD_IRQHandler               /* 1  */
    .word TAMPER_IRQHandler            /* 2  */
    .word RTC_IRQHandler               /* 3  */
    .word FLASH_IRQHandler             /* 4  */
    .word RCC_IRQHandler               /* 5  */
    .word EXTI0_IRQHandler             /* 6  */
    .word EXTI1_IRQHandler             /* 7  */
    .word EXTI2_IRQHandler             /* 8  */
    .word EXTI3_IRQHandler             /* 9  */
    .word EXTI4_IRQHandler             /* 10 */
    .word DMA1_Channel1_IRQHandler     /* 11 */
    .word DMA1_Channel2_IRQHandler     /* 12 */
    .word DMA1_Channel3_IRQHandler     /* 13 */
    .word DMA1_Channel4_IRQHandler     /* 14 */
    .word DMA1_Channel5_IRQHandler     /* 15 */
    .word DMA1_Channel6_IRQHandler     /* 16 */
    .word DMA1_Channel7_IRQHandler     /* 17 */
    .word ADC1_2_IRQHandler            /* 18 */
    .word USB_HP_CAN1_TX_IRQHandler    /* 19 */
    .word USB_LP_CAN1_RX0_IRQHandler   /* 20 */
    .word CAN1_RX1_IRQHandler          /* 21 */
    .word CAN1_SCE_IRQHandler          /* 22 */
    .word EXTI9_5_IRQHandler           /* 23 */
    .word TIM1_BRK_IRQHandler          /* 24 */
    .word TIM1_UP_IRQHandler           /* 25 */
    .word TIM1_TRG_COM_IRQHandler      /* 26 */
    .word TIM1_CC_IRQHandler           /* 27 */
    .word TIM2_IRQHandler              /* 28 */
    .word TIM3_IRQHandler              /* 29 */
    .word TIM4_IRQHandler              /* 30 */
    .word I2C1_EV_IRQHandler           /* 31 */
    .word I2C1_ER_IRQHandler           /* 32 */
    .word I2C2_EV_IRQHandler           /* 33 */
    .word I2C2_ER_IRQHandler           /* 34 */
    .word SPI1_IRQHandler              /* 35 */
    .word SPI2_IRQHandler              /* 36 */
    .word USART1_IRQHandler            /* 37 */
    .word USART2_IRQHandler            /* 38 */
    .word USART3_IRQHandler            /* 39 */
    .word EXTI15_10_IRQHandler         /* 40 */
    .word RTC_Alarm_IRQHandler         /* 41 */
    .word USBWakeUp_IRQHandler         /* 42 */

    .size g_pfnVectors, .-g_pfnVectors

/* ------------------------------------------------------------------ */
/* Alias faibles : tout handler non redéfini en C → Default_Handler   */
/* ------------------------------------------------------------------ */
    .macro weak_handler name
    .weak \name
    .thumb_set \name, Default_Handler
    .endm

    weak_handler NMI_Handler
    weak_handler HardFault_Handler
    weak_handler MemManage_Handler
    weak_handler BusFault_Handler
    weak_handler UsageFault_Handler
    weak_handler SVC_Handler
    weak_handler DebugMon_Handler
    weak_handler PendSV_Handler
    weak_handler SysTick_Handler

    weak_handler WWDG_IRQHandler
    weak_handler PVD_IRQHandler
    weak_handler TAMPER_IRQHandler
    weak_handler RTC_IRQHandler
    weak_handler FLASH_IRQHandler
    weak_handler RCC_IRQHandler
    weak_handler EXTI0_IRQHandler
    weak_handler EXTI1_IRQHandler
    weak_handler EXTI2_IRQHandler
    weak_handler EXTI3_IRQHandler
    weak_handler EXTI4_IRQHandler
    weak_handler DMA1_Channel1_IRQHandler
    weak_handler DMA1_Channel2_IRQHandler
    weak_handler DMA1_Channel3_IRQHandler
    weak_handler DMA1_Channel4_IRQHandler
    weak_handler DMA1_Channel5_IRQHandler
    weak_handler DMA1_Channel6_IRQHandler
    weak_handler DMA1_Channel7_IRQHandler
    weak_handler ADC1_2_IRQHandler
    weak_handler USB_HP_CAN1_TX_IRQHandler
    weak_handler USB_LP_CAN1_RX0_IRQHandler
    weak_handler CAN1_RX1_IRQHandler
    weak_handler CAN1_SCE_IRQHandler
    weak_handler EXTI9_5_IRQHandler
    weak_handler TIM1_BRK_IRQHandler
    weak_handler TIM1_UP_IRQHandler
    weak_handler TIM1_TRG_COM_IRQHandler
    weak_handler TIM1_CC_IRQHandler
    weak_handler TIM2_IRQHandler
    weak_handler TIM3_IRQHandler
    weak_handler TIM4_IRQHandler
    weak_handler I2C1_EV_IRQHandler
    weak_handler I2C1_ER_IRQHandler
    weak_handler I2C2_EV_IRQHandler
    weak_handler I2C2_ER_IRQHandler
    weak_handler SPI1_IRQHandler
    weak_handler SPI2_IRQHandler
    weak_handler USART1_IRQHandler
    weak_handler USART2_IRQHandler
    weak_handler USART3_IRQHandler
    weak_handler EXTI15_10_IRQHandler
    weak_handler RTC_Alarm_IRQHandler
    weak_handler USBWakeUp_IRQHandler