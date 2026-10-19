#include "gpio.h"


void InitPin(char port_index, uint8_t pin, uint8_t mode)
{
    volatile uint32_t *port = (volatile uint32_t*)((volatile uint8_t*)PORTA + (0x400 * port_index));
    uint32_t mask = (1 << (port_index + 0x02));
    RCC_APB2ENR |= mask;
    uint8_t offset;
    offset = pin > 7 ? 0x04 : 0x00;
    volatile uint32_t *port_register = (volatile uint32_t*)((volatile uint8_t*)port + offset);
    uint8_t shift = (pin % 8) * 4;
    uint32_t port_mask = (0xF << shift);
    *port_register &= ~port_mask;
    *port_register |= (mode << shift);
    
}


void WritePin(char port_index, uint8_t pin, bool value)
{
    volatile uint32_t *port = (volatile uint32_t*)((volatile uint8_t*)PORTA + (0x400 * port_index) + GPIOx_ODR) ;
    uint32_t mask = (1 << pin);
    *port &= ~mask;
    *port |= (value << pin);

}


bool ReadPin(char port_index, uint8_t pin)
{
    volatile uint32_t *port = (volatile uint32_t*)((volatile uint8_t*)PORTA + (0x400 * port_index) + GPIOx_IDR);
    uint32_t mask = (1 << pin);
    return ((*port & mask) != 0);
}