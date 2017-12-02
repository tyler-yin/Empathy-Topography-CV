ParticleSystem ps;

Path path;

void setup() {
  size(1200, 800);
  noStroke ();
  newPath();  
  ps = new ParticleSystem(new PVector(width/2, 50));
}

void draw() {
  background(255);
  ps.run();
  //path.display();
}

void newPath() {
  // A more sophisticated path might be a curve
  path = new Path();
  float offset = 250;
  path.addPoint(width/2 + offset,height/2);
  path.addPoint(width/2 + offset*2/3,height/2-offset*2/3);
  path.addPoint(width/2,height/2-offset);
  path.addPoint(width/2 - offset*2/3,height/2-offset*2/3);
  path.addPoint(width/2-offset,height/2);
  path.addPoint(width/2 - offset*2/3,height/2+offset*2/3);
  path.addPoint(width/2,height/2+offset);
  path.addPoint(width/2 + offset*2/3,height/2+offset*2/3);
}