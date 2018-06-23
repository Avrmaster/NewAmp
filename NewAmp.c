/*******************************************************
This program was created by the
CodeWizardAVR V3.10 Evaluation
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : New Amp
Version : 1.0.1
Date    : 29.06.2014
Author  : Leskiv Oleksandr
Company : Home Labaratory
Comments: 
I hope, it will work loud!


Chip type               : ATmega64A
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*******************************************************/

#include <mega64a.h>
#include <delay.h>
#include <i2c.h>
#include <alcd.h>
#include <stdio.h>
#include <DefineSymbols.h>


unsigned char recentMenu;

#define volumeMenu    0;
#define trebleMenu    1;
#define bassMenu      2;
#define inputsMenu    3;
#define preampMenu    4;
#define loudnessMenu  5;
#define LRBalanceMenu 6;
#define FRBalanceMenu 7;
#define bluetothMenu  8;

unsigned int sleepTime = 5000;
unsigned int bluetoothResetTime=50000;

unsigned int timer=0, sleepTimer=0, bluetoothResetTimer=49500, bluetoothAskStateTimer=0;

char BlueBuffer[10];
unsigned char doesPlaying=0;
unsigned char doesConected=0;

unsigned char lastConectedState=50;
unsigned char lastPlayingState=50;

unsigned char volume, treble, bass, input, gain, loudness, brightless, isBluetoothEnabled=0, PlayerMenu=1;
signed char LR_balance, FR_balance; 
unsigned int opasity;

char mayOFF=0;
char isOFF=1;

unsigned int encwas;
char buffer[32];
 
char k;
char sleepBrightless;

char wasPlayingBeforeSwitch =0;

eeprom char doesEEpromWritten;
eeprom int settings[12];                                                         
 
#include <BluePlayerMenu.h>                                                      //recentMenu
#include <ShowScaleSimple.h>                                                     //   0 - Volume
#include <ShowScaleBalance.h>                                                    //   1 - Treble
#include <bluetoothState_menu.h>                                                 //   2 - Bass
#include <volume_menu.h>                                                         //   3 - Inputs
#include <treble_menu.h>                                                         //   4 - Preamp
#include <bass_menu.h>                                                           //   5 - Loudness
#include <inputs_menu.h>                                                         //   6 - Balance Left - Right
#include <preamp_menu.h>                                                         //   7 - Balance Front - Rear
#include <loudness_menu.h>                                                       //   8 - Bluetooth ON/OFF
#include <RL_balance_menu.h>                                                     //   9 - Brightless
#include <FR_balance_menu.h>                                                     //  10 - Opacity
#include <bluetooth_menu.h>                                                      //  11 - Bluetooth PlayerMenu
#include <brightless_menu.h>
#include <opasity_menu.h>



//Update SCREEN information
void UpdateMenu (void) {

sleepTimer=0;

	switch (recentMenu) {
		case 0: volume_menu();
		break;
		case 1: treble_menu();
		break;
		case 2: bass_menu();
		break;
		case 3: inputs_menu();
		break;
        case 4: preamp_menu();
        break;
        case 5: loudness_menu();
        break;
        case 6: RL_balance_menu();
        break;
        case 7: FS_balance_menu();
        break;
        case 8: bluetooth_menu();
        break;
        case 9: brightless_menu();
        break;
        case 10: opasity_menu();
        break;
        case 11: BluePlayerMenu(); 
        break;
	}
};

void SendToBluetoothByte (char data) {

while ( !( UCSR1A & (1<<UDRE1)) ) {}
UDR1=data;
}

void SendToBluetooth (char *string){
SendToBluetoothByte('A');
SendToBluetoothByte('T');
SendToBluetoothByte('#');
SendToBluetoothByte(*string);
*string++;
SendToBluetoothByte(*string);
SendToBluetoothByte(0x0a);
SendToBluetoothByte(0x0d);

}

void LED (unsigned char color) {
switch (color) {
case 0: PORTF=0b00000000; break;
case 1: PORTF=0b00000100; break;
case 2: PORTF=0b00010000; break;
case 3: PORTF=0b01000000; break;
case 4: PORTF=0b00010100; break;
case 5: PORTF=0b01000100; break;
case 6: PORTF=0b01010000; break;
case 7: PORTF=0b01010100; break;
}
}

void BluetoothOFF (void) {
PORTA.1=0; 
UCSR1A=0x00;
UCSR1B=0x00;      
UCSR1C=0x00;
UBRR1H=0x00;
UBRR1L=0x00;

isBluetoothEnabled=0;
updateBluetoothState(0);
doesConected=0;
doesPlaying=0;
}

