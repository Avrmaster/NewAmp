void bluetooth_menu (void) {
lcd_clear();
lcd_puts("   Bluetooth");
lcd_gotoxy(0,1);
if (isBluetoothEnabled) {lcd_puts("     Enable");}
else {lcd_puts("    Disable");}
}