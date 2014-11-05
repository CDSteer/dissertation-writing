import processing.serial.*;
import processing.opengl.*;
import java.util.ArrayList;
import java.util.List;
boolean cali = true;
int caliX1, caliX2, caliY1, caliY2;
PImage sunflower, cloud;
int rainNum = 50;
List<Rain> rain = new ArrayList<Rain>(50);
ArrayList splash = new ArrayList();
float current;
float reseed = random(0,.2);
int g_winW             = 1000;
int g_winH             = 700;
boolean g_enableFilter = true;

cDataArray g_xAccel    = new cDataArray(200);
cDataArray g_yAccel    = new cDataArray(200);
cDataArray g_zAccel    = new cDataArray(200);
cDataArray g_vRef      = new cDataArray(200);
cDataArray g_xRate     = new cDataArray(200);
cDataArray g_yRate     = new cDataArray(200);
cGraph g_graph         = new cGraph(10, 190, 800, 400);
Serial g_serial;
PFont  g_font;

float x, y;
float waterLvl, waterLvl2, waterLvl3;
boolean isCollision = false;
float sunflowerAX, sunflowerAY;
float sunflowerBX, sunflowerBY;
float sunflowerCX, sunflowerCY;

int oldXAccel, oldYAccel;
int xAccel, yAccel, zAccel, vRef, xRate, yRate;

void setup() {
  size(g_winW, g_winH, P3D);
  cloud = loadImage("rec/cloud.png");
  sunflower = loadImage("rec/sunflower.png");
  x =  g_winW/2;
  y =  10;
  noStroke();
  sunflowerAX = 100; 
  sunflowerAY = 550;
  
  sunflowerBX = 400; 
  sunflowerBY = 550;
  
  sunflowerCX = 750; 
  sunflowerCY = 550;
  println(Serial.list());
  g_serial = new Serial(this, "/dev/tty.usbmodem1421", 115200, 'N', 8, 1.0);
  g_font = loadFont("ArialMT-20.vlw");
  textFont(g_font, 20);

  colorMode(RGB,100);
  background(0);
  rain.add(new Rain(x, y));
  current = millis();
}

void draw(){
  background(0);
  blur(50);
  image(cloud, x, y);
  image(sunflower, sunflowerAX, sunflowerAY);
  image(sunflower, sunflowerBX, sunflowerBY);
  image(sunflower, sunflowerCX, sunflowerCY);

  if ((millis()-current)/1000>reseed&&rain.size()<150) {
    rain.add(new Rain(x,y));
    reseed = random(0,.2);
    current = millis();
  }

  for (int i=0 ; i<rain.size() ; i++) {
    Rain rainT = (Rain)rain.get(i);
    rainT.calculate();
    rainT.draw();
    if (rainT.position.y>height) {
      for (int k = 0 ; k<random(5,10); k++) {
        splash.add(new Splash(rainT.position.x,height));
      }
      rain.remove(i);
      float rand = random(0,100);
      if (rand>10&&rain.size()<150)
      rain.add(new Rain(x,y));
    }
  }

  fill(255, 255, 255);
  rect(70, 700, 20, -155);
  rect(350, 700, 20, -155);
  rect(700, 700, 20, -155);

  for (Rain rainT : rain) {
    if (rainT.position.y > 540){
      isCollision = isCollidingCircleRectangle(rainT.position.x, 
      rainT.position.y, 5, sunflowerAX, sunflowerAY, 116.0, 149.0);
      if (isCollision == true){
        if (waterLvl >= -155){
          waterLvl = waterLvl - .4;
        }
      }
      if (waterLvl > -155){
        fill(0, 0, 255);
      } else {
        fill(0, 255, 0);
      }
      rect(70, 700, 20, waterLvl);
      
      isCollision = isCollidingCircleRectangle(rainT.position.x, 
      rainT.position.y, 5, sunflowerBX, sunflowerBY, 116.0, 149.0);
      if (isCollision == true){
        if (waterLvl2 >= -155){
          waterLvl2 = waterLvl2 - .4;
        }
      }
      if (waterLvl2 > -155){
        fill(0, 0, 255);
      } else {
        fill(0, 255, 0);
      }
      rect(350, 700, 20, waterLvl2);
      
      isCollision = isCollidingCircleRectangle(rainT.position.x, 
      rainT.position.y, 5, sunflowerCX, sunflowerCY, 116.0, 149.0);
      if (isCollision == true){
        if (waterLvl3 >= -155){
          waterLvl3 = waterLvl3 - .4;
        }
      }
      if (waterLvl3 > -155){
        fill(0, 0, 255);
      } else {
        fill(0, 255, 0);
      }
      rect(700, 700, 20, waterLvl3);
    }
  }
  

  if (waterLvl <= 0){
    waterLvl = waterLvl + .2;
  }
  if (waterLvl2 <= 0){
    waterLvl2 = waterLvl2 + .2;
  }
  if (waterLvl3 <= 0){
    waterLvl3 = waterLvl3 + .2;
  }

  for (int i=0 ; i<splash.size() ; i++){
    Splash spl = (Splash) splash.get(i);
    spl.calculate();
    spl.draw();
    if (spl.position.y>height)
    splash.remove(i);
  }

  if (xAccel < caliX1 && xAccel < caliX2){
    x = x - 5;
  } else if (xAccel > caliX1 && xAccel > caliX2) {
    x = x + 5;
  }

  while (g_serial.available() >= 2*6+2) {
    processSerialData();
  }

  strokeWeight(1);
  fill(255, 255, 255);
}

