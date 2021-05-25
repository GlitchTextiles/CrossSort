public class ControlFrame extends PApplet {
  int w, h, x, y;
  ControlP5 cp5;
  PApplet parent;
  SortOperations operations;

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
    surface.setSize(w, h);
    surface.setLocation(x, y);
    cp5 = new ControlP5(this);   
    operations = new SortOperations(cp5, grid(0), grid(2));
    frameRate(30);

    // row 0 controls
    cp5.addButton("open_image")
      .setPosition(grid(0), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("OPEN")
      .plugTo(parent, "open_file")
      ;
    cp5.getController("open_image").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addButton("save_image")
      .setPosition(grid(1), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("SAVE")
      .plugTo(parent, "save_file")
      ;
    cp5.getController("save_image").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addButton("reset")
      .setPosition(grid(2), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("RST")
      .plugTo(this, "reset")
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
      .plugTo(parent, "record_sequence")
      ;
    cp5.getController("record_sequence").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addToggle("help")
      .setPosition(grid(5), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("HELP")
      .plugTo(parent, "help")
      ;
    cp5.getController("help").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addBang("addOperation")
      .setPosition(grid(6), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("ADD\nOp")
      .plugTo(parent, "addOperation")
      ;
    cp5.getController("addOperation").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addBang("removeOperation")
      .setPosition(grid(7), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("REM\nOP")
      .plugTo(parent, "removeOperation")
      ;
    cp5.getController("help").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    // row 1 controls

    cp5.addSlider("iterations")
      .setPosition(grid(0), grid(1))
      .setSize(500, guiObjectSize)
      .setRange(1, 100)
      .setNumberOfTickMarks(100)
      .setLabel("Iterate")
      .plugTo(parent, "iterations")
      .setValue(1)
      ;
  }

  public void draw() {
    background(0);
  }

  void addOperation() {
    if(operations.size()<4) operations.add();
  }


  void removeOperation() {
    if(operations.size()>0) operations.remove();
  }

  void reset() {
    buffer=src.copy();
  }
}



int grid( int _pos) {
  return gridSize * _pos + gridOffset;
}
