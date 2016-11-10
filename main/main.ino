// lcd.clear() , Clears the LCD screen and positions the cursor in the upper-left corner.
// http://electronics.stackexchange.com/questions/54/saving-arduino-sensor-data-to-a-text-file

#include <LiquidCrystal.h>
LiquidCrystal lcd(12, 11, 5, 4, 3, 2); // The numbers of the interface pins

// Constants
float MINTEMP = 30;
float MAXTEMP = 80;

// Global variables
int counter = 0;
double analog1Sum = 0;

void setup() {
  // Set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
}

void loop() {
  float analog0;
  float analog1;
  float refT;
  int refT_int;
  double T1;
  double R1;
  
  // ------------------------------
  // --- Read analog values
  analog0 = analogRead(0);
  analog1 = analogRead(1);

  // ------------------------------
  // --- Do calculations
  refT = ((MAXTEMP-MINTEMP)/1023)*analog0 + MINTEMP;	// Set ref-temp from potentiometer
  refT_int = refT;									    // Floor it to an integer
  
  // Mean value from 10 samples
  if (counter < 10) {
	analog1Sum += analog1;
	counter += 1;
  }
  else {
	R1 = (2250600/analog1 - 2200)/10;					// Mean resistance
	T1 = -(R1 - 3965.26)/70.2873;						// Mean temperature
	counter = 0;
    analog1Sum = 0;
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
  lcd.setCursor(0, 1);
  lcd.print("Temp: ");

  if (counter == 0) {
	lcd.print(T1);		// The temperature value
	lcd.print((char)223);
	lcd.print("C");
  }
  
  delay(100);
}

