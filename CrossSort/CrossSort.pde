//import java.util.*;

import controlP5.*;

ControlFrame gui;

LFO[] lfos;

String inputPath;
String sequencePath;
String stillPath;

boolean diagonal_a = false;
boolean diagonal_b = false;

boolean sort_issued = false;
boolean play = false;
boolean record = false;
boolean sort_x=false;
boolean sort_y=false;
boolean color_mode_x = false;
boolean color_mode_y = false;
boolean pre = true;
boolean realtime = false;
boolean shift_left = false;
boolean shift_right = false;
boolean quick = false;
boolean preview_mode = false;
boolean rand = false;
boolean automate = false;
boolean reverse = false;

PImage src;
PImage buffer;

int screen_width = 384;
int screen_height = 512;

color positive_threshold = color(0);
color negative_threshold = color(0);

int r_pos=0;
int g_pos=0;
int b_pos=0;

int r_neg=0;
int g_neg=0;
int b_neg=0;

int sort_mode = 0;
int sort_by = 0;

int thresh_1 = 0;
int thresh_2 = 0;
int thresh_3 = 0;

int direction_y_r = 0;
int direction_y_g = 0;
int direction_y_b = 0;

int direction_x_r = 0;
int direction_x_g = 0;
int direction_x_b = 0;

int order_y_r = 0;
int order_y_g = 0;
int order_y_b = 0;

int order_x_r = 0;
int order_x_g = 0;
int order_x_b = 0;

int start = 0;
int end = 0;
int threshold_mode = 0;

int shift_amt_x;
int shift_amt_y;

int display_mode = 2; //0 = source, 1 = buffer, 2 = preview, 3 = output;
int sequenceIndex = 0;
int iterations=0;

float[] inc = new float[6];
float[] phase = new float[6];

int ControlFrame_w = 800;
int ControlFrame_h = 400;
int GUILocationX = 0;
int GUILocationY = 10;

void setup() {
  size(10, 10);
  surface.setSize(screen_width, screen_height);
  frameRate(30);

  //setup GUI
  gui = new ControlFrame(this, GUILocationX, GUILocationY, ControlFrame_w, ControlFrame_h);
  lfos = new LFO[6];
  for (int i = 0; i < lfos.length; i++) {
    lfos[i] = new LFO(random(1));
  }
}

void draw() {


  //begin process
  if (play) {

    if (automate) {    
      for (int i = 0; i < lfos.length; ++i) {
        lfos[i].setPhase(phase[i]);
        lfos[i].setRate(inc[i]);
      }
      r_pos = int(256*(lfos[0].update()/2+0.5));
      r_neg = int(256*(lfos[1].update()/2+0.5));
      g_pos = int(256*(lfos[2].update()/2+0.5));
      g_neg = int(256*(lfos[3].update()/2+0.5));
      b_pos = int(256*(lfos[4].update()/2+0.5));
      b_neg = int(256*(lfos[5].update()/2+0.5));

      if (rand) {
        r_pos = int(random(256));
        r_neg = int(random(256));
        g_pos = int(random(256));
        g_neg = int(random(256));
        b_pos = int(random(256));
        b_neg = int(random(256));
      }
    }

    makeParameters();

    if (quick) {
      buffer = src.copy();
      sortPixels(buffer, positive_threshold, negative_threshold, sort_mode, threshold_mode);
    } else {
      for (int i = 0; i < iterations; i++) {
        sortPixels(buffer, positive_threshold, negative_threshold, sort_mode, threshold_mode);
      }
    }
    if (shift_left) {
      shift(buffer, 0);
    }
    if (shift_right) {
      shift(buffer, 1);
    }
    if (record) {
      if (sequencePath != null) {
        buffer.save(sequencePath+"-"+nfs(sequenceIndex, 4)+".png");
        sequenceIndex++;
      }
    }
  }
  if (buffer != null) image(buffer, 0, 0);
}
//end process


void makeParameters() {
  sort_mode = direction_x_r << 11 | order_x_r << 10 | direction_x_g << 9 | order_x_g << 8 | direction_x_b <<7 | order_x_b << 6 | direction_y_r << 5 | order_y_r << 4 | direction_y_g << 3 | order_y_g << 2 | direction_y_b << 1 | order_y_b;
  threshold_mode = thresh_1 << 2 | thresh_2 << 1| thresh_3 ;
  positive_threshold = 255 << 24 | r_pos << 16 | g_pos << 8 | b_pos;
  negative_threshold = 255 << 24 | r_neg << 16 | g_neg << 8 | b_neg;
}
