//pixelsorting

PImage sortPixels (PImage _image, color _pos, color _neg, int _sort_mode, int _threshold_mode) { 

  color[] px_buffer;
  color[] r_buffer;
  color[] g_buffer;
  color[] b_buffer;

  int index = 0;
  int x = 0;
  int y = 0; 

  _image.loadPixels();

  // this really needs to be cleaned up...
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

  if (diagonal_a) {
    if (!color_mode_x) {
      
      // grab pixels
      for (int i = 0; i < _image.height; i++) {
        index = 0;
        x = 0;
        y = i;
        if (i < _image.width) {
          px_buffer = new color[i+1];
        } else {
          px_buffer = new color[_image.width];
        }
        while (x < _image.width && x <= i && y >= 0 && index < px_buffer.length) {
          px_buffer[index] = _image.pixels[y*_image.width+x];
          index++;
          x++;
          y--;
        }
        
        px_buffer = thresholdSort(px_buffer, _pos, _neg, _sort_mode >> 10 & 3, _threshold_mode >> 2 & 1);
        
        index=0;
        x=0;
        y=i;
        
        while (x < _image.width && x <= i && y >= 0 && index < px_buffer.length) {
          _image.pixels[y*_image.width+x]=px_buffer[index];
          index++;
          x++;
          y--;
        }
      }

      for (int i = 1; i < _image.width; i++) {
        index=0;
        x=i;
        y=_image.height-1;
        if (_image.width > _image.height && i < _image.width - _image.height) {
          px_buffer = new color[height];
        } else {
          px_buffer = new color[width - (x)];
        }
        while (x < _image.width && y >= 0  && index < px_buffer.length) {
          px_buffer[index] = _image.pixels[y*_image.width+x];
          index++;
          x++;
          y--;
        }

        px_buffer = thresholdSort(px_buffer, _pos, _neg, _sort_mode >> 10 & 3, _threshold_mode >> 2 & 1);

        index=0;
        x=i;
        y=_image.height-1;
        while (x < _image.width && y >= 0 && index < px_buffer.length) {
          _image.pixels[y*_image.width+x] = px_buffer[index];
          index++;
          x++;
          y--;
        }
      }
    } else {
      //RGB mode diagonal sorting
      for (int i = 0; i < _image.height; i++) {
        index = 0;
        x = 0;
        y = i;

        if (i < _image.width) {
          r_buffer = new color[i+1];
          g_buffer = new color[i+1];
          b_buffer = new color[i+1];
        } else {
          r_buffer = new color[_image.width];
          g_buffer = new color[_image.width];
          b_buffer = new color[_image.width];
        }

        while (x < _image.width && x <= i && y >= 0 && index < r_buffer.length) {

          r_buffer[index] = _image.pixels[y*_image.width+x] >> 16 & 0xFF;
          g_buffer[index] = _image.pixels[y*_image.width+x] >> 8 & 0xFF;
          b_buffer[index] = _image.pixels[y*_image.width+x] & 0xFF;
          index++;
          x++;
          y--;
        }

        r_buffer = thresholdSort(r_buffer, _pos >> 16 & 0xFF, _neg >> 16 & 0xFF, _sort_mode >> 10 & 3, _threshold_mode >> 2 & 1);
        g_buffer = thresholdSort(g_buffer, _pos >> 8 & 0xFF, _neg >> 8 & 0xFF, _sort_mode >> 8 & 3, _threshold_mode >> 1 & 1);
        b_buffer = thresholdSort(b_buffer, _pos & 0xFF, _neg & 0xFF, _sort_mode >> 6 & 3, _threshold_mode & 1);

        index=0;
        x=0;
        y=i;
        while (x < _image.width && x <= i && y >= 0 && index < r_buffer.length) {

          _image.pixels[y*_image.width+x]= 255 << 24 | r_buffer[index] << 16 | g_buffer[index] << 8 | b_buffer[index];

          index++;
          x++;
          y--;
        }
      }

      for (int i = 1; i < _image.width; i++) {
        index=0;
        x=i;
        y=_image.height-1;

        if (_image.width > _image.height && i < _image.width - _image.height) {
          r_buffer = new color[height];
          g_buffer = new color[height];
          b_buffer = new color[height];
        } else {
          r_buffer = new color[width - (x)];
          g_buffer = new color[width - (x)];
          b_buffer = new color[width - (x)];
        }

        while (x < _image.width && y >= 0 && index < r_buffer.length) {
          r_buffer[index] = _image.pixels[y*_image.width+x] >> 16 & 0xFF;
          g_buffer[index] = _image.pixels[y*_image.width+x] >> 8 & 0xFF;
          b_buffer[index] = _image.pixels[y*_image.width+x] & 0xFF;
          index++;
          x++;
          y--;
        }

        r_buffer = thresholdSort(r_buffer, _pos >> 16 & 0xFF, _neg >> 16 & 0xFF, _sort_mode >> 10 & 3, _threshold_mode >> 2 & 1);
        g_buffer = thresholdSort(g_buffer, _pos >> 8 & 0xFF, _neg >> 8 & 0xFF, _sort_mode >> 8 & 3, _threshold_mode >> 1 & 1);
        b_buffer = thresholdSort(b_buffer, _pos & 0xFF, _neg & 0xFF, _sort_mode >> 6 & 3, _threshold_mode & 1);

        index=0;
        x=i;
        y=_image.height-1;
        while (x < _image.width && y >= 0 && index < r_buffer.length) {
          _image.pixels[y*_image.width+x]= 255 << 24 | r_buffer[index] << 16 | g_buffer[index] << 8 | b_buffer[index];
          index++;
          x++;
          y--;
        }
      }
    }
  }

  if (diagonal_b) {//  starting from 0, height-1 to width-1, 0 ; picks diagonal pixels from bottom right to upper left  

    for (int i = 0; i < _image.width; i++) {
      index = 0;
      x = i;
      y = _image.height-1;

      if (_image.width > _image.height && i >= _image.height) {
        px_buffer = new color[_image.height];
      } else {
        px_buffer= new color[i+1];
      }

      while ( x >= 0 && y >=0 && index < px_buffer.length) {
        px_buffer[index]=_image.pixels[y*_image.width+x];
        _image.pixels[y*_image.width+x]=0;
        x--;
        y--;
        index++;
      }

      px_buffer = thresholdSort(px_buffer, _pos, _neg, _sort_mode >> 10 & 3, _threshold_mode >> 2 & 1);

      index = 0;
      x = i;
      y = _image.height-1;
      while ( x >=0 && y >=0 && index < px_buffer.length) {
        _image.pixels[y*_image.width+x]=px_buffer[index];
        x--;
        y--;
        index++;
      }
    }

    for (int i = 1; i < _image.height; i++) {
      index = 0;

      x = _image.width - 1;
      y = _image.height - 1 - i;
      if (_image.height > _image.width && i < _image.width -1 ) {
        px_buffer = new color[_image.width];
      } else {
        px_buffer = new color[_image.height - i];
      }

      while (x >= 0 && y >= 0 && index < px_buffer.length) {
        px_buffer[index]=_image.pixels[y*_image.width+x];
        x--;
        y--;
        index++;
      }

      px_buffer = thresholdSort(px_buffer, _pos, _neg, _sort_mode >> 10 & 3, _threshold_mode >> 2 & 1);


      index = 0;
      x = _image.width - 1;
      y = _image.height - 1 - i;

      while (x >= 0 && y >= 0 && index < px_buffer.length) {
        _image.pixels[y*_image.width+x]=px_buffer[index];
        x--;
        y--;
        index++;
      }
    }
  }



  if (sort_x) {

    if (!color_mode_x) {
      px_buffer = new int[_image.width];    
      for (int a = 0; a < _image.height; a++) {
        for (int b = 0; b < px_buffer.length; b++) {
          px_buffer[b] = _image.pixels[a*_image.width+b];
        }
        px_buffer = thresholdSort(px_buffer, _pos, _neg, _sort_mode >> 10 & 3, _threshold_mode >> 2 & 1);
        for (int b = 0; b < px_buffer.length; b++) {
          _image.pixels[a*_image.width+b] = px_buffer[b];
        }
      }
    } else {
      r_buffer = new int[_image.width];
      g_buffer = new int[_image.width];
      b_buffer = new int[_image.width];

      for (int a = 0; a < _image.height; a++) {
        for (int b = 0; b < r_buffer.length; b++) {
          r_buffer[b] = _image.pixels[a*_image.width+b] >> 16 & 0xFF;
          g_buffer[b] = _image.pixels[a*_image.width+b] >> 8 & 0xFF;
          b_buffer[b] = _image.pixels[a*_image.width+b] & 0xFF;
        }

        r_buffer = thresholdSort(r_buffer, _pos >> 16 & 0xFF, _neg >> 16 & 0xFF, _sort_mode >> 10 & 3, _threshold_mode >> 2 & 1);
        g_buffer = thresholdSort(g_buffer, _pos >> 8 & 0xFF, _neg >> 8 & 0xFF, _sort_mode >> 8 & 3, _threshold_mode >> 1 & 1);
        b_buffer = thresholdSort(b_buffer, _pos & 0xFF, _neg & 0xFF, _sort_mode >> 6 & 3, _threshold_mode & 1);

        for (int b = 0; b < r_buffer.length; b++) {
          _image.pixels[a*_image.width+b]= 255 << 24 | r_buffer[b] << 16 | g_buffer[b] << 8 | b_buffer[b];
        }
      }
    }
  }

  if (sort_y) {
    if (!color_mode_y) {
      px_buffer = new color[_image.height];   
      for (int a = 0; a < _image.width; a++) {
        for (int b = 0; b < px_buffer.length; b++) {
          px_buffer[b] = _image.pixels[b*_image.width+a];
        }
        px_buffer = thresholdSort(px_buffer, _pos, _neg, _sort_mode >> 4 & 3, _threshold_mode >> 2  & 1);
        for (int b = 0; b < px_buffer.length; b++) {
          _image.pixels[b*_image.width+a] = px_buffer[b];
        }
      }
    } else {
      r_buffer = new color[_image.height];
      g_buffer = new color[_image.height];
      b_buffer = new color[_image.height];

      for (int a = 0; a < _image.width; a++) {
        for (int b = 0; b < r_buffer.length; b++) {
          r_buffer[b] = _image.pixels[b*_image.width+a] >> 16 & 0xFF;
          g_buffer[b] = _image.pixels[b*_image.width+a] >> 8 & 0xFF;
          b_buffer[b] = _image.pixels[b*_image.width+a] & 0xFF;
        }
        r_buffer = thresholdSort(r_buffer, _pos >> 16 & 0xFF, _neg >> 16 & 0xFF, _sort_mode >> 4 & 3, _threshold_mode >> 2 & 1);
        g_buffer = thresholdSort(g_buffer, _pos >> 8 & 0xFF, _neg >> 8 & 0xFF, _sort_mode >> 2 & 3, _threshold_mode >> 1 & 1);
        b_buffer = thresholdSort(b_buffer, _pos & 0xFF, _neg & 0xFF, _sort_mode & 3, _threshold_mode & 1);

        for (int b = 0; b < r_buffer.length; b++) {
          _image.pixels[b*_image.width+a]= 255 << 24 | r_buffer[b] << 16 | g_buffer[b] << 8 | b_buffer[b];
        }
      }
    }
  }

  _image.updatePixels();
  return _image;
}