// This reads in one set of the data from the serial port
void processSerialData() {
  int inByte = 0;
  int curMatchPos = 0;
  int[] intBuf = new int[2];

  intBuf[0] = 0xAD;
  intBuf[1] = 0xDE;

  while (g_serial.available() < 2); // Loop until we have enough bytes
  inByte = g_serial.read();
  while(curMatchPos < 2) {
    if (inByte == intBuf[curMatchPos]) {
      ++curMatchPos;
      if (curMatchPos == 2)
        break;
      while (g_serial.available() < 2); // Loop until we have enough bytes
      inByte = g_serial.read();
    } else {
      if (curMatchPos == 0) {
        while (g_serial.available() < 2); // Loop until we have enough bytes
        inByte = g_serial.read();
      } else {
        curMatchPos = 0;
      }
    }
  }

  while (g_serial.available() < 2*6){
    byte[] inBuf = new byte[2];
    oldXAccel = xAccel;
    oldYAccel = yAccel;
    g_serial.readBytes(inBuf);
    xAccel = ((int)(inBuf[1]&0xFF) << 8) + ((int)(inBuf[0]&0xFF) << 0);
    g_serial.readBytes(inBuf);
    yAccel = ((int)(inBuf[1]&0xFF) << 8) + ((int)(inBuf[0]&0xFF) << 0);
    g_serial.readBytes(inBuf);
    zAccel = ((int)(inBuf[1]&0xFF) << 8) + ((int)(inBuf[0]&0xFF) << 0);
    g_serial.readBytes(inBuf);
    vRef   = ((int)(inBuf[1]&0xFF) << 8) + ((int)(inBuf[0]&0xFF) << 0);
    g_serial.readBytes(inBuf);
    xRate  = ((int)(inBuf[1]&0xFF) << 8) + ((int)(inBuf[0]&0xFF) << 0);
    g_serial.readBytes(inBuf);
    yRate  = ((int)(inBuf[1]&0xFF) << 8) + ((int)(inBuf[0]&0xFF) << 0);

    System.out.println("X: " + xAccel + " Y: " + yAccel + " Z: " + zAccel);
    if (cali == true){
      caliX1 = xAccel;
      caliX2 = xAccel+1; 
      caliY1 = yAccel;
      caliY2 = yAccel+1;
      cali = false;
      System.out.println(caliX1 + ", "+ caliY1);
    }
  }
}
class cDataArray {
  float[] m_data;
  int m_maxSize;
  int m_startIndex = 0;
  int m_endIndex = 0;
  int m_curSize;

  cDataArray(int maxSize) {
    m_maxSize = maxSize;
    m_data = new float[maxSize];
  }

  void addVal(float val) {

    if (g_enableFilter && (m_curSize != 0)) {
      int indx;

      if (m_endIndex == 0)
        indx = m_maxSize-1;
      else
        indx = m_endIndex - 1;

      m_data[m_endIndex] = getVal(indx)*.5 + val*.5;
    } else {
      m_data[m_endIndex] = val;
    }

    m_endIndex = (m_endIndex+1)%m_maxSize;
    if (m_curSize == m_maxSize) {
      m_startIndex = (m_startIndex+1)%m_maxSize;
    } else {
      m_curSize++;
    }
  }

  float getVal(int index) {
    return m_data[(m_startIndex+index)%m_maxSize];
  }

  int getCurSize() {
    return m_curSize;
  }

  int getMaxSize() {
    return m_maxSize;
  }
}

void blur(float trans) {
  noStroke();
  fill(0,trans);
  rect(0,0,width,height);
}

class cGraph {
  float m_gWidth, m_gHeight;
  float m_gLeft, m_gBottom, m_gRight, m_gTop;

  cGraph(float x, float y, float w, float h) {
    m_gWidth     = w;
    m_gHeight    = h;
    m_gLeft      = x;
    m_gBottom    = g_winH - y;
    m_gRight     = x + w;
    m_gTop       = g_winH - y - h;
  }

boolean isCollidingCircleRectangle(
      float circleX,
      float circleY,
      float radius,
      float rectangleX,
      float rectangleY,
      float rectangleWidth,
      float rectangleHeight) {

  float circleDistanceX = abs(circleX - rectangleX - rectangleWidth/2);
  float circleDistanceY = abs(circleY - rectangleY - rectangleHeight/2);

  if (circleDistanceX > (rectangleWidth/2 + radius)) { return false; }
  if (circleDistanceY > (rectangleHeight/2 + radius)) { return false; }

  if (circleDistanceX <= (rectangleWidth/2)) { return true; }
  if (circleDistanceY <= (rectangleHeight/2)) { return true; }

  float cornerDistance_sq = pow(circleDistanceX - rectangleWidth/2, 2) +
                       pow(circleDistanceY - rectangleHeight/2, 2);

  return (cornerDistance_sq <= pow(radius,2));
}


