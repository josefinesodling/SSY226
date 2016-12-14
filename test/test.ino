// lcd.clear() , Clears the LCD screen and positions the cursor in the upper-left corner.
// http://electronics.stackexchange.com/questions/54/saving-arduino-sensor-data-to-a-text-file
// http://www.thinksrs.com/downloads/programs/Therm%20Calc/NTCCalibrator/NTCcalculator.htm

#include <TimerOne.h>
#include <LiquidCrystal.h>
#include <math.h>
LiquidCrystal lcd(12, 11, 5, 4, 3, 2); // Interface pins

// Constants
float MINTEMP = 40, MAXTEMP = 90; // Reference temp range
int SAMPLETIME = 10 * 10; //10 seconds
int DISPLAYTIME = 10 * 1; //1 second

// Global variables
int counter, counter2, counter3, experiment;
double a = 1.675091827e-3;
double b = 1.857536553e-4;
double c = 5.373169834e-7;
unsigned long time = millis(), delay_check = millis(), delay_check2 = millis();
double analog1Sum, analog2Sum, analog1Sum2, analog2Sum2, analog3Sum, analog3Sum2;

// Controller
double Kp = 30.0, Ki = 1.0, P, I, error;

// Global shared variables
volatile float analog0, analog1, analog2, analog3;
volatile int pushState, pushState2, pushOn, pushOn2, has_read, counter10;

// Variables for the control of the Solid State Relay
int counter_out, set_out ;
volatile int output_rate; //(0 - 100%)

// Variables to control eggs
volatile int eggMenuState = 0;
volatile unsigned long int eggTime = 40;
volatile int eggMenuClock = 0;

volatile int eggIndexArr[100] = {};
volatile unsigned long eggTimeArr[100] = {};
volatile unsigned long eggStartTimeArr[100] = {};
volatile int arrLen = -1;
volatile int eggIndexCount = 1;
volatile int eggDone = 0;
volatile int eggIndexDone = 0;
volatile int eggConfirm = 0;
volatile int inBuff = 0;

void setup() {
  lcd.begin(16, 2);    // Set up the LCD display
  Serial.begin(9600);
  pinMode(7, INPUT);   // Pushbutton pin
  pinMode(6, OUTPUT);  // LED diode pin
  pinMode(8, OUTPUT);  // SSR heater pin
  pinMode(9, INPUT);   // Pushbutton pin
  pinMode(10, OUTPUT);  // LED diode pin
  // Set up interrupts
  Timer1.initialize(100000); // Do not change (10 HZ)
  Timer1.attachInterrupt(getData); // Run getData with 10 HZ
}

void getData(void)
{
  time = millis();
  analog0 = analogRead(0), analog1 = analogRead(1), analog2 = analogRead(2), analog3 = analogRead(3);
  pushOn = digitalRead(7), pushOn2 = digitalRead(9);
  has_read = 1;
  
  //-----------------------------------------------------------
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
    //When 10 seconds has passed, get new set_out value
    if (counter_out == 100){
      counter_out = 0;
      counter10 += 10;
      set_out = output_rate;
      if (pushState > 2){
        lcd.clear();
      }
    }
  }
  if (eggMenuState == 2)
  {
    eggMenuClock += 1;
    if (eggMenuClock > 40){
      eggMenuClock = 0;
      eggMenuState = 3;
      lcd.clear();
    }
  }
  if ((arrLen > -1) && (eggDone == 0) && eggMenuState == 0)
  {
    for(int i = 0; i<arrLen+1; i++){
        //Serial.println(eggIndexArr[i]);
        //Serial.println(eggTimeArr[i]);
        //Serial.println(eggStartTimeArr[i]);
        if (millis() - eggStartTimeArr[i] > eggTimeArr[i]){
          //Serial.println(eggIndexArr[i]);
          eggDone = 1;
          eggIndexDone = i;
          lcd.clear();
          break;
          }
        
      }
  }
  if ((eggDone == 1) && (eggConfirm == 1)){
    eggConfirm = 0;
    eggDone = 0;
    //arrLen -= 1;
    //inBuff -=1;

    //Serial.println(eggIndexArr[eggIndexDone]);
    //Serial.println(eggTimeArr[eggIndexDone]);
    //Serial.println(eggStartTimeArr[eggIndexDone]);

    int temparr1[100] = {};
    unsigned long temparr2[100] = {};
    unsigned long temparr3[100] = {};
    int count = 0;
    for(int i = 0; i<arrLen+1; i++){
      if (i == eggIndexDone){
        
        }
      else{
          temparr1[count] = eggIndexArr[i];
          temparr2[count] = eggTimeArr[i];
          temparr3[count] = eggStartTimeArr[i];
          count += 1;
      }
      eggIndexArr[i] = 0;
      eggTimeArr[i] = 0;
      eggStartTimeArr[i] = 0;
    }

    arrLen -= 1;

    for(int i = 0; i<arrLen+1; i++){
      
          eggIndexArr[i] = temparr1[i];
          eggTimeArr[i] = temparr2[i];
          eggStartTimeArr[i] = temparr3[i];
        
      }
    
    //eggIndexArr[eggIndexDone] = {};
    //eggTimeArr[eggIndexDone] = {};
    //eggStartTimeArr[eggIndexDone] = {};
    lcd.clear();
    }
    
   if (eggDone == 1){
      digitalWrite(10, HIGH);
    }
    else{
      digitalWrite(10, LOW);
    }
  // -----------------------------------------------------------
}

