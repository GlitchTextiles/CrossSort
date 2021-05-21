public void open_file() {
  selectInput("Select a file to process: ", "inputSelection");
}

public void inputSelection(File input) {
  if (input == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + input.getAbsolutePath());
    src = loadImage(input.getAbsolutePath());
    buffer = src.copy();
    surface.setSize(src.width, src.height);
  }
}

public void save_file() {
  selectOutput("Specify file location and format to save to:", "outputSelection");
}

public void outputSelection(File output) {
  if (output == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + output.getAbsolutePath());
    stillPath = output.getAbsolutePath();
    buffer.save(stillPath);
  }
}

public void record_sequence(boolean value) {
  if (value) {
    selectFolder("Select a location and filename (no extension) to save sequence to:", "outputFolderSelection");
  } else {
    record=false;
  }
}

public void outputFolderSelection(File output) {
  if (output == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + output.getAbsolutePath());
    sequencePath = split(output.getAbsolutePath(),'.')[0];
    record = true;
    sequenceIndex=0;
  }
}
