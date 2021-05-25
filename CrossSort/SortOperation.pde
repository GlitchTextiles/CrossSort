public class SortOperations {
  ArrayList<SortOperation> sortOperations;
  Accordion accordion;
  ControlP5 controlContext;

  SortOperations(ControlP5 _controlContext, int _x, int _y ) {
    controlContext = _controlContext;
    sortOperations = new ArrayList<SortOperation>();

    accordion = controlContext.addAccordion("Operations")
      .setPosition(_x, _y)
      .setWidth(600)
      .setHeight(guiObjectSize)
      ;
  }

  public void add() {
    sortOperations.add(new SortOperation("Operation "+sortOperations.size(), controlContext));
    accordion.addItem(sortOperations.get(sortOperations.size()-1).group);

  }

  public void remove() {
    if (sortOperations.size() >0) {
      sortOperations.get(sortOperations.size()-1).group.remove();
      sortOperations.remove(sortOperations.size()-1);
    }
  }

  public int size() {
    return sortOperations.size();
  }

  public void sort(PImage _image) {
    for (SortOperation o : sortOperations) {  
      for (int i = 0; i < iterations; i++) {
        o.sortPixels(_image);
      }
    }
  }
}

public class SortOperation {

  int sample_direction = 0; // 0 = LR, 1 = UD, 2 = DD, 3 = DU
  int threshold_mode = 0;
  int sort_direction = 0;
  int sort_by = 0; // 0 = RAW, 1 = R, 2 = G, 3 = B, 4 = HUE,
  boolean quick = false;
  boolean reverse = false;
  int min = 0;
  int max = 0;

  ControlP5 controls;

  Group group;

  Range threshold;
  RadioButton sample_direction_radio, sort_mode_radio, threshold_mode_radio, sort_by_radio;

  String name;

  SortOperation(String _name, ControlP5 _controlContext) {
    name = _name;
    controls = _controlContext;

    // GUI

    group = controls.addGroup(name);

    // Quick - reverse toggle / Slow  - sort_direction radio
    // sort_by radio

    // row 1 controls

    controls.addToggle(name+"quick")
      .setPosition(grid(0), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("QK\nSRT")
      .plugTo(this, "quickToggle")
      .moveTo(group)
      ;
    controls.getController(name+"quick").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    // visible when quick

    controls.addToggle(name+"reverse")
      .setPosition(grid(1), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("REV")
      .plugTo(this, "reverse")
      .setValue(false)
      .moveTo(group)
      .hide();
    ;
    controls.getController(name+"reverse").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    controls.addToggle(name+"random")
      .setPosition(grid(2), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("RAND")
      .setValue(false)
      .moveTo(group)
      .hide()
      ;
    controls.getController(name+"random").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    // visible when !quick

    sort_mode_radio = controls.addRadioButton(name+"sort_direction")
      .setPosition(grid(1), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setItemsPerRow(4)
      .setSpacingColumn(guiBufferSize)
      .addItem(name+"FW>", 0)
      .addItem(name+"FW<", 1)
      .addItem(name+"RV>", 2)
      .addItem(name+"RV<", 3)
      .plugTo(this, "sortDirection")
      .moveTo(group)
      .activate(0)
      ;
    sort_mode_radio.getItem(name+"FW>").setLabel("FW>");
    sort_mode_radio.getItem(name+"FW<").setLabel("FW<");
    sort_mode_radio.getItem(name+"RV>").setLabel("RV>");
    sort_mode_radio.getItem(name+"RV<").setLabel("RV<");
    for (Toggle t : sort_mode_radio.getItems()) {
      t.getCaptionLabel().align(ControlP5.CENTER, CENTER);
    }

    // row 2 controls

    sort_by_radio = controls.addRadioButton(name+"sort_by")
      .setPosition(grid(0), grid(1))
      .setSize(guiObjectSize, guiObjectSize)
      .setItemsPerRow(4)
      .setSpacingColumn(guiBufferSize)
      .addItem(name+"rgb", 0)
      .addItem(name+"hue", 1)
      .addItem(name+"sat", 2)
      .addItem(name+"brt", 3)
      .plugTo(this, "sortBy")
      .moveTo(group)
      .activate(0)
      ;
    sort_by_radio.getItem(name+"rgb").setLabel("raw");
    sort_by_radio.getItem(name+"hue").setLabel("hue");
    sort_by_radio.getItem(name+"sat").setLabel("sat");
    sort_by_radio.getItem(name+"brt").setLabel("brt");
    for (Toggle t : sort_by_radio.getItems()) {
      t.getCaptionLabel().align(ControlP5.CENTER, CENTER);
    }

    // row 3 controls

    sample_direction_radio = controls.addRadioButton(name+"sample_direction")
      .setPosition(grid(0), grid(2))
      .setSize(guiObjectSize, guiObjectSize)
      .setItemsPerRow(6)
      .setSpacingColumn(guiBufferSize)
      .addItem(name+"LR", 0)
      .addItem(name+"UD", 1)
      .addItem(name+"DD", 2)
      .addItem(name+"DU", 3)
      .plugTo(this, "sampleDirection")
      .moveTo(group)
      .activate(0)
      ;
    sample_direction_radio.getItem(name+"LR").setLabel("LR");
    sample_direction_radio.getItem(name+"UD").setLabel("UD");
    sample_direction_radio.getItem(name+"DD").setLabel("DD");
    sample_direction_radio.getItem(name+"DU").setLabel("DU");
    for (Toggle t : sample_direction_radio.getItems()) {
      t.getCaptionLabel().align(ControlP5.CENTER, CENTER);
    }

    // row 4 controls

    threshold_mode_radio = controls.addRadioButton(name+"threshold_mode")
      .setPosition(grid(0), grid(3))
      .setSize(guiObjectSize, guiObjectSize)
      .setItemsPerRow(6)
      .setSpacingColumn(guiBufferSize)
      .addItem(name+">mn", 0)
      .addItem(name+"<mn", 1)
      .addItem(name+">mx", 2)
      .addItem(name+"<mx", 3)
      .addItem(name+"><", 4)
      .addItem(name+"<>", 5)
      .plugTo(this, "thresholdMode")
      .moveTo(group)
      .activate(0)
      ;
    threshold_mode_radio.getItem(name+">mn").setLabel(">mn");
    threshold_mode_radio.getItem(name+"<mn").setLabel("<mn");
    threshold_mode_radio.getItem(name+">mx").setLabel(">mx");
    threshold_mode_radio.getItem(name+"<mx").setLabel("<mx");
    threshold_mode_radio.getItem(name+"><").setLabel("><");
    threshold_mode_radio.getItem(name+"<>").setLabel("<>");
    for (Toggle t : threshold_mode_radio.getItems()) {
      t.getCaptionLabel().align(ControlP5.CENTER, CENTER);
    }

    threshold = controls.addRange(name+"threshold")
      .setLabel("threshold")
      .setPosition(grid(0), grid(4))
      .setSize(500, guiObjectSize)
      .setHandleSize(guiBufferSize)
      .setRange(0, 255)
      .plugTo(this)
      .moveTo(group)
      .setRangeValues(50, 205)
      ;
    controls.getController(name+"threshold").getCaptionLabel().align(ControlP5.CENTER, CENTER);
  }

  void quickToggle(int _value) {
    quick = boolean(_value);
    if (quick) {
      sort_mode_radio.hide();
      controls.getController(name+"reverse").show();
      controls.getController(name+"random").show();
    } else {
      sort_mode_radio.show();
      controls.getController(name+"reverse").hide();
      controls.getController(name+"random").hide();
    }
  }

  public void controlEvent(ControlEvent theControlEvent) {
    if (theControlEvent.isFrom(name+"threshold")) {
      this.min = int(theControlEvent.getController().getArrayValue(0));
      this.max = int(theControlEvent.getController().getArrayValue(1));
    }
  }

  public void sampleDirection(int _id) {
    this.sample_direction = _id;
    println("sample_direction: "+sample_direction);
  }
  public void thresholdMode(int _id) {
    this.threshold_mode = _id;
    println("threshold_mode: "+threshold_mode);
  }
  public void sortDirection(int _id) {
    this.sort_direction = _id;
    println("sort_direction: "+sort_direction);
  }
  public void sortBy(int _id) {
    this.sort_by = _id;
    println("sort_by: "+sort_by);
  }

  int grid( int _pos) {
    return gridSize * _pos + gridOffset;
  }

  PImage sortPixels (PImage _image) {
    color[] px_buffer;

    int buffer_size = 0;

    int x = 0;
    int y = 0; 
    int x_start = 0;
    int y_start = 0;

    _image.loadPixels();

    // Y Axis:
    // UP
    // DOWN (reverse of UP)

    // X Axis:
    // LEFT
    // RIGHT (reverse of RIGHT)

    // Diagonal
    // UP+LEFT
    // UP+RIGHT
    // DOWN+LEFT
    // DOWN+RIGHT
    // LEFT+UP
    // LEFT+DOWN
    // RIGHT+UP
    // RIGHT+DOWN

    // 1. Grab Pixels
    // 2. Sort Pixels
    // 3. Replace Pixels

    switch(sample_direction) {
    case 0: // LR
      px_buffer = new int[_image.width];    
      for (int a = 0; a < _image.height; a++) {
        for (int b = 0; b < px_buffer.length; b++) {
          px_buffer[b] = _image.pixels[a*_image.width+b];
        }
        px_buffer = thresholdSort(px_buffer);
        for (int b = 0; b < px_buffer.length; b++) {
          _image.pixels[a*_image.width+b] = px_buffer[b];
        }
      }
      break; 
    case 1: // UD
      px_buffer = new color[_image.height];   
      for (int a = 0; a < _image.width; a++) {
        for (int b = 0; b < px_buffer.length; b++) {
          px_buffer[b] = _image.pixels[b*_image.width+a];
        }
        px_buffer = thresholdSort(px_buffer);
        for (int b = 0; b < px_buffer.length; b++) {
          _image.pixels[b*_image.width+a] = px_buffer[b];
        }
      }
      break;
    case 2: // DD
      for (int i = 0; i < _image.width+_image.height; i++) {

        // logic for setting buffer size and x,y starting values
        if (_image.width < _image.height) {
          x_start=_image.width-1;
          y_start=(_image.height-1)-(i-_image.width);
          if (i < _image.width) {
            x_start=i;
            y_start=_image.height-1;
            buffer_size = i+1;
          } else if (i >= _image.width && i < _image.height) {
            buffer_size = _image.width;
          } else {
            buffer_size = _image.height-(i-_image.width);
          }
        } else if (_image.width >= _image.height) {
          x_start=i;
          y_start=_image.height-1;
          if (i < _image.height) {
            buffer_size = i+1;
          } else if (i >= _image.height && i < _image.width) {
            buffer_size = _image.height;
          } else {
            x_start=_image.width-1;
            y_start=(_image.height-1)-(i-_image.width);
            buffer_size = _image.height-(i-_image.width);
          }
        } else {
          println("[!] image dimension error in diagonal down (DD) logic");
        }

        // set buffer size
        px_buffer=new color[buffer_size];

        // fill the buffer
        x=x_start;
        y=y_start;
        for (int j = 0; j < px_buffer.length; j++) {
          px_buffer[j] = _image.pixels[y*_image.width+x];
          x--;
          y--;
        }

        // perform sorting operations
        px_buffer = thresholdSort(px_buffer);

        // write the sorted pixels back to the buffer
        x=x_start;
        y=y_start;
        for (int j = 0; j < px_buffer.length; j++) {
          _image.pixels[y*_image.width+x]=px_buffer[j];
          x--;
          y--;
        }
      }
      break;
    case 3: // DU
      for (int i = 0; i < _image.width+_image.height; i++) {

        // logic for setting buffer size and x,y starting values
        if (_image.width < _image.height) {
          x_start=0;
          y_start=i;
          if (i < _image.width) {
            buffer_size = i+1;
          } else if (i >= _image.width && i < _image.height) {
            buffer_size = _image.width;
          } else {
            x_start=i-_image.height;
            y_start=_image.height-1;
            buffer_size = _image.width-(i -_image.height);
          }
        } else if (_image.width >= _image.height) {
          x_start=i-_image.height;
          y_start=_image.height-1;
          if (i < _image.height) {
            x_start=0;
            y_start=i;
            buffer_size = i+1;
          } else if ( i >= _image.height && i < _image.width) {
            buffer_size = _image.height-1;
          } else {
            buffer_size = _image.height-(i - _image.width);
          }
        } else {
          println("[!] image dimension error in diagonal up (DU) logic");
        }

        // set buffer size
        px_buffer=new color[buffer_size];

        // fill the buffer
        x=x_start;
        y=y_start;
        for (int j = 0; j < px_buffer.length; j++) {
          px_buffer[j] = _image.pixels[y*_image.width+x];
          x++;
          y--;
        }

        // perform sorting operations
        px_buffer = thresholdSort(px_buffer);

        // write the sorted pixels back to the buffer
        x=x_start;
        y=y_start;
        for (int j = 0; j < px_buffer.length; j++) {
          _image.pixels[y*_image.width+x]=px_buffer[j];
          x++;
          y--;
        }
      }
      break;
    default:
      break;
    }
    _image.updatePixels();
    return _image;
  }

  color[] thresholdSort(color[] _pixels) {

    int in = 0;
    int out = 0;

    boolean in_flag = false;
    boolean out_flag = false;
    boolean min_flag = false;

    // Threshold Modes
    // 0: below min - in: <= min, out: > min
    // 1: above min - in: >= min, out: < min
    // 2: above max - in: >= max, out: < max
    // 3: below max - in: <= max, out: > max
    // 4: above min && below max - in: >= min && <= max, out: < min || > max
    // 5: below min && above max - in: <= min || >= max, if in: <= min; then out: > min, else if in >= max; then out: < max

    // gather Samples
    for (int i = 0; i < _pixels.length; ++i) {    

      int pixel = _pixels[i];

      // future: implement RAW/HSB switch

      switch(sort_by) {
      case 0: // RAW
      case 1: // R
      case 2: // G
      case 3: // B
      case 4: // H
      case 5: // S
      case 6: // B
      default:
        break;
      }

      // switch for in and out point logic
      switch(this.threshold_mode) {
      case 0: // below min - in: <= min, out: > min
        if (!in_flag) {
          if (pixel <= color(this.min)) {
            in = i;
            in_flag=true;
          }
        } else if (!out_flag || ( i == _pixels.length-1)) {
          if (pixel > color(this.min)) {
            out = i;
            out_flag=true;
          }
        }
        break;
      case 1: // above min - in: >= min, out: < min
        if (!in_flag) {
          if (pixel >= color(this.min)) {
            in = i;
            in_flag=true;
          }
        } else if (!out_flag || ( i == _pixels.length-1)) {
          if (pixel < color(this.min)) {
            out = i;
            out_flag=true;
          }
        }
        break;
      case 2: // above max - in: >= max, out: < max
        if (!in_flag) {
          if (pixel >= color(this.max)) {
            in = i;
            in_flag=true;
          }
        } else if (!out_flag || ( i == _pixels.length-1)) {
          if (pixel < color(this.max)) {
            out = i;
            out_flag=true;
          }
        }
        break;
      case 3: // below max - in: <= max, out: > max
        if (!in_flag) {
          if (pixel <= color(this.max)) {
            in = i;
            in_flag=true;
          }
        } else if (!out_flag || ( i == _pixels.length-1)) {
          if (pixel > color(this.max)) {
            out = i;
            out_flag=true;
          }
        }
        break;
      case 4: // above min && below max - in: >= min && <= max, out: < min || > max
        if (!in_flag) {
          if (pixel >= color(this.min) && pixel <= color(this.max)) {
            in = i;
            in_flag=true;
          }
        } else if (!out_flag || ( i == _pixels.length-1)) {
          if (pixel < color(this.min) || pixel > color(this.max)) {
            out = i;
            out_flag=true;
          }
        }
        break;
      case 5:  // below min && above max - in: <= min || >= max, if in: <= min; then out: > min, else if in >= max; then out: < max
        if ( !in_flag ) {
          if ( pixel <= color(this.min) ) {
            in = i;
            in_flag=true;
            min_flag=true;
          } else if ( pixel >= color(this.max)) {
            in = i;
            in_flag=true;
            min_flag=false;
          }
        } else if ( !out_flag || ( i == _pixels.length-1) ) {
          if (min_flag) {
            if ( pixel > color(this.min)) {
              out = i;
              out_flag = true;
            }
          } else {
            if ( pixel < color(this.max)) {
              out = i;
              out_flag = true;
            }
          }
        }
        break;
      }

      if ( in_flag && out_flag ) {
        int[] sample = new int[ out - in ];

        for (int j = 0; j < sample.length; ++j) {
          sample[j]=_pixels[j+in];
        }

        if (quick) {
          sample=sort(sample);
          if (reverse) sample=reverse(sample);
        } else {
          sample=pixelSort(sample);
        }

        for (int j = 0; j < sample.length; ++j) {
          _pixels[j+in]=sample[j];
        }

        in_flag = false;
        out_flag = false;
      }
    }
    return _pixels;
  }

  color[] pixelSort(color[] _pixels) {

    if (sort_by == 0) {

      switch(sort_direction) { 
      case 0:
        for (int i = 0; i < _pixels.length-1; i++) {
          if (_pixels[i] < _pixels[i+1]) {
            _pixels = swapPixels(_pixels, i+1, i);
          }
        }
        break;
      case 1:
        for (int i = 0; i < _pixels.length-1; i++) {
          if (_pixels[i] > _pixels[i+1]) {
            _pixels = swapPixels(_pixels, i+1, i);
          }
        }
        break;
      case 2:
        for (int i = _pixels.length-2; i >= 0; i--) {
          if (_pixels[i] < _pixels[i+1]) {
            _pixels = swapPixels(_pixels, i+1, i);
          }
        }
        break;
      case 3:
        for (int i = _pixels.length-2; i >= 0; i--) {
          if (_pixels[i] > _pixels[i+1]) {
            _pixels = swapPixels(_pixels, i+1, i);
          }
        }
        break;
      }
    } else if (sort_by == 1) {

      switch(sort_direction) { 
      case 0:
        for (int i = 0; i < _pixels.length-1; i++) {
          if (hue(_pixels[i]) < hue(_pixels[i+1])) {
            _pixels = swapPixels(_pixels, i+1, i);
          }
        }
        break;
      case 1:
        for (int i = 0; i < _pixels.length-1; i++) {
          if (hue(_pixels[i]) > hue(_pixels[i+1])) {
            _pixels = swapPixels(_pixels, i+1, i);
          }
        }
        break;
      case 2:
        for (int i = _pixels.length-2; i >= 0; i--) {
          if (hue(_pixels[i]) < hue(_pixels[i+1])) {
            _pixels = swapPixels(_pixels, i+1, i);
          }
        }

        break;
      case 3:

        for (int i = _pixels.length-2; i >= 0; i--) {
          if (hue(_pixels[i]) > hue(_pixels[i+1])) {
            _pixels = swapPixels(_pixels, i+1, i);
          }
        }
        break;
      }
    } else if (sort_by == 2) {

      switch(sort_direction) { 
      case 0:
        for (int i = 0; i < _pixels.length-1; i++) {
          if (brightness(_pixels[i]) < brightness(_pixels[i+1])) {
            _pixels = swapPixels(_pixels, i+1, i);
          }
        }
        break;
      case 1:
        for (int i = 0; i < _pixels.length-1; i++) {
          if (brightness(_pixels[i]) > brightness(_pixels[i+1])) {
            _pixels = swapPixels(_pixels, i+1, i);
          }
        }
        break;
      case 2:
        for (int i = _pixels.length-2; i >= 0; i--) {
          if (brightness(_pixels[i]) < brightness(_pixels[i+1])) {
            _pixels = swapPixels(_pixels, i+1, i);
          }
        }
        break;
      case 3:
        for (int i = _pixels.length-2; i >= 0; i--) {
          if (brightness(_pixels[i]) > brightness(_pixels[i+1])) {
            _pixels = swapPixels(_pixels, i+1, i);
          }
        }
        break;
      }
    } else if (sort_by == 3) {

      switch(sort_direction) { 
      case 0:
        for (int i = 0; i < _pixels.length-1; i++) {
          if (saturation(_pixels[i]) < saturation(_pixels[i+1])) {
            _pixels = swapPixels(_pixels, i+1, i);
          }
        }
        break;
      case 1:
        for (int i = 0; i < _pixels.length-1; i++) {
          if (saturation(_pixels[i]) > saturation(_pixels[i+1])) {
            _pixels = swapPixels(_pixels, i+1, i);
          }
        }

        break;
      case 2:
        for (int i = _pixels.length-2; i >= 0; i--) {
          if (saturation(_pixels[i]) < saturation(_pixels[i+1])) {
            _pixels = swapPixels(_pixels, i+1, i);
          }
        }

        break;
      case 3:
        for (int i = _pixels.length-2; i >= 0; i--) {
          if (saturation(_pixels[i]) > saturation(_pixels[i+1])) {
            _pixels = swapPixels(_pixels, i+1, i);
          }
        }
        break;
      }
    }
    return _pixels;
  }

  int[] swapPixels(int[] _pixels, int _index1, int _index2) {
    int pixel = _pixels[_index1];
    _pixels[_index1] = _pixels[_index2];
    _pixels[_index2] = pixel;
    return _pixels;
  }
}
