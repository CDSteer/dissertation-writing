#include "Settings.h"

Settings::Settings(){
    solid = true;
    flashing = false;
    breathing = false;
    flashTime = 800;
}
Settings::~Settings(){}


bool Settings::isSolid() {
    return this->solid;
}
bool Settings::isFlashing() {
    return this->flashing;
}
bool Settings::isBreathing() {
    return this->breathing;
}

int Settings::setMode(int args){
    if (args == 1){
        solid = true;
        flashing = false;
        breathing = false;
    } else if (args == 2) {
        solid = false;
        flashing = true;
        breathing = false;
    } else if (args == 3) {
        solid = false;
        flashing = false;
        breathing = true;
    }
    return 0;
}

void Settings::setFlash(int flashTime){
    this->flashTime = flashTime;
}
int Settings::getFlash(){
    return this->flashTime;
}