import java.awt.event.*;
import java.awt.*;

abstract class GUI 
{
  float x;
  float y;

  private ArrayList<GUIStyle> styles = new ArrayList<GUIStyle>();

  public abstract void draw();
  
  public void resetAnimations() {
    for(GUIStyle s : styles) {
      if(s instanceof GUIAnim) {
        ((GUIAnim)s).reset();
      }
    }
  }

  public void addStyle(GUIStyle style) {
    styles.add(style);
  }
}

public static enum Theme {
  LIGHT, DARK
}

interface GUIStyle {
  void apply();
  void wash();
}

GUIThemeColorGenerator colorGen = new GUIThemeColorGenerator();

class GUIThemeColorGenerator {

  // 0.0: Color of background -> 1.0: Opposite color of background
  color colorForShade(float norm) {
    switch(theme) {
    case LIGHT: 
      return color(255 - 255 * norm);
    case DARK: 
      return color(255 * norm);
    default: 
      return color(0);
    }
  }

  // 0.0: Hard to see -> 1.0: Easy to see
  color colorForColor(color c, float norm) {
    float r = red(c) / 255.0;
    float g = green(c) / 255.0;
    float b = blue(c) / 255.0;
    switch(theme) {
    case LIGHT: 
      return color(255 * r * norm, 255 * g * norm, 255 * b * norm);
    case DARK: 
      return color(255 * (1 - norm * r), 255 * (1 - norm * g), 255 * (1 - norm * b));
    default: 
      return color(0);
    }
  }
}

class Align implements GUIStyle
{
  private Alignment alignment;

  public Align(Alignment mode) {
    alignment = mode;
  }

  void apply() {
    switch(alignment) {
    case LEFT: 
      textAlign(LEFT); 
      rectMode(CORNER); 
      break;
    case RIGHT: 
      textAlign(RIGHT); 
      break;
    case CENTER: 
      textAlign(CENTER); 
      rectMode(CENTER); 
      break;
    }
  }

  void wash() {
    textAlign(LEFT); 
    rectMode(CORNER);
  }
}

private static enum Alignment
{
  LEFT, RIGHT, CENTER;
}

class Font implements GUIStyle
{
  private FontPreset preset;

  public Font(FontPreset preset) {
    this.preset = preset;
  }

  void apply() {
    switch(preset) {
    case TITLE: 
      textFont(presetFonts[0]); 
      fill(colorGen.colorForShade(1)); 
      textSize(32); 
      break;
    case SUBTITLE: 
      textFont(presetFonts[1]); 
      fill(colorGen.colorForShade(0.6)); 
      textSize(24); 
      break;
    case HEADER: 
      textFont(presetFonts[2]); 
      fill(colorGen.colorForShade(1)); 
      textSize(24); 
      break;
    case BODY: 
      textFont(presetFonts[3]); 
      fill(colorGen.colorForShade(0.8)); 
      textSize(18); 
      break;
    case CAPTION: 
      textFont(presetFonts[4]); 
      fill(colorGen.colorForShade(0.5)); 
      textSize(14); 
      break;
    case SYMBOL:
      textFont(sanFranLight);
      fill(colorGen.colorForShade(0.4)); 
      textSize(24);
      break;
    case CODE:
      textFont(presetFonts[5]);
      fill(colorGen.colorForShade(0.4));
      textSize(12);
      break;
    }
  }

  void wash() {
    textFont(presetFonts[3]); 
    fill(colorGen.colorForShade(0.8)); 
    textSize(24);
  }
}

private static enum FontPreset
{
  TITLE, SUBTITLE, HEADER, BODY, CAPTION, SYMBOL, CODE
}

private PFont[] presetFonts;

class Text extends GUI
{
  private String message;

  public Text(String text, float x, float y) {
    this.x = x;
    this.y = y;
    message = text;
  }

  public void draw() {
    for (GUIStyle style : super.styles) {
      style.apply();
    }

    text(message, x, y);

    for (GUIStyle style : super.styles) {
      style.wash();
    }
  }
}

class Button extends GUI
{
  private String title;
  String call;
  int width;
  boolean beingPressed = false;
  private float weight = 1;
  Font bodyFont = new Font(FontPreset.BODY);
  Text buttonText;
  
  public Button(String text, float x, float y, String call) {
    this.x = x;
    this.y = y;
    this.call = call;
    this.width = text.length() * 20;
    title = text;
    
    buttonText = new Text(title, x, y);
    buttonText.addStyle(bodyFont);
  }
  
  void draw() {
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    
    stroke(colorGen.colorForShade(0.8));
    if(mouseInside() && weight < 3) weight += 0.5;
    else if(!mouseInside() && weight > 0) weight -= 0.5;
    strokeWeight((int)weight);
    if(beingPressed) fill(colorGen.colorForShade(0.2));
    else noFill();
    rect(x, y, this.width, 30, 4, 4, 4, 4);
    
    buttonText.draw();
  }
  
  void mousePressed() {
    if(mouseInside()) beingPressed = true;
  }
  
  void mouseReleased() {
    beingPressed = false;
    
    if(mouseInside()) buttonHandler(call);
  }
  
  void mouseMoved() {
    if(!mouseInside()) beingPressed = false;
  }
  
  boolean mouseInside() {
    return mouseX <= x + this.width/2 && mouseX >= x - this.width/2 && mouseY <= y + 15 && mouseY >= y - 15;
  }
}

class SFButton extends Button
{
  String pressedTitle;
  String notPressedTitle;
  
  public SFButton(String notPressed, String pressed, float x, float y, String call) {
    super(notPressed, x, y, call);
    pressedTitle = pressed;
    notPressedTitle = notPressed;
  }
  
  void draw() {
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    
    fill(colorGen.colorForShade(0.5));
    if(mouseInside()) textFont(sanFranHeavy);
    else textFont(sanFranLight);
    if(super.beingPressed) text(pressedTitle, x, y);
    else text(notPressedTitle, x, y);
  }
  
  void mousePressed() {
    if(mouseInside()) super.beingPressed = true;
  }
  
  boolean mouseInside() {
    return mouseX <= x + 15 && mouseX >= x - 15 && mouseY <= y + 15 && mouseY >= y - 15;
  }
}

abstract class GUIAnim implements GUIStyle
{
  float delay = 0;
  float duration = 100;
  float life = 0;
  float val = 1.0;
  GUIAnimTimingMode timingMode = GUIAnimTimingMode.LINEAR;
  
  public void reset() {
    val = 0;
  }
}

enum GUIAnimTimingMode
{
  LINEAR, EASE_IN, EASE_OUT
}

class FadeIn extends GUIAnim
{
  color natural;

  void apply() {
    natural = g.fillColor;
    fill(red(natural), green(natural), blue(natural), 255 * (val - delay)/ duration);

    switch(timingMode) {
    case LINEAR: 
      val++;
    case EASE_IN: 
      val += val / 12.0;
    case EASE_OUT: 
      val += (duration - val) / 12.0;
    }
  }

  void setTimingMode(GUIAnimTimingMode mode) {
    timingMode = mode;
  }

  void wash() {
    fill(natural);
  }

  public FadeIn(float duration) {
    this.duration = duration;
  }

  public FadeIn(float duration, float delay) {
    this.duration = duration;
    this.delay = delay;
  }
}

class Move extends GUIAnim
{
  PVector offset;

  void apply() {
    pushMatrix();
    translate(offset.x * constrain((val - delay)/ duration, 0, 1.0), offset.y * constrain((val - delay)/ duration, 0, 1.0));

    switch(timingMode) {
    case LINEAR: 
      val++;
    case EASE_IN: 
      val += val / duration;
    case EASE_OUT: 
      val += (duration - val) / duration;
    }
  }

  void setTimingMode(GUIAnimTimingMode mode) {
    timingMode = mode;
  }

  void wash() {
    popMatrix();
  }

  public Move(PVector offset, float duration) {
    this.offset = offset;
  }

  public Move(PVector offset, float duration, float delay) {
    this.offset = offset;
  }
}

class Pointer extends GUI
{
  int pointerSize = 1;
  ArrayList<Button> interactible = new ArrayList<Button>();
  
  void draw() {
    stroke(colorGen.colorForShade(1.0));
    strokeWeight(1);
    noFill();
    noCursor();
    if(ppmouseX != 0 && ppmouseY != 0 && !inButton()) {
      bezier(mouseX, mouseY, pmouseX, pmouseY, pmouseX, pmouseY, ppmouseX, ppmouseY);
    }
    
    if(!inButton()) {
      if(mouseX == pmouseX && mouseY == pmouseY) {
        if(pointerSize < 5) pointerSize += 1;
      } else {
        if(pointerSize > 0) pointerSize -= 1;
      }
    } else if(pointerSize > 0) pointerSize -= 1;
    
    if(mousePressed) fill(colorGen.colorForColor(color(255, 255, 0), 1.0));
    else fill(colorGen.colorForShade(1.0));
    if(pointerSize > 1) circle(mouseX, mouseY, pointerSize);
  }
  
  boolean inButton() {
    for(Button b : interactible) {
      if(b.mouseInside()) return true;
    }
    return false;
  }
}
