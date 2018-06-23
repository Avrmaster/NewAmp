
void preamp_menu (void) {unsigned char send;
lcd_clear();
input&=0x03;

    switch (input) {
     case 0: switch (gain) {
             case 24: lcd_puts("Gain:    0  db  ");
                      lcd_gotoxy(0,1);
                      lcd_puts ("3.25  7.5  11.25");
                      break;
             case 16: lcd_puts("Gain: + 3.25db  ");
                      lcd_gotoxy(0,1);
                      lcd_puts ("  0   7.5  11.25");
                      break;
             case 8 : lcd_puts("Gain: + 7.5 db  ");
                      lcd_gotoxy(0,1);
                      lcd_puts ("  0  3.25  11.25");
                      break;
             case 0 : lcd_puts("Gain: +11.25db  ");
                      lcd_gotoxy(0,1);
                      lcd_puts ("  0  3.25   7.25");
                      break;   
             }
             break;
     case 1:
     case 2: switch (gain) { m1:
             case 24: lcd_puts("Gain:    0  db  ");
                      lcd_gotoxy(0,1);
                      lcd_puts ("      3.25");
                      break;
             case 16: lcd_puts("Gain: + 3.25db  ");
                      lcd_gotoxy(7,1);
                      lcd_puts ("0");
                      break;
             case 8 : gain=16; goto m1;
             case 0 : gain=16; goto m1;  
             } 
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