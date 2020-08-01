#include "arduinoFFT.h"
#include <Wire.h>
#include <Adafruit_ADS1015.h>
Adafruit_ADS1015 ads;

//Setup some variables used to show how long the ADC conversion takes place
unsigned long starttime;
unsigned long endtime ;
int16_t Raw;
int i;

#define SAMPLES 256
#define SAMPLING_FREQUENCY 1000

arduinoFFT FFT = arduinoFFT();

arduinoFFT FFT1 = arduinoFFT();

unsigned int sampling_period_us;
unsigned long microseconds;
unsigned int offset;
double vReal[SAMPLES];
double vImag[SAMPLES];
double aReal[SAMPLES];
double aImag[SAMPLES];

void setup() {
  Serial.begin(230400);
  ads.begin();
  sampling_period_us = round(1000000 * (1.0 / SAMPLING_FREQUENCY));
}

void loop() {
  /*SAMPLING*/
  
  
  if (Serial.read() == 'L' ) {
    if(1){
    for (int i = 0; i < SAMPLES; i++) {
      microseconds = micros();    //Overflows after around 70 minutes!
      //adc.triggerConversion(); //Start a conversion.  This immediatly returns
      float v_results = (3 * ads.readADC_Differential_2_3())/1000.0;
      float a_results = (3 * ads.readADC_Differential_0_1())/1000.0;
      //Serial.println(results);
      vReal[i] = v_results * 1;
      vImag[i] = 0;
      aReal[i] = a_results *30;
      aImag[i] = 0;
      while (micros() < (microseconds + sampling_period_us)) {
      }
    }

    /*FFT*/
    FFT.Windowing(vReal, SAMPLES, FFT_WIN_TYP_HAMMING, FFT_FORWARD);
    FFT1.Windowing(aReal, SAMPLES, FFT_WIN_TYP_HAMMING, FFT_FORWARD);
    FFT.Compute(vReal, vImag, SAMPLES, FFT_FORWARD);
    FFT1.Compute(aReal, aImag, SAMPLES, FFT_FORWARD);
    FFT.ComplexToMagnitude(vReal, vImag, SAMPLES);
    FFT1.ComplexToMagnitude(aReal, aImag, SAMPLES);

    /*PRINT RESULTS*/
    // Serial.println(peak);     //Print out what frequency is the most dominant.
    for (int i = 0; i < (SAMPLES / 2) ; i = i + 1) {
      Serial.print((i * 10.0 * SAMPLING_FREQUENCY) / SAMPLES, 0);
      Serial.print(",");
      
            vReal[i] = vReal[i] * 10;
            aReal[i] = aReal[i] * 10;

      Serial.print(vReal[i], 0); //View only this line in serial plotter to visualize the bins
      Serial.print(",");
      Serial.print(aReal[i], 0); //View only this line in serial plotter to visualize the bins
      Serial.println(",");
    }
    Serial.println('F');
  }
}