void BluetoothON (void) {
PORTA.1=1;
UCSR1A=0x00;
UCSR1B=0xD8;
UCSR1C=0x06;
UBRR1H=0x00;
UBRR1L=0x08;

bluetoothResetTimer=0;
isBluetoothEnabled=1;
updateBluetoothState(0);
}

void BluetoothReset(void) {

      if (doesConected|!isBluetoothEnabled) return; 
              
        if (bluetoothResetTimer<(bluetoothResetTime+500)) {
           PORTA.1=0; 
           UCSR1A=0x00;
           UCSR1B=0x00;      
           UCSR1C=0x00;
           UBRR1H=0x00;
           UBRR1L=0x00;
           LED(3);
        } else  {
           PORTA.1=1;
           UCSR1A=0x00;
           UCSR1B=0xD8;
           UCSR1C=0x06;
           UBRR1H=0x00;
           UBRR1L=0x08;
           bluetoothResetTimer=0;
           if (isOFF) LED(0); else LED(2);
        } 

}

#include <buttons_controll.c>

//Called, when ENCODER has been rotated. 1: clockwise. 2: counterclockwise
void ValueChanged (char direction) {
if (isOFF) return;
timer=0;
sleepTimer=0;
switch (recentMenu) {
     case 1: if (direction==1) {if (treble<14) {treble++;}} else {if (treble!=0) {treble--;}}
     break; 
     case 2: if (direction==1) {if (bass<14) {bass++;}} else {if (bass!=0) {bass--;}}
     break;
     case 3: if (input==1&isBluetoothEnabled&doesConected&doesPlaying) {
             wasPlayingBeforeSwitch=1; SendToBluetooth ("MA");}   
             if (direction==1) {if (input<2) {input++;}} else {if (input!=0) {input--;}}
             if (input==1&wasPlayingBeforeSwitch==1) {
             wasPlayingBeforeSwitch=0; SendToBluetooth ("MA");}
              
     break;
     case 4: if (direction==0) {if (gain<24) {gain+=8;}} else {if (gain!=0) {gain-=8;}}
     break;
     case 5: if (direction==0) {if (loudness!=0) {loudness=0;}} else {if (loudness!=4) {loudness=4;}}
     break;
     case 6: if (direction==0) {if (LR_balance!=0) {LR_balance--;}} else {if (LR_balance<62) {LR_balance++;}}
     break;
     case 7: if (direction==0) {if (FR_balance!=0) {FR_balance--;}} else {if (FR_balance<62) {FR_balance++;}}
     break;
     case 8: if (direction==0) {if (isBluetoothEnabled) {BluetoothOFF();}} else {BluetoothON();}
     break;
     case 9: if (direction==0) {if (brightless>0) {brightless-=5;;}} else {if (brightless<255) {brightless+=5;}}
     break;
     case 10: if (direction==0) {if (opasity>0) {opasity-=10;;}} else {if (opasity<400) {opasity+=10;;}}
     break;
     case 11: if (direction==0) {if (PlayerMenu!=0) {PlayerMenu--;}} else {if (PlayerMenu!=2) {PlayerMenu++;}}
     break; 
     default: recentMenu=0; if (direction==1) {if (volume<63) {volume++;}} else {if (volume!=0) {volume--;}}
     break;
}
UpdateMenu();
}


interrupt [USART1_RXC] void usart1_rx_isr(void) {
BlueBuffer[0]=BlueBuffer[1];
BlueBuffer[1]=BlueBuffer[2];
BlueBuffer[2]=BlueBuffer[3];
BlueBuffer[3]=BlueBuffer[4];
BlueBuffer[4]=UDR1;

if (BlueBuffer[0]!=0x0d|BlueBuffer[1]!=0x0a) return;


if (BlueBuffer[2]==0x4d) {
  if (BlueBuffer[3]==0x52|BlueBuffer[3]==0x42) {doesPlaying=1;} else 
    if (BlueBuffer[3]==0x50|BlueBuffer[3]==0x41) {doesPlaying=0;} 
         
  if (BlueBuffer[3]==0x47) {
                            if (BlueBuffer[4]==0x31) doesConected=0; else  
                            if (BlueBuffer[4]==0x33) doesConected=1;}
        
}


if (BlueBuffer[2]==0x49) {
  if (BlueBuffer[3]==0x56) doesConected=1; else 
    if (BlueBuffer[3]==0x49) doesConected=0;     
} 


updateBluetoothState(0);

}

