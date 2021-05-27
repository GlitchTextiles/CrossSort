//import java.util.*;

import controlP5.*;

String inputPath;
String sequencePath;
String stillPath;

public boolean play;
public boolean record;
public boolean quick;

PImage src=null;
PImage buffer=null;
PGraphics banner;
int sequenceIndex = 0;
int iterations=0;

int ControlFrame_w = 640;
int ControlFrame_h = 800;
int GUILocationX = 0;
int GUILocationY = 0;

int screen_x = ControlFrame_w;
int screen_y = 0;
int screen_width = 600;
int screen_height = 320;

//these are used by the GUI and associated objects
int guiObjectSize = 40;
int guiObjectWidth = 600;
int guiBufferSize = 10;
int gridSize = guiObjectSize + guiBufferSize;
int gridOffset = guiBufferSize;

color backgroundColor = color(15);
color guiGroupBackground = color(30);
color guiBackground = color(60);
color guiForeground = color(120);
color guiActive=color(150);

ControlFrame GUI;

void setup() {
  size(10, 10);
  surface.setSize(screen_width, screen_height);
  surface.setLocation(screen_x, screen_y);
  frameRate(30);
  GUI = new ControlFrame(this, GUILocationX, GUILocationY, ControlFrame_w, ControlFrame_h);
  banner=generateBanner();
  background(backgroundColor);
}

void draw() {

  if (buffer != null) {
    image(buffer, 0, 0);
    if (play) { 
      GUI.operations.sort(buffer);
      if (record && sequencePath != null) {
        buffer.save(sequencePath+"-"+nfs(sequenceIndex, 4)+".png");
        sequenceIndex++;
      }
    }
  } else {
    image(banner, 0, 0);
  }
}
