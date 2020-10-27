//////////////////////////////////////////////
// GUI
//////////////////////////////////////////////

public class ControlFrame extends PApplet {

  int w, h, x, y;
  PApplet parent;
  ControlP5 cp5;
  float value = 0.0;

  public ControlFrame(PApplet _parent, int _x, int _y, int _w, int _h) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    x=_x;
    y=_y;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(w, h);
  }

  public void setup() {
    surface.setLocation(x, y);
    cp5 = new ControlP5(this);
    background(0);
  }

  void draw() {
    background(0);
  }
  
  /////////////////////////////////////////////////////////
  // Methods for the controlFrame

  public void mouseReleased() {
    parent.redraw();
  }
}
