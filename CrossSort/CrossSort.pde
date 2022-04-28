import controlP5.*;
import java.util.*;

String inputPath, sequencePath, stillPath, batchDirectory, batchOutputDirectory;

public boolean play, record, quick, batch, automate, automationIsLoaded, jitter;

ArrayList<File> batchFileList;
AutomationGroup automationGroup;

KeyFrames min1, max1, min2, max2, min3, max3, min4, max4;

PImage src=null;
PImage buffer=null;
PGraphics banner;
int sequenceIndex = 0;
int iterations=0;

int frameIndex = 0;
int batchIndex = 0;
float batchProgress = 0.0;
int batchSize = 0;

int ControlFrame_w = 640;
int ControlFrame_h = 800;
int GUILocationX = 0;
int GUILocationY = 0;

int screen_x = ControlFrame_w;
int screen_y = 0;
int screen_width = 600;
int screen_height = 320;

//these are used by the GUI and associated objects
int guiObjectSize = 40;
int guiObjectWidth = 600;
int guiBufferSize = 10;
int gridSize = guiObjectSize + guiBufferSize;
int gridOffset = guiBufferSize;

color backgroundColor = color(15);
color guiGroupBackground = color(30);
color guiBackground = color(60);
color guiForeground = color(120);
color guiActive=color(150);

String mode = "";

ControlFrame GUI;

void setup() {
  size(10, 10);
  surface.setSize(screen_width, screen_height);
  surface.setLocation(screen_x, screen_y);
  frameRate(30);
  GUI = new ControlFrame(this, GUILocationX, GUILocationY, ControlFrame_w, ControlFrame_h);
  banner=generateBanner();
  background(backgroundColor);
  randomSeed(0);
  play = false;
  record = false;
  quick = false;
  batch = false;
  automate = false;
  automationIsLoaded = false;
  jitter = false;
}

void draw() {

  switch(mode) {
  case "single":
    if (buffer != null) {
      image(buffer, 0, 0);
      if (play) {
        if (record && sequencePath != null) {
          buffer.save(sequencePath+"-"+nfs(sequenceIndex, 4)+".png");
          sequenceIndex++;
        }
        if (quick) {
          buffer=src.copy();
        }
        GUI.operations.sort(buffer);
      } else {
      }
    } else {
      image(banner, 0, 0);
    }
    break;
  case "batch":
    if (batchFileList.size()>0) {
      String filePath = batchFileList.get(frameIndex).getAbsolutePath();
      PImage frame = loadImage(filePath);
      if (width != frame.width || height != frame.height) {
        surface.setSize(frame.width, frame.height);
      }
      if (automate) applyAutomation(frameIndex);
      GUI.operations.sort(frame);
      image(frame, 0, 0);
      if (play) {
        if (batch) frame.save(batchDirectory+"/sorted/"+nf(frameIndex, 4)+".png");
        GUI.frameIncrement();
      }
    }
    break;
  default:
    image(banner, 0, 0);
    break;
  }
}

void applyAutomation(int _frameIndex) {
  float _min = 0;
  float _max = 0;
  for (int i = 0; i < GUI.operations.sortOperations.size(); i++) {
    _min = automationGroup.getKeyFrameSet(i, "min").getValue(_frameIndex);
    _max = automationGroup.getKeyFrameSet(i, "max").getValue(_frameIndex);
    if (jitter) {
      _min = constrain(_min+random(-0.125, 0.125), 0.0, 1.0);
      _max = constrain(_max+random(-0.125, 0.125), 0.0, 1.0);
    }
    GUI.operations.sortOperations.get(i).threshold.setRangeValues(_min, _max);
  }
}

void loadAutomation(String _path) {
  JSONObject automationJSON;
  automationGroup = new AutomationGroup();
  automationJSON = loadJSONObject(_path);
  println(automationJSON.getString("objectClass"));
  JSONArray automationData = automationJSON.getJSONArray("automation");
  for (int i = 0; i < automationData.size(); i++) {
    JSONObject targetObject = automationData.getJSONObject(i);
    int id = targetObject.getInt("objectIndex");
    JSONArray parameters = targetObject.getJSONArray("parameters");
    for (int j = 0; j < parameters.size(); j++) {
      JSONObject parameter = parameters.getJSONObject(j);
      String parameterName = parameter.getString("name");
      JSONArray keyframes = parameter.getJSONArray("keyframes");
      KeyFrames keyFrameSet = new KeyFrames(id, parameterName);
      for (int k = 0; k < keyframes.size(); k++) {
        JSONObject keyframeData = keyframes.getJSONObject(k);
        int frame = keyframeData.getInt("frame");
        float value = keyframeData.getFloat("value");
        keyFrameSet.add(frame, value);
      }
      automationGroup.add(keyFrameSet);
    }
  }
  automationIsLoaded = true;
}
