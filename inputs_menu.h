void inputs_menu (void) {
    unsigned char send;
	lcd_clear();
	lcd_gotoxy(0,1);
		  
	loudness&=0b00000100;
	gain&=0b00011000;

    input&=0b00000011;
    
    
	lcd_gotoxy(0,0);
	lcd_puts("Input:    1 2 3 ");
	switch(input) {
	case 0: lcd_gotoxy(10,1); 
	break;
	case 1: lcd_gotoxy(12,1);
	break;
	case 2: lcd_gotoxy(14,1);
	break;
	}
	 
	lcd_putchar(0xD9);  
    
	send =0b01000000;
	send|=input;
	send|=gain;
	send|=loudness;
	i2c_start();
	i2c_write(0b10001000);
	i2c_write(send);    
	i2c_stop();
}