#include "lcd.h"

#define RCC 0x40021000
#define RCC_APB1ENR (*(volatile uint32_t*)(RCC + 0x1C))

void InitTimer2()
{
    RCC_APB1ENR |= 0x1; // Enable clock for Timer 2
}

int main(void)
{
    LCD_Init();
    LCD_Clear();
    LCD_SetCursor(2, 1);
    LCD_SendString("yo");
    LCD_WriteChar(0xA5);

    
    return 0;
}

