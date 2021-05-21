//import java.util.*;

import controlP5.*;

ControlFrame gui;

String inputPath;
String sequencePath;
String stillPath;

boolean play = false;
boolean record = false;

boolean help = false;

PImage src;
PImage buffer;

int sort_mode = 0;
int sort_by = 0;

boolean UD=false;
boolean LR=false;
boolean DD=false;
boolean DU=false;


int sequenceIndex = 0;
int iterations=0;

float[] inc = new float[6];
float[] phase = new float[6];

int ControlFrame_w = 650;
int ControlFrame_h = 425;
int GUILocationX = 0;
int GUILocationY = 0;

int screen_x=ControlFrame_w;
int screen_y=0;
int screen_width = 600;
int screen_height = 410;

void setup() {
  size(10, 10);
  surface.setSize(screen_width, screen_height);
  surface.setLocation(screen_x, screen_y);
  frameRate(30);

  //setup GUI
  gui = new ControlFrame(this, GUILocationX, GUILocationY, ControlFrame_w, ControlFrame_h);
}

void draw() {
  background(0);

  //begin process
  if (play && buffer != null) {

    if (gui.operation.quick) {
      buffer = src.copy();
      gui.operation.sortPixels(buffer);
    } else {
      for (int i = 0; i < iterations; i++) {
        gui.operation.sortPixels(buffer);
      }
    }

    if (record) {
      if (sequencePath != null) {
        buffer.save(sequencePath+"-"+nfs(sequenceIndex, 4)+".png");
        sequenceIndex++;
      }
    }
  }
  if (buffer != null) image(buffer, 0, 0);
  if (help) image(generateHelp(), 0, 0);
}
//end process

void breakPoint() {
  println("breakpoint reached!");
  exit();
}
