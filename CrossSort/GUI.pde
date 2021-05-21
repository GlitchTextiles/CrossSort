public class ControlFrame extends PApplet {

  public int w, h, x, y;
  PApplet parent;
  ControlP5 cp5;

  public Range threshold;
  public RadioButton sort_mode_radio, threshold_mode_radio, sort_by_radio;

  public SortOperation operation;

  int guiObjectSize = 40;
  int guiBufferSize = 10;
  int gridSize = guiObjectSize + guiBufferSize;
  int gridOffset = 10;

  int grid( int _pos) {
    return gridSize * _pos + gridOffset;
  }

  ControlFrame(PApplet _parent, int _x, int _y, int _w, int _h) {
    //super();   
    parent = _parent;
    w=_w;
    h=_h;
    x=_x;
    y=_y;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
  
  void settings() {
    size(w, h);
  }

  void setup() {

    frameRate(30);
    cp5 = new ControlP5(this);

    surface.setLocation(x, y);

    // row 0 controls
    operation = new SortOperation(0, grid(1), guiObjectSize, guiBufferSize, this);

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
  }

  void open_image() {
    open_file();
  }

  void save_image() {
    save_file();
  }

  void draw() {
    background(0);
  }

  void reset() {
    buffer=src.copy();
  }

  // Key Bindings for the cp5 Window
  void keyReleased() {
    switch(key) {
    case 'o':
      open_file();
      break;
    case 's':
      save_file();
      break;
    case 'h':
      help=!help;
      break;
    }
  }
}