interrupt [USART1_TXC] void usart1_tx_isr(void) {

}

//Ext0 interrupt calling, when at least one BUTTON has been pressed//
interrupt [EXT_INT0] void Button_Pressed(void) {
#asm("sei");

timer=0;
sleepTimer=0;

delay_ms(20);

if (isOFF) return;



if (PING&1==1) {if (mayOFF==1) {delay_ms(150); button_1();}}
if ((PING>>1)&1==1) {button_2();}
if (PINC.0==1) {button_3();}
if (PINC.1==1) {button_4();}
if (PINC.2==1) {button_5();}
if (PINC.3==1) {button_6();}
if (PINC.4==1) {button_7();}
if (PINC.5==1) {button_8();}
if (PINC.6==1) {button_9();}
}

//Encoder Button
interrupt [EXT_INT1] void EncoderButton_Pressed(void) {delay_ms(20); if (PIND.1==1) return; else while (PIND.1==0) {}
if (isOFF) return;

if (recentMenu==11) {switch (PlayerMenu) {
case 0: SendToBluetooth ("ME"); break;
case 1: SendToBluetooth ("MA"); if (doesPlaying==1) doesPlaying=0; else doesPlaying=1; break;
case 2: SendToBluetooth ("MD"); break;
} timer=0; sleepTimer=0;} 
else {recentMenu=volumeMenu;}


if (recentMenu!=11|recentMenu!=0)
{UpdateMenu();} else 
updateBluetoothState(0);

}

//Bluetooth Mute (0 - enable, 1 - disable)
interrupt [EXT_INT4] void Bluetooth_Mute(void) {



              if (PINE.4==1) {
              doesPlaying=1;
              i2c_start();
		      i2c_write(0b10001000);
              i2c_write(63-volume);
		      i2c_stop();
              } else {     
              doesPlaying=0;
              i2c_start();
		      i2c_write(0b10001000);
              if (input==1&isBluetoothEnabled) i2c_write(63);
		      i2c_stop();
              }
             
              if (recentMenu==0|recentMenu==11) 
              if (input==1&doesConected==1)
              if (isBluetoothEnabled) 
              updateBluetoothState(0);
                 
}


int doesReceiving=0;
int recentBitLenght;

//Ext1 interrupt calling, when IR signal has been detected//
interrupt [EXT_INT6] void TSOP(void) {
/*
sleepTimer=0;

if (PINE.6==1) {

if (!doesReceiving) return;

TCCR2=0;
recentBitLenght=TCNT2;
TCNT2=0;
sprintf(buffer, "Bit: %d ", recentBitLenght);
lcd_clear();
lcd_puts(buffer);

doesReceiving=0;

LED(2);

} else {
doesReceiving=1;
TCNT2=0;
TCCR2=5;
TIMSK=0x40;
LED(6);
}


*/
}

interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
lcd_clear();
lcd_puts("Overflow");
recentBitLenght=doesReceiving=0;
}

//Called 140 times per second
interrupt [TIM3_COMPA] void tim3_compa (void) {    
    unsigned int enc; 

      if (bluetoothAskStateTimer<100) bluetoothAskStateTimer++; else {bluetoothAskStateTimer=0; SendToBluetooth("CY");}
       
        
      if (isBluetoothEnabled==1) {
      bluetoothResetTimer++;
      if (bluetoothResetTimer>bluetoothResetTime)                       
      BluetoothReset();        
      } 
            
                       
    enc=PIND; enc>>=4; enc&=0b00000011;
	if (enc!=encwas) {
		if (encwas==3) {
			if (enc==1)  {ValueChanged(0);}
			if (enc==2)  {ValueChanged(1);}
			UpdateMenu();
		}
		encwas=enc;
    }
    
    if (recentMenu!=0) {
      timer++;
      if (recentMenu!=11) {
      if (timer>700) {
      timer=0;
      recentMenu=0;
      UpdateMenu();
      }}
      else
      {if (timer>1400) {
      timer=0;
      recentMenu=0;
      UpdateMenu();}
      } 
      } 
      
                        
      if (sleepTimer<sleepTime) {
      sleepTimer++;        
             
      if (OCR0!=brightless)
      for (k=OCR0; k<=brightless; k++) {
      OCR0=k;
      delay_ms(2);
      }          
      
      } else if (brightless>sleepBrightless) { 
      for (k=OCR0; k>sleepBrightless; k--) {
      OCR0=k;
      delay_ms(2);
      }                                       
     
      }
      
      
  }