color[] thresholdSort(color[] _array, int _threshold_pos, int _threshold_neg, int _sort_mode, int _mode) {

  color[] _buffer;
  boolean section = false;
  int beginning = 0;
  int section_length=0;

  switch(_mode) {

    //sorts above threshold  
  case 0:
    for (int i = 0; i < _array.length; i++) {
      if (_array[i] >= _threshold_pos && !section) {
        section = true;
        section_length=1;
        beginning = i;
      } else if (_array[i] >= _threshold_neg && section) {
        section_length++;
      }
      if (_array[i] < _threshold_neg && section || i >= _array.length-1) {
        _buffer = new color[section_length];
        for (int j = 0; j < _buffer.length; j++) {
          _buffer[j] = _array[beginning+j];
        }
        if (!quick) {
          _buffer = pixelSort(_buffer, _sort_mode);
        } else {
          _buffer = sort(_buffer);
        }
        section = false;
        for (int k = 0; k < _buffer.length; k++) {
          _array[beginning+k] = _buffer[k];
        }
      }
    }
    break;

    //sorts below threshold
  case 1:
    for (int i = 0; i < _array.length; i++) {
      if (_array[i] <= _threshold_neg && !section) {
        section = true;
        section_length=1;
        beginning = i;
      } else if (_array[i] <= _threshold_pos && section) {
        section_length++;
      }
      if (_array[i] > _threshold_pos && section || i >= _array.length-1) {
        _buffer = new color[section_length];
        for (int j = 0; j < _buffer.length; j++) {
          _buffer[j] = _array[beginning+j];
        }
        if (!quick) {
          _buffer = pixelSort(_buffer, _sort_mode);
        } else {
          _buffer = sort(_buffer);
        }
        section = false;
        for (int k = 0; k < _buffer.length; k++) {
          _array[beginning+k] = _buffer[k];
        }
      }
    }
    break;
  }
  return _array;
}

