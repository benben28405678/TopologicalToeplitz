class StartScene extends Scene
{
  Text title;
  Text subtitle;
  Text caption;
  Button begin;
  SFButton theme;
  Pointer cursor;
  
  void setup() {
    Font titleFont = new Font(FontPreset.TITLE);
    Font subtitleFont = new Font(FontPreset.SUBTITLE);
    Font captionFont = new Font(FontPreset.CAPTION);
    FadeIn fadeIn = new FadeIn(60, 0); fadeIn.setTimingMode(GUIAnimTimingMode.EASE_OUT);
    Align centerAlign = new Align(Alignment.CENTER);
    title = new Text("Toeplitz and the Square Peg Conjecture", width/2, height/2 - 20);
    begin = new Button("Begin", width/2, 2*height/3, "begin"); interactibles.add(begin);
    theme = new SFButton("􀆹", "􀆺", 20, 20, "themeChange"); interactibles.add(theme);
    title.addStyle(titleFont); title.addStyle(centerAlign); title.addStyle(fadeIn);
    subtitle = new Text("A Topological Approach", width/2, height/2 + 20);
    subtitle.addStyle(subtitleFont); subtitle.addStyle(centerAlign);
    caption = new Text("Ben Myers", width/2, height - 25);
    caption.addStyle(captionFont); caption.addStyle(centerAlign);
    cursor = new Pointer(); cursor.interactible.add(begin); cursor.interactible.add(theme);
  }
  
  void draw() {
    background(colorGen.colorForShade(0));
  
    title.draw();
    subtitle.draw();
    caption.draw();
    begin.draw();
    theme.draw();
    
    cursor.draw();
  }
  
  void mousePressed() {
    for(Button b : interactibles) {
      b.mousePressed();
    }
  }
  
  void mouseReleased() {
    for(Button b : interactibles) {
      b.mouseReleased();
    }
  }
  
  void mouseMoved() {
    for(Button b : interactibles) {
      b.mouseMoved();
    }
  }
}
