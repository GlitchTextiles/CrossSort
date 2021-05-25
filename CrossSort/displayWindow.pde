public class DisplayWindow extends PApplet {

  PImage image;
  int w, h, x, y;
  
  public DisplayWindow(int _x, int _y, int _w, int _h) {
    w=_w;
    h=_h;
    x=_x;
    y=_y;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(w, h);
  }
  
  public void setup(){
    frameRate(30);
    surface.setLocation(x, y);
  }

  public void draw() {
    if (image != null) {
      image(image, 0, 0);
    } else {
      background(0);
    }
  }

  public void display(PImage _image) {
    if (width != _image.width && height != _image.height) {
      surface.setSize(_image.width, _image.height);
    }
    image = _image;
  }

  public void setLocation(int _x, int _y) {
    surface.setLocation(_x, _y);
  }
}
