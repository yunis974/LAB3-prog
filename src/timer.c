#include "timer.h"

static void (*userCallback)(void) = 0;

void timerInit(void)
{
    RCC_APB1ENR |= RCC_APB1ENR_ENTIM2;
    TIM2_PSC = TIM2_PSC_VAL;
    TIM2_ARR = TIM2_ARR_VAL;
    TIM2_EGR = (1u << 0);     
    TIM2_SR  = ~(1u << 0);   
    TIM2_DIER |= (1u << 0);
    NVIC_ISER0 |= (1u << 28);
    TIM2_CR1 |= (1u << 0);
}

void setTimerCallback(void(*f)(void))
{
    userCallback = f;
}


void TIM2_IRQHandler(void)
{
    if (TIM2_SR & (1u << 0)) { 
        TIM2_SR = ~(1u << 0);    
        if (userCallback) userCallback();    
    }
}