color[] thresholdSort(color[] _pixels, int _min, int _max, int _threshold_mode) {
  
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
    // 
    switch(sort_by){
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
    switch(_threshold_mode) {
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
    case 4: // above min && below max - in: >= min && <= max, out: < min || > max
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
    case 5:  // below min && above max - in: <= min || >= max, if in: <= min; then out: > min, else if in >= max; then out: < max
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
