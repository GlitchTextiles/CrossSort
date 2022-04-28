class AutomationGroup {
  ArrayList<KeyFrames> automation;

  AutomationGroup() {
    automation = new ArrayList<KeyFrames>();
  }

  void add(KeyFrames _keyFrameSet) {
    automation.add(_keyFrameSet);
  }

  //ArrayList<KeyFrames> get() {
  //  return this.automation;
  //}

  KeyFrames getKeyFrameSet(int _index) {
    if (_index < this.automation.size()) {
      return this.automation.get(_index);
    } else {
      return null;
    }
  }

  KeyFrames getKeyFrameSet(int _objectId, String _parameterName) {
    for (KeyFrames kfs : automationGroup.automation) { 
      if (kfs.objectId == _objectId && kfs.parameterName.equals(_parameterName)) {
        return kfs;
      }
    }
    return null;
  }
}

class KeyFrame {
  int frame;
  float value;

  KeyFrame(int _frame, float _value) {
    this.frame = _frame;
    this.value = _value;
  }

  public int distance(int _frame) {
    return _frame - this.frame;
  }
}

class KeyFrames {
  ArrayList<KeyFrame> keyFrames;
  int objectId;
  String parameterName;

  KeyFrames() {
    keyFrames = new ArrayList<KeyFrame>();
    objectId = 0;
    parameterName = "none specified";
  }

  KeyFrames(int _id, String _name) {
    keyFrames = new ArrayList<KeyFrame>();
    objectId = _id;
    parameterName = _name;
  }

  public ArrayList<KeyFrame> add(KeyFrame _kf) {
    boolean updated = false;
    
    for (KeyFrame kf : this.keyFrames) {
      if (kf.frame == _kf.frame) {
        kf.value = _kf.value;
        updated = true;
      }
    }
    
    if (!updated) {
      this.keyFrames.add(_kf);
      this.sortByFrame();
    }
    
    return this.keyFrames;
  }

  public ArrayList<KeyFrame> add(int _frame, float _value) {
    return this.add(new KeyFrame(_frame, _value));
  }

  float getValue(int _frame) {
    KeyFrame kf1;
    KeyFrame kf2;
    int qtyKeyFrames = this.keyFrames.size();
    if (qtyKeyFrames == 0) {
      return 0.0;
    } else if (qtyKeyFrames == 1) {
      return this.keyFrames.get(0).value;
    } else {
      for (int i = 0; i < keyFrames.size()-1; i++ ) {
        kf1 = this.keyFrames.get(i);
        kf2 = this.keyFrames.get(i+1);
        if (i == 0 && _frame <= kf1.frame)return kf1.value;
        if ( i == keyFrames.size()-2 && _frame >= kf2.frame)return kf2.value;
        if (_frame >= kf1.frame && _frame <= kf2.frame) {
          float progress = (_frame - kf1.frame)/float(kf2.frame - kf1.frame);
          return lerp(kf1.value, kf2.value, progress);
        }
      }
    }
    return -1;
  }

  void sortByFrame() {
    Collections.sort(this.keyFrames, new sortKeyFramesByFrame());
  }

  void sortByValue() {
    Collections.sort(this.keyFrames, new sortKeyFramesByValue());
  }

  public ArrayList<KeyFrame> get() {
    return this.keyFrames;
  }

  public KeyFrame get(int _index) {
    if (_index < this.keyFrames.size()) {
      return this.keyFrames.get(_index);
    } else {
      return null;
    }
  }
}

public class sortKeyFramesByFrame implements Comparator<KeyFrame> {
  @Override
    public int compare(KeyFrame kf1, KeyFrame kf2) {
    return kf1.frame - kf2.frame;
  }
}

public class sortKeyFramesByValue implements Comparator<KeyFrame> {
  @Override
    public int compare(KeyFrame kf1, KeyFrame kf2) {
    return int(1000*(kf1.value - kf2.value));
  }
}
