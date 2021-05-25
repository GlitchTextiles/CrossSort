//import java.util.*;

import controlP5.*;

String inputPath;
String sequencePath;
String stillPath;

boolean play, record;

PImage src;
PImage buffer;

int sequenceIndex = 0;
int iterations=0;

int ControlFrame_w = 650;
int ControlFrame_h = 790;
int GUILocationX = 0;
int GUILocationY = 0;

int screen_x = ControlFrame_w;
int screen_y = 0;
int screen_width = 650;
int screen_height = 425;

int guiObjectSize = 40;
int guiBufferSize = 10;
int gridSize = guiObjectSize + guiBufferSize;
int gridOffset = 10;


ControlFrame GUI;

void setup() {
  size(10, 10);
  surface.setSize(screen_width, screen_height);
  surface.setLocation(screen_x, screen_y);
  frameRate(30);
  GUI = new ControlFrame(this, GUILocationX, GUILocationY, ControlFrame_w, ControlFrame_h);
}

void draw() {
  background(0);

  if (play && buffer != null) {
    GUI.operations.sort(buffer);
    if (record) {
      if (sequencePath != null) {
        buffer.save(sequencePath+"-"+nfs(sequenceIndex, 4)+".png");
        sequenceIndex++;
      }
    }
  }
  if (buffer != null) image(buffer, 0, 0);
}
