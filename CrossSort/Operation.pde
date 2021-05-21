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

  Range threshold;
  RadioButton sample_direction_radio, sort_mode_radio, threshold_mode_radio, sort_by_radio;

  int position_x = 0, position_y = 0;

  int guiObjectSize;
  int guiBufferSize;
  int gridSize;
  int gridOffset = 10;

  int grid( int _pos) {
    return gridSize * _pos + gridOffset;
  }

  SortOperation(int _x, int _y, int _guiObjectSize, int _guiBufferSize, PApplet _applet) {
    position_x = _x;
    position_y = _y;
    guiObjectSize = _guiObjectSize;
    guiBufferSize = _guiBufferSize;
    gridSize = guiObjectSize + guiBufferSize;
    controls = new ControlP5(_applet);

    // GUI
    // Quick - reverse toggle / Slow  - sort_direction radio
    // sort_by radio

    // row 1 controls

    controls.addToggle("quick")
      .setPosition(grid(0)+position_x, grid(0)+position_y)
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("QK\nSRT")
      .plugTo(this, "quickToggle")
      ;
    controls.getController("quick").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    // visible when quick

    controls.addToggle("reverse")
      .setPosition(grid(1)+position_x, grid(0)+position_y)
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("REV")
      .plugTo(this, "reverse")
      .setValue(false)
      .hide();
    ;
    controls.getController("reverse").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    controls.addToggle("random")
      .setPosition(grid(2)+position_x, grid(0)+position_y)
      .setSize(guiObjectSize, guiObjectSize)
      .setLabel("RAND")
      .setValue(false)
      .hide()
      ;
    controls.getController("random").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    // visible when !quick

    sort_mode_radio = controls.addRadioButton("sort_direction")
      .setPosition(grid(1)+position_x, grid(0)+position_y)
      .setSize(guiObjectSize, guiObjectSize)
      .setItemsPerRow(4)
      .setSpacingColumn(guiBufferSize)
      .addItem("FW>", 0)
      .addItem("FW<", 1)
      .addItem("RV>", 2)
      .addItem("RV<", 3)
      .plugTo(this, "sortDirection")
      .activate(0)
      ;

    for (Toggle t : sort_mode_radio.getItems()) {
      t.getCaptionLabel().align(ControlP5.CENTER, CENTER);
    }

    // row 2 controls

    sort_by_radio = controls.addRadioButton("sort_by")
      .setPosition(grid(0)+position_x, grid(1)+position_y)
      .setSize(guiObjectSize, guiObjectSize)
      .setItemsPerRow(4)
      .setSpacingColumn(guiBufferSize)
      .addItem("rgb", 0)
      .addItem("hue", 1)
      .addItem("sat", 2)
      .addItem("brt", 3)
      .plugTo(this, "sortBy")
      .activate(0)
      ;

    for (Toggle t : sort_by_radio.getItems()) {
      t.getCaptionLabel().align(ControlP5.CENTER, CENTER);
    }

    // row 3 controls

    sample_direction_radio = controls.addRadioButton("sample_direction")
      .setPosition(grid(0)+position_x, grid(2)+position_y)
      .setSize(guiObjectSize, guiObjectSize)
      .setItemsPerRow(6)
      .setSpacingColumn(guiBufferSize)
      .addItem("LR", 0)
      .addItem("UD", 1)
      .addItem("DD", 2)
      .addItem("DU", 3)
      .plugTo(this, "sampleDirection")
      .activate(0)
      ;

    // row 4 controls

    for (Toggle t : sample_direction_radio.getItems()) {
      t.getCaptionLabel().align(ControlP5.CENTER, CENTER);
    }

    threshold_mode_radio = controls.addRadioButton("threshold_mode")
      .setPosition(grid(0)+position_x, grid(3)+position_y)
      .setSize(guiObjectSize, guiObjectSize)
      .setItemsPerRow(6)
      .setSpacingColumn(guiBufferSize)
      .addItem(">mn", 0)
      .addItem("<mn", 1)
      .addItem(">mx", 2)
      .addItem("<mx", 3)
      .addItem("><", 4)
      .addItem("<>", 5)
      .plugTo(this, "thresholdMode")
      .activate(0)
      ;

    for (Toggle t : threshold_mode_radio.getItems()) {
      t.getCaptionLabel().align(ControlP5.CENTER, CENTER);
    }

    threshold = controls.addRange("threshold")
      .setLabel("threshold")
      .setPosition(grid(0)+position_x, grid(4)+position_y)
      .setSize(500, guiObjectSize)
      .setHandleSize(guiBufferSize)
      .setRange(0, 255)
      .plugTo(this)
      .setRangeValues(50, 205)
      ;
    controls.getController("threshold").getCaptionLabel().align(ControlP5.CENTER, CENTER);
  }

  void quickToggle(int _value) {
    quick = boolean(_value);
    if (quick) {
      sort_mode_radio.hide();
      controls.getController("reverse").show();
      controls.getController("random").show();
    } else {
      sort_mode_radio.show();
      controls.getController("reverse").hide();
      controls.getController("random").hide();
    }
  }

  void sortBy(int id) {
    this.sort_by = id;
  }

  void sortDirection(int id) {
    this.sort_direction = id;
  }

  void thresholdMode(int id) {
    this.threshold_mode = id;
  }

  void sampleDirection(int id) {
    this.sample_direction = id;
  }
  
  public void controlEvent(ControlEvent theControlEvent) {
    if (theControlEvent.isFrom("threshold")) {
      this.min = int(theControlEvent.getController().getArrayValue(0));
      this.max = int(theControlEvent.getController().getArrayValue(1));
    }
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
          sample=pixelSort(sample, sort_mode);
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

  color[] pixelSort(color[] _pixels, int _sort_direction) {

    if (sort_by == 0) {

      switch(_sort_direction) { 
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

      switch(_sort_direction) { 
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

      switch(_sort_direction) { 
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

      switch(_sort_direction) { 
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
