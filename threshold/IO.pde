public void open_file() {
  selectInput("Select a file to process: ", "inputSelection");
}

public void inputSelection(File input) {
  if (input == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + input.getAbsolutePath());
    source=loadImage(input.getAbsolutePath());
    buffer=source.copy();
    surface.setSize(source.width, source.height);  
    redraw();
  }
}

public void save_file() {
  selectOutput("Select a file to process:", "outputSelection");
}

public void outputSelection(File output) {
  if (output == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + output.getAbsolutePath());
    buffer.save(output.getAbsolutePath());
  }
}
