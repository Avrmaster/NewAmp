void brightless_menu (void) {unsigned char temp;


TCCR0=0b01101001;
PORTB.4=1;
temp=OCR0=brightless;
temp/=5;
sleepBrightless=brightless/10;
lcd_clear();
sprintf(buffer, "Brightless: %d ", temp);
lcd_puts(buffer);

ShowScaleSimple(temp);

}