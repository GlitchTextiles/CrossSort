////////////////////////////////////////////////////////////////
// For comparing 48bit RGB pixel values stored as double[]


/*

 package com.tutorialspoint;
 
 import java.lang.*;
 
 public class DoubleDemo {
 
 public static void main(String[] args) {
 
 // compares two Double objects numerically
 Double obj1 = new Double("8.5");
 Double obj2 = new Double("11.50");
 int retval =  obj1.compareTo(obj2);
 
 if(retval > 0) {
 System.out.println("obj1 is greater than obj2");
 } else if(retval < 0) {
 System.out.println("obj1 is less than obj2");
 } else {
 System.out.println("obj1 is equal to obj2");
 }
 }
 }  
 */
Comparator<double[]> arrayComparator = new Comparator<double[]>() {
  @Override
    public int compare(double[] o1, double[] o2) {
    return compareDoubleArrays(o1,o2);
  }
};

int compareDoubleArrays(double[] a, double[] b) {
  if (eq(a, b)) {
    return 0;
  } else if (lt(a, b)) {
    return -1;
  } else if (gt(a, b)) {
    return 1;
  } else {
    return 0;
  }
}

boolean gte(double[] a, double[] b) {
  if (a.length == b.length) {
    if (Arrays.equals(a, b)) {
      return true;
    } else {
      return gt(a, b);
    }
  }
  return false;
}

boolean gt(double[] a, double[] b) {
  if (a.length == b.length) {
    for (int i = 0; i < a.length; i++) {
      if (a[i] == b[i] ) {
      } else {
        return a[i] > b[i];
      }
    }
  }
  return false;
}

boolean lt(double[] a, double[] b) {
  if (a.length == b.length) {
    for (int i = 0; i < a.length; i++) {
      if (a[i] == b[i] ) {
      } else {
        return a[i] < b[i];
      }
    }
  }
  return false;
}

boolean lte(double[] a, double[] b) {
  if (a.length == b.length) {
    if (Arrays.equals(a, b)) {
      return true;
    } else {
      return lt(a, b);
    }
  }
  return false;
}

boolean eq(double[] a, double[]b) {
  return Arrays.equals(a, b);
}

////////////////////////////////////////////////////////////////
// for obtaining the average value of a 48bit RGB pixel

float pixelRGBAvg(double[] _pixel) {
  float sum = 0;
  for (int i = 0; i < _pixel.length; i++) {
    sum += (float) _pixel[i];
  }
  return sum/(float)_pixel.length;
}

////////////////////////////////////////////////////////////////
// BufferedImage to PImage

PImage bufferedImageToPImage(BufferedImage _img) {
  if (_img != null) {
    PImage _image = createImage(_img.getWidth(), _img.getHeight(), RGB);
    _image.loadPixels();
    for (int y = 0; y<_image.height; y++) {
      for (int x = 0; x < _image.width; x++) {
        _image.pixels[y*_image.width+x] = _img.getRGB(x, y) | 0xff << 24;
      }
    }
    _image.updatePixels();
    return _image;
  } else {
    return null;
  }
}
////////////////////////////////////////////////////////////////
// WritableRaster to PImage

PImage wrToPImage(WritableRaster _wr) {
  PImage _image = createImage(_wr.getWidth(), _wr.getHeight(), RGB);
  _image.loadPixels();
  for (int y = 0; y<_image.height; y++) {
    for (int x = 0; x < _image.width; x++) {
      _image.pixels[y*_image.width+x] =  _wr.getSample(x, y, 3) << 24 | _wr.getSample(x, y, 0) << 16 | _wr.getSample(x, y, 1) << 8 | _wr.getSample(x, y, 2);
    }
  }
  _image.updatePixels();
  return _image;
}
