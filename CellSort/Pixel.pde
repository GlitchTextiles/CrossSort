private class Pixel {
  int x;
  int y;
  color c;
  
  public Pixel(int _x, int _y, color _c){
    x=_x;
    y=_y;
    c=_c;
  }
  
  public boolean isGreater(Pixel _px){
    return this.c > _px.getColor();
  }
  
  public boolean hIsGreater(Pixel _px){
    return hue(this.c) > hue(_px.getColor());
  }
  
  public boolean sIsGreater(Pixel _px){
    return saturation(this.c) > saturation(_px.getColor());
  }
  
  public boolean vIsGreater(Pixel _px){
   return brightness(this.c) > brightness(_px.getColor());
  }
  
  public boolean rIsGreater(Pixel _px){
    return red(this.c) > red(_px.getColor());
  }
  
  public boolean gIsGreater(Pixel _px){
    return green(this.c) > green(_px.getColor());
  }
  
  public boolean bIsGreater(Pixel _px){
    return blue(this.c) > blue(_px.getColor());
  }
  
  public boolean isGreater(color _c){
    return this.c > _c;
  }
  
  public boolean hIsGreater(color _c){
    return hue(this.c) > red(_c);
  }
  
  public boolean sIsGreater(color _c){
    return saturation(this.c) > red(_c);
  }
  
  public boolean vIsGreater(color _c){
    return brightness(this.c) > red(_c);
  }
  
  public boolean rIsGreater(color _c){
    return red(this.c) > red(_c);
  }
  
  public boolean gIsGreater(color _c){
    return green(this.c) > green(_c);
  }
  
  public boolean bIsGreater(color _c){
    return blue(this.c) > blue(_c);
  }
  
  public Pixel get(){
    return this;
  }
  
  public Pixel copy(){
    return new Pixel(this.x, this.y, this.c);
  }
  
  public Pixel set(Pixel _px){
    this.x = _px.x;
    this.y = _px.y;
    this.c = _px.c;
    return this;
  }
  
  public int getX(){
    return this.x;
  }
  
  public int getY(){
    return this.y;
  }
  
  public color getColor(){
   return this.c;
  }
}
