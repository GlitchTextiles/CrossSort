public class ControlFrame extends PApplet {

  int w, h;
  PApplet parent;
  ControlP5 cp5;

  int playbackControlsX = 200;
  int playbackControlsY = 50;
  int toggleW = 30;
  int toggleH = 30;
  int toggleSpacing = 20;

  int buttonW = 30;
  int buttonH = 30;
  int buttonSpacing = 20;

  int neighborToggleX=10;
  int neighborToggleY=10;
  int neighborToggleSpacing = 20;
  int neighborToggleW=30;
  int neighborToggleH=30;

  int radiosX = 10;
  int radiosY = 180;
  int radiosW = 30;
  int radiosH = 30;
  int radiosSpacing=20;

  int thresholdSlidersX = 200;
  int thresholdSlidersY = 10;
  int thresholdSlidersW = 255;
  int thresholdSlidersH = 30;
  int thresholdSlidersSpacingX = 30;
  int thresholdSlidersSpacingY = 20;

  Toggle[][] neighborToggles = new Toggle[3][3]; //holds GUI cp5 Toggle objects for cell logic
  Range threshold;
  RadioButton raster_direction;
  RadioButton compare_mode;
  RadioButton threshold_mode;

  public ControlFrame(PApplet _parent, int _w, int _h) {
    super();   
    parent = _parent;
    w = _w;
    h = _h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(w, h);
    noSmooth();
  }

  public void setup() {
    surface.setLocation(0, 400);
    cp5 = new ControlP5(this);

    //toggles to enable/disable checking of specific neighbor cells.
    for (int x = 0; x < 3; x++) {
      for (int y = 0; y < 3; y++) {
        int id = y * 3 + x;
        if (id !=4) {
          neighborToggles[x][y] = cp5.addToggle("neighborToggle_"+x+"_"+y)
            .setLabel(nf(id+1))
            .setPosition(neighborToggleX + ((neighborToggleSpacing+neighborToggleW)*x), neighborToggleY + ((neighborToggleSpacing+neighborToggleH)*y))
            .setSize(neighborToggleW, neighborToggleH);
          ;
        }
      }
    }

    raster_direction = cp5.addRadioButton("raster_direction")
      .setSize(radiosW, radiosH)
      .setPosition(radiosX, radiosY+0*(radiosH+radiosSpacing))
      .setItemsPerRow(14)
      .setSpacingColumn(30)
      .addItem("TBLR", 0)
      .addItem("TBRL", 1)
      .addItem("BTLR", 2)
      .addItem("BTRL", 3)
      .addItem("LRTB", 4)
      .addItem("RLTB", 5)
      .addItem("LRBT", 6)
      .addItem("RLBT", 7)
      ;

    //radio controls for the compare and threshold logic 
    compare_mode = cp5.addRadioButton("compare_mode")
      .setSize(radiosW, radiosH)
      .setPosition(radiosX, radiosY+1*(radiosH+radiosSpacing))
      .setItemsPerRow(14)
      .setSpacingColumn(30)
      .addItem("RGB<", 0)
      .addItem("RGB>", 1)
      .addItem("HUE<", 2)
      .addItem("HUE>", 3)
      .addItem("SAT<", 4)
      .addItem("SAT>", 5)
      .addItem("VAL<", 6)
      .addItem("VAL>", 7)
      .addItem("RED<", 8)
      .addItem("RED>", 9)
      .addItem("GRN<", 10)
      .addItem("GRN>", 11)
      .addItem("BLU<", 12)
      .addItem("BLU>", 13)
      ;

    threshold_mode = cp5.addRadioButton("threshold_mode").setSize(radiosW, radiosH)
      .setPosition(radiosX, radiosY+2*(radiosH+radiosSpacing))
      .setItemsPerRow(14)
      .setSpacingColumn(30)
      .addItem("RGB", 0)
      .addItem("!RGB", 1)
      .addItem("HUE", 2)
      .addItem("!HUE", 3)
      .addItem("SAT", 4)
      .addItem("!SAT", 5)
      .addItem("VAL", 6)
      .addItem("!VAL", 7)
      .addItem("RED", 8)
      .addItem("!RED", 9)
      .addItem("GRN", 10)
      .addItem("!GRN", 11)
      .addItem("BLU", 12)
      .addItem("!BLU", 13)
      ;

    //togles and buttons for the penultimate row
    cp5.addToggle("playToggle")
      .setLabel("PLAY")
      .setSize(toggleW, toggleH)
      .setPosition(playbackControlsX+(toggleSpacing+toggleW)*0, playbackControlsY+(buttonSpacing+buttonH)*0)
      .setValue(play)
      ;
    cp5.addToggle("recordToggle")
      .setLabel("REC")
      .setSize(toggleW, toggleH)
      .setPosition(playbackControlsX+(toggleSpacing+toggleW)*1, playbackControlsY+(buttonSpacing+buttonH)*0)
      .setValue(record)
      ;
    cp5.addButton("openButton")
      .setLabel("OPEN")
      .setSize(buttonW, buttonH)
      .setPosition(playbackControlsX+(buttonSpacing+buttonW)*2, playbackControlsY+(buttonSpacing+buttonH)*0)
      ;
    cp5.addButton("saveButton")
      .setLabel("SAVE")
      .setSize(buttonW, buttonH)
      .setPosition(playbackControlsX+(buttonSpacing+buttonW)*3, playbackControlsY+(buttonSpacing+buttonH)*0)
      ;

    //togles and buttons for the bottom row
    cp5.addToggle("wrapToggle")
      .setLabel("WRAP")
      .setSize(toggleW, toggleH)
      .setPosition(playbackControlsX+(toggleSpacing+toggleW)*0, playbackControlsY+(toggleSpacing+toggleH)*1)
      .setValue(wrap)
      ;
    cp5.addButton("resetButton")
      .setLabel("RESET")
      .setSize(buttonW, buttonH)
      .setPosition(playbackControlsX+(buttonSpacing+buttonW)*1, playbackControlsY+(buttonSpacing+buttonH)*1)
      ;
    cp5.addToggle("visibleToggle")
      .setLabel("VIEW")
      .setSize(buttonW, buttonH)
      .setPosition(playbackControlsX+(buttonSpacing+buttonW)*2, playbackControlsY+(buttonSpacing+buttonH)*1)
      .setValue(visible)
      ;

    //Sliders for the threshold Min + Max

    threshold = cp5.addRange("threshold")
      .setBroadcast(false) 
      .setPosition(thresholdSlidersX+(thresholdSlidersW+thresholdSlidersSpacingX)*0, thresholdSlidersY+(thresholdSlidersH+thresholdSlidersSpacingY)*0)
      .setSize(2*thresholdSlidersW+thresholdSlidersSpacingX, thresholdSlidersH)  
      .setHandleSize(thresholdSlidersH)
      .setRange(0, 255)
      .setRangeValues(50, 100)
      .setBroadcast(true)
      ;

    cp5.addSlider("iterationSlider")
      .setLabel("Iterations")
      .setPosition(thresholdSlidersX+(thresholdSlidersW+thresholdSlidersSpacingX)*1, thresholdSlidersY+(thresholdSlidersH+thresholdSlidersSpacingY)*1)
      .setSize(thresholdSlidersW, thresholdSlidersH)
      .setMin(1)
      .setMax(128)
      .setNumberOfTickMarks(128)
      .snapToTickMarks(true)
      .showTickMarks(false)
      ;

    compare_mode.setValue(0).activate(0);
    threshold_mode.setValue(0).activate(0);
    raster_direction.setValue(0).activate(0);
  }

  void draw() {
    background(0);
    min = color(threshold.getArrayValue(0));
    max = color(threshold.getArrayValue(1));
    iterations = int (cp5.getValue("iterationSlider"));
    textAlign(LEFT, BOTTOM);
    text("Iterations: "+nf(iterationCount), 800, 30);
    updateRules();
  }

  public void updateRules() {
    for (int x = 0; x < 3; x++) {
      for (int y = 0; y < 3; y++) {
        if (!(x==1 && y==1)) rules[x][y] = this.neighborToggles[x][y].getState();
      }
    }
  }
  
  public void clearRules() {
    for (int x = 0; x < 3; x++) {
      for (int y = 0; y < 3; y++) {
        if (!(x==1 && y==1)) this.neighborToggles[x][y].setValue(0);
      }
    }
  }
  //GUI callbacks

  public void playToggle(boolean _val) {
    play = _val;
  }

  public void recordToggle(boolean _val) {
    record = _val;
  }

  public void openButton() {
    openImage();
  }

  public void saveButton() {
    saveImage();
  }

  public void wrapToggle(boolean _val) {
    wrap = _val;
  }

  public void resetButton() {
    resetOutput();
  }

  public void visibleToggle(boolean _val) {
    visible = _val;
  }

  public void raster_direction(int _direction) {
    rasterDirection=_direction;
  }

  public void compare_mode(int _mode) {
    switch(int(_mode)) {
    case 0:
      compareMode = "RGB<";
      break;
    case 1:
      compareMode = "RGB>";
      break;
    case 2:
      compareMode = "HUE<";
      break;
    case 3:
      compareMode = "HUE>";
      break;
    case 4:
      compareMode = "SAT<";
      break;
    case 5:
      compareMode = "SAT>";
      break;
    case 6:
      compareMode = "VAL<";
      break;
    case 7:
      compareMode = "VAL>";
      break;
    case 8:
      compareMode = "RED<";
      break;
    case 9:
      compareMode = "RED>";
      break;
    case 10:
      compareMode = "GRN<";
      break;
    case 11:
      compareMode = "GRN>";
      break;
    case 12:
      compareMode = "BLU<";
      break;
    case 13:
      compareMode = "BLU>";
      break;
    }
  }

  public void threshold_mode(int _mode) {
    switch(int(_mode)) {
    case 0:
      thresholdMode = "<RGB>";
      break;
    case 1:
      thresholdMode = ">RGB<";
      break;
    case 2:
      thresholdMode = "<HUE>";
      break;
    case 3:
      thresholdMode = ">HUE<";
      break;
    case 4:
      thresholdMode = "<SAT>";
      break;
    case 5:
      thresholdMode = ">SAT<";
      break;
    case 6:
      thresholdMode = "<VAL>";
      break;
    case 7:
      thresholdMode = ">VAL<";
      break;
    case 8:
      thresholdMode = "<RED>";
      break;
    case 9:
      thresholdMode = ">RED<";
      break;
    case 10:
      thresholdMode = "<GRN>";
      break;
    case 11:
      thresholdMode = ">GRN<";
      break;
    case 12:
      thresholdMode = "<BLU>";
      break;
    case 13:
      thresholdMode = ">BLU<";
      break;
    }
  }

  void keyPressed() {
    switch(key) {
    case '-':
      threshold_mode.activate((int(threshold_mode.getValue())-1+threshold_mode.getArrayValue().length)%threshold_mode.getArrayValue().length);
      break;
    case '=':
      threshold_mode.activate((int(threshold_mode.getValue())+1)%threshold_mode.getArrayValue().length);
      break;
    case ',':
      compare_mode.activate((int(compare_mode.getValue())-1+compare_mode.getArrayValue().length)%compare_mode.getArrayValue().length);
      break;
    case '.':
      compare_mode.activate((int(compare_mode.getValue())+1)%compare_mode.getArrayValue().length);
      break;
    case '[':
      raster_direction.activate((int(raster_direction.getValue())-1+raster_direction.getArrayValue().length)%raster_direction.getArrayValue().length);
      break;
    case ']':
      raster_direction.activate((int(raster_direction.getValue())+1)%raster_direction.getArrayValue().length);
      break;


    case '1':
      neighborToggles[0][0].setValue(!neighborToggles[0][0].getState());
      break;
    case '2':
      neighborToggles[1][0].setValue(!neighborToggles[1][0].getState());
      break;
    case '3':
      neighborToggles[2][0].setValue(!neighborToggles[2][0].getState());
      break;
    case '4':
      neighborToggles[0][1].setValue(!neighborToggles[0][1].getState());
      break;
    case '6':
      neighborToggles[2][1].setValue(!neighborToggles[2][1].getState());
      break;
    case '7':
      neighborToggles[0][2].setValue(!neighborToggles[0][2].getState());
      break;
    case '8':
      neighborToggles[1][2].setValue(!neighborToggles[1][2].getState());
      break;
    case '9':
      neighborToggles[2][2].setValue(!neighborToggles[2][2].getState());
      break;

    case 'o':
      openImage();
      break;
    case 's':
      saveImage();
      break;
    case 'p': // play toggles animation
      if (play) {
        cp5.getController("playToggle").setValue(0);
      } else {
        cp5.getController("playToggle").setValue(1);
      }  
      break;
    case 'q':
      clearRules(); 
      break;
    case 'w': // w toggles edge wrap mode
      if (wrap) {
        cp5.getController("wrapToggle").setValue(0);
      } else {
        cp5.getController("wrapToggle").setValue(1);
      }  
      break;
    case 'e':
      resetButton();
      break;
    case 'r': //
      if (record) {
        cp5.getController("recordToggle").setValue(0);
      } else {
        cp5.getController("recordToggle").setValue(1);
      } 
      break;
    case 'v': // 
      if (visible) {
        cp5.getController("visibleToggle").setValue(0);
      } else {
        cp5.getController("visibleToggle").setValue(1);
      } 
      break;
    }
  }
}
