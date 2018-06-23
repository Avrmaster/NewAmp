
void volume_menu (void) {unsigned char temp;
	lcd_clear();
	temp=63-volume;
	sprintf(buffer, "Volume: %d ", volume);
	lcd_puts(buffer);
	ShowScaleSimple(volume);
		    volume&=0b00111111;
		    i2c_start();
		    i2c_write(0b10001000);
		    if (input==1&isBluetoothEnabled) {if (PINE.4!=0) i2c_write(temp);} else {i2c_write(temp);} 
		    i2c_stop();                    
        
    updateBluetoothState(1);
   
}