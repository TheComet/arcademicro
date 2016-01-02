#!/bin/sh

DEVICE=ATmega644
PROGRAMMER=usbtiny

avra -I ../include main.asm
avrdude -p $DEVICE -c $PROGRAMMER -U flash:w:main.hex

