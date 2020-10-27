

color[] thresholdSort(color[] _pixels, int _min, int _max, int _mode) {

  int in = 0;
  int out = 0;

  boolean in_flag = false;
  boolean out_flag = false;
  boolean min_flag = false;

  // gather Samples
  for (int i = 0; i < _pixels.length; ++i) {
    int pixel = _pixels[i];

    // switch for in and out point logic
    switch(_mode) {
    case 0: // below min - in: <= min, out: > min
      if (!in_flag) {
        if (pixel <= color(_min)) {
          in = i;
          in_flag=true;
        }
      } else if (!out_flag || ( i == _pixels.length-1)) {
        if (pixel > color(_min)) {
          out = i;
          out_flag=true;
        }
      }
      break;
    case 1: // above min - in: >= min, out: < min
      if (!in_flag) {
        if (pixel >= color(_min)) {
          in = i;
          in_flag=true;
        }
      } else if (!out_flag || ( i == _pixels.length-1)) {
        if (pixel < color(_min)) {
          out = i;
          out_flag=true;
        }
      }
      break;
    case 2: // above max - in: >= max, out: < max
      if (!in_flag) {
        if (pixel >= color(_max)) {
          in = i;
          in_flag=true;
        }
      } else if (!out_flag || ( i == _pixels.length-1)) {
        if (pixel < color(_max)) {
          out = i;
          out_flag=true;
        }
      }
      break;
    case 3: // below max - in: <= max, out: > max
      if (!in_flag) {
        if (pixel <= color(_max)) {
          in = i;
          in_flag=true;
        }
      } else if (!out_flag || ( i == _pixels.length-1)) {
        if (pixel > color(_max)) {
          out = i;
          out_flag=true;
        }
      }
      break;
    case 4: // above min && = || below max - in: >= min && <= max, out: < min || > max
      if (!in_flag) {
        if (pixel >= color(_min) && pixel <= color(_max)) {
          in = i;
          in_flag=true;
        }
      } else if (!out_flag || ( i == _pixels.length-1)) {
        if (pixel < color(_min) || pixel > color(_max)) {
          out = i;
          out_flag=true;
        }
      }
      break;
    case 5:  // below min && above max. in: <= min || >= max, if in: <= min; then out: > min, else if in >= max; then out: < max
      if ( !in_flag ) {
        if ( pixel <= color(_min) ) {
          in = i;
          in_flag=true;
          min_flag=true;
        } else if ( pixel >= color(_max)) {
          in = i;
          in_flag=true;
          min_flag=false;
        }
      } else if ( !out_flag || ( i == _pixels.length-1) ) {
        if (min_flag) {
          if ( pixel > color(_min)) {
            out = i;
            out_flag = true;
          }
        } else {
          if ( pixel < color(_max)) {
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
        // bubble sort logic goes here
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
