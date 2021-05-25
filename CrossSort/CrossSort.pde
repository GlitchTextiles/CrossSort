//import java.util.*;

import controlP5.*;

ControlP5 cp5;



String inputPath;
String sequencePath;
String stillPath;

boolean play = false;
boolean record = false;
boolean help = false;

PImage src;
PImage buffer;

int sequenceIndex = 0;
int iterations=0;

int ControlFrame_w = 650;
int ControlFrame_h = 425;
int GUILocationX = 0;
int GUILocationY = 0;

int screen_x=0;
int screen_y=0;
int screen_width = 650;
int screen_height = 425;

int guiObjectSize = 40;
int guiBufferSize = 10;
int gridSize = guiObjectSize + guiBufferSize;
int gridOffset = 10;

SortOperations operations;
DisplayWindow displayWindow = new DisplayWindow(screen_width,0,10,10);

void setup() {
  size(10, 10);
  surface.setSize(screen_width, screen_height);
  surface.setLocation(screen_x, screen_y);
  frameRate(30);
  setupGUI();
  operations = new SortOperations(grid(0),grid(2));
  
  
  
}

void draw() {
  background(0);

  if (play && buffer != null) {

    operations.sort();

    if (record) {
      if (sequencePath != null) {
        buffer.save(sequencePath+"-"+nfs(sequenceIndex, 4)+".png");
        sequenceIndex++;
      }
    }
  }
  if (buffer != null) displayWindow.display(buffer);
  if (help) image(generateHelp(), 0, 0);
}

void reset() {
  buffer=src.copy();
}
