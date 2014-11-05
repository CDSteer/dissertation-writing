#ifndef BREATHLIGHT_H
#define BREATHLIGHT_H
#include "NoteLight.h"

class BreathLight: public NoteLight{
  private:
    int i;
  public:
    BreathLight();
    ~BreathLight();
};

#endif // !BREATHLIGHT_H