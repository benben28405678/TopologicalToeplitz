class DrawScene extends Scene
{
  Text instruction;
  Text detail;
  Text drawSym;
  Text nodes;
  //SFButton mode;
  Pointer cursor;
  Button scan;
  Button cancel;

  PImage pencil;
  
  int tick = 0;

  boolean canAddToCurve = true;

  void setup() {
    pencil = loadImage("Pencil.png");

    Font headerFont = new Font(FontPreset.HEADER);
    Font bodyFont = new Font(FontPreset.BODY);
    Font symFont = new Font(FontPreset.SYMBOL);
    Font codeFont = new Font(FontPreset.CODE);
    instruction = new Text("Draw a curve.", width/2, 30);
    detail = new Text("Click and hold the mouse pointer to draw.", width/2, 55);
    nodes = new Text("0", width - 10, 20);
    drawSym = new Text("􀈐", width/2, 90);
    Align centerAlign = new Align(Alignment.CENTER);
    Align rightAlign = new Align(Alignment.RIGHT);
    FadeIn fadeIn = new FadeIn(60, 0); 
    fadeIn.setTimingMode(GUIAnimTimingMode.EASE_OUT);
    instruction.addStyle(centerAlign); 
    instruction.addStyle(headerFont); 
    instruction.addStyle(fadeIn);
    nodes.addStyle(rightAlign); 
    nodes.addStyle(codeFont);
    detail.addStyle(centerAlign); 
    detail.addStyle(bodyFont);
    drawSym.addStyle(centerAlign); 
    drawSym.addStyle(symFont);
    //mode = new SFButton("", "", width/2, 60, "nodeModeChange");
    cursor = new Pointer();
    scan = new Button(" Scan ", width/2 + 70, height - 35, "triangleScan");
    cancel = new Button("Cancel", width/2 - 70, height - 35, "cancel");
    interactibles.add(scan); interactibles.add(cancel);
    cursor.interactible.add(scan); cursor.interactible.add(cancel);
  }

  int penAlpha = 255;
  int drawTick = 0;

  void draw() {
    background(colorGen.colorForShade(0));

    instruction.draw();
    detail.draw();
    drawSym.draw();
    nodes.draw();

    if(canAddToCurve) {
      if (mouseX == pmouseX && mouseY == pmouseY && penAlpha < 255) penAlpha += 5;
      else if (penAlpha > 115) penAlpha -= 20;
      pushMatrix();
      imageMode(CORNER);
      translate(mouseX, mouseY);
      rotate(PI * (-mouseX / (float)width) + PI/4 + PI * (mouseY / (float)height) + PI/4);
      tint(colorGen.colorForShade(1.0), penAlpha);
      image(pencil, 0, -23, 25, 25);
      noTint();
      popMatrix();
    } else {
      cursor.draw();
      scan.draw();
      cancel.draw();
    }

    if (mousePressed && (mouseX != pmouseX || mouseY != pmouseY) && canAddToCurve) {
      if (drawTick % nodeTime == 0) curve.add(mouse()); 
      nodes.message = curve.size() + "";
      drawTick++;
    }

    drawCurve();

    if (curve.size() > 0 && canAddToCurve) {
      if (dist(mouse(), curve.get(0)) > 20) {

        stroke(colorGen.colorForColor(color(255, 0, 255), 1.0));
        if (curve.size() > 5) line(curve.get(curve.size() - 1), mouse());

      } else {

        stroke(colorGen.colorForColor(color(0, 255, 255), 1.0));
        line(curve.get(curve.size() - 1), curve.get(0));
      }
    }
    
    drawGammaPoints(tick);
    
    tick += 1;
  }
  
  void mousePressed() {
    for(Button b : interactibles) {
      b.mousePressed();
    }
  }
  
  void mouseReleased() {
    if (dist(mouse(), curve.get(0)) <= 20) {
      if (canAddToCurve) {
        canAddToCurve = false;
        fillGamma();
        instruction.message = "Is this curve ok?";
        instruction.resetAnimations();
        detail.message = "Here is what your curve looks like. Press the button to scan for triangles.";
        drawSym.message = "􀇺";
        curve.add(curve.get(0));
      }
    }
    
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
