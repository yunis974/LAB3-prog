#include "lcd.h"
#include "timer.h"
#include <stdio.h>

#define TIM2_CNT (*(volatile uint32_t *)0x40000024)

uint8_t sec = 50;
uint8_t min = 59;
uint8_t hour = 23;

void updateNumber()
{
    static char buf[16];
    sec++;
    if (sec == 60)
    {
        sec = 0;
        min++;

        if (min == 60)
        {
            min = 0;
            hour++;

            if(hour == 24)
            {
                hour = 0;
            }
        }
    }
    LCD_SetCursor(0,6);
    sprintf(buf,"%02d:%02d:%02d", hour, min, sec);
    LCD_SendString(buf);
}


int main(void)
{   
    void (*f)(void) = updateNumber;
    timerInit();
    setTimerCallback(*f);
    LCD_Init();
    LCD_Clear();
    LCD_SetCursor(0, 6);
    LCD_SendString("17:48:00");
    


    return 0;
}



