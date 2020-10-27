
public class ControlFrame extends PApplet {

  controlP5.Label label;
  int w, h, x, y;
  PApplet parent;
  ControlP5 cp5;
  boolean shift = false;
  float value = 0.0;

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

    cp5.addBang("open")
      .setPosition(5, 5)
      .setSize(20, 20)
      .setLabel("O")
      .plugTo(parent,"open_file");
      ;

    cp5.addBang("save")
      .setPosition(30, 5)
      .setSize(20, 20)
      .setLabel("S")
      .plugTo(parent,"save_file");
      ;

    cp5.addButton("reset")
      .setPosition(55, 5)
      .setSize(20, 20)
      .setLabel("RST")
      ;

    cp5.addToggle("play")
      .setPosition(80, 5)
      .setSize(20, 20)
      .setLabel("P")
      .plugTo(parent, "play")
    ;


    cp5.addToggle("record_sequence")
      .setPosition(105, 5)
      .setSize(20, 20)
      .setLabel("R")
    ;

    cp5.addToggle("quick")
      .setPosition(130, 5)
      .setSize(20, 20)
      .setLabel("Q")
      .plugTo(parent, "quick")
    ;

    cp5.addButton("resetLFO")
      .setPosition(155, 5)
      .setSize(20, 20)
      .setLabel("RST")
      ;



    cp5.addToggle("rand")
      .setPosition(5, 45)
      .setSize(20, 20)
      .setLabel("RAND")
      .plugTo(parent, "rand")
      .setValue(false);
    ;

    cp5.addToggle("automate")
      .setPosition(30, 45)
      .setSize(20, 20)
      .setLabel("AUTO")
      .plugTo(parent, "automate")
      .setValue(false);
    ;

    cp5.addRadioButton("sort_by")
      .setPosition(55, 45)
      .setSize(20, 20)
      .setItemsPerRow(4)
      .setSpacingColumn(25)
      .addItem("val", 0)
      .addItem("h", 1)
      .addItem("s", 2)
      .addItem("b", 3)
      .activate(0)
      ;

    cp5.addToggle("sort_x")
      .setPosition(625, 45)
      .setSize(20, 20)
      .setLabel("X")
      .plugTo(parent, "sort_x")
      .setValue(false);
    ;

    cp5.addToggle("sort_y")
      .setPosition(675, 45)
      .setSize(20, 20)
      .setLabel("Y")
      .plugTo(parent, "sort_y")
      .setValue(false)
      ;

    cp5.addToggle("sort_diagonal_a")
      .setPosition(625, 5)
      .setSize(20, 20)
      .setLabel("A")
      .plugTo(parent, "diagonal_a")
      .setValue(false);
    ;

    cp5.addToggle("sort_diagonal_b")
      .setPosition(675, 5)
      .setSize(20, 20)
      .setLabel("B")
      .plugTo(parent, "diagonal_b")
      .setValue(false)
      ;


    cp5.addToggle("color_mode_x")
      .setPosition(650, 45)
      .setSize(20, 20)
      .setLabel("modeX")
      .plugTo(parent, "color_mode_x")
      ;

    cp5.addToggle("color_mode_y")
      .setPosition(700, 45)
      .setSize(20, 20)
      .setLabel("modeY")
      .plugTo(parent, "color_mode_y")
      ;

    cp5.addToggle("direction_x_r")
      .setPosition(625, 80)
      .setSize(20, 20)
      .setLabel("F/B")
      .plugTo(parent, "direction_x_r")
      ;
    cp5.addToggle("direction_x_g")
      .setPosition(625, 105)
      .setSize(20, 20)
      .setLabel("F/B")
      .plugTo(parent, "direction_x_g")
      ;
    cp5.addToggle("direction_x_b")
      .setPosition(625, 130)
      .setSize(20, 20)
      .setLabel("F/B")
      .plugTo(parent, "direction_x_b")
      ;

    cp5.addToggle("order_x_r")
      .setPosition(650, 80)
      .setSize(20, 20)
      .setLabel("</>")
      .plugTo(parent, "order_x_r")
      ;

    cp5.addToggle("order_x_g")
      .setPosition(650, 105)
      .setSize(20, 20)
      .setLabel("</>")
      .plugTo(parent, "order_x_g")
      ;

    cp5.addToggle("order_x_b")
      .setPosition(650, 130)
      .setSize(20, 20)
      .setLabel("</>")
      .plugTo(parent, "order_x_b")
      ;

    cp5.addToggle("direction_y_r")
      .setPosition(675, 80)
      .setSize(20, 20)
      .setLabel("F/B")
      .plugTo(parent, "direction_y_r")
      ;
    cp5.addToggle("direction_y_g")
      .setPosition(675, 105)
      .setSize(20, 20)
      .setLabel("F/B")
      .plugTo(parent, "direction_y_g")
      ;
    cp5.addToggle("direction_y_b")
      .setPosition(675, 130)
      .setSize(20, 20)
      .setLabel("F/B")
      .plugTo(parent, "direction_y_b")
      ;

    cp5.addToggle("order_y_r")
      .setPosition(700, 80)
      .setSize(20, 20)
      .setLabel("</>")
      .plugTo(parent, "order_y_r")
      ;

    cp5.addToggle("order_y_g")
      .setPosition(700, 105)
      .setSize(20, 20)
      .setLabel("</>")
      .plugTo(parent, "order_y_g")
      ;

    cp5.addToggle("order_y_b")
      .setPosition(700, 130)
      .setSize(20, 20)
      .setLabel("</>")
      .plugTo(parent, "order_y_b")
      ;

    cp5.addToggle("thresh_mode_1")
      .setPosition(600, 80)
      .setSize(20, 20)
      .setLabel("Tr")
      .plugTo(parent, "thresh_1")
      ;

