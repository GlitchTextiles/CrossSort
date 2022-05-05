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
      .plugTo(this, "quick_sort")
      ;
    cp5.getController("quick_sort").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addButton("batch_dir")
      .setPosition(grid(6), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setLabel("BATCH\nDIR")
      .plugTo(parent, "open_batch_folder");
    ;
    cp5.getController("batch_dir").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addToggle("batch_toggle")
      .setPosition(grid(7), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setLabel("BATCH\nSTART")
      .setValue(0)
      .plugTo(this, "toggleBatch")
      ;
    cp5.getController("batch_toggle").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addButton("load_automation")
      .setPosition(grid(8), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setLabel("LOAD\nAUTO")
      .plugTo(parent, "open_JSON")
      ;
    cp5.getController("load_automation").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addToggle("enable_automation")
      .setPosition(grid(9), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setLabel("EN\nAUTO")
      .plugTo(this, "enableAutomation")
      .hide()
      ;
    cp5.getController("enable_automation").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addToggle("enable_jitter")
      .setPosition(grid(10), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setLabel("JITTER")
      .plugTo(this, "enableJitter")
      ;
    cp5.getController("enable_jitter").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addButton("frame_decrement")
      .setPosition(grid(6), grid(1))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setLabel("FRAME\n-")
      .plugTo(this, "frameDecrement");
    ;
    cp5.getController("frame_decrement").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addButton("frame_increment")
      .setPosition(grid(7), grid(1))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setLabel("FRAME\n+")
      .plugTo(this, "frameIncrement");
    ;
    cp5.getController("frame_increment").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    cp5.addNumberbox("frame_index")
      .setPosition(grid(8), grid(1))
      .setSize(2*guiObjectSize+guiBufferSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setLabel("FRAME")
      .setMin(0)
      .setValue(0)
      .plugTo(this, "setFrameIndex")
      ;
    cp5.getController("frame_index").getCaptionLabel().align(ControlP5.CENTER, CENTER);
    
    cp5.addToggle("alpha_only")
      .setPosition(grid(11), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setLabel("ALPHA\nONLY")
      .plugTo(this, "alphaOnlyEnable")
      ;
    cp5.getController("alpha_only").getCaptionLabel().align(ControlP5.CENTER, CENTER);

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

  public void enableAutomation(boolean _value) {
    if (_value) {
      if (automationIsLoaded) {
        automate = true;
      } else {
        cp5.getController("enable_automation").setValue(0);
      }
    } else {
      automate = false;
    }
  }
  
  public void alphaOnlyEnable(boolean _value){
    alphaOnly = _value;
  }

  public void enableJitter(boolean _value) {
    jitter = _value;
  }

  public void quick_sort(boolean _value) {
    quick = _value;
    for (SortOperation o : operations.sortOperations) {
      o.setQuick(quick);
    }
  }

  public void toggleBatch(boolean _value) {
    cp5.getController("frame_index").setValue(0);
    batch = _value;
  }

  public void frameIncrement() {
    Controller numberBox = cp5.getController("frame_index");
    int value = int(numberBox.getValue());
    value++;
    if (value == batchSize) {
      cp5.getController("play").setValue(0);
      cp5.getController("batch_toggle").setValue(0);
    }
    value = constrain(value, 0, batchSize);
    numberBox.setValue(value);
  }

  public void frameDecrement() {
    Controller numberBox = cp5.getController("frame_index");
    int value = int(numberBox.getValue());
    value--;
    value = constrain(value, 0, batchSize);
    numberBox.setValue(value);
  }

  public void setFrameIndex(int _value) {
    frameIndex = _value;
  }
}

public int grid( int _pos) {
  return gridSize * _pos + gridOffset;
}
