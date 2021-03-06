// lcd.clear() , Clears the LCD screen and positions the cursor in the upper-left corner.
// http://electronics.stackexchange.com/questions/54/saving-arduino-sensor-data-to-a-text-file
// http://www.thinksrs.com/downloads/programs/Therm%20Calc/NTCCalibrator/NTCcalculator.htm

#include <LiquidCrystal.h>
#include <math.h>
LiquidCrystal lcd(12, 11, 5, 4, 3, 2); // The numbers of the interface pins

// Constants
int DEBUG = 0;
float MINTEMP = 30;
float MAXTEMP = 80;
int SAMPLETIME = 10; // 60 seconds
int DISPLAYTIME = 10;
int pushState = 0;

// Global variables
int counter = 0;
int counter2 = 0;
double analog1Sum = 0;
double analog2Sum = 0;
double analog1Sum2 = 0;
double analog2Sum2 = 0;
unsigned long time = millis();
unsigned long delay_check = millis();
unsigned long time_mic = micros();
double a = 1.675091827e-3;
double b = 1.857536553e-4;
double c = 5.373169834e-7;

void setup() {
  // Set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  Serial.begin(9600);
  pinMode(7, INPUT);
}

void loop() {
  time = millis();
  time_mic = micros();
  double T1; double T2;
  // --- Read analog values
  float analog0 = analogRead(0);
  float analog1 = analogRead(1);
  float analog2 = analogRead(2);

  // --- Read digital values
  int pushOn = digitalRead(7);

  if (pushOn){
    if ((pushState == 0) && ((millis() - delay_check) > 1000)){
      pushState = 1;
      delay_check = millis();
      lcd.clear();
    }
    else if ((pushState == 1) && ((millis() - delay_check) > 1000)){
      pushState = 2;
      delay_check = millis();
    }
    else if ((pushState == 2) && ((millis() - delay_check) > 1000)){
      pushState = 1;
      delay_check = millis();
    }
  }

  if (pushState > 0){
  // ------------------------------
  // --- Do calculations
  float refT = ((MAXTEMP-MINTEMP)/1023)*analog0 + MINTEMP;	// Set ref-temp from potentiometer
  int refT_int = round(refT);
  
  // Mean value from SAMPLETIME samples
  if (counter < DISPLAYTIME) {
	  analog1Sum += analog1/DISPLAYTIME;
	  analog2Sum += analog2/DISPLAYTIME;
	  counter += 1;

  }
  else {
    
	  double R1 = (2250600/analog1Sum - 2200);			    // Mean resistance
    T1 = log(R1);
    T1 = 1 /(a + (b + (c * T1 * T1 ))* T1 );
    T1 -= 273.15;
	  double R2 = (2250600/analog2Sum - 2200);			    // Mean resistance
	  T2 = log(R2);
    T2 = 1 /(a + (b + (c * T2 * T2 ))* T2 );
    T2 -= 273.15;
	  counter = 0;
    analog1Sum = 0;
	  analog2Sum = 0;
  }
  if (counter2 < SAMPLETIME) {
    analog1Sum2 += analog1/SAMPLETIME;
    analog2Sum2 += analog2/SAMPLETIME;
    counter2 += 1;
  }
  else {
    Serial.println(time);
    Serial.println(analog1Sum2);
    Serial.println(analog2Sum2);
    counter2 = 0;
    analog1Sum2 = 0;
    analog2Sum2 = 0;
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
    //lcd.print("T1:");
	  int T1_int = round(T1);
	  lcd.print(T1);		// The temperature value
	  lcd.print((char)223);
	  lcd.print("C");
    //lcd.print("  T2:");
    lcd.print("/");
	  int T2_int = round(T2);
	  lcd.print(T2);		// The temperature value
	  lcd.print((char)223);
	  lcd.print("C");
  }
  }
  else{
    lcd.setCursor(0, 0);
    lcd.print("Waiting for");
    lcd.setCursor(0, 1);
    lcd.print("pushbutton...");
  }
  delay(time - millis() + 91);
}

