class Object {
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  float gravity;
  Object[] others;

  Object(float xin, float yin, float din, int idin, Object[] oin) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
    gravity = defaultGravity;
  }

  void collide() {
    for (int i = id + 1; i < numBalls; i++) {
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others[i].diameter/2 + diameter/2;
      if (distance < minDist) {
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others[i].x) * spring;
        float ay = (targetY - others[i].y) * spring;
        vx -= ax;
        vy -= ay;
        others[i].vx += ax;
        others[i].vy += ay;
      }
    }
  }

  void move() {
    vy += gravity;
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction;
    } else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2 ;
      vy *= friction;
    } else if (y  < 0) {
      y = 0;
      vy *= friction;
    }
  }

  void display() {
    //    noStroke();
    //    fill(165, 100, 100);
    //    ellipse(x, y, diameter, diameter);
    PImage img;
    img = loadImage("birds.png");
    img.resize(floor(diameter), floor(diameter*0.75));
    image(img, x, y);
  }
}

class Ball extends Object {
  Ball[] others;

  Ball(float xin, float yin, float din, int idin, Ball[] oin) {
    super(xin, yin, din, idin, oin);
  }
}

class Rectangular extends Object {

  Rectangular[] others;

  Rectangular(float xin, float yin, float din, int idin, Rectangular[] oin) {
    super(xin, yin, din, idin, oin);
  }
  void display() {
    //    noStroke();
    //    fill(339, 39, 100);
    //    rect(x, y, diameter, diameter);
    PImage img;
    img = loadImage("wind.png");
    img.resize(floor(diameter), floor(diameter*0.5));
    image(img, x, y);
  }
}
class Triangle extends Object {
  Triangle[] triangles;

  Triangle(float xin, float yin, float din, int idin, Triangle[] oin) {
    super(xin, yin, din, idin, oin);
  }
  void display() {
    //    noStroke();
    //    fill(255, 254, 134);
    //    triangle(x, y, x+diameter, y, x, y-diameter);
    PImage img;
    img = loadImage("water.png");
    img.resize(floor(diameter), floor(diameter*0.4));
    image(img, x, y);
  }
}
