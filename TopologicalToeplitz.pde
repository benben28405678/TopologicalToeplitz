public static Theme theme = Theme.DARK;
public static int nodeTime = 5;
public static float tolerance = 2.0;

int ppmouseX, ppmouseY;
PFont sanFranLight, sanFranHeavy;

ArrayList<Point> curve = new ArrayList<Point>();
ArrayList<Point> gamma = new ArrayList<Point>();

void setup() {
  frameRate(60);
  size(1000, 500);

  PFont[] loadFonts = {
    loadFont("CMUSerif-Bold-32.vlw"), 
    loadFont("CMUSerif-Italic-24.vlw"), 
    loadFont("CMUSansSerif-Bold-24.vlw"), 
    loadFont("CMUSerif-Roman-18.vlw"), 
    loadFont("CMUSerif-Italic-14.vlw"), 
    loadFont("Ayuthaya-12.vlw"), 
  };

  presetFonts = loadFonts;

  sanFranLight = createFont("SFProText-Light", 24);
  sanFranHeavy = createFont("SFProText-Heavy", 24);


  currentScene.setup();
}

void draw() {
  currentScene.draw();

  ppmouseX = pmouseX;
  ppmouseY = pmouseY;
}

void mousePressed() {
  currentScene.mousePressed();
}

void mouseReleased() {
  currentScene.mouseReleased();
}

void mouseMoved() {
  currentScene.mouseMoved();
}

void buttonHandler(String call) {
  switch(call) {
  case "themeChange":
    if (theme == Theme.LIGHT) {
      theme = Theme.DARK;
      ((SFButton)currentScene.interactibles.get(1)).notPressedTitle = "􀆹";
      ((SFButton)currentScene.interactibles.get(1)).pressedTitle = "􀆺";
    } else {
      theme = Theme.LIGHT;
      ((SFButton)currentScene.interactibles.get(1)).notPressedTitle = "􀆭";
      ((SFButton)currentScene.interactibles.get(1)).pressedTitle = "􀆮";
    }
    ((StartScene)currentScene).title.resetAnimations();
    break;
  case "begin":
    currentScene.present(new DrawScene());
    break;
  case "cancel":
    currentScene.present(new DrawScene());
    curve = new ArrayList<Point>();
    gamma = new ArrayList<Point>();
    break;
  case "triangleScan":
    currentScene.present(new ScanScene());
    break;
  }
}

void drawCurve() {
  noFill();
  stroke(255);
  strokeWeight(1);
  if (curve.size() < 5) return;

  rectMode(CENTER);
  beginShape();
  stroke(colorGen.colorForShade(1.0));
  curveVertex(curve.get(0));
  for (int i = 0; i < curve.size(); i++) {
    curveVertex(curve.get(i));
    
    /*if(i > 1 && i < curve.size() - 1) {
      for(float j = 0.01; j < 1.0; j += 2.0/dist(curve.get(i-1), curve.get(i))) {
        float x = curvePoint(curve.get(i-2).x, curve.get(i-1).x, curve.get(i).x, curve.get(i+1).x, j);
        float y = curvePoint(curve.get(i-2).y, curve.get(i-1).y, curve.get(i).y, curve.get(i+1).y, j);
        circle(x, y, 5);
      }
    }*/
  }
  curveVertex(curve.get(curve.size() - 1));
  endShape();
}

void fillGamma() {
  for(int i = 2; i < curve.size() - 1; i++) {
    for(float j = 0.01; j < 1.0; j += 2.0/dist(curve.get(i-1), curve.get(i))) {
      float x = curvePoint(curve.get(i-2).x, curve.get(i-1).x, curve.get(i).x, curve.get(i+1).x, j);
      float y = curvePoint(curve.get(i-2).y, curve.get(i-1).y, curve.get(i).y, curve.get(i+1).y, j);
      gamma.add(new Point(x, y));
    }
  }
  
  for(float j = 0.01; j < 1.0; j += 2.0/dist(curve.get(curve.size() - 1), curve.get(0))) {
    float x = curvePoint(curve.get(curve.size() - 2).x, curve.get(curve.size() - 1).x, curve.get(0).x, curve.get(1).x, j);
    float y = curvePoint(curve.get(curve.size() - 2).y, curve.get(curve.size() - 1).y, curve.get(0).y, curve.get(1).y, j);
    gamma.add(new Point(x, y));
  }
  
  for(float j = 0.01; j < 1.0; j += 2.0/dist(curve.get(0), curve.get(1))) {
    float x = curvePoint(curve.get(curve.size() - 1).x, curve.get(0).x, curve.get(1).x, curve.get(2).x, j);
    float y = curvePoint(curve.get(curve.size() - 1).y, curve.get(0).y, curve.get(1).y, curve.get(2).y, j);
    gamma.add(new Point(x, y));
  }
}

void drawGammaPoints(int t) {
  if(gamma.size() < 2) return;
  
  for(int i = 0; i < gamma.size(); i++) {
    noFill();
    fill(colorGen.colorForShade(1.0));
    circle(gamma.get(i).x, gamma.get(i).y, constrain(2 * sin(t / 20.0 + 6.0*(float)i/gamma.size()), 0, 2));
  }
}
