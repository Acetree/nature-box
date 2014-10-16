

void setup() {
  Serial.begin(9600);
}

void loop() {
  int fSR1 = analogRead(A0); // read the sensor value
  Serial.print (fSR1);
  Serial.print(",");
  delay(1);

  int fSR2 = analogRead(A1); // read the sensor value
  Serial.print (fSR2);
  Serial.print(",");
  delay(1);

  int fSR3 = analogRead(A2); // read the sensor value
  Serial.println (fSR3);

}


