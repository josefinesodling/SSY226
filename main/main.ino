// lcd.clear() , Clears the LCD screen and positions the cursor in the upper-left corner.
// http://electronics.stackexchange.com/questions/54/saving-arduino-sensor-data-to-a-text-file

#include <LiquidCrystal.h>
LiquidCrystal lcd(12, 11, 5, 4, 3, 2); // The numbers of the interface pins

// Constants
int DEBUG = 0;
float MINTEMP = 30;
float MAXTEMP = 80;

// Global variables
int counter = 0;
double analog1Sum = 0;
double analog2Sum = 0;
unsigned long time;

void setup() {
  // Set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  
  Serial.begin(9600);
}

void loop() {
  float analog0;
  float analog1;
  float refT;
  int refT_int;
  double T1;
  int T1_int;
  double R1;
  double T2;
  int T2_int;
  double R2;
  
  // ------------------------------
  // --- Read analog values
  analog0 = analogRead(0);
  analog1 = analogRead(1);
  analog2 = analogRead(2);

  // ------------------------------
  // --- Do calculations
  refT = ((MAXTEMP-MINTEMP)/1023)*analog0 + MINTEMP;	// Set ref-temp from potentiometer
  refT_int = refT;									    // Floor it to an integer
  
  // Mean value from 10 samples
  if (counter < 10) {
	analog1Sum += analog1;
	analog2Sum += analog2;
	counter += 1;
  }
  else {
	time = millis();							     	// Time since program started
	R1 = (2250600/analog1Sum - 2200)/10;			    // Mean resistance
	T1 = -(R1 - 3965.26)/70.2873;						// Mean temperature
	R2 = (2250600/analog2Sum - 2200)/10;			    // Mean resistance
	T2 = -(R2 - 3965.26)/70.2873;						// Mean temperature
	counter = 0;
    analog1Sum = 0;
	analog2Sum = 0;
  }
  
  // ------------------------------
  // --- Set LCD display strings  
  
  // Line 1 - Reference temperature
  lcd.setCursor(0, 0);
  lcd.print("Ref.temp: ");
  lcd.print(refT_int);	// The ref-temp value
  lcd.print((char)223);
  lcd.print("C");     
  
  // Line 2 - The measured, calculated temperature
  if (DEBUG){
	  lcd.setCursor(0, 1);
	  lcd.print("A1:");
	  lcd.print(analog1);
	  lcd.print("/A2:");
	  lcd.print(analog2);
  }
  else if (counter == 0) {
	lcd.setCursor(0, 1);
    lcd.print("T1:");
	T1_int = T1;
	lcd.print(T1_int);		// The temperature value
	lcd.print((char)223);
	lcd.print("C");
    lcd.print("  T2:");
	T2_int = T2;
	lcd.print(T2_int);		// The temperature value
	lcd.print((char)223);
	lcd.print("C");
  }
  
  delay(100);
}

