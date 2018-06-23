void ShowScaleBalance (unsigned char temp, signed char temp2) {
	unsigned char i,k;
	lcd_gotoxy(0,1);
	lcd_puts("                ");
	lcd_gotoxy(0,1);

	if (temp2<=0) {
    i=temp;
    i&=0b00001111;
	if (i!=0b00001111) {for (k=0; k<i; k++) {lcd_puts("-");}}
	lcd_putchar(0xFF); lcd_putchar(0xFF);
	i=temp;
	i&=0b00001111;
    for (k=15; k>i; k--) {lcd_puts("-");}
	}
	else {
		i=temp;
		i&=0b00001111;
		i=15-i;
		for (k=0; k<7; k++) {lcd_puts("-");}
		for (k=0; k<i; k++) {
			lcd_puts("-");
		}
			lcd_putchar(0xFF); lcd_putchar(0xFF);
		for (k=0; k<7; k++) {lcd_puts("-");}
	}
}