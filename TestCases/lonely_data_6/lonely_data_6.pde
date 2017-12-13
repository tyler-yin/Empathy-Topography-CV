ParticleSystem ps;

Path path;
Path path2;

void setup() {
  size(640, 360);
  noStroke ();
  newPath(); 
  ps = new ParticleSystem(new PVector(width/2, 50));
}

void draw() {
  background(255);
  ps.run();
  //path2.display();
}

void newPath() {
  // A more sophisticated path might be a curve
  path = new Path();
  float offset = 30;
  path.addPoint(width/2 + offset,height/2);
  path.addPoint(width/2 + offset*2/3,height/2-offset*2/3);
  path.addPoint(width/2,height/2-offset);
  path.addPoint(width/2 - offset*2/3,height/2-offset*2/3);
  path.addPoint(width/2-offset,height/2);
  path.addPoint(width/2 - offset*2/3,height/2+offset*2/3);
  path.addPoint(width/2,height/2+offset);
  path.addPoint(width/2 + offset*2/3,height/2+offset*2/3);
  
  float offset2 = 100;
  path2 = new Path();
  path2.addPoint(width/2 + offset2,height/2);
  path2.addPoint(width/2 + offset2*2/3,height/2-offset2*2/3);
  path2.addPoint(width/2,height/2-offset2);
  path2.addPoint(width/2 - offset2*2/3,height/2-offset2*2/3);
  path2.addPoint(width/2-offset2,height/2);
  path2.addPoint(width/2 - offset2*2/3,height/2+offset2*2/3);
  path2.addPoint(width/2,height/2+offset2);
  path2.addPoint(width/2 + offset2*2/3,height/2+offset2*2/3);
  
}