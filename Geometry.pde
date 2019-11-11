class Point
{
  public float x;
  public float y;
  
  public Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

enum NodeMode
{
  LINE, BEZIER
}

void line(Point p1, Point p2) {
  line(p1.x, p1.y, p2.x, p2.y);
}

void bezier(Point p1, Point mid, Point p2) {
  bezier(p1.x, p1.y, mid.x, mid.y, mid.x, mid.y, p2.x, p2.y);
}

Point flip(Point base, Point toFlip) {
  PVector d = new PVector(base.x - toFlip.x, base.y - toFlip.y);
  d.setMag(pow(d.mag(), 0.7));
  return new Point(base.x + d.x, base.y + d.y);
}

Point mouse() {
  return new Point(mouseX, mouseY);
}
