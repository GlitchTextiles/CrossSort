SecondApplet sa;
PGraphics graphic;

void setup() {
  size(10, 10);
  surface.setSize(150, 150);
  surface.setLocation(0, 0);
  String[] args = {"TwoFrameTest"};
  sa = new SecondApplet();
  PApplet.runSketch(args, sa);
  sa.setLocation(width, 0);
  graphic = createGraphics(400, 400);
  graphic.noSmooth();
}

void draw() {
  background(0);

  graphic.beginDraw();
  graphic.fill(frameCount % 256);
  graphic.stroke(255 - (frameCount % 256));
  graphic.background(255);
  graphic.ellipse(graphic.width/2, graphic.height/2, 100, 100);
  graphic.endDraw();

  sa.display(graphic);
}

public class SecondApplet extends PApplet {

  color fillColor = 0, backgroundColor = 255;
  PImage image;

  public void settings() {
    size(200, 100);
  }

  public void draw() {
    if (image != null) {
      image(image, 0, 0);
    } else {
      background(backgroundColor);
    }
  }

  public void display(PGraphics _graphic) {
    surface.setSize(_graphic.width, _graphic.height);
    image = _graphic.copy();
  }

  public void setLocation(int _x, int _y) {
    surface.setLocation(_x, _y);
  }
}
