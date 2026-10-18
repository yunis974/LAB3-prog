#ifndef lcd.h

#include <stdbool.h>
#include <stdint.h>


void LCD_Init(void);
void LCD_Command(bool RW, bool RS, uint8_t data);
void LCD_WriteChar(char character);
void LCD_ShowTime(void);

void LCD_GPIO_Init(void);
void LCD_SysTickInit(uint32_t freq);
void LCD_Delay(uint16_t time);
void WriteToPin(uint8_t pin, bool value);
void LCD_Send4bits(uint8_t data);
void LCD_SendString(char *string);
void LCD_Clear(void);
void LCD_SetCursor(uint8_t row, uint8_t col);

#endif