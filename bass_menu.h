void bass_menu (void) {unsigned char temp2; signed char showbass;
        lcd_clear();
		switch (bass) {
			case 0:  showbass=-14; temp2=0b01100000;
			break;
			case 1:  showbass=-12; temp2=0b01100001;
			break;
			case 2:  showbass=-10; temp2=0b01100010;
			break;
			case 3:  showbass=-8;  temp2=0b01100011;
			break;
			case 4:  showbass=-6;  temp2=0b01100100;
			break;
			case 5:  showbass=-4;  temp2=0b01100101;
			break;
			case 6:  showbass=-2;  temp2=0b01100110;
			break;
			case 7:  showbass=0;   temp2=0b01100111;
			break;
			case 8:  showbass=2;   temp2=0b01101110;
			break;
			case 9:  showbass=4;   temp2=0b01101101;
			break;
			case 10: showbass=6;   temp2=0b01101100;
			break;
			case 11: showbass=8;   temp2=0b01101011;
			break;
			case 12: showbass=10;  temp2=0b01101010;
			break;
			case 13: showbass=12;  temp2=0b01101001;
			break;
			case 14: showbass=14;  temp2=0b01101000;
			break;
			
		}
		
		if (showbass<=0) {
			sprintf(buffer, "Bass: %d ", showbass);
		}
		if (showbass>0)  {
			sprintf(buffer, "Bass: +%d ", showbass);
		}
		lcd_puts(buffer);
		ShowScaleBalance(temp2, showbass);
		i2c_start();
		i2c_write(0b10001000);
		i2c_write(temp2);
		i2c_stop();
}