int led = D0;
int led2 = D7;

int red, blue, green;

void setup() {
  pinMode(led, OUTPUT);
  pinMode(led2, OUTPUT);
  Spark.function("colourLight", colourLight);
  Spark.function("RGBOff", RGBOff);
  RGB.control(true);
}

void loop() {
    RGB.color(red, green, blue);
}

int lightOn(String args){
  digitalWrite(led, HIGH);   // Turn ON the LED pins
  digitalWrite(led2, HIGH);
  return 0;
}

int lightOff(String args){
  digitalWrite(led, LOW);   // Turn ON the LED pins
  digitalWrite(led2, LOW);
  return 0;
}

int colourLight(String args){
    if (args == "blue"){
        blue = 255;
        red = 0;
        green = 0;
    } else if (args == "lBlue"){
        blue = 128;
        red = 0;
        green = 0;
    } else if (args =="red"){
        red = 255;
        blue = 0;
        green = 0;
    } else if (args =="green"){
        green = 255;
        red = 0;
        blue = 0;
    } else if (args =="yellow"){
        green = 255;
        red = 255;
        blue = 0;
    } else if (args == "orange"){
        green = 255;
        red = 128;
        blue = 0;
    }
}

int lightBlue(String args){
  blue = 255;
  return 0;
}

int lightRed(String args){
  red = 255;
  return 0;
}

int lightGreen(String args){
  green = 255;
  return 0;
}

int lightYellow(String args){
  green = 255;
  red = 255;
  return 0;
}

int lightOrange(String args){
  green = 255;
  red = 128;
  return 0;
}

int RGBOff(String args){
    red = 0;
    blue = 0;
    green = 0;
    return 0;
}