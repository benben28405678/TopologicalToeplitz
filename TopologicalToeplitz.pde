public static Theme theme = Theme.DARK;
public static NodeMode nodeMode = NodeMode.BEZIER;

int ppmouseX, ppmouseY;
PFont sanFranLight, sanFranHeavy;

ArrayList<Point> curve = new ArrayList<Point>();

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
  }
}

void drawCurve() {
  noFill();
  if (curve.size() < 5) return;

  switch(nodeMode) {
  case BEZIER:

    float shade = constrain(1.0 - curve.size() * 0.04, 0.5, 1.0);
    stroke(colorGen.colorForShade(shade));

    Point pi0 = curve.get(0);
    Point pi1 = curve.get(1);
    Point pi2 = curve.get(2);
    bezier(pi0, pi1, pi2);

    Point toFlip = pi1;


    for (int i = 2; i < curve.size() - 2; i += 1) {
      stroke(colorGen.colorForShade(shade));
      Point pa = curve.get(i);
      Point pb = flip(pa, toFlip);
      Point pc = curve.get(i+1);
      bezier(pa, pb, pc);
      toFlip = pb;
      if (i > curve.size() - 15) shade += 0.04; 
      if (shade > 1.0) shade = 1.0;
    }
    break;
  case LINE:
    for (int i = 0; i < curve.size() - 1; i++) {
      Point p1 = curve.get(i);
      Point p2 = curve.get(i+1);
      line(p1, p2);
    }
    break;
  }
}
