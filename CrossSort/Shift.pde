//pixel shifting

void shift(PImage _image, int _direction) {
  int[] temp;
  int start;
  int end;
  int index;
  int _random;

  switch(_direction) {
    
  case 0:
    index = 0;
    while (index < _image.height) {
      temp = new int[_image.width];
      start = index;
      end = start + int(random(500));
      if (end > _image.height) end = _image.height;
      index = end;
      _random = int(random(-50, 50));
      for (int y = start; y < end; y++) {
        for (int x = 0; x < _image.width; x++) {
          temp[x] = _image.pixels[y*_image.width+x];
        }
        temp = shiftPixels(temp, -int((y%45)*10>>3+3<<2)%temp.length);
        for (int x = 0; x < _image.width; x++) {
          _image.pixels[y*_image.width+x] = temp[x];
        }
      }
    }
    break;

  case 1:
    index=0;
    while (index < _image.width) {
      temp = new int[_image.height];
      start = index;
      end = start + int(random(500));
      if (end > _image.height) end = _image.height;
      index = end;
      _random = int(random(-50, 50));
      for (int x = start; x < end; x++) {
        for (int y = 0; y < _image.height; y++) {
          temp[y] = _image.pixels[y*_image.width+x];
        }
        temp = shiftPixels(temp, x);
        for (int y = 0; y < _image.height; y++) {
          _image.pixels[y*_image.width+x] = temp[y];
        }
      }
    }
    break;
  }
}

int[] shiftPixels(int[] _pixelArray, int _spaces) {
  int[] temp = new int[_pixelArray.length];
  for (int i = temp.length - 1; i >= 0; i-- ) {
    temp[(i - _spaces + temp.length) % temp.length] = _pixelArray[i];
  }
  return temp;
}
