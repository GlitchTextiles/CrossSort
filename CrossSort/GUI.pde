
public class ControlFrame extends PApplet {

  int w, h, x, y;
  PApplet parent;
  ControlP5 cp5;
  boolean shift = false;
  float value = 0.0;

  Range threshold;
  RadioButton sort_mode_radio, threshold_mode_radio, sort_by_radio;

  int guiObjectSize = 30;
  int guiBufferSize = 5;
  int gridSize = guiObjectSize + guiBufferSize;
  int gridOffset = 10;

  int grid( int _pos) {
    return gridSize * _pos + gridOffset;
  }

  public ControlFrame(PApplet _parent, int _x, int _y, int _w, int _h) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    x=_x;
    y=_y;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
  public void settings() {
    size(w, h);
  }

  public void setup() {

    frameRate(30);
    cp5 = new ControlP5(this);

    surface.setLocation(x, y);

    // row 0 controls

    cp5.addButton("open_image")
      .setPosition(grid(0), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("OPEN")
      ;
    cp5.getController("open_image").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addButton("save_image")
      .setPosition(grid(1), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("SAVE")
      ;
    cp5.getController("save_image").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addButton("reset")
      .setPosition(grid(2), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("RST")
      ;
    cp5.getController("reset").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addToggle("play")
      .setPosition(grid(3), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("PLAY")
      .plugTo(parent, "play")
      ;
    cp5.getController("play").getCaptionLabel().align(ControlP5.CENTER, CENTER);


    cp5.addToggle("record_sequence")
      .setPosition(grid(4), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("REC")
      ;
    cp5.getController("record_sequence").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addToggle("help")
      .setPosition(grid(5), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("HELP")
      .plugTo(parent, "help")
      ;
    cp5.getController("help").getCaptionLabel().align(ControlP5.CENTER, CENTER);


    // row 1 controls

    cp5.addToggle("quick")
      .setPosition(grid(0), grid(1))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("QK\nSRT")
      .plugTo(parent, "quick")
      ;
    cp5.getController("quick").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addToggle("rand")
      .setPosition(grid(1), grid(1))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("RAND")
      .plugTo(parent, "rand")
      .setValue(false);
    ;
    cp5.getController("rand").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addToggle("automate")
      .setPosition(grid(2), grid(1))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("AUTO")
      .plugTo(parent, "automate")
      .setValue(false);
    ;
    cp5.getController("automate").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addButton("resetLFO")
      .setPosition(grid(3), grid(1))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("RST\nLFO")
      ;
    cp5.getController("resetLFO").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    // row 2 controls

    sort_by_radio = cp5.addRadioButton("sort_by")
      .setPosition(grid(0), grid(2))
      .setSize(guiObjectSize, guiObjectSize)
      .setItemsPerRow(4)
      .setSpacingColumn(guiBufferSize)
      .addItem("rgb", 0)
      .addItem("hue", 1)
      .addItem("sat", 2)
      .addItem("brt", 3)
      .activate(0)
      ;

    for (Toggle t : sort_by_radio.getItems()) {
      t.getCaptionLabel().align(ControlP5.CENTER, CENTER);
    }

    // row 3 controls

    sort_mode_radio = cp5.addRadioButton("sort_mode")
      .setPosition(grid(0), grid(3))
      .setSize(guiObjectSize, guiObjectSize)
      .setItemsPerRow(4)
      .setSpacingColumn(guiBufferSize)
      .addItem("FW>", 0)
      .addItem("FW<", 1)
      .addItem("RV>", 2)
      .addItem("RV<", 3)
      .activate(0)
      ;
      
    for (Toggle t : sort_mode_radio.getItems()) {
      t.getCaptionLabel().align(ControlP5.CENTER, CENTER);
    }
    // row 4 controls

    threshold_mode_radio = cp5.addRadioButton("threshold_mode")
      .setPosition(grid(0), grid(4))
      .setSize(guiObjectSize, guiObjectSize)
      .setItemsPerRow(6)
      .setSpacingColumn(guiBufferSize)
      .addItem(">mn", 0)
      .addItem("<mn", 1)
      .addItem(">mx", 2)
      .addItem("<mx", 3)
      .addItem("><", 4)
      .addItem("<>", 5)
      .activate(0)
      ;

    for (Toggle t : threshold_mode_radio.getItems()) {
      t.getCaptionLabel().align(ControlP5.CENTER, CENTER);
    }

    // row 5 controls

    cp5.addToggle("LR")
      .setPosition(grid(0), grid(5))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("LR")
      .plugTo(parent, "LR")
      .setValue(false);
    ;
    cp5.getController("LR").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addToggle("UD")
      .setPosition(grid(1), grid(5))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("UD")
      .plugTo(parent, "UD")
      .setValue(false)
      ;
    cp5.getController("UD").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addToggle("DU")
      .setPosition(grid(2), grid(5))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("DU")
      .plugTo(parent, "DU")
      .setValue(false);
    ;
    cp5.getController("DU").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addToggle("DD")
      .setPosition(grid(3), grid(5))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("DD")
      .plugTo(parent, "DD")
      .setValue(true)
      ;
    cp5.getController("DD").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    // row 6 controls

    threshold = cp5.addRange("threshold")
      .setLabel("threshold")
      .setPosition(grid(0), grid(6))
      .setSize(500, guiObjectSize)
      .setHandleSize(guiBufferSize)
      .setRange(0, 255)
      .setRangeValues(50, 205)
      ;
    cp5.getController("threshold").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    // row 7 controls

    cp5.addSlider("iterations")
      .setPosition(grid(0), grid(7))
      .setSize(500, guiObjectSize)
      .setRange(1, 100)
      .setNumberOfTickMarks(100)
      .setLabel("Iterate")
      .plugTo(parent, "iterations")
      .setValue(1)
      ;
    // automation will be incorporated in the SortOperation (tentative name) class 
    // automation increments                  
    //cp5.addSlider("r_pos_inc")
    //  .setPosition(5, 250)
    //  .setSize(200, 20)
    //  .setRange(-0.01, 0.01)
    //  .setLabel("r_pos_inc")
    //  ;

    //cp5.addSlider("r_neg_inc")
    //  .setPosition(305, 250)
    //  .setSize(200, 20)
    //  .setRange(-0.01, 0.01)
    //  .setLabel("r_neg_inc")
    //  ;

    //cp5.addSlider("g_pos_inc")
    //  .setPosition(5, 275)
    //  .setSize(200, 20)
    //  .setRange(-0.01, 0.01)
    //  .setLabel("g_pos_inc")
    //  ;

    //cp5.addSlider("g_neg_inc")
    //  .setPosition(305, 275)
    //  .setSize(200, 20)
    //  .setRange(-0.01, 0.01)
    //  .setLabel("g_neg_inc")
    //  ;

    //cp5.addSlider("b_pos_inc")
    //  .setPosition(5, 300)
    //  .setSize(200, 20)
    //  .setRange(-0.01, 0.01)
    //  .setLabel("b_pos_inc")
    //  ;

    //cp5.addSlider("b_neg_inc")
    //  .setPosition(305, 300)
    //  .setSize(200, 20)
    //  .setRange(-0.01, 0.01)
    //  .setLabel("b_neg_inc")
    //  ;

    //// phase adjustments

    //cp5.addSlider("r_pos_phase")
    //  .setPosition(5, 325)
    //  .setSize(200, 20)
    //  .setRange(0, 1)
    //  .setLabel("r_pos_phase")
    //  ;

    //cp5.addSlider("r_neg_phase")
    //  .setPosition(305, 325)
    //  .setSize(200, 20)
    //  .setRange(0, 1)
    //  .setLabel("r_neg_phase")
    //  ;

    //cp5.addSlider("g_pos_phase")
    //  .setPosition(5, 350)
    //  .setSize(200, 20)
    //  .setRange(0, 1)
    //  .setLabel("g_pos_phase")
    //  ;

    //cp5.addSlider("g_neg_phase")
    //  .setPosition(305, 350)
    //  .setSize(200, 20)
    //  .setRange(0, 1)
    //  .setLabel("g_neg_phase")
    //  ;

    //cp5.addSlider("b_pos_phase")
    //  .setPosition(5, 375)
    //  .setSize(200, 20)
    //  .setRange(0, 1)
    //  .setLabel("b_pos_phase")
    //  ;

    //cp5.addSlider("b_neg_phase")
    //  .setPosition(305, 375)
    //  .setSize(200, 20)
    //  .setRange(0, 1)
    //  .setLabel("b_neg_phase")
    //  ;
  }


  public void open_image() {
    open_file();
  }

  public void save_image() {
    save_file();
  }

  //public void resetLFO() {
  //  for (int i = 0; i < lfos.length; i++) {
  //    lfos[i].reset();
  //  }
  //}

  public void r_pos_inc(float _value) {
    inc[0] = _value;
  }

  public void r_neg_inc(float _value) {
    inc[1] = _value;
  }

  public void g_pos_inc(float _value) {
    inc[2] = _value;
  }

  public void g_neg_inc(float _value) {
    inc[3] = _value;
  }

  public void b_pos_inc(float _value) {
    inc[4] = _value;
  }

  public void b_neg_inc(float _value) {
    inc[5] = _value;
  }

  public void r_pos_phase(float _value) {
    phase[0] = _value;
  }

  public void r_neg_phase(float _value) {
    phase[1] = _value;
  }

  public void g_pos_phase(float _value) {
    phase[2] = _value;
  }

  public void g_neg_phase(float _value) {
    phase[3] = _value;
  }

  public void b_pos_phase(float _value) {
    phase[4] = _value;
  }

  public void b_neg_phase(float _value) {
    phase[5] = _value;
  }

  public void sort_by(int id) {
    sort_by = id;
    println(sort_by);
  }

  public void sort_mode(int id) {
    sort_mode = id;
  }

  public void threshold_mode(int id) {
    threshold_mode = id;
  }


  public void controlEvent(ControlEvent theControlEvent) {
    if (theControlEvent.isFrom("threshold")) {
      min = int(theControlEvent.getController().getArrayValue(0));
      max = int(theControlEvent.getController().getArrayValue(1));
    }
  }


  public void draw() {
    background(50);
  }

  public void reset() {
    buffer=src.copy();
  }
}
