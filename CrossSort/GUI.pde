
void setupGUI() {
  
  cp5 = new ControlP5(this);

  // row 0 controls

  cp5.addButton("open_image")
    .setPosition(grid(0), grid(0))
    .setSize(guiObjectSize, guiObjectSize)
    .setLabel("OPEN")
    .plugTo(this, "open_file")
    ;
  cp5.getController("open_image").getCaptionLabel().align(ControlP5.CENTER, CENTER);

  cp5.addButton("save_image")
    .setPosition(grid(1), grid(0))
    .setSize(guiObjectSize, guiObjectSize)
    .setLabel("SAVE")
    .plugTo(this, "save_file")
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
    .plugTo(this, "play")
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
    .plugTo(this, "help")
    ;
  cp5.getController("help").getCaptionLabel().align(ControlP5.CENTER, CENTER);
  
  cp5.addBang("addOperation")
    .setPosition(grid(6), grid(0))
    .setSize(guiObjectSize, guiObjectSize)
    .setLabel("ADD\nOp")
    .plugTo(this, "addOperation")
    ;
  cp5.getController("addOperation").getCaptionLabel().align(ControlP5.CENTER, CENTER);
  
  cp5.addBang("removeOperation")
    .setPosition(grid(7), grid(0))
    .setSize(guiObjectSize, guiObjectSize)
    .setLabel("REM\nOP")
    .plugTo(this, "removeOperation")
    ;
  cp5.getController("help").getCaptionLabel().align(ControlP5.CENTER, CENTER);

  // row 7 controls

  cp5.addSlider("iterations")
    .setPosition(grid(0), grid(1))
    .setSize(500, guiObjectSize)
    .setRange(1, 100)
    .setNumberOfTickMarks(100)
    .setLabel("Iterate")
    .plugTo(this, "iterations")
    .setValue(1)
    ;
}

void addOperation(){
  operations.add();
}


void removeOperation(){
  operations.remove();
}

int grid( int _pos) {
  return gridSize * _pos + gridOffset;
}
