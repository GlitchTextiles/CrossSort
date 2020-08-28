import controlP5.*;

//input and output image objects
PImage input, output;

//sortlogic GUI
boolean play, record, wrap, visible;

//sort logic selectors
String compareMode = new String();
String thresholdMode = new String();
int rasterDirection = 0;
String recordPath; //string that holds the save path and filename for recorded fram sequences

int iterations = 1; // how many times the sort is run before the window is updated.
long iterationCount = 0;
color min = color(0);
color max = color(0);

Toggle[][] neighborToggles = new Toggle[3][3]; //holds GUI cp5 Toggle objects for cell logic

boolean[][] rules = new boolean[3][3]; //used to enable checking current cell against specific neighbor cells

//GUI WINDOW
ControlFrame GUI;

void settings() {
  size(400, 400);
}

void setup() {
  GUI = new ControlFrame(this, 900, 325); //initializes the GUI window
  surface.setLocation(0, 0);
  play = false;
  record = false;
  wrap = false;
  visible = true;
  initRules();
}

void draw() {
  if (output != null) {
    if (visible) image(output, 0, 0);
    if (play) {
      ruleToggles();
      for (int i = 0; i < iterations; i++) {
        cellSort(output);
      }
    }
  }
}

void initRules() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      rules[i][j]=false;
    }
  }
}

void ruleToggles() {
  for (int x = 0; x < 3; x++) {
    for (int y = 0; y < 3; y++) {
      if (!(x==1 && y==1)) rules[x][y] = neighborToggles[x][y].getState();
    }
  }
}

PImage resetOutput() {
  iterationCount=0;
  return output=input.copy();
}
