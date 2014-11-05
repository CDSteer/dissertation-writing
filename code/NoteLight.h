#ifndef NOTELIGHT_H
#define NOTELIGHT_H

class NoteLight{
  protected:
    int red;
    int green;
    int blue;
  public:
    NoteLight();
    ~NoteLight();
    void setRed(int);
    int getRed();
    void setGreen(int);
    int getGreen();
    void setBlue(int);
    int getBlue();
    int lightGreen();
    int lightRed();
    int lightBlue();
    int lightOff();
};

#endif // !NOTELIGHT_H