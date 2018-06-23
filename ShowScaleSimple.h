void ShowScaleSimple (unsigned int input) {
	unsigned char i;
	lcd_gotoxy(0,1);
	lcd_puts("                ");
	lcd_gotoxy(0,1);
	
	for (i=input/5; i!=0; i--) {
		lcd_putchar(0xFF);
	}
	
	i=input%5;
	switch (i) {
		case 1: lcd_putchar(0);
		break;
		case 2: lcd_putchar(1);
		break;
		case 3: lcd_putchar(2);
		break;
		case 4: lcd_putchar(3);
		break;
	}

	
}
