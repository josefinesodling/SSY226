// lcd.clear() , Clears the LCD screen and positions the cursor in the upper-left corner.
// http://electronics.stackexchange.com/questions/54/saving-arduino-sensor-data-to-a-text-file
// http://www.thinksrs.com/downloads/programs/Therm%20Calc/NTCCalibrator/NTCcalculator.htm

#include <TimerOne.h>
#include <LiquidCrystal.h>
#include <math.h>
LiquidCrystal lcd(12, 11, 5, 4, 3, 2); // The numbers of the interface pins

// Constants
float MINTEMP = 30, MAXTEMP = 80;
int SAMPLETIME = 10 * 10; //1 second (never smaller than frequency of Timer1.init)
int DISPLAYTIME = 10 * 1; //1 second (never smaller than frequency of Timer1.init)

// Global variables
int counter = 0, counter2 = 0, counter3 = 0;
double analog1Sum = 0, analog2Sum = 0, analog1Sum2 = 0, analog2Sum2 = 0, analog3Sum = 0, analog3Sum2;
unsigned long time = millis(), delay_check = millis();
double a = 1.675091827e-3;
double b = 1.857536553e-4;
double c = 5.373169834e-7;

// Global shared variables
volatile float analog0 = 0, analog1 = 0, analog2 = 0, analog3 = 0, pushOn = 0, has_read = 0;
volatile int pushState = 0;

// Variables for the control of the Solid State Relay
int counter_out = 0, set_out = 0;
volatile int output_rate = 25; //(0 - 100%)

void setup() {
  lcd.begin(16, 2);    // Set up the LCD display
  Serial.begin(9600);
  pinMode(7, INPUT);   // Pushbutton pin
  pinMode(6, OUTPUT);  // LED diode pin
  pinMode(8, OUTPUT);  // SSR heater pin
  // Set up interrupts
  Timer1.initialize(100000); // Do not change (10 HZ)
  Timer1.attachInterrupt(getData); // Run getData with 10 HZ
}

void getData(void)
{
  time = millis();
  analog0 = analogRead(0), analog1 = analogRead(1), analog2 = analogRead(2), analog3 = analogRead(3);
  pushOn = digitalRead(7);
  has_read = 1;
  
  //--------------------------------------------------------------------
  // SSR set on/off over 10 seconds
  if (pushState > 0){
    counter_out += 1;
    if (set_out >= counter_out){
      digitalWrite(6, HIGH);
      digitalWrite(8, HIGH);
    }
    else{
      digitalWrite(6, LOW);
      digitalWrite(8, LOW);
    }
    //When 10 seconds has passed, get new set_out value from the controller
    if (counter_out == 100){
      counter_out = 0;
      set_out = output_rate;
      if (pushState > 2){
        lcd.clear();
      }
    }
  }
  // --------------------------------------------------------------------
}

