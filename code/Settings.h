#ifndef SETTINGS_H
#define SETTINGS_H
#include "string.h"

class Settings{
  private:
    bool solid;
    bool flashing;
    bool breathing;
    int flashTime;
  public:
    Settings();
    ~Settings();
    bool isSolid();
    bool isFlashing();
    bool isBreathing();
    int setMode(int);
    void setFlash(int);
    int getFlash();
};

#endif // !SETTINGS_H