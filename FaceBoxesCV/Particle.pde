class Particle {

PVector location, velocity, acceleration;
float r, maxforce, maxspeed;

Particle(float x, float y) {
  acceleration = new PVector(0,0);
  velocity = new PVector(0,0);
  location = new PVector(x,y);
  // r = 6; //?
  maxspeed = random(1, 2.5);
  maxforce = random(0.25, 0.5);
}

void drawParticle() {
  stroke(0, 255, 0);
  strokeWeight(1);
  int halfSize = 4;
  line(location.x-halfSize, location.y, location.x+halfSize, location.y);
  line(location.x, location.y-halfSize, location.x, location.y+halfSize);
  // rect(location.x-1, location.y-1, 2, 2);
}

void moveParticle() {
  velocity.add(acceleration);
  velocity.limit(maxspeed);
  location.add(velocity);
  acceleration.mult(0);
}

void applyForce(PVector force) {
  acceleration.add(force);
}

void align (ArrayList<Particle> particles) {
  float neighbordist = 45;
  PVector sum = new PVector(0, 0);
  int count = 0;
  for (Particle other : particles) {
    float d = PVector.dist(location, other.location);
    if ((d > 0) && (d < neighbordist)) {
      sum.add(other.velocity);
      count++;
    }
  }
  if (count > 0) {
    sum.div((float)count);
    sum.normalize();
    sum.mult(maxspeed);
    PVector steer = PVector.sub(sum, velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }
}

void avoid(ArrayList<Particle> particles) {
  PVector separateForce = separate(particles);
  separateForce.mult(2);
  applyForce(separateForce);
}

PVector separate (ArrayList<Particle> particles) {
  float desiredSeparation = 30;
  PVector sum = new PVector();
  int count = 0;
  for (Particle other : particles) {
    float d = PVector.dist(location, other.location);
    if ((d > 0) && (d < desiredSeparation)) {
      PVector diff = PVector.sub(location, other.location);
      diff.normalize();
      diff.div(d);
      sum.add(diff);
      count++;
    }
  }
  if (count > 0) {
    sum.div(count);
    sum.normalize();
    sum.mult(maxspeed);
    sum.sub(velocity);
    sum.limit(maxforce);
  }
  return sum;
}

void borders() {
  if (location.x > width) location.x = 0;
  if (location.x < 0) location.x = width;
  if (location.y > height) location.y = 0;
  if (location.y < 0) location.y = height;
}

}
