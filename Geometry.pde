class Point
{
  public float x;
  public float y;

  public Point(float x, float y) {
    this.x = x;
    this.y = y;
  }

  public boolean isCloseTo(Point p) {
    return abs(p.x - x) < tolerance && abs(p.y - y) < tolerance;
  }
  
  public String toString() {
    return "(" + x + ", " + y + ")";
  }
}

class Triangle
{
  public Point base;
  public Point t1;
  public Point t2;

  public Triangle(Point base, Point t1, Point t2) {
    this.base = base;
    this.t1 = t1;
    this.t2 = t2;
  }
}

void line(Point p1, Point p2) {
  line(p1.x, p1.y, p2.x, p2.y);
}

void bezier(Point p1, Point mid, Point p2) {
  bezier(p1.x, p1.y, mid.x, mid.y, mid.x, mid.y, p2.x, p2.y);
}

void circle(Point p, float rad) {
  circle(p.x, p.y, rad);
}

void triangle(Point p1, Point p2, Point p3) {
  triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
}

Point flip(Point base, Point toFlip) {
  PVector d = new PVector(base.x - toFlip.x, base.y - toFlip.y);
  //d.setMag(pow(d.mag(), 0.7));
  return new Point(base.x + d.x, base.y + d.y);
}

Point mouse() {
  return new Point(mouseX, mouseY);
}

void curveVertex(Point p) {
  curveVertex(p.x, p.y);
}

float dist(Point p1, Point p2) {
  return dist(p1.x, p1.y, p2.x, p2.y);
} 

boolean inLine(Point A, Point B, Point C) {
  if (A.x == C.x) return abs(B.x - C.x) < 3;
  if (A.y == C.y) return abs(B.y - C.y) < 3;
  return abs((A.x - C.x)*(A.y - C.y) - (C.x - B.x)*(C.y - B.y)) < 3;
}

ArrayList<Point> between(Point A, Point B) {
  ArrayList<Point> arr = new ArrayList<Point>();

  if (A.x < B.x) {
    for (float i = A.x; i < B.x; i += (B.x - A.x)/dist(A, B)) {
      Point p = new Point(i, A.y + (i-A.x)*(B.y-A.y)/(B.x-A.x));
      //println(p + " " + p);
      //println(p);
      arr.add(p);
      
      if(A.isCloseTo(B)) i += 0.001;
    }
  } else {
    for (float i = A.x; i > B.x; i -= (A.x - B.x)/dist(A, B)) {
      Point p = new Point(i, A.y + (i-A.x)*(B.y-A.y)/(B.x-A.x));
      //println(i);
      //println(p + " " + p);
      //println(p);
      arr.add(p);

      if(A.isCloseTo(B)) i += 0.1;
    }
  }

  return arr;
}

public ArrayList<Point> search(ArrayList<Point> alphas, ArrayList<Point> betas) {
  ArrayList<Point> results = new ArrayList<Point>();    // Create container for results

  for (Point alpha : alphas) {
    for (Point beta : betas) {
      if (alpha.isCloseTo(beta)) {
        results.add(alpha);
        break;
      }
    }
  }

  return results;
}

public boolean close(float a, float b) {
  return abs(a - b) < 2.0;
}

public float[] distanceSet(Point base, ArrayList<Point> terminals) {
  float[] arr = new float[terminals.size()];
  for (int i = 0; i < terminals.size(); i++) {
    arr[i] = dist(base, terminals.get(i));
  }
  return arr;
}