void main(void) {

DDRA =0b00011111; DDRB =0b11111111; DDRD =0b00000000; DDRE= 0b00001110; DDRF= 0b00101010; DDRG =0b00001000; DDRC =0b10000000;                  
PORTA=0b00011010; PORTB=0b00000000; PORTD=0b11110010; PORTE=0b01000000; PORTF=0b00001000; PORTG=0b00000011; PORTC=0b11111111;  

TCCR1A=0b10000010;
TCCR1B=0b00000001;
ICR1=480; 
OCR1A=480;

TCCR3A=0b00000000;
TCCR3B=0b00000001;
ETIMSK=0b00010000;
OCR3AH=0b00001110;
OCR3AL=0b10100000;
     
UCSR1A=0x00;
UCSR1B=0b11011000;       // Uart init:
UCSR1C=0b00000110;       // 9600 bouds / 8 data Bit / 1 Stop Bit / No parity
UBRR1H=0x00;             // Interrupts RXC and TXC are enabled 
UBRR1L=0x08; 
 
EICRA=0b00001011;           // Interrupts setup:  
EICRB=0b00010001;           // INT0 - Rising edge interrupt (Buttons); INT1 - falling edge interrupt (ENC BUTTON);        
EIMSK=0b01010011;           // INT2 & INT3  - UART (unused ints); INT4 - Any change, BLUETOOTH MUTE; INT6 - Falling edge, TSOP;
         

if (doesEEpromWritten==1)
isBluetoothEnabled=settings[11];
else
isBluetoothEnabled=1;



if (!isBluetoothEnabled)
BluetoothOFF(); else bluetoothResetTimer=bluetoothResetTime-1000;


#asm("sei");

lcd_init(16);
lcd_clear();

//Writing New Symbols into LCD
{
define_char(char0,0);
define_char(char1,1);
define_char(char2,2);
define_char(char3,3);
define_char(char4,4);
define_char(char5,5);
define_char(char6,6);
}



while ((PING&1)==0) {if (doesConected) {settings[7]=1; goto start;}}
bluetoothResetTimer=bluetoothResetTime-1000;
start:
bluetoothResetTimer=0;


isOFF=0;

TCCR0=0b01101001;

LED(2);
PORTA|=1;

delay_ms(50);
i2c_init();//Test
i2c_start();
i2c_stop();


//Testing audioproccesor
if (i2c_start()==1) {
    if (i2c_write(0b10001000)==1) {}
    else {
    lcd_clear();
    lcd_puts("Audio processor");
    lcd_gotoxy(0,2);
    lcd_puts("Error: adress");
    i2c_stop();
    #asm("cli");
    while (1) {PORTF=0b00000100; delay_ms(1000); PORTF=0x00; delay_ms(1000);}}
    }

else {
lcd_clear();
lcd_puts("Audio processor");
lcd_gotoxy(0,1);
lcd_puts("Error with bus");
i2c_stop(); 
while (1) {PORTF=0b00000100; delay_ms(1000); PORTF=0x00; delay_ms(1000);} 
}




//Writing default settings;
	
    if (doesEEpromWritten!=1) {
    volume=10;
	bass=10;
	treble=13;
	gain=0b00011000;
	loudness=0;
    LR_balance=31;
    FR_balance=31;
    input=1;
    brightless=125;
    opasity=220;
    isBluetoothEnabled=0;
    } else {
    volume=settings[0];
	bass=settings[1];
	treble=settings[2];
	gain=settings[3];
	loudness=settings[4];
    LR_balance=settings[5];
    FR_balance=settings[6];
    input=settings[7];
    brightless=settings[8];
    opasity=settings[9];
    doesPlaying=settings[10];
    isBluetoothEnabled=settings[11];
    }


for (recentMenu=0; recentMenu<12; recentMenu++) {
UpdateMenu();
}

lcd_clear();
lcd_puts("     NewAmp");
lcd_gotoxy(0,1);
lcd_puts("  Firmware 3.1");
delay_ms(1000);
lcd_clear();
lcd_puts("  Leskiv");
lcd_gotoxy(0,1);
lcd_puts("    Production");
delay_ms(1000);




recentMenu=0;
UpdateMenu();


mayOFF=1;


while(1) {}

  /*
m1:
while (1) {
      if (bluetoothResetTimer<49000) goto m1;
      bluetoothResetTimer=0; 
      
      if (doesConected) {
      lastConectedState=50;
      lastPlayingState=50;
      } else {
       
         BluetoothOFF();
         delay_ms(10000);
         BluetoothON();                
         
      }
}    
  */

}