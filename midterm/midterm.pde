import processing.serial.*;

// Audio Library
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

// Audio Variables
Minim minim1, minim2, minim3;
AudioPlayer player1, player2, player3;
Gain gain;
int volume = 0;

Serial myPort;
int numBalls = 18;
float spring = 0.02;
float defaultGravity = 0.03;
float friction = -0.3;
Ball[] balls = new Ball[numBalls];
Rectangular[] rectangulars = new Rectangular[numBalls];
Triangle[] triangles = new Triangle[numBalls];
// int hue = 160;
// int sat = 4;
// int bri = 90;
int r = 180;
int g = 200;
int b = 200;
float ballsY = height;
float rectsY = height;
float trisY = height;


void setup() {

  colorMode(RGB, 255, 255, 255);

  size(960, 540);

  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball(random(width), height, random(30, 70), i, balls);
    rectangulars[i] = new Rectangular(random(width), height, random(30, 70), i, rectangulars);
    triangles[i] = new Triangle(random(width), height, random(30, 70), i, triangles);
  }

  minim1 = new Minim(this);
  player1 = minim1.loadFile("bird2.mp3");
  player1.play();
  player1.loop();

  minim2 = new Minim(this);
  player2 = minim2.loadFile("river.mp3");
  player2.play();
  player2.loop();

  minim3 = new Minim(this);
  player3 = minim3.loadFile("wind.mp3");
  player3.play();
  player3.loop();

  String portName = "/dev/tty.usbmodem1451"; // name of the port you want to use
  myPort = new Serial(this, portName, 9600); // initiatlize the port
  myPort.bufferUntil('\n'); // only generate a serialEvent when you see a new line
  myPort.clear(); // clear buffer
}

void draw() {
  background(color(r, g, b));
  for (int i = 0; i < numBalls; i++) {
    balls[i].collide();
    balls[i].move();
    balls[i].display();
    rectangulars[i].collide();
    rectangulars[i].move();
    rectangulars[i].display();
    triangles[i].collide();
    triangles[i].move();
    triangles[i].display();
  }
}

void serialEvent (Serial myPort) {
  String fsrs = myPort.readString();
  println(fsrs);
  fsrs = trim(fsrs);
  int forces[] = int(split(fsrs, ','));

  float ballSpeed = map(forces[0], 0, 250, 0, 0.022);
  float rectSpeed = map(forces[1], 0, 250, 0, 0.022);
  float triSpeed = map(forces[2], 0, 250, 0, 0.022);

  float ballGravity = map(forces[0], 0, 250, 0.08, 0.028);
  float rectGravity = map(forces[1], 0, 250, 0.08, 0.028);
  float triGravity = map(forces[2], 0, 250, 0.08, 0.028);

  float volume1 = map(forces[0], 0, 300, -50, 50);
  float volume2 = map(forces[1], 0, 300, -50, 50);
  float volume3 = map(forces[2], 0, 300, -50, 50);
  // println(volume);
  // println("");
  
  player1.setGain(volume1); 
  player2.setGain(volume3);
  player3.setGain(volume2);
  // delay(100);

  ballsY = 0;
  rectsY = 0;
  trisY = 0;
  for (int i = 0; i < numBalls; i++) {  
    balls[i].vy -= ballSpeed;
    balls[i].gravity = ballGravity;
    ballsY += balls[i].y/numBalls;
    rectangulars[i].vy -= rectSpeed;
    rectangulars[i].gravity = rectGravity;
    rectsY +=  rectangulars[i].y/numBalls;
    triangles[i].vy -= triSpeed;
    triangles[i].gravity = triGravity;
    trisY += triangles[i].y/numBalls;
  }

  r = floor(map(ballsY, 540, 200, 180, 240));
  g = floor(map(rectsY, 540, 200, 200, 240));
  b = floor(map(trisY, 540, 200, 200, 240));
  // hue = floor(map(ballsY, 540, 200, 240, 140));
  // sat = floor(map(rectsY, 540, 200, 0, 60));
  // bri = floor(map(trisY, 540, 200, 90, 100));
  // println(hue, sat, bri);
}

void stop() {
  player1.close();
  minim1.stop();
  player2.close();
  minim2.stop();
  player3.close();
  minim3.stop();
  super.stop();
}