    cp5.addToggle("thresh_mode_2")
      .setPosition(600, 105)
      .setSize(20, 20)
      .setLabel("Tg")
      .plugTo(parent, "thresh_2")
      ;

    cp5.addToggle("thresh_mode_3")
      .setPosition(600, 130)
      .setSize(20, 20)
      .setLabel("Tb")
      .plugTo(parent, "thresh_3")
      ;

    cp5.addSlider("shift_amt_x")
      .setPosition(5, 155)
      .setSize(255, 20)
      .setRange(-10, 10)
      .setNumberOfTickMarks(21)
      .setLabel("shift x")
      .plugTo(parent, "shift_amt_x")
      ;
    cp5.addSlider("shift_amt_y")
      .setPosition(5, 180)
      .setSize(255, 20)
      .setRange(-10, 10)
      .setNumberOfTickMarks(21)
      .setLabel("shift y")
      .plugTo(parent, "shift_amt_y")
      ;

    cp5.addToggle("shift_left")
      .setPosition(325, 155)
      .setSize(20, 20)
      .setLabel("Y/N")
      .plugTo(parent, "shift_left")
      ;

    cp5.addToggle("shift_right")
      .setPosition(325, 180)
      .setSize(20, 20)
      .setLabel("Y/N")
      .plugTo(parent, "shift_right")
      ;

    //RGB values for threshold_positive
    cp5.addSlider("r_pos")
      .setPosition(5, 80)
      .setSize(255, 20)
      .setRange(0, 255)
      .setLabel("r thd +")
      .plugTo(parent, "r_pos")
      ;

    cp5.addSlider("g_pos")
      .setPosition(5, 105)
      .setSize(255, 20)
      .setRange(0, 255)
      .setLabel("g thd +")
      .plugTo(parent, "g_pos")
      ;
    cp5.addSlider("b_pos")
      .setPosition(5, 130)
      .setSize(255, 20)
      .setRange(0, 255)
      .setLabel("b thd +")
      .plugTo(parent, "b_pos")
      ;

    //RGB values for threshold_negativee
    cp5.addSlider("r_neg")
      .setPosition(300, 80)
      .setSize(255, 20)
      .setRange(0, 255)
      .setLabel("r thd -")
      .plugTo(parent, "r_neg")
      ;
    cp5.addSlider("g_neg")
      .setPosition(300, 105)
      .setSize(255, 20)
      .setRange(0, 255)
      .setLabel("g thd -")
      .plugTo(parent, "g_neg")
      ;
    cp5.addSlider("b_neg")
      .setPosition(300, 130)
      .setSize(255, 20)
      .setRange(0, 255)
      .setLabel("b thd -")
      .plugTo(parent, "b_neg")
      ;

    // automation increments                  
    cp5.addSlider("r_pos_inc")
      .setPosition(5, 250)
      .setSize(200, 20)
      .setRange(-0.01, 0.01)
      .setLabel("r_pos_inc")
      ;

    cp5.addSlider("r_neg_inc")
      .setPosition(305, 250)
      .setSize(200, 20)
      .setRange(-0.01, 0.01)
      .setLabel("r_neg_inc")
      ;

    cp5.addSlider("g_pos_inc")
      .setPosition(5, 275)
      .setSize(200, 20)
      .setRange(-0.01, 0.01)
      .setLabel("g_pos_inc")
      ;

    cp5.addSlider("g_neg_inc")
      .setPosition(305, 275)
      .setSize(200, 20)
      .setRange(-0.01, 0.01)
      .setLabel("g_neg_inc")
      ;

    cp5.addSlider("b_pos_inc")
      .setPosition(5, 300)
      .setSize(200, 20)
      .setRange(-0.01, 0.01)
      .setLabel("b_pos_inc")
      ;

    cp5.addSlider("b_neg_inc")
      .setPosition(305, 300)
      .setSize(200, 20)
      .setRange(-0.01, 0.01)
      .setLabel("b_neg_inc")
      ;

    // phase adjustments

    cp5.addSlider("r_pos_phase")
      .setPosition(5, 325)
      .setSize(200, 20)
      .setRange(0, 1)
      .setLabel("r_pos_phase")
      ;

    cp5.addSlider("r_neg_phase")
      .setPosition(305, 325)
      .setSize(200, 20)
      .setRange(0, 1)
      .setLabel("r_neg_phase")
      ;

    cp5.addSlider("g_pos_phase")
      .setPosition(5, 350)
      .setSize(200, 20)
      .setRange(0, 1)
      .setLabel("g_pos_phase")
      ;

    cp5.addSlider("g_neg_phase")
      .setPosition(305, 350)
      .setSize(200, 20)
      .setRange(0, 1)
      .setLabel("g_neg_phase")
      ;

    cp5.addSlider("b_pos_phase")
      .setPosition(5, 375)
      .setSize(200, 20)
      .setRange(0, 1)
      .setLabel("b_pos_phase")
      ;

    cp5.addSlider("b_neg_phase")
      .setPosition(305, 375)
      .setSize(200, 20)
      .setRange(0, 1)
      .setLabel("b_neg_phase")
      ;    

    //iterations

    cp5.addSlider("iterations")
      .setPosition(5, 205)
      .setSize(200, 20)
      .setRange(0, 50)
      .setNumberOfTickMarks(51)
      .setLabel("Iterate")
      .plugTo(parent, "iterations")
      .setValue(1)
      ;
  }

  public void resetLFO() {
    for (int i = 0; i < lfos.length; i++) {
      lfos[i].reset();
    }
  }

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

  public void draw() {
    background(50);
  }

  public void reset() {
    buffer=src.copy();
  }
}
