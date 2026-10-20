#ifndef TIMER_H
#define TIMER_H
#include <stdint.h>

#define RCC 0x40021000
#define RCC_APB1ENR (*(volatile uint32_t*)(RCC + 0x1C))
#define TIM2_BASE 0x40000000
#define RCC_APB1ENR_ENTIM2 0x00000001  
#define TIM2_PSC (*(volatile uint32_t *)(TIM2_BASE + 0x28))     
#define TIM2_ARR (*(volatile uint32_t *)(TIM2_BASE + 0x2C))     
#define TIM2_DIER (*(volatile uint32_t *)(TIM2_BASE + 0x0C))    
#define TIM2_PSC_VAL 7999
#define TIM2_ARR_VAL 999
#define NVIC_ISER0 (*(volatile uint32_t *)0xE000E100)
#define TIM2_SR (*(volatile uint32_t *)(TIM2_BASE + 0x10))      
#define TIM2_CR1 (*(volatile uint32_t*)TIM2_BASE)
#define TIM2_EGR (*(volatile uint32_t*)(TIM2_BASE + 0x14))
void timerInit(void);
void setTimerCallback(void(*f)(void));



#endif