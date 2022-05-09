public class SortOperations {
  ArrayList<SortOperation> sortOperations;
  Accordion accordion;
  ControlP5 controlContext;

  SortOperations(ControlP5 _controlContext, int _x, int _y ) {
    controlContext = _controlContext;
    sortOperations = new ArrayList<SortOperation>();

    accordion = controlContext.addAccordion("Operations")
      .setPosition(_x, _y)
      .setWidth(guiObjectWidth+2*guiBufferSize)
      .setCollapseMode(Accordion.MULTI)
      ;
  }
  
  public void add() {
    try {
      sortOperations.add(new SortOperation("Sort Operation "+(sortOperations.size()+1)+" ", controlContext));
      accordion.addItem(sortOperations.get(sortOperations.size()-1).group).setItemHeight(grid(3)).open();
    }  
    catch(ConcurrentModificationException e) {
      e.printStackTrace();
    }
  }

  public void remove() {
    if (sortOperations.size() > 0) {
      sortOperations.get(sortOperations.size()-1).group.remove();
      try {
        sortOperations.remove(sortOperations.size()-1);
      } 
      catch(ConcurrentModificationException e) {
        e.printStackTrace();
      }
    }
  }

  public int size() {
    return sortOperations.size();
  }

  public PImage sort(PImage _image) {
    PImage _buffer = _image.copy();
    for (SortOperation o : sortOperations) {  
      for (int i = 0; i < iterations; i++) {
        if (o.enable) o.sortPixels(_buffer, null);
      }
    }
    return _buffer;
  }

  public BufferedImage sort(BufferedImage _image) {
    WritableRaster wr = _image.getColorModel().createCompatibleWritableRaster(_image.getWidth(),_image.getHeight());
    WritableRaster wr2 = _image.getRaster();
    double[] sample = new double[3];
    for(int y = 0; y< _image.getHeight();y++){
      for(int x = 0; x< _image.getWidth();x++){
        wr2.getPixel(x,y,sample);
        wr.setPixel(x,y,sample);
      }
    }
    for (SortOperation o : sortOperations) {  
      for (int i = 0; i < iterations; i++) {
        if (o.enable) o.sortPixels(wr, null);
      }
    }
    return new BufferedImage(_image.getColorModel(), wr, false, null);
  }

  public PImage sortAlpha(PImage _image) {

    PImage _buffer = _image.copy();
    _buffer.loadPixels();
    ArrayList<Integer> _mask = new ArrayList<Integer>();
    for (int i = 0; i < _image.pixels.length; i++) _mask.add(0);
    for (SortOperation o : sortOperations) {  
      for (int i = 0; i < iterations; i++) {
        if (o.enable) o.sortPixels(_buffer, _mask);
      }
    }
    int[] _theMask = new int[_image.pixels.length];
    for (int i = 0; i < _image.pixels.length; i++) _theMask[i] = _mask.get(i);
    _buffer.mask(_theMask);
    return _buffer;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////


public class SortOperation {

  public int sample_direction = 0; // 0 = LR, 1 = UD, 2 = DD, 3 = DU
  public int threshold_mode = 0;
  public int sort_direction = 0;
  public int sort_by = 0; // 0 = RAW, 1 = R, 2 = G, 3 = B, 4 = HUE,
  public boolean quick = false;
  public boolean reverse = false;
  public boolean rgbMode = false;
  public boolean enable;

  public ControlP5 controls;

  public Group group;

  public Range threshold;
  public Range[] rgbThresholds = new Range[3];
  public RadioButton sample_direction_radio;
  public RadioButton sort_mode_radio;
  public RadioButton threshold_mode_radio;
  public RadioButton sort_by_radio;
  public String name;

  public SortOperation(String _name, ControlP5 _controlContext) {
    name = _name;
    controls = _controlContext;

    // GUI
    group = controls.addGroup(name)
      .setBackgroundColor(guiGroupBackground)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .disableCollapse()
      .hideArrow()
      ;

    // visible when quick

    controls.addToggle(name+"reverse")
      .setPosition(grid(7), grid(1))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setLabel("REV")
      .plugTo(this, "reverse")
      .setValue(false)
      .moveTo(group)
      .hide();
    ;
    controls.getController(name+"reverse").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    controls.addToggle(name+"enable")
      .setPosition(grid(11), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setLabel("ENABLE")
      .plugTo(this, "enable")
      .setValue(false)
      .moveTo(group)
      ;
    controls.getController(name+"enable").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    // visible when !quick

    sample_direction_radio = controls.addRadioButton(name+"sample_direction")
      .setPosition(grid(0), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
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
    sample_direction_radio.getItem(name+"LR").setLabel("LEFT\nRIGHT");
    sample_direction_radio.getItem(name+"UD").setLabel("UP\nDOWN");
    sample_direction_radio.getItem(name+"DD").setLabel("DIAG\nDOWN");
    sample_direction_radio.getItem(name+"DU").setLabel("DIAG\nUP");
    for (Toggle t : sample_direction_radio.getItems()) {
      t.getCaptionLabel().align(ControlP5.CENTER, CENTER);
    }

    sort_by_radio = controls.addRadioButton(name+"sort_by")
      .setPosition(grid(5), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
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

    controls.addToggle(name+"rgbThresh")
      .setPosition(grid(9), grid(0))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setLabel("RGB")
      .setValue(false)
      .plugTo(this, "rgbThresh")
      .moveTo(group)
      ;
    controls.getController(name+"rgbThresh").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    threshold_mode_radio = controls.addRadioButton(name+"threshold_mode")
      .setPosition(grid(0), grid(1))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setItemsPerRow(6)
      .setSpacingColumn(guiBufferSize)
      .addItem(name+"<mn", 0)
      .addItem(name+">mn", 1)
      .addItem(name+">mx", 2)
      .addItem(name+"<mx", 3)
      .addItem(name+"><", 4)
      .addItem(name+"<>", 5)
      .plugTo(this, "thresholdMode")
      .moveTo(group)
      .activate(0)
      ;
    threshold_mode_radio.getItem(name+"<mn").setLabel("<min");
    threshold_mode_radio.getItem(name+">mn").setLabel(">min");
    threshold_mode_radio.getItem(name+">mx").setLabel(">max");
    threshold_mode_radio.getItem(name+"<mx").setLabel("<max");
    threshold_mode_radio.getItem(name+"><").setLabel("><");
    threshold_mode_radio.getItem(name+"<>").setLabel("<>");
    for (Toggle t : threshold_mode_radio.getItems()) {
      t.getCaptionLabel().align(ControlP5.CENTER, CENTER);
    }

    sort_mode_radio = controls.addRadioButton(name+"sort_direction")
      .setPosition(grid(7), grid(1))
      .setSize(guiObjectSize, guiObjectSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
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

    threshold = controls.addRange(name+"threshold")
      .setLabel("threshold")
      .setPosition(grid(0), grid(2))
      .setSize(600, guiObjectSize)
      .setHandleSize(guiBufferSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setRange(0, 1)
      .moveTo(group)
      .setRangeValues(0.25, 0.75)
      .plugTo(this)
      ;
    controls.getController(name+"threshold").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    rgbThresholds[0] = controls.addRange(name+"rThreshold")
      .setLabel("red")
      .setPosition(grid(0), grid(2))
      .setSize(600, guiObjectSize/3)
      .setHandleSize(guiBufferSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setRange(0, 1)
      .moveTo(group)
      .setRangeValues(0.25, 0.75)
      .plugTo(this)
      .hide()
      ;
    controls.getController(name+"rThreshold").getCaptionLabel().align(ControlP5.CENTER, CENTER);

    rgbThresholds[1] = controls.addRange(name+"gThreshold")
      .setLabel("green")
      .setPosition(grid(0), grid(2)+guiObjectSize/3)
      .setSize(600, guiObjectSize/3)
      .setHandleSize(guiBufferSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setRange(0, 1)
      .moveTo(group)
      .setRangeValues(0.25, 0.75)
      .plugTo(this)
      .hide()
      ;
    controls.getController(name+"gThreshold").getCaptionLabel().align(ControlP5.CENTER, CENTER);


    rgbThresholds[2] = controls.addRange(name+"bThreshold")
      .setLabel("blue")
      .setPosition(grid(0), grid(2)+2*guiObjectSize/3)
      .setSize(600, guiObjectSize/3)
      .setHandleSize(guiBufferSize)
      .setColorForeground(guiForeground)
      .setColorBackground(guiBackground) 
      .setColorActive(guiActive)
      .setRange(0, 1)
      .moveTo(group)
      .setRangeValues(0.25, 0.75)
      .plugTo(this)
      .hide()
      ;
    controls.getController(name+"bThreshold").getCaptionLabel().align(ControlP5.CENTER, CENTER);
  }

  void rgbThresh(boolean _value) {
    this.rgbMode = _value;
    if (this.rgbMode) {
      this.sort_by_radio.hide();
      threshold.hide();
      for (int i = 0; i < 3; i++)rgbThresholds[i].show();
    } else {
      threshold.show();
      for (int i = 0; i < 3; i++)rgbThresholds[i].hide();
      if (this.quick) {
      } else {
        this.sort_by_radio.show();
      }
    }
  }

  void setQuick(boolean _value) {
    this.quick = _value;
    if (this.quick) {
      this.sort_mode_radio.hide();
      this.sort_by_radio.hide();
      controls.getController(name+"reverse").show();
    } else {
      if (!this.rgbMode) {
        this.sort_by_radio.show();
      }
      this.sort_mode_radio.show();
      controls.getController(name+"reverse").hide();
    }
  }

  public void sampleDirection(int _id) {
    this.sample_direction = _id;
  }
  public void thresholdMode(int _id) {
    this.threshold_mode = _id;
  }
  public void sortDirection(int _id) {
    this.sort_direction = _id;
  }
  public void sortBy(int _id) {
    this.sort_by = _id;
  }

  //this method appears as a function in the main applet context, included here for portability
  int grid( int _pos) {
    return gridSize * _pos + gridOffset;
  }

  void sortPixels (WritableRaster _image, ArrayList<Integer> _mask) {
    double[][] px_image;
    int buffer_size = 0;
    ArrayList<Integer> _maskStrip;
    int x = 0;
    int y = 0; 
    int x_start = 0;
    int y_start = 0;
    switch(sample_direction) {
    case 0: // Left / Right (X-axis)
      px_image = new double[_image.getWidth()][3]; 
      for (int a = 0; a < _image.getHeight(); a++) {
        _maskStrip = new ArrayList<Integer>();
        for (int b = 0; b < px_image.length; b++) {
          _image.getPixel(b, a, px_image[b]);
          _maskStrip.add(0);
        }

        px_image = sortPixelArray(px_image, _maskStrip);

        for (int b = 0; b < px_image.length; b++) {
          _image.setPixel(b, a, px_image[b]);
          if (_mask != null && _mask.get(a*_image.getWidth()+b) == 0) _mask.set(a*_image.getWidth()+b, _maskStrip.get(b));
        }
      }
      break; 
    case 1: // Up / Down (Y-axis)
      px_image = new double[_image.getHeight()][3];
      for (int a = 0; a < _image.getWidth(); a++) {
        _maskStrip = new ArrayList<Integer>();
        for (int b = 0; b < px_image.length; b++) {
          _image.getPixel(a, b, px_image[b]);
          _maskStrip.add(0);
        }

        px_image = sortPixelArray(px_image, _maskStrip);

        for (int b = 0; b < px_image.length; b++) {
          _image.setPixel(a, b, px_image[b]);
          if (_mask != null && _mask.get(b*_image.getWidth()+a) == 0) _mask.set(b*_image.getWidth()+a, _maskStrip.get(b));
        }
      }
      break;
    case 2: // Diagonal Down (left to right)
      for (int i = 0; i < _image.getWidth()+_image.getHeight(); i++) {

        // logic for setting buffer size and x,y starting values
        if (_image.getWidth() < _image.getHeight()) {
          x_start=_image.getWidth()-1;
          y_start=(_image.getHeight()-1)-(i-_image.getWidth());
          if (i < _image.getWidth()) {
            x_start=i;
            y_start=_image.getHeight()-1;
            buffer_size = i+1;
          } else if (i >= _image.getWidth() && i < _image.getHeight()) {
            buffer_size = _image.getWidth();
          } else {
            buffer_size = _image.getHeight()-(i-_image.getWidth());
          }
        } else if (_image.getWidth() >= _image.getHeight()) {
          x_start=i;
          y_start=_image.getHeight()-1;
          if (i < _image.getHeight()) {
            buffer_size = i+1;
          } else if (i >= _image.getHeight() && i < _image.getWidth()) {
            buffer_size = _image.getHeight();
          } else {
            x_start=_image.getWidth()-1;
            y_start=(_image.getHeight()-1)-(i-_image.getWidth());
            buffer_size = _image.getHeight()-(i-_image.getWidth());
          }
        } else {
          println("[!] image dimension error in diagonal down (DD) logic");
        }

        // set buffer size
        px_image = new double[buffer_size][3];
        _maskStrip = new ArrayList<Integer>();
        for (int k = 0; k < buffer_size; k++) _maskStrip.add(0);
        // fill the buffer
        x=x_start;
        y=y_start;
        for (int j = 0; j < px_image.length; j++) {
          _image.getPixel(x,y,px_image[j]);
          x--;
          y--;
        }

        // perform sorting operations
        px_image = sortPixelArray(px_image, _maskStrip);

        // write the sorted pixels back to the buffer
        x=x_start;
        y=y_start;
        for (int j = 0; j < px_image.length; j++) {
          _image.setPixel(x, y, px_image[j]);
          if (_mask != null &&  _mask.get(y*_image.getWidth()+x) == 0) _mask.set(y*_image.getWidth()+x, _maskStrip.get(j));
          x--;
          y--;
        }
      }
      break;
    case 3: // Diagonal Up
      for (int i = 0; i < _image.getWidth()+_image.getHeight(); i++) {

        // logic for setting buffer size and x,y starting values
        if (_image.getWidth() < _image.getHeight()) {
          x_start=0;
          y_start=i;
          if (i < _image.getWidth()) {
            buffer_size = i+1;
          } else if (i >= _image.getWidth() && i < _image.getHeight()) {
            buffer_size = _image.getWidth();
          } else {
            x_start=i-_image.getHeight();
            y_start=_image.getHeight()-1;
            buffer_size = _image.getWidth()-(i -_image.getHeight());
          }
        } else if (_image.getWidth() >= _image.getHeight()) {
          x_start=i-_image.getHeight();
          y_start=_image.getHeight()-1;
          if (i < _image.getHeight()) {
            x_start=0;
            y_start=i;
            buffer_size = i+1;
          } else if ( i >= _image.getHeight() && i < _image.getWidth()) {
            buffer_size = _image.getHeight()-1;
          } else {
            buffer_size = _image.getHeight()-(i - _image.getWidth());
          }
        } else {
          println("[!] image dimension error in diagonal up (DU) logic");
        }

        // set buffer size
        px_image = new double[buffer_size][3];
        _maskStrip = new ArrayList<Integer>();
        for (int k = 0; k < buffer_size; k++) _maskStrip.add(0);
        // fill the buffer
        x=x_start;
        y=y_start;
        for (int j = 0; j < px_image.length; j++) {
          _image.getPixel(x,y,px_image[j]);
          x++;
          y--;
        }

        // perform sorting operations
        px_image = sortPixelArray(px_image, _maskStrip);

        // write the sorted pixels back to the buffer
        x=x_start;
        y=y_start;
        for (int j = 0; j < px_image.length; j++) {
          _image.setPixel(x, y, px_image[j]);
          if (_mask != null &&  _mask.get(y*_image.getWidth()+x) == 0) _mask.set(y*_image.getWidth()+x, _maskStrip.get(j));
          x++;
          y--;
        }
      }
      break;
    default:
      break;
    }
  }

  PImage sortPixels (PImage _image, ArrayList<Integer> _mask) {
    int[] px_image;
    int buffer_size = 0;
    ArrayList<Integer> _maskStrip;
    int x = 0;
    int y = 0; 
    int x_start = 0;
    int y_start = 0;
    _image.loadPixels();
    switch(sample_direction) {
    case 0: // Left / Right (X-axis)
      px_image = new int[_image.width]; 
      for (int a = 0; a < _image.height; a++) {
        _maskStrip = new ArrayList<Integer>();
        for (int b = 0; b < px_image.length; b++) {
          px_image[b] = _image.pixels[a*_image.width+b];
          _maskStrip.add(0);
        }

        px_image = sortPixelArray(px_image, _maskStrip);

        for (int b = 0; b < px_image.length; b++) {
          _image.pixels[a*_image.width+b] = px_image[b];
          if (_mask != null && _mask.get(a*_image.width+b) == 0) _mask.set(a*_image.width+b, _maskStrip.get(b));
        }
      }
      break; 
    case 1: // Up / Down (Y-axis)
      px_image = new int[_image.height];
      for (int a = 0; a < _image.width; a++) {
        _maskStrip = new ArrayList<Integer>();
        for (int b = 0; b < px_image.length; b++) {
          px_image[b] = _image.pixels[b*_image.width+a];
          _maskStrip.add(0);
        }

        px_image = sortPixelArray(px_image, _maskStrip);

        for (int b = 0; b < px_image.length; b++) {
          _image.pixels[b*_image.width+a] = px_image[b];
          if (_mask != null && _mask.get(b*_image.width+a) == 0) _mask.set(b*_image.width+a, _maskStrip.get(b));
        }
      }
      break;
    case 2: // Diagonal Down (left to right)
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
        px_image = new int[buffer_size];
        _maskStrip = new ArrayList<Integer>();
        for (int k = 0; k < buffer_size; k++) _maskStrip.add(0);
        // fill the buffer
        x=x_start;
        y=y_start;
        for (int j = 0; j < px_image.length; j++) {
          px_image[j] = _image.pixels[y*_image.width+x];
          x--;
          y--;
        }

        // perform sorting operations
        px_image = sortPixelArray(px_image, _maskStrip);

        // write the sorted pixels back to the buffer
        x=x_start;
        y=y_start;
        for (int j = 0; j < px_image.length; j++) {
          _image.pixels[y*_image.width+x]=px_image[j];
          if (_mask != null &&  _mask.get(y*_image.width+x) == 0) _mask.set(y*_image.width+x, _maskStrip.get(j));
          x--;
          y--;
        }
      }
      break;
    case 3: // Diagonal Up
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
        px_image=new int[buffer_size];
        _maskStrip = new ArrayList<Integer>();
        for (int k = 0; k < buffer_size; k++) _maskStrip.add(0);
        // fill the buffer
        x=x_start;
        y=y_start;
        for (int j = 0; j < px_image.length; j++) {
          px_image[j] = _image.pixels[y*_image.width+x];
          x++;
          y--;
        }

        // perform sorting operations
        px_image = sortPixelArray(px_image, _maskStrip);

        // write the sorted pixels back to the buffer
        x=x_start;
        y=y_start;
        for (int j = 0; j < px_image.length; j++) {
          _image.pixels[y*_image.width+x]=px_image[j];
          if (_mask != null &&  _mask.get(y*_image.width+x) == 0) _mask.set(y*_image.width+x, _maskStrip.get(j));
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

  int[] sortPixelArray(int[] _pxArray, ArrayList<Integer> _mask) {
    int min;
    int max;
    if (this.rgbMode) {
      int[] new_px = new int[_pxArray.length];
      for (int i = 0; i < new_px.length; i++) new_px[i] = 0xff000000;
      int[] channel = new int[_pxArray.length];
      for (int ch = 0; ch < 3; ch++) {
        for (int i = 0; i < _pxArray.length; i++) channel[i] = (_pxArray[i] >> (8*(2-ch))) & 0xff;
        min = int(rgbThresholds[ch].getArrayValue(0) * 255);
        max = int(rgbThresholds[ch].getArrayValue(1) * 255);
        channel = thresholdSort(min, max, channel, _mask);
        for (int i = 0; i < _pxArray.length; i++) {
          new_px[i] |= (channel[i] << (8*(2-ch)));
        }
      }
      for (int i = 0; i < _pxArray.length; i++) _pxArray[i] = new_px[i];
    } else {
      min = int(threshold.getArrayValue(0) * pow(2, 24));
      max = int(threshold.getArrayValue(1) * pow(2, 24));
      _pxArray = thresholdSort(min, max, _pxArray, _mask);
    }
    return _pxArray;
  }

  double[][] sortPixelArray(double[][] _pxArray, ArrayList<Integer> _mask) {
    if (this.rgbMode) {
      int[] channel;
      channel = new int[_pxArray.length];
      for (int ch = 0 ; ch < _pxArray[0].length; ch++) {
        for (int i = 0; i < _pxArray.length; i++) channel[i] = (int) _pxArray[i][ch];
        int min = int(rgbThresholds[ch].getArrayValue(0) * pow(2, 16));
        int max = int(rgbThresholds[ch].getArrayValue(1) * pow(2, 16));
        channel = thresholdSort(min, max, channel, _mask);
        for (int i = 0; i < _pxArray.length; i++) _pxArray[i][ch] = (double) channel[i];
      }
    } else {
      long min = (long)(threshold.getArrayValue(0) * (pow(2, 48)-1));
      long max = (long)(threshold.getArrayValue(1) * (pow(2, 48)-1));
      _pxArray = thresholdSort(min, max, _pxArray, _mask);
    }
    return _pxArray;
  }
  
  double[][] thresholdSort(long _min, long _max, double[][] _pixels, ArrayList<Integer> _maskStrip) {
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
      long pixel = longFromPixel(_pixels[i]); // strip alpha layer

      // switch for in and out point logic
      switch(this.threshold_mode) {
      case 0: // below min - in: <= min, out: > min
        if (!in_flag) {
          if (pixel <= _min) {
            in = i;
            in_flag=true;
          }
        } else if (!out_flag) {
          if (pixel > _min || ( i == _pixels.length-1)) {
            out = i;
            out_flag=true;
          }
        }
        break;
      case 1: // above min - in: >= min, out: < min
        if (!in_flag) {
          if (pixel >= _min) {
            in = i;
            in_flag=true;
          }
        } else if (!out_flag) {
          if (pixel < _min || ( i == _pixels.length-1 )) {
            out = i;
            out_flag=true;
          }
        }
        break;
      case 2: // above max - in: >= max, out: < max
        if (!in_flag) {
          if (pixel >= _max ) {
            in = i;
            in_flag=true;
          }
        } else if (!out_flag ) {
          if (pixel < _max || ( i == _pixels.length-1)) {
            out = i;
            out_flag=true;
          }
        }
        break;
      case 3: // below max - in: <= max, out: > max
        if (!in_flag) {
          if (pixel <= _max) {
            in = i;
            in_flag=true;
          }
        } else if (!out_flag ) {
          if (pixel > _max || ( i == _pixels.length-1)) {
            out = i;
            out_flag=true;
          }
        }
        break;
      case 4: // above min && below max - in: >= min && <= max, out: < min || > max
        if (!in_flag) {
          if (pixel >= _min && pixel <= _max) {
            in = i;
            in_flag=true;
          }
        } else if (!out_flag) {
          if (pixel < _min || pixel > _max || ( i == _pixels.length-1)) {
            out = i;
            out_flag=true;
          }
        }
        break;
      case 5:  // below min && above max - in: <= min || >= max, if in: <= min; then out: > min, else if in >= max; then out: < max
        if ( !in_flag ) {
          if ( pixel <= _min ) {
            in = i;
            in_flag=true;
            min_flag=true;
          } else if ( pixel >= _max) {
            in = i;
            in_flag=true;
            min_flag=false;
          }
        } else if ( !out_flag ) {
          if (min_flag) {
            if ( pixel > _min || ( i == _pixels.length-1)) {
              out = i;
              out_flag = true;
            }
          } else {
            if ( pixel < _max || ( i == _pixels.length-1)) {
              out = i;
              out_flag = true;
            }
          }
        }
        break;
      }

      if ( in_flag && out_flag ) {
        double[][] sample = new double[ out - in ][];

        for (int j = 0; j < sample.length; ++j) {
          sample[j]=_pixels[j+in];
        }
        //will work on the pixel by pixel sorting functionality for 24bit images later
        //if (quick) {
          Arrays.sort(sample, arrayComparator);
          if (reverse) Collections.reverse(Arrays.asList(sample));
        //} else {
        //  sample=pixelSort(sample);
        //}

        for (int j = 0; j < sample.length; ++j) {
          _pixels[j+in] = sample[j];
          _maskStrip.set(j+in, 255);
        }

        in_flag = false;
        out_flag = false;
      }
    }
    return _pixels;
  }

  int[] thresholdSort(int _min, int _max, int[] _pixels, ArrayList<Integer> _maskStrip) {
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
      int pixel = _pixels[i] & 0x00FFFFFF; // strip alpha layer
      // switch for in and out point logic
      switch(this.threshold_mode) {
      case 0: // below min - in: <= min, out: > min
        if (!in_flag) {
          if (pixel <= _min) {
            in = i;
            in_flag=true;
          }
        } else if (!out_flag) {
          if (pixel > _min || ( i == _pixels.length-1)) {
            out = i;
            out_flag=true;
          }
        }
        break;
      case 1: // above min - in: >= min, out: < min
        if (!in_flag) {
          if (pixel >= _min) {
            in = i;
            in_flag=true;
          }
        } else if (!out_flag) {
          if (pixel < _min || ( i == _pixels.length-1 )) {
            out = i;
            out_flag=true;
          }
        }
        break;
      case 2: // above max - in: >= max, out: < max
        if (!in_flag) {
          if (pixel >= _max ) {
            in = i;
            in_flag=true;
          }
        } else if (!out_flag ) {
          if (pixel < _max || ( i == _pixels.length-1)) {
            out = i;
            out_flag=true;
          }
        }
        break;
      case 3: // below max - in: <= max, out: > max
        if (!in_flag) {
          if (pixel <= _max) {
            in = i;
            in_flag=true;
          }
        } else if (!out_flag ) {
          if (pixel > _max || ( i == _pixels.length-1)) {
            out = i;
            out_flag=true;
          }
        }
        break;
      case 4: // above min && below max - in: >= min && <= max, out: < min || > max
        if (!in_flag) {
          if (pixel >= _min && pixel <= _max) {
            in = i;
            in_flag=true;
          }
        } else if (!out_flag) {
          if (pixel < _min || pixel > _max || ( i == _pixels.length-1)) {
            out = i;
            out_flag=true;
          }
        }
        break;
      case 5:  // below min && above max - in: <= min || >= max, if in: <= min; then out: > min, else if in >= max; then out: < max
        if ( !in_flag ) {
          if ( pixel <= _min ) {
            in = i;
            in_flag=true;
            min_flag=true;
          } else if ( pixel >= _max) {
            in = i;
            in_flag=true;
            min_flag=false;
          }
        } else if ( !out_flag ) {
          if (min_flag) {
            if ( pixel > _min || ( i == _pixels.length-1)) {
              out = i;
              out_flag = true;
            }
          } else {
            if ( pixel < _max || ( i == _pixels.length-1)) {
              out = i;
              out_flag = true;
            }
          }
        }
        break;
      }

      if ( in_flag && out_flag ) {
        int[] sample = new int[ out - in];

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
          _pixels[j+in] = sample[j];
          _maskStrip.set(j+in, 255);
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