void loop() {
  if (has_read == 1){
    //----------------------------------------------------------
    // Change push state if push botton has been pressed during the last second
    if (pushOn && ((millis() - delay_check) > 200)){
      if (eggDone < 1){
      if (eggMenuState < 1){
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
      }

      if (eggMenuState == 1){
        eggMenuState = 0;
      }
      else if (eggMenuState == 2){
        eggTime -= 1;
        if (eggTime < 1){
          eggTime = 1;
          }
        eggMenuClock = 0;
      }
      else if (eggMenuState == 3){
        eggMenuState = 0;
        eggTime = 40;
      }
      else if (eggMenuState == 4){
          eggIndexArr[arrLen+1] = eggIndexCount;
          eggTimeArr[arrLen+1] = eggTime*1000*60;
          eggStartTimeArr[arrLen+1] = millis();
          arrLen += 1;
          inBuff += 1;
          eggIndexCount += 1;
          
          eggMenuState = 0;
        }
      }
      else{
        eggConfirm = 1;
      }
      
      delay_check = millis();
      lcd.clear();
    }
    
    if (pushState > 0){
      if (pushOn2 && ((millis() - delay_check2) > 200)){
        if (eggDone < 1){
        if (eggMenuState == 0){
          eggMenuState = 1;
        }
        else if (eggMenuState == 1){
          eggMenuState = 2;
        }
        else if (eggMenuState == 2){
          eggTime += 1;
          if (eggTime > 120){
            eggTime = 120;
            }
          eggMenuClock = 0;
        }
        else if (eggMenuState == 3){
          eggMenuState = 4;
        }
        else if (eggMenuState == 4){
          eggIndexArr[arrLen+1] = eggIndexCount;
          eggTimeArr[arrLen+1] = eggTime*1000*60;
          eggStartTimeArr[arrLen+1] = millis();
          arrLen += 1;
          inBuff += 1;
          eggIndexCount += 1;

          //eggTime = 40;
          eggMenuState = 0;
        }
        }
        else{
          eggConfirm = 1;
          }
        delay_check2 = millis();
        lcd.clear();
      }
    }
    //-------------------------------------------------------------
    // If push botton has been pressed once, start the program
    if (pushState > 0){
      double T1, T2, T3;
      //-----------------------------------------------------------
      // Set ref-temp from potentiometer --------------------------
      double refT = ((MAXTEMP-MINTEMP)/1023)*analog0 + MINTEMP;
      int refT_int = round(refT);

      // If running experiment, ref-temp is predefined
      if (experiment){
        if (counter10 < 400){
          refT_int = 50;
          }
        else if ((counter10 >= 400) && (counter10 < 700)){
          refT_int = 60;
          }
        else if ((counter10 >= 700) && (counter10 < 900)){
          refT_int = 70;
          }
        else if ((counter10 >= 900) && (counter10 < 1300)){
          refT_int = 90;
          }
        else if ((counter10 >= 1300) && (counter10 < 2000)){
          refT_int = 85;
          }
        else{
          refT_int = 90;
          }
      }

      if (counter3 > 4){
        counter3 = 0;
      }
      else{
        counter3 += 1;
      }

      //-----------------------------------------------------------
      // Mean value from DISPLAYTIME amount of samples ------------
      if ((counter+1) < DISPLAYTIME) {
        noInterrupts();
    	  analog1Sum += analog1/(DISPLAYTIME-1);
    	  analog2Sum += analog2/(DISPLAYTIME-1);
        analog3Sum += analog3/(DISPLAYTIME-1);
        interrupts();
    	  counter += 1;
      }
      else {
        //---------------------------------------------------------
        // Calculate temperature for the LCD display --------------
    	  double R1 = (2250600/analog1Sum - 2200);
        T1 = log(R1);
        T1 = (1 /(a + (b + (c * T1 * T1 ))* T1 )) - 273.15;
    	  double R2 = (2250600/analog2Sum - 2200);
    	  T2 = log(R2);
        T2 = (1 /(a + (b + (c * T2 * T2 ))* T2 )) - 273.15;
        double R3 = (2250600/analog3Sum - 2200);
        T3 = log(R3);
        T3 = (1 /(a + (b + (c * T3 * T3 ))* T3 )) - 273.15;
        
        Serial.println(analog1Sum);
        Serial.println(refT_int);
        Serial.println(output_rate);
        
    	  counter=0, analog1Sum=0, analog2Sum=0, analog3Sum=0;
      }
      
      //-----------------------------------------------------------
      // Mean value from SAMPLETIME amount of samples -------------
      if ((counter2+1) < SAMPLETIME) {
        noInterrupts();
        analog1Sum2 += analog1/(SAMPLETIME-1);
        analog2Sum2 += analog2/(SAMPLETIME-1);
        analog3Sum2 += analog3/(SAMPLETIME-1);
        interrupts();
        counter2 += 1;
      }
      else {
        // Print sample data to computer via serial
        //Serial.println(time);
        //Serial.println(analog1Sum2);
        //Serial.println(analog2Sum2);
        //Serial.println(analog3Sum2);
        //Serial.println(refT_int);

        //Calculate control output
        double R1 = (2250600/analog1Sum2 - 2200);
        T1 = log(R1);
        T1 = (1 /(a + (b + (c * T1 * T1 ))* T1 )) - 273.15;
        
        error = refT_int - T1;
        P = error;

        // Reset the integral part if outside error range
        if ((error < 1) && (error > 0)){
          I += error * SAMPLETIME*0.1;
        }
        else{
          I = 0;
        }
        
        output_rate = round(Kp*P + Ki*I);

        if (output_rate > 100){
          output_rate = 100;
        }
        else if ((output_rate < 0) || (error < -0.05)){
          output_rate = 0;
        }

        //Serial.println(output_rate);

        counter2=0, analog1Sum2=0, analog2Sum2=0, analog3Sum2=0;
      }
      
      //--------------------------------------------------------
      // --- Set LCD display strings ---------------------------
      if (eggDone < 1){
      if (eggMenuState < 1){
        if ((pushState == 1) && (counter == 0)){
          // Line 1 - Reference temperature
          lcd.setCursor(0, 0);
          lcd.print("Ref.temp: ");
          lcd.print(refT_int);	// The ref-temp value
          lcd.print((char)223);
          lcd.print("C");     
          
          // Line 2 - The measured, calculated temperature
      	  lcd.setCursor(0, 1);
      	  lcd.print(T1, 1);		// Water temp
          lcd.print("|");
      	  lcd.print(T2, 1);		// Room temp
          lcd.print("|");
          lcd.print(T3, 1);   // Jacket temp
        }
        else if ((pushState == 2) && (counter3 == 0)){
          lcd.setCursor(0, 0);
          lcd.print(round(analog1)); // Water analog
          lcd.print("|");
          lcd.print(round(analog2)); // Room analog
          lcd.print("|");
          lcd.print(round(analog3)); // Jacket analog
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
        if (eggMenuState == 1){
          lcd.setCursor(0, 0);
          lcd.print("Init food #");
          lcd.print(eggIndexCount);
          lcd.setCursor(0, 1);
          lcd.print("to system [Y/N]?");
          }
        else if (eggMenuState == 2){
          lcd.setCursor(0, 0);
          lcd.print("Set cooking time");
          lcd.setCursor(0, 1);
          lcd.print("Time: ");
          lcd.print(eggTime);
          lcd.print(" min");
          }
         else if (eggMenuState == 3){
          lcd.setCursor(0, 0);
          lcd.print("Add food #");
          lcd.print(eggIndexCount);
          lcd.setCursor(0, 1);
          lcd.print("to system [Y/N]?");
          }
          else if (eggMenuState == 4){
          lcd.setCursor(0, 0);
          lcd.print("Food #");
          lcd.print(eggIndexCount);
          lcd.print(" added!");
          }
      }
      }
      else{
        lcd.setCursor(0, 0);
        lcd.print("Food #");
        lcd.print(eggIndexArr[eggIndexDone]);
        lcd.print(" is done!");
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

