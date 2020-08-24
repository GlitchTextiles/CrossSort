PImage image;
String path;

int min = 64;
int max = 192;

void setup(){
  size(0,0);
}

void draw(){
  markThreshold(image, min, max);
}

void markThreshold(PImage _image, int _min, int _max){
  
  int in = 0;
  int out = 0;
  boolean in_flag = false;
  boolean out_flag = false;
  
  _image.loadPixels();
  
  for(int i = 0 ; i < _image.width ; ++i){
    
    if( _image.pixels[i] > color(_min) && !in_flag){
      in = i;
      in_flag = true;
    } else if ( _image.pixels[i] > color(_max) && in_flag && !out_flag){
      out = i;
      out_flag = true;
    }
    
    if ( in_flag && out_flag ){
      color[] sample = new int[out - in];
      
      for (int j = 0 ; j < sample; ++j){
        
      }
      
      in_flag = false;
      out_flag = false;
    }
    
  }
}
