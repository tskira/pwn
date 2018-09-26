# Nome do programa principal
PROG = main

# Porta de comunicação com o Arduino
PORT = /dev/ttyACM0

# Escolha uma otimização dentre as seguintes:
# -O0 -O1 -O2 -O3 -Os
OPTIMIZE = -Os

# Configuração para o Arduino UNO
# -------------------------------
# Altere apenas se for utilizar outro modelo de Arduino
# Consulte o arquivo /arduino/avr/boards.txt para outras configurações
MCU_TARGET = atmega2560 
UPLOAD_SPEED = 115200
UPLOAD_PROTOCOL = wiring 

# ==========================================
# Não é necessário alterar as regras abaixo.
# ==========================================

OBJS    = $(PROG).o
CC      = avr-gcc
OBJCOPY = avr-objcopy
CFLAGS  = $(OPTIMIZE) -Wall -mmcu=$(MCU_TARGET)

.PHONY: all install clean

all: $(PROG).hex $(PROG).eep.hex

$(PROG).elf: $(OBJS)
	$(CC) -mmcu=$(MCU_TARGET) -o $@ $^

$(PROG).hex: $(PROG).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

$(PROG).eep.hex: $(PROG).elf
	$(OBJCOPY) -j .eeprom --change-section-lma .eeprom=0 --no-change-warnings -O ihex $< $@ \
        || { echo empty $@ not generated; exit 0; }

install: $(PROG).hex $(PROG).eep.hex
	avrdude -F -V -c $(UPLOAD_PROTOCOL) -p $(MCU_TARGET) -P $(PORT) -b $(UPLOAD_SPEED) -U flash:w:$< - U eeprom:w:$(word 2,$^) -D

clean:
	@rm -f $(PROG).elf $(PROG).hex $(PROG).eep.hex $(OBJS)
