class ScanScene extends Scene
{
  int pointIndex = 0;

  void setup() {
  }

  void draw() {
    background(colorGen.colorForShade(0.0));

    drawCurve();

    if (safeIncrementPointIndex()) {
      fill(colorGen.colorForColor(color(255, 0, 255), 1.0));
      noStroke();
      circle(gamma.get(pointIndex), 5);

      strokeWeight(0.5);
      
      float startTheta = 0.05;
      float endTheta = 2*PI;

      for (float theta = startTheta; theta < endTheta; theta += 0.05) {

        Point cen = gamma.get(pointIndex);
        Point inner0 = new Point(cen.x + 10 * cos(theta), cen.y + 10 * sin(theta));
        Point outer0 = new Point(cen.x + 500 * cos(theta), cen.y + 500 * sin(theta));
        ArrayList<Point> intersections0 = search(between(inner0, outer0), gamma);
        float[] dist0 = distanceSet(cen, intersections0);

        stroke(theta * 25, theta * 25, 255);
        line(inner0, outer0);

        if (intersections0.size() > 0) {
          fill(255, 0, 0);
          noStroke();
          for (Point p : intersections0) circle(p, 5);
        }

        Point inner90 = new Point(cen.x + 10.0 * cos(theta + PI/2), cen.y + 10.0 * sin(theta + PI/2));
        Point outer90 = new Point(cen.x + 500.0 * cos(theta + PI/2), cen.y + 500.0 * sin(theta + PI/2));
        ArrayList<Point> between = between(inner90, outer90);
        ArrayList<Point> intersections90 = search(between, gamma);
        float[] dist90 = distanceSet(cen, intersections90);

        stroke(theta * 25, 255, 255);
        line(inner90, outer90);

        if (intersections0.size() > 0) {
          fill(255, 255, 0);
          noStroke();
          for (Point p : intersections90) circle(p, 5);
        }

        for (int i = 0; i < dist0.length; i++) {
          for (int j = 0; j < dist90.length; j++) {
            if (abs(dist0[i] - dist90[j]) < tolerance * dist0[i] / 100.0) {
              noFill();
              stroke(0, 0, 255);
              strokeWeight(1);
              triangle(cen, intersections0.get(i), intersections90.get(j));
              //theta = 2*PI;
            }
          }
        }
      }
    } else {
      pointIndex = 0;
    }
  }

  void mousePressed() {
    for (Button b : interactibles) {
      b.mousePressed();
    }
  }

  void mouseReleased() {
    for (Button b : interactibles) {
      b.mouseReleased();
    }
  }

  void mouseMoved() {
    for (Button b : interactibles) {
      b.mouseMoved();
    }
  }

  boolean safeIncrementPointIndex() {
    pointIndex++;
    return pointIndex < gamma.size();
  }
}