color[] pixelSort(color[] _pixelArray, int _sort_mode) {

  if (sort_by == 0) {
    switch(_sort_mode) { 
    case 0:
      for (int i = 0; i < _pixelArray.length-1; i++) {
        if (_pixelArray[i] < _pixelArray[i+1]) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }
      break;
    case 1:
      for (int i = 0; i < _pixelArray.length-1; i++) {
        if (_pixelArray[i] > _pixelArray[i+1]) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }

      break;
    case 2:
      for (int i = _pixelArray.length-2; i >= 0; i--) {
        if (_pixelArray[i] < _pixelArray[i+1]) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }

      break;
    case 3:
      for (int i = _pixelArray.length-2; i >= 0; i--) {
        if (_pixelArray[i] > _pixelArray[i+1]) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }
      break;
    }
  } else if (sort_by == 1) {

    switch(_sort_mode) { 
    case 0:
      for (int i = 0; i < _pixelArray.length-1; i++) {
        if (hue(_pixelArray[i]) < hue(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }
      break;
    case 1:
      for (int i = 0; i < _pixelArray.length-1; i++) {
        if (hue(_pixelArray[i]) > hue(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }

      break;
    case 2:
      for (int i = _pixelArray.length-2; i >= 0; i--) {
        if (hue(_pixelArray[i]) < hue(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }

      break;
    case 3:

      for (int i = _pixelArray.length-2; i >= 0; i--) {
        if (hue(_pixelArray[i]) > hue(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }
      break;
    }
  } else if (sort_by == 2) {

    switch(_sort_mode) { 
    case 0:
      for (int i = 0; i < _pixelArray.length-1; i++) {
        if (brightness(_pixelArray[i]) < brightness(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }
      break;
    case 1:
      for (int i = 0; i < _pixelArray.length-1; i++) {
        if (brightness(_pixelArray[i]) > brightness(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }

      break;
    case 2:
      for (int i = _pixelArray.length-2; i >= 0; i--) {
        if (brightness(_pixelArray[i]) < brightness(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }

      break;
    case 3:
      for (int i = _pixelArray.length-2; i >= 0; i--) {
        if (brightness(_pixelArray[i]) > brightness(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }
      break;
    }
  } else if (sort_by == 3) {

    switch(_sort_mode) { 
    case 0:
      for (int i = 0; i < _pixelArray.length-1; i++) {
        if (saturation(_pixelArray[i]) < saturation(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }
      break;
    case 1:
      for (int i = 0; i < _pixelArray.length-1; i++) {
        if (saturation(_pixelArray[i]) > saturation(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }

      break;
    case 2:
      for (int i = _pixelArray.length-2; i >= 0; i--) {
        if (saturation(_pixelArray[i]) < saturation(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }

      break;
    case 3:

      for (int i = _pixelArray.length-2; i >= 0; i--) {
        if (saturation(_pixelArray[i]) > saturation(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }
      break;
    }
  }

  return _pixelArray;
}


int[] swapPixels(int[] _pixels, int _index1, int _index2) {
  int pixel = _pixels[_index1];
  _pixels[_index1] = _pixels[_index2];
  _pixels[_index2] = pixel;
  return _pixels;
}
