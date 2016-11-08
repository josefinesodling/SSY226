/*
  LiquidCrystal Library - display() and noDisplay()

 Demonstrates the use a 16x2 LCD display.  The LiquidCrystal
 library works with all LCD displays that are compatible with the
 Hitachi HD44780 driver. There are many of them out there, and you
 can usually tell them by the 16-pin interface.

 This sketch prints "Hello World!" to the LCD and uses the
 display() and noDisplay() functions to turn on and off
 the display.

 The circuit:
 * LCD RS pin to digital pin 12
 * LCD Enable pin to digital pin 11
 * LCD D4 pin to digital pin 5
 * LCD D5 pin to digital pin 4
 * LCD D6 pin to digital pin 3
 * LCD D7 pin to digital pin 2
 * LCD R/W pin to ground
 * 10K resistor:
 * ends to +5V and ground
 * wiper to LCD VO pin (pin 3)

 Library originally added 18 Apr 2008
 by David A. Mellis
 library modified 5 Jul 2009
 by Limor Fried (http://www.ladyada.net)
 example added 9 Jul 2009
 by Tom Igoe
 modified 22 Nov 2010
 by Tom Igoe

 This example code is in the public domain.

 http://www.arduino.cc/en/Tutorial/LiquidCrystalDisplay

 */

// include the library code:
#include <LiquidCrystal.h>

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);
float minTemp = 30;
float maxTemp = 80;
int counter = 0;
double tempSum = 0;

void setup() {
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  //Serial.begin(115200);   //This code sets up the Serial port at 115200 baud rate
  // Print a message to the LCD.
  lcd.print("hello!");
  
}

void loop() {
  float analog0;
  float analog1;
  float refTemp;
  int refIntTemp;
  double temp;
  double R;
  
  analog0 = analogRead(0);      //Read the analog port 0 and store the value in val
  analog1 = analogRead(1);

  refTemp = ((maxTemp-minTemp)/1023)*analog0 + minTemp;
  refIntTemp = refTemp;
  
  R = 2250600/analog1 - 2200;
  temp = -(R - 3965.26)/70.2873;
  
  lcd.setCursor(0, 0);    // Clear 
  lcd.print("Ref.temp: ");// Print out reftemp 
  
  lcd.print(refIntTemp);
  
  lcd.print((char)223);
  lcd.print("C");     
  lcd.setCursor(0, 1);    // Clear 
  lcd.print("Temp: ");    // print out current temp

  if (counter < 10)
  {
    tempSum = tempSum + temp;
    counter = counter + 1;
  }
  else
  {
    counter = 0;
    temp = tempSum/10;
    tempSum = 0;
    lcd.print(temp);
    lcd.print((char)223);
    lcd.print("C");
  }
  delay(100);            //Wait one second before we do it again
}

