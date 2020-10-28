//import java.util.*;

import controlP5.*;

ControlFrame gui;

LFO[] lfos;

String inputPath;
String sequencePath;
String stillPath;

int direction = 0;

boolean play = false;
boolean record = false;

boolean color_mode_x = false;
boolean color_mode_y = false;
boolean quick = false;
boolean rand = false;
boolean automate = false;
boolean reverse = false;
boolean help = true;

PImage src;
PImage buffer;

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

int[] thresholdModes = new int[4];
int thresh_1 = 0;
int thresh_2 = 0;
int thresh_3 = 0;


/* Threshold Modes
0 - in: <= min, out: > min
1 - in: >= min, out: < min
2 - in: >= max, out: < max
3 - in: <= max, out: > max
4 - in: >= min && <= max, out: < min || > max
5 - in: <= min || >= max, if in: <= min; then out: > min, else if in >= max; then out: < max
*/

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

int mode = 0;

boolean UD=false;
boolean LR=false;
boolean DD=false;
boolean DU=false;


int sequenceIndex = 0;
int iterations=0;

float[] inc = new float[6];
float[] phase = new float[6];

int ControlFrame_w = 800;
int ControlFrame_h = 400;
int GUILocationX = 0;
int GUILocationY = 0;

int screen_x=ControlFrame_w;
int screen_y=0;
int screen_width = 384;
int screen_height = 512;

void setup() {
  size(10, 10);
  surface.setSize(screen_width, screen_height);
  surface.setLocation(screen_x,screen_y);
  frameRate(30);

  //setup GUI
  gui = new ControlFrame(this, GUILocationX, GUILocationY, ControlFrame_w, ControlFrame_h);
  lfos = new LFO[6];
  for (int i = 0; i < lfos.length; i++) {
    lfos[i] = new LFO(random(1));
  }
  
  open_file();
}

void draw() {


  //begin process
  if (play && buffer != null) {

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

    if (quick) {
      buffer = src.copy();
      sortPixels(buffer, r_pos, r_neg);
    } else {
      for (int i = 0; i < iterations; i++) {
        sortPixels(buffer,r_pos, r_neg);
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
  if (help) image(generateHelp(),0,0);
}
//end process
