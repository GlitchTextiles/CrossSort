public class LFO {

  private float angle=0.0f, phase=0.0f, rate=0.0f;
  private float min=0.0f,max=1.0f;
  
  public LFO(float _rate, float _angle, float _phase) {
    this.rate = _rate;
    this.angle = _angle;
    this.phase = _phase;
  }

  public LFO(float _rate, float _phase) {
    this.rate = _rate;
    this.angle = 0;
    this.phase = _phase;
  }

  public LFO(float _rate) {
    this.phase = 0;
    this.angle = 0;
    this.rate = _rate;
  }

  public float update() {
    float output = this.math(angle, phase);
    this.angle=(this.angle+this.rate);
    return output;
  }

  public float math(float _angle, float _phase) {
    return map(sin(2*PI*_angle+_phase),-1,1,min,max);
  }


  public void reset() {
    this.rate = 0;
    this.angle = 0;
    this.phase = 0;
  }

  public void setAngle(float _angle) {
    this.angle = this.wrap(_angle);
    }
  
  public void setPhase(float _phase) {
    this.phase=_phase;
  }
  
  public void setRate(float _rate) {
    this.rate=this.wrap(_rate);
  }

  public float wrap(float _value) { // wraps values around range 0-1

    if (_value < 0) {
      return (_value + 1 % 1);
    } else {
      return (_value % 1);
    }
    
  }
}
