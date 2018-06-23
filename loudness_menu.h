void loudness_menu (void) {unsigned char send;

    
    lcd_clear();
    lcd_puts("Loudness:");
    lcd_gotoxy(0,1);
    if (loudness==0) {
    lcd_puts("> ON <     OFF ");
    }
    else {
    lcd_puts("  ON     > OFF <");
    }
    
 
    send =0b01000000;
    send|=input;
    send|=gain;
    send|=loudness;
    i2c_start();
    i2c_write(0b10001000);
    i2c_write(send);
	i2c_stop();
}