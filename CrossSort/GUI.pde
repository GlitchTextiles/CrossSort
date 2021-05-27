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
    for (int i = 0; i <4; i++) {
      operations.add();
    }
    frameRate(30);

    // row 0 controls
    cp5.addButton("open_image")
      .setPosition(grid(0), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setLabel("OPEN")
      .plugTo(parent, "open_file")
      ;
    cp5.getController("open_image").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addButton("save_image")
      .setPosition(grid(1), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setLabel("SAVE")
      .plugTo(parent, "save_file")
      ;
    cp5.getController("save_image").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addButton("reset")
      .setPosition(grid(2), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setLabel("RESET")
      .plugTo(this, "reset")
      ;
    cp5.getController("reset").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addToggle("play")
      .setPosition(grid(3), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setLabel("PLAY")
      .plugTo(parent, "play")
      ;
    cp5.getController("play").getCaptionLabel().align(ControlP5.CENTER, CENTER);


    cp5.addToggle("record_sequence")
      .setPosition(grid(4), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setLabel("REC")
      .plugTo(parent, "record_sequence")
      ;
    cp5.getController("record_sequence").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addToggle("quick_sort")
      .setPosition(grid(5), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setLabel("QUICK")
      .plugTo(parent, "quick_sort")
      ;
    cp5.getController("quick_sort").getCaptionLabel().align(ControlP5.CENTER, CENTER);


    // row 1 controls

    cp5.addSlider("iterations")
      .setPosition(grid(0), grid(1))
      .setSize(grid(6)-2*guiBufferSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setRange(1, 100)
      .setDecimalPrecision(1)
      .setLabel("iterations")
      .plugTo(parent, "iterations")
      .setValue(1)
      ;
    cp5.getController("iterations").getCaptionLabel().align(ControlP5.CENTER, CENTER);
  }

  public void draw() {
    background(backgroundColor);
  }

  public void reset() {
    buffer=src.copy();
  }

  public void quick_sort(int _value) {
    quick = boolean(_value);
    for (SortOperation o : operations.sortOperations) {
      o.setQuick(quick);
    }
  }
}


public int grid( int _pos) {
  return gridSize * _pos + gridOffset;
}
