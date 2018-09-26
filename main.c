#include "../inc/macros.h"
#include <avr/io.h>
#include <util/delay.h>

#define led PB7

int main() {
    
    uint8_t valor = 1; 
    uint8_t state = 1;
    OCR0A = valor; 
    SETBIT(TCCR0A, WGM01);
    SETBIT(TCCR0A, WGM00);
    SETBIT(TCCR0A, COM0A1);
    SETBIT(TCCR0B, CS00);
    SETBIT(TCCR0B, CS01);


    SETBIT(DDRB, led);
    
    while(1) {
        _delay_ms(1);
        valor += state;
        OCR0A = valor;
        state = (valor == 255) || (valor == 0) ? - state : state;
    }

        
    
    return 0;
}

