void updateBluetoothState (char isNecessarilyUpdate) {

if (recentMenu==11) if (lastPlayingState!=doesPlaying) {sleepTimer=0; lastPlayingState=doesPlaying; BluePlayerMenu();}

if (recentMenu!=0) return;
  
if (isBluetoothEnabled) {lcd_gotoxy(14,0); lcd_putchar(6);} else {
    lcd_gotoxy(14,0); lcd_puts(" "); return;
    } 
         
if (isNecessarilyUpdate|(lastConectedState!=doesConected)) {
    sleepTimer=0;
    if (doesConected) {
    lcd_gotoxy(13,0);
    lcd_puts(">"); 
    lcd_gotoxy(15,0);
    lcd_puts("<"); 
    } else {
    lcd_gotoxy(13,0);
    lcd_puts(" "); 
    lcd_gotoxy(15,0);
    lcd_puts(" "); 
    }
    
    
    if (doesConected==0&lastConectedState==1) 
    bluetoothResetTimer=bluetoothResetTime-1000;
   
    
    lastConectedState=doesConected;
     
     }
    
if (isNecessarilyUpdate|(lastPlayingState!=doesPlaying)) { 

   
    if (!doesConected) {lcd_gotoxy(14,1); lcd_puts(" "); return;}  
    
    sleepTimer=0; 
        
    lcd_gotoxy(14,1); 
    if (doesPlaying)
    lcd_putchar(5);
    else
    lcd_putchar(4); 
    lastPlayingState=doesPlaying;
    }
}