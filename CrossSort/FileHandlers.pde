public void open_JSON() {
  selectInput("Select a JSON automation file to load: ", "JSONSelection");
}

public void JSONSelection(File input) {
  if (input == null) {
    println("Window was closed or the user hit cancel.");
    automationIsLoaded = false;
    GUI.cp5.getController("enable_automation").setValue(0);
    GUI.cp5.getController("enable_automation").hide();
    GUI.cp5.getController("enable_jitter").setValue(0);
    GUI.cp5.getController("enable_jitter").hide();
  } else {
    String path = input.getAbsolutePath();
    println("User selected " + path);
    String[] pathTest = split(path, '.');
    switch(pathTest[pathTest.length-1]) {
    case "JSON":
    case "json":
    case "Json":
      loadAutomation(path);
      GUI.cp5.getController("enable_automation").show();
      GUI.cp5.getController("enable_jitter").show();
      break;
    default:
      println("selected file is not JSON");
      break;
    }
  }
}

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
    mode = "single";
    GUI.cp5.getController("quick_sort").show();
  }
}

public void open_batch_folder() {
  selectFolder("Select a folder to batch process: ", "batchFolderSelection");
}

public void batchFolderSelection(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    batchDirectory = selection.getAbsolutePath();
    println(batchDirectory);
    File[] files = selection.listFiles();
    batchFileList = new ArrayList<File>(0);
    String path;
    String fileExt;
    for (File f : files) {
      if (f.isFile()) {
        path = f.getAbsolutePath();
        String[] pathParts = split(path, '.');
        fileExt = pathParts[pathParts.length-1];
        switch(fileExt) {
        case "png":
        case "PNG":
          batchFileList.add(f);
          break;
        }
      }
    }
    java.util.Collections.sort(batchFileList);
    batchIndex = 0;
    batchSize = batchFileList.size();
    mode = "batch";
    GUI.cp5.getController("frame_index").setMax(batchSize-1);
    GUI.cp5.getController("quick_sort").setValue(1);
    GUI.cp5.getController("quick_sort").hide();
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
    sequencePath = split(output.getAbsolutePath(), '.')[0];
    record = true;
    sequenceIndex=0;
  }
}