void loop() {
  if (has_read == 1){
    //-------------------------------------------------------------------------
    // Change push state if push botton has been pressed during the last second
    if (pushOn && ((millis() - delay_check) > 1000)){
      if (pushState == 0){
        pushState = 1;
      }
      else if (pushState == 1){
        pushState = 2;
      }
      else if (pushState == 2){
        pushState = 3;
      }
      else if (pushState == 3){
        pushState = 1;
      }
      delay_check = millis();
      lcd.clear();
    }
    
    //------------------------------------------------------------------------
    // If push botton has been pressed once, start the program
    if (pushState > 0){
      double T1, T2, T3;
      //----------------------------------------------------------------------
      // Set ref-temp from potentiometer -------------------------------------
      float refT = ((MAXTEMP-MINTEMP)/1023)*analog0 + MINTEMP;
      int refT_int = round(refT);
      output_rate = round((refT_int-30)*2);

      if (counter3 > 4){
        counter3 = 0;
      }
      else{
        counter3 += 1;
      }

      //----------------------------------------------------------------------
      // Mean value from DISPLAYTIME amount of samples -----------------------
      if ((counter+1) < DISPLAYTIME) {
        noInterrupts();
    	  analog1Sum += analog1/(DISPLAYTIME-1);
    	  analog2Sum += analog2/(DISPLAYTIME-1);
        analog3Sum += analog3/(DISPLAYTIME-1);
        interrupts();
    	  counter += 1;
      }
      else {
        //--------------------------------------------------------------------
        // Calculate temperature for the LCD display -------------------------
    	  double R1 = (2250600/analog1Sum - 2200);			    // Mean resistance
        T1 = log(R1);
        T1 = 1 /(a + (b + (c * T1 * T1 ))* T1 );
        T1 -= 273.15;
    	  double R2 = (2250600/analog2Sum - 2200);			    // Mean resistance
    	  T2 = log(R2);
        T2 = 1 /(a + (b + (c * T2 * T2 ))* T2 );
        T2 -= 273.15;
        double R3 = (2250600/analog3Sum - 2200);          // Mean resistance
        T3 = log(R3);
        T3 = 1 /(a + (b + (c * T3 * T3 ))* T3 );
        T3 -= 273.15;
    	  counter = 0, analog1Sum = 0, analog2Sum = 0, analog3Sum = 0;
      }
      
      //----------------------------------------------------------------------
      // Mean value from SAMPLETIME amount of samples ------------------------
      if ((counter2+1) < SAMPLETIME) {
        noInterrupts();
        analog1Sum2 += analog1/(SAMPLETIME-1);
        analog2Sum2 += analog2/(SAMPLETIME-1);
        analog3Sum2 += analog3/(SAMPLETIME-1);
        interrupts();
        counter2 += 1;
      }
      else {
        // Print sample data
        Serial.println(time);
        Serial.println(analog1Sum2);
        Serial.println(analog2Sum2);
        Serial.println(analog3Sum2);
        counter2 = 0, analog1Sum2 = 0, analog2Sum2 = 0, analog3Sum2 = 0;
      }
      
      //----------------------------------------------------------------------
      // --- Set LCD display strings -----------------------------------------  
      if ((pushState == 1) && (counter == 0)){
        // Line 1 - Reference temperature
        lcd.setCursor(0, 0);
        lcd.print("Ref.temp: ");
        lcd.print(refT_int);	// The ref-temp value
        lcd.print((char)223);
        lcd.print("C");     
        
        // Line 2 - The measured, calculated temperature
    	  lcd.setCursor(0, 1);
    	  lcd.print(T1, 1);		// The temperature value
    	  //lcd.print((char)223);
    	  //lcd.print("C/");
        lcd.print("|");
    	  lcd.print(T2, 1);		// The temperature value
    	  //lcd.print((char)223);
    	  //lcd.print("C");
        lcd.print("|");
        lcd.print(T3, 1);    // The temperature value
      }
      else if ((pushState == 2) && (counter3 == 0)){
        lcd.setCursor(0, 0);
        //lcd.print("A1:");
        lcd.print(round(analog1));
        lcd.print("|");
        //lcd.print("/A2:");
        lcd.print(round(analog2));
        lcd.print("|");
        lcd.print(round(analog3));
        lcd.setCursor(0, 1);
        lcd.print("Samp_t:");
        lcd.print(0.1*SAMPLETIME, 1);
        lcd.print("s");
      }
      else if ((pushState == 3) && (counter3 == 0)){
        int power = (1218.0/100.0)*set_out;
        lcd.setCursor(0, 0);
        lcd.print("Power:");
        lcd.print(power);
        lcd.print("W|");
        lcd.print(set_out);
        lcd.print("%");
      }
    }
    else{
      lcd.setCursor(0, 0);
      lcd.print("Waiting for");
      lcd.setCursor(0, 1);
      lcd.print("pushbutton...");
    }
    has_read = 0;
  }
}

