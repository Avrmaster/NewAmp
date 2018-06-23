void FS_balance_menu (void) {
signed char balance1 = LR_balance;
signed char balance2 = FR_balance; 
signed char LF, RF, LR, RR;
unsigned char x=16;

if (balance1<31) {RF=balance1; LF=31;}
balance1 = LR_balance;
if (balance1==31) {RF=LF=31;}
balance1 = LR_balance;
if (balance1>31) {balance1=62-balance1; LF=balance1; RF=31;}

LR=LF; RR=RF;

if (balance2<31) {balance2=31-balance2; RR-=balance2; LR-=balance2;}
balance2 = FR_balance;
if (balance2>31) {balance2=balance2-31;; RF-=balance2; LF-=balance2;}


balance2 = FR_balance;

if (balance2<31) {
lcd_clear();
sprintf(buffer, "Front %d", 31);
lcd_puts(buffer);
lcd_gotoxy(8,0);
lcd_putchar(0x3A);
sprintf(buffer, "%d ", balance2);
lcd_puts(buffer);
lcd_gotoxy(12,0);
lcd_puts("Rear");
}
if (balance2==31) {
lcd_clear();
sprintf(buffer, "Front %d", 31);
lcd_puts(buffer);
lcd_gotoxy(8,0);
lcd_putchar(0x3A);
sprintf(buffer, "%d ", 31);
lcd_puts(buffer);
lcd_gotoxy(12,0);
lcd_puts("Rear");
}
if (balance2>31) {balance2=62-balance2; 
lcd_clear();
sprintf(buffer, "Front %d", balance2);
lcd_puts(buffer);
lcd_gotoxy(8,0);
lcd_putchar(0x3A);
sprintf(buffer, "%d ", 31);
lcd_puts(buffer);
lcd_gotoxy(12,0);
lcd_puts("Rear");
}


balance2=FR_balance;
if (balance2!=62) {
for (balance2=FR_balance; balance2>0; balance2=balance2-5) {
lcd_puts("-");
x--;
}
lcd_putchar(0xFF);
lcd_putchar(0xFF);
while (x!=0) {
lcd_puts("-");
x--;
}
} else {
lcd_puts("--------------");
lcd_putchar(0xFF);
lcd_putchar(0xFF);
}





i2c_start();
i2c_write(0b10001000);
if (LF>0) {LF=31-LF;} else {LF=31;}
if (RF>0) {RF=31-RF;} else {RF=31;}
if (LR>0) {LR=31-LR;} else {LR=31;}
if (RR>0) {RR=31-RR;} else {RR=31;}

LF&=0b00011111; RF&=0b00011111;
LR&=0b00011111; RR&=0b00011111;
LF|=0b10000000; RF|=0b10100000;
LR|=0b11000000; RR|=0b11100000;

i2c_write(LF);
i2c_write(RF);
i2c_write(LR);
i2c_write(RR);

i2c_stop();



}