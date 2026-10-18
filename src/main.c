#include "lcd.h"


int main(void)
{
    LCD_Init();
    LCD_SendString("Hello World !");
    LCD_WriteChar(0xA5);

    
    return 0;
}

