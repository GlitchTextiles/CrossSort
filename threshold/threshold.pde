// rewrite of threshold based sorting

import controlP5.*;

ControlFrame gui;

//Control Frame Dimensions and Location
int GUIWidth = 500;
int GUIHeight = 225;
int GUILocationX = 0;
int GUILocationY = 0;

//DataViz Frame Dimensions and Location
int screen_width = 384;
int screen_height = 500;
int WindowLocationX = GUIWidth;
int WindowLocationY = 10;

PImage source;
PImage buffer;
String path;
boolean loaded = false;
boolean reverse = false;
int min = 128;
int max = 192;
int mode = 0;
ArrayList<Sample> samples;  

void setup() {
  size(0, 0);
  surface.setLocation(WindowLocationX, WindowLocationY);
  surface.setSize(screen_width, screen_height);
  gui = new ControlFrame(this, GUILocationX, GUILocationY, GUIWidth, GUIHeight);
  noLoop();
  noSmooth();
  background(0);
}

void draw() {
  if (buffer !=null) {
    buffer = thresholdSort(source.copy(), min, max);
    image(buffer, 0, 0);
  }
}

PImage thresholdSort(PImage _image, int _min, int _max) {

  _image.loadPixels();

  for (int y = 0; y < _image.height; ++y) {

    int in = 0;
    int out = 0;
    boolean in_flag = false;
    boolean out_flag = false;
    boolean min_flag = false;

    samples = new ArrayList<Sample>();

    // gather Samples
    for (int x = 0; x < _image.width; ++x) {
      int pixel = _image.pixels[y*_image.width+x];

      // switch for in and out point logic
      switch(mode) {
      case 0: // below min - in: <= min, out: > min
        if (!in_flag) {
          if (pixel <= color(_min)) {
            in = x;
            in_flag=true;
          }
        } else if (!out_flag || ( x == _image.width-1)) {
          if (pixel > color(_min)) {
            out = x;
            out_flag=true;
          }
        }
        break;
      case 1: // above min - in: >= min, out: < min
        if (!in_flag) {
          if (pixel >= color(_min)) {
            in = x;
            in_flag=true;
          }
        } else if (!out_flag || ( x == _image.width-1)) {
          if (pixel < color(_min)) {
            out = x;
            out_flag=true;
          }
        }
        break;
      case 2: // above max - in: >= max, out: < max
        if (!in_flag) {
          if (pixel >= color(_max)) {
            in = x;
            in_flag=true;
          }
        } else if (!out_flag || ( x == _image.width-1)) {
          if (pixel < color(_max)) {
            out = x;
            out_flag=true;
          }
        }
        break;
      case 3: // below max - in: <= max, out: > max
        if (!in_flag) {
          if (pixel <= color(_max)) {
            in = x;
            in_flag=true;
          }
        } else if (!out_flag || ( x == _image.width-1)) {
          if (pixel > color(_max)) {
            out = x;
            out_flag=true;
          }
        }
        break;
      case 4: // above min && = || below max - in: >= min && <= max, out: < min || > max
        if (!in_flag) {
          if (pixel >= color(_min) && pixel <= color(_max)) {
            in = x;
            in_flag=true;
          }
        } else if (!out_flag || ( x == _image.width-1)) {
          if (pixel < color(_min) || pixel > color(_max)) {
            out = x;
            out_flag=true;
          }
        }
        break;
      case 5:  // below min && above max. in: <= min || >= max, if in: <= min; then out: > min, else if in >= max; then out: < max
        if ( !in_flag ) {
          if ( pixel <= color(_min) ) {
            in = x;
            in_flag=true;
            min_flag=true;
          } else if ( pixel >= color(_max)) {
            in = x;
            in_flag=true;
            min_flag=false;
          }
        } else if ( !out_flag || ( x == _image.width-1) ) {
          if (min_flag) {
            if ( pixel > color(_min)) {
              out = x;
              out_flag = true;
            }
          } else {
            if ( pixel < color(_max)) {
              out = x;
              out_flag = true;
            }
          }
        }
        break;
      }

      if ( in_flag && out_flag ) {

         int[] sample = new int[ out - in ];
       
        for (int j = 0; j < sample.length; ++j) {
          sample[j]=_image.pixels[y*_image.width+(j+in)];
        }

        sample=sort(sample);

        if (reverse) sample=reverse(sample);

        for (int j = 0; j < sample.length; ++j) {
          _image.pixels[y*_image.width+(j+in)]=sample[j];
        }

        in_flag = false;
        out_flag = false;
      }
    }
  }
  _image.updatePixels();
  return _image;
}


class Sample {

  int in = 0;
  int out = 0;
  int[] data;

  Sample(int _in, int _out) {
    in = _in;
    out = _out;
    data = new int[_out - _in];
  }

  int[] applySort() {
    return data=sort(data);
  }

  int[] getSorted() {
    return sort(data);
  }

  int[] applyReverse() {
    return data=reverse(data);
  }

  int[] getReversed() {
    return reverse(data);
  }

  int[] reverseSort() {
    return reverse(sort(data));
  }
}
