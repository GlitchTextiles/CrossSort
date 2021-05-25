import controlP5.*;

ControlP5 cp5;
Tests tests;

void setup() {
  size(400, 400);
  cp5 = new ControlP5( this );
  tests = new Tests();
}

void draw() {
  background(20);
}

void keyPressed() {
  switch(key) {
  case '=':
    tests.add();
    break;
  case '-':
    tests.remove();
    break;
  }
}

class Tests {
  ArrayList<Test> tests;
  Accordion accordion;

  Tests() {
    tests = new ArrayList<Test>();
    accordion = cp5.addAccordion("Items");
  }

  void add() {
    tests.add(new Test("Operation "+tests.size()));
    accordion.addItem(tests.get(tests.size()-1).group);
  }

  void remove() {
    if (tests.size() >0) {
      tests.get(tests.size()-1).group.remove();
      tests.remove(tests.size()-1);
    }
  }
}

class Test {

  int value;
  Group group;

  Test( String thePrefix ) {

    group = cp5.addGroup(thePrefix)
      .setPosition(100, 100)
      .setBackgroundColor(color(0, 64))
      .setBackgroundHeight(150)
      ;

    cp5.addBang("bang"+thePrefix)
      .setPosition(0, 0)
      .setSize(100, 100)
      .moveTo(group)
      .plugTo(this, "shuffle");
    ;
  }

  void setValue(int theValue) {
    value = theValue;
  }
}
