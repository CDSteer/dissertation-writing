#include "NoteLight.h"
#include "BreathLight.h"
#include "Settings.h"

int i;
String cubeColour = "";
Settings settings;
BreathLight breathLight;
NoteLight noteLight;

void setup() {
    Spark.function("colourLight", colourLight);
    Spark.function("RGBOff", RGBOff);
    Spark.function("setMode", setMode);
    Spark.function("setFlashRate", setFlashRate);
    settings = Settings();
    noteLight = NoteLight();
    breathLight = BreathLight();
    setMode("solid");
    RGB.control(true);
}

void loop() {
    if (settings.isSolid() == true){
        RGB.color(noteLight.getRed(), noteLight.getGreen(), noteLight.getBlue());
    } else if (settings.isFlashing() == true) {
        flash();
    } else if (settings.isBreathing() == true) {
        breath(cubeColour);
    }
}
int flash(){
    RGB.color(noteLight.getRed(), noteLight.getGreen(), noteLight.getBlue());
    delay(settings.getFlash());
    RGB.color(0, 0, 0);
    delay(settings.getFlash());
}
int setMode(String args){
    if (args == "solid"){
        settings.setMode(1);
    } else if (args == "flashing") {
        settings.setMode(2);
        settings.setFlash(800);
    } else if (args == "breathing") {
        settings.setMode(3);
    }
    return 0;
}
int setFlashRate(String args){
    char msg[256];
    args.toCharArray(msg, 256);
    int range = atoi(msg);
    settings.setFlash(range);
    return 0;
}

int colourLight(String args){
    cubeColour = args;
    if (args == "blue"){
        noteLight.lightBlue();
    } else if (args == "lBlue"){
        noteLight.setBlue(128);
        noteLight.setRed(0);
        noteLight.setGreen(0);
    } else if (args =="red"){
        noteLight.lightRed();
    } else if (args =="green"){
        noteLight.lightGreen();
    } else if (args =="yellow"){
        noteLight.setBlue(0);
        noteLight.setRed(255);
        noteLight.setGreen(255);
    } else if (args == "orange"){
        noteLight.setBlue(0);
        noteLight.setRed(128);
        noteLight.setGreen(255);
    }
    return 0;
}

int RGBOff(String args){
    noteLight.lightOff();
    return 0;
}

int breath(String colour) {
    for(i = 15 ; i <= 255; i+=1) {
        setBreathColor(colour, i);
        RGB.color(noteLight.getRed(), noteLight.getGreen(), noteLight.getBlue());
        lightCycle(noteLight.getRed());
    }
    for(i = 255; i >=15; i-=1) {
        setBreathColor(colour, i);
        RGB.color(noteLight.getRed(), noteLight.getGreen(), noteLight.getBlue());
        lightCycle(noteLight.getRed());
    }
    delay(870);
  return 0;
}

int setBreathColor(String colour, int i){
    if (colour == "blue"){
        noteLight.setGreen(0);
        noteLight.setRed(0);
        noteLight.setBlue(i);
    } else if (colour =="red"){
        noteLight.setBlue(0);
        noteLight.setGreen(0);
        noteLight.setRed(i);
    } else if (colour =="green"){
        noteLight.setBlue(0);
        noteLight.setRed(0);
        noteLight.setGreen(i);
    } else if (colour == "yellow"){
        noteLight.setBlue(0);
        noteLight.setRed(i);
        noteLight.setGreen(i);
    }
}

int lightCycle(int i) {
    if (i > 150) {
      delay(4);
    }
    if ((i > 125) && (i < 151)) {
      delay(5);
    }
    if (( i > 100) && (i < 126)) {
      delay(7);
    }
    if (( i > 75) && (i < 101)) {
      delay(10);
    }
    if (( i > 50) && (i < 76)) {
      delay(14);
    }
    if (( i > 25) && (i < 51)) {
      delay(18);
    }
    if (( i > 1) && (i < 26)) {
      delay(19);
    }
    return 0;
}
