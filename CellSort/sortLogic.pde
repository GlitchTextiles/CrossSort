void cellSort(PImage _image) {

  _image.loadPixels();

  switch( rasterDirection ) {
  case 0: // top to bottom, left to right
    for (int y = 0; y < _image.height; y++) {
      for (int x = 0; x < _image.width; x++) {
        swapPixels(_image, x, y);
      }
    }
    break;
  case 1: // top to bottom, right to left
    for (int y = 0; y < _image.height; y++) {
      for (int x = _image.width-1; x >=0; x--) {
        swapPixels(_image, x, y);
      }
    }
  case 2: // bottom to top, left to right
    for (int y = _image.height-1; y >= 0; y--) {
      for (int x = 0; x < _image.width; x++) {
        swapPixels(_image, x, y);
      }
    }
    break;
  case 3: // bottom to top, right to left
    for (int y = _image.height-1; y >= 0; y--) {
      for (int x = _image.width-1; x >=0; x--) {
        swapPixels(_image, x, y);
      }
    }
    break;
  }

  _image.updatePixels();
}

void swapPixels(PImage _image, int _x, int _y) {
  
  Pixel current = new Pixel(_x, _y, _image.pixels[_y*_image.width+_x]);
  Pixel neighbor = current.copy();
  Pixel swap = current.copy();

  if (threshold(current, min, max, thresholdMode)) {

    // iterate through surrounding cells
    for (int y2 = 0; y2 < 3; y2 ++) {
      for (int x2 = 0; x2 < 3; x2 ++) {
        // if the cell is enabled
        if (rules[x2][y2]) {

          int xn = _x + (x2-1);
          int yn = _y + (y2-1);

          // wrap the neighbor coordinates around boundary
          if (wrap) {
            xn = (xn + _image.width) % _image.width;
            yn = (yn + _image.height) % _image.height;
          }

          if ( isInBounds(_image, xn, yn) ) { // if not wrapped, this ignores neighbor coordinates beyond image boundaries
            neighbor = new Pixel(xn, yn, _image.pixels[yn*_image.width+xn]);
            // comparison logic
            if (compare(current, neighbor, compareMode) && threshold(neighbor, min, max, thresholdMode)) {
              if (compare(swap, neighbor, compareMode)) {
                swap = neighbor.copy();
              }
            }
          }
        }
      }
    }
    _image.pixels[current.getY()*_image.width+current.getX()] = swap.getColor();
    _image.pixels[swap.getY()*_image.width+swap.getX()] = current.getColor();
  }
}

boolean isInBounds(PImage _image, int _x, int _y) {
  return _x < _image.width && _x >= 0 && _y < _image.height && _y >= 0;
}

boolean threshold(Pixel _px, color _min, color _max, String _mode) {
  switch(_mode) {
  case "<RGB>": //RGB pixel value is > min and < max
    return _px.isGreater(_min) && !_px.isGreater(_max);
  case ">RGB<": //RGB pixel value is < min and > max
    return  !(_px.isGreater(_min) && !_px.isGreater(_max));
  case "<HUE>":
    return _px.hIsGreater(_min) && !_px.hIsGreater(_max);
  case ">HUE<":
    return !(_px.hIsGreater(_min) && !_px.hIsGreater(_max));
  case "<SAT>":
    return _px.sIsGreater(_min) && !_px.sIsGreater(_max);
  case ">SAT<":
    return !(_px.sIsGreater(_min) && !_px.sIsGreater(_max));
  case "<VAL>":
    return _px.vIsGreater(_min) && !_px.vIsGreater(_max);
  case ">VAL<":
    return !(_px.vIsGreater(_min) && !_px.vIsGreater(_max));
  case "<RED>":
    return _px.rIsGreater(_min) && !_px.rIsGreater(_max);
  case ">RED<":
    return !(_px.rIsGreater(_min) && !_px.rIsGreater(_max));
  case "<GRN>":
    return _px.gIsGreater(_min) && !_px.gIsGreater(_max);
  case ">GRN<":
    return !(_px.gIsGreater(_min) && !_px.gIsGreater(_max));
  case "<BLU>":
    return _px.bIsGreater(_min) && !_px.bIsGreater(_max);
  case ">BLU<":
    return !(_px.bIsGreater(_min) && !_px.bIsGreater(_max));
  default:
    return false;
  }
}

boolean compare(Pixel _px1, Pixel _px2, String _mode) {
  switch(_mode) {
  case "RGB<":
    return _px2.isGreater(_px1);
  case "RGB>":
    return _px1.isGreater(_px2);
  case "HUE<":
    return _px2.hIsGreater(_px1);
  case "HUE>":
    return _px1.hIsGreater(_px2);
  case "SAT<":
    return _px2.sIsGreater(_px1);
  case "SAT>":
    return _px1.sIsGreater(_px2);
  case "VAL<":
    return _px2.vIsGreater(_px1);
  case "VAL>":
    return _px1.vIsGreater(_px2);
  case "RED<":
    return _px2.rIsGreater(_px1);
  case "RED>":
    return _px1.rIsGreater(_px2);
  case "GRN<":
    return _px2.gIsGreater(_px1);
  case "GRN>":
    return _px1.gIsGreater(_px2);
  case "BLU<":
    return _px2.bIsGreater(_px1);
  case "BLU>":
    return _px1.bIsGreater(_px2);
  default:
    return false;
  }
}
