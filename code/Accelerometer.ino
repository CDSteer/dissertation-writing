#define X_ACCEL_APIN 0
#define Y_ACCEL_APIN 1
#define Z_ACCEL_APIN 2
#define V_REF_APIN   3
#define Y_RATE_APIN  4
#define X_RATE_APIN  5

void setup() {
  Serial.begin(115200);
}

void loop() {
  int xAccel=0, yAccel=0, zAccel=0, vRef=0, xRate=0, yRate=0;
  unsigned int startTag = 0xDEAD;
  oopCount = 12;

  #ifdef CHECK_FPS  
    unsigned long startTime, endTime;
    startTime = millis();
  #endif

  for(int i = 0; i < loopCount; ++i) {
    xAccel += analogRead(X_ACCEL_APIN);
    yAccel += analogRead(Y_ACCEL_APIN);
    zAccel += analogRead(Z_ACCEL_APIN);
    vRef   += analogRead(V_REF_APIN);
    xRate  += analogRead(X_RATE_APIN);
    yRate  += analogRead(Y_RATE_APIN);
  }

  xAccel /= loopCount;
  yAccel /= loopCount;
  zAccel /= loopCount;
  vRef   /= loopCount;
  xRate  /= loopCount;
  yRate  /= loopCount;

  Serial.write((unsigned byte*)&startTag, 2);
  Serial.write((unsigned byte*)&xAccel, 2);
  Serial.write((unsigned byte*)&yAccel, 2);
  Serial.write((unsigned byte*)&zAccel, 2);
  Serial.write((unsigned byte*)&vRef, 2);
  Serial.write((unsigned byte*)&xRate, 2);
  Serial.write((unsigned byte*)&yRate, 2);
  
  #ifdef CHECK_FPS  
    endTime = millis();
    Serial.print(" - FPS: ");
    Serial.println(1.f / (endTime-startTime) * 1000);
  #endif
}

