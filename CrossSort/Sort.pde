//pixelsorting

PImage sortPixels (PImage _image, int _min, int _max) { 

  color[] px_buffer;

  int buffer_size = 0;

  int x = 0;
  int y = 0; 
  int x_start = 0;
  int y_start = 0;

  _image.loadPixels();

  // first comes the direction, let's use names that make sense:
  // UP, DOWN, LEFT, RIGHT

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

  if (DU) {
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
      px_buffer = thresholdSort(px_buffer, _min, _max, threshold_mode);

      // write the sorted pixels back to the buffer
      x=x_start;
      y=y_start;
      for (int j = 0; j < px_buffer.length; j++) {
        _image.pixels[y*_image.width+x]=px_buffer[j];
        x++;
        y--;
      }
    }
  }


  if (DD) {//  starting from 0, height-1 to width-1, 0 ; picks diagonal pixels from bottom right to upper left  

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
      px_buffer = thresholdSort(px_buffer, _min, _max, threshold_mode);

      // write the sorted pixels back to the buffer
      x=x_start;
      y=y_start;
      for (int j = 0; j < px_buffer.length; j++) {
        _image.pixels[y*_image.width+x]=px_buffer[j];
        x--;
        y--;
      }
    }
  }



  if (LR) { 
    px_buffer = new int[_image.width];    
    for (int a = 0; a < _image.height; a++) {
      for (int b = 0; b < px_buffer.length; b++) {
        px_buffer[b] = _image.pixels[a*_image.width+b];
      }
      px_buffer = thresholdSort(px_buffer, _min, _max, threshold_mode);
      for (int b = 0; b < px_buffer.length; b++) {
        _image.pixels[a*_image.width+b] = px_buffer[b];
      }
    }
  }


  if (UD) {
    px_buffer = new color[_image.height];   
    for (int a = 0; a < _image.width; a++) {
      for (int b = 0; b < px_buffer.length; b++) {
        px_buffer[b] = _image.pixels[b*_image.width+a];
      }
      px_buffer = thresholdSort(px_buffer, _min, _max, threshold_mode);
      for (int b = 0; b < px_buffer.length; b++) {
        _image.pixels[b*_image.width+a] = px_buffer[b];
      }
    }
  } 


  _image.updatePixels();
  return _image;
}

color[] pixelSort(color[] _pixels, int _sort_mode) {

  if (sort_by == 0) {
    switch(_sort_mode) { 
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

    switch(_sort_mode) { 
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

    switch(_sort_mode) { 
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

    switch(_sort_mode) { 
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
