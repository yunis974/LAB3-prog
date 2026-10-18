#include "lcd.h"

//pin used by the lcd on our stm32 devboard
//PBX
#define RS_Pin 9      
#define RW_Pin 10
#define EN_Pin 11
#define D4_Pin 12
#define D5_Pin 13
#define D6_Pin 14
#define D7_Pin 15

#define RCC 0x40021000
#define PORTB 0x40010C00
#define RCC_APB2ENR (*(volatile uint32_t*)(RCC + 0x18))
#define GPIOx_ODR 0x0C
#define SYSTICK 0xE000E010
#define SYSTICK_CTRL ((volatile uint32_t*)(SYSTICK + 0x00))

void LCD_GPIO_Init(void)
{
    RCC_APB2ENR |= (1U << 3);

    volatile uint32_t *GPIOB_CRH = (volatile uint32_t*)((volatile uint8_t*)PORTB + 0x04);

    uint32_t mask = 0xFFFFFFF0;

    *GPIOB_CRH &= ~mask;

    *GPIOB_CRH |= 0x11111110;
}

void LCD_SysTickInit(uint32_t freq)
{
    volatile uint32_t* stkLoad = (volatile uint32_t*)((volatile uint8_t*)SYSTICK_CTRL + 0x04);
    uint32_t mask = 0xFFFFFF;
    freq &= mask;
    *stkLoad = freq;
    uint32_t mask2 = 0x7;
    *SYSTICK_CTRL &= ~mask2;
    *SYSTICK_CTRL |= 0x5;
}

void LCD_Delay(uint16_t time)
{
    uint32_t freq = 8000;
    freq *= time;
    volatile uint32_t* stkLoad = (volatile uint32_t*)((volatile uint8_t*)SYSTICK_CTRL + 0x04);
    //*(volatile uint32_t*)((volatile uint8_t*)SYSTICK_CTRL + 0x08) = 0;
    uint32_t mask2 = 0xFFFFFF;
    freq &= mask2;
    *stkLoad = freq;
    uint32_t mask = (0x1 << 16);
    while((*SYSTICK_CTRL & mask) == 0){

    }
    *SYSTICK_CTRL &= ~mask;
    return;
}

void WriteToPin(uint8_t pin, bool value)
{   
    volatile uint32_t *port = (volatile uint32_t*)((volatile uint8_t*)PORTB + GPIOx_ODR);  
    uint32_t mask = (1 << pin);
    *port &= ~mask;
    *port |= (value << pin);


}


void LCD_Send4Bits(uint8_t data)
{
    for (int i = 0; i < 4; i++)
    {
        WriteToPin(D4_Pin + i, (data >> i) & 0x01);
    }
    
    WriteToPin(EN_Pin, 1);
    LCD_Delay(1);
    WriteToPin(EN_Pin, 0);
}


void LCD_Command(bool RW, bool RS, uint8_t data)
{
    WriteToPin(RW_Pin, RW);
    WriteToPin(RS_Pin, RS);

    LCD_Send4Bits(data >> 4);
    LCD_Send4Bits(data & 0x0F);

}


void LCD_Init(void)
{
    LCD_GPIO_Init();
    LCD_SysTickInit(8000);
    LCD_Delay(50);

    LCD_Command(0, 0, 0x33);
    LCD_Command(0, 0, 0x32);

    LCD_Command(0, 0, 0x28);
    LCD_Command(0, 0, 0x08);
    LCD_Command(0,0, 0x0C);
    LCD_Command(0, 0, 0x06);
    LCD_Command(0,0, 0x01);

    LCD_Delay(2);
}

void LCD_WriteChar(char character)
{
    WriteToPin(RS_Pin, 1);
    WriteToPin(RW_Pin, 0);

    LCD_Send4Bits(character >> 4);
    LCD_Send4Bits(character & 0x0F);
}

void LCD_SendString(char *string)
{
    while (*string)
    {
        LCD_WriteChar(*string++);
    }
}

void LCD_Clear(void)
{
    LCD_Command(0, 0, 0x01);
    LCD_Delay(2);
}

void LCD_SetCursor(uint8_t row, uint8_t col)
{
    uint8_t rows[4] = {0x00, 0x40, 0x14, 0x54};
    if (row > 3) return;
    if (col > 19) return;

    uint8_t address = rows[row] + col;

    uint8_t com = (1u << 7) | (address & 0x1F);
    LCD_Command(0, 0 , com);
    
    LCD_Delay(2);
    
}