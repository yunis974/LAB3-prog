#ifndef gpio_h
#define gpio_h


#define RCC 0x40021000
#define PORTA 0x40010800 
#define RCC_APB2ENR (*(volatile uint32_t*)(RCC + 0x18))
#define RCC_APB1ENR (*(volatile uint32_t*)(RCC + 0x1C))
#define OUTPUT_PULL 0x1
#define INPUT_PULL 0x8
#define OUTOUT_AF_PULL 0xB
#define GPIOx_ODR 0x0C
#define GPIOx_IDR 0x08

#include <stdint.h>
#include <stdbool.h>



void InitPin(char port_index, uint8_t pin, uint8_t mode);
void WritePin(char port_index, uint8_t pin, bool value); 
bool ReadPin(char port_index, uint8_t pin);


#endif