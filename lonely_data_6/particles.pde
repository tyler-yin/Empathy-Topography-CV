
// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 


class ParticleSystem {
  ArrayList<Particle> particles;
  ArrayList<Particle> particles2;
  ArrayList<Particle> particles3;
  PVector origin;
  int never;
  int overayear;
  int ayear;
  int amonth;
  int twoweeks;
  

  ParticleSystem(PVector position) {
    origin = position.copy();
    particles = new ArrayList<Particle>();
    particles2 = new ArrayList<Particle>();
    particles3 = new ArrayList<Particle>();
    never = 40;
    overayear = 40;
    ayear = 40;
    amonth = 37;
    twoweeks = 53;   
    
  }

  void run() {
    
    // NEVER DATA
    pushMatrix();
    for (int i = 0; i < never; i++) {
    particles.add(new Particle(origin));
    Particle p = particles.get(i);
    
    p.run1();
    p.applyBehaviorsn(particles);
   }
   popMatrix();
   
   //OVER A YEAR DATA
   pushMatrix();
   for (int i = 0; i < overayear; i++) {
    particles2.add(new Particle(origin));
    Particle p2 = particles2.get(i);
    p2.run2();
    p2.applyBehaviors(particles2,path);
   }
   popMatrix();
   
   // WITHIN A YEAR DATA
   pushMatrix();
   for (int i = 0; i < ayear; i++) {
    particles3.add(new Particle(origin));
    Particle p3 = particles3.get(i);
    p3.run3();
    p3.applyBehaviors3(particles3,path2);
   }
   popMatrix();
   
   
  }
}


class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float diameter;
  float r;
  float angle;
  float d1;
  float maxforce1;
  float maxspeed1;
  float maxspeed;
  float maxforce;
  float d2;
  float s1;
  Boolean change;
  
  Particle(PVector l) {
    acceleration = new PVector (0,0);
    velocity = new PVector(maxspeed,2);
    position = new PVector (random(0,width),random(0,height));
    angle = 0;
    diameter = 2;
    r = 12;
    maxspeed1 = 9;
    maxforce1 = 0.1;
    maxspeed = random(2,4);
    maxforce = 0.3;
    change = false;
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target,position);  // A vector pointing from the position to the target
    
    desired.setMag(maxspeed1);
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce1);  // Limit to maximum steering force
    
    return steer;
  }
  
 PVector separate (ArrayList particles) {
    float desiredseparation = s1;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // check if particles are too close
    for (int i = 0 ; i < particles.size(); i++) {
      Particle other = (Particle) particles.get(i);
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    if (count > 0) {
      steer.div((float)count);
    }

    if (steer.mag() > 0) {
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }
  
 


  // NEVER DATA ------------------------------------------------------------------
  void run1() {
    update();
    display();
  }
  
  void applyBehaviorsn(ArrayList<Particle> particles) {
     s1 = 1.3;
     PVector separateForce = separate(particles);
     PVector seekForce = seek(new PVector(width/2,height/2));
     separateForce.mult(0.3);
     seekForce.mult(2);
     applyForce(separateForce);
     applyForce(seekForce); 
  }
  
  // Method to update position for "never"
  void update() {
     
    velocity.add(acceleration);
    velocity.limit(maxspeed1); // range
    position.add(velocity);
    acceleration.mult(0);
  }


  // Method to display data for "never"
  void display() {
    pushMatrix();
    fill(0);
    noStroke();
    rect(position.x, position.y,2.5,2.5);
    popMatrix();
  } 
  
   // OVER A YEAR DATA ------------------------------------------------------------------
  void run2() {
    update2();
    display2();
    border2();
  }
  
  void applyBehaviors(ArrayList<Particle> particles, Path path) {
    path.pr = 20;
    s1 = 2;
    PVector f = follow(path);
    PVector s = separate(particles);
    f.mult(2);
    s.mult(1);
    applyForce(f);
    applyForce(s);
  }
  
  // Method to update position for "overayear"
  void update2() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity);
    acceleration.mult(0);  
  }

  // Method to display data for "overayear"
  void display2() {
    pushMatrix();
    fill(50);
    noStroke();
    d2= 1 + (sin(angle) * diameter/2) + diameter/2;
    rect(position.x, position.y, d2, d2);
    angle += 0.02; // pulsing rate
    popMatrix();
  } 
  
  void border2() {
    if (position.x < -r) position.x = width+r;
    //if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    //if (position.y > height+r) position.y = -r;
  }
  
  // WITHIN A YEAR DATA ------------------------------------------------------------------
  void run3() {
    update3();
    display3();
    border3();
  }
  
  void applyBehaviors3(ArrayList<Particle> particles, Path path2) {
    path2.pr = 60;
    s1 = 3;
    PVector f;
    float fy;
    float sy;
  
    if (mousePressed == true) {
      change = true;
    } 
    
    if (change == true) {
      f = follow(path);
      fy = 4;
      sy = 1;
    } else {
      f = follow(path2);
      fy = 2;
      sy = 2;
    }
    println(change);

    PVector s = separate(particles);
    f.mult(fy);
    s.mult(sy);
    applyForce(f);
    applyForce(s);
  }
  
  // Method to update position for "overayear"
  void update3() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity);
    acceleration.mult(0);  
  }

  // Method to display data for "overayear"
  void display3() {
    pushMatrix();
    fill(100);
    noStroke();
    d2= 1 + (sin(angle) * diameter/2) + diameter/2;
    rect(position.x, position.y, d2, d2);
    angle += 0.02; // pulsing rate
    popMatrix();
  } 
  
  void border3() {
    if (position.x < -r) position.x = width+r;
    //if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    //if (position.y > height+r) position.y = -r;
  }
  
  // FOLLOW PATH STUFF -------------------------------------------------------------------------
  
  PVector follow(Path p) {

    PVector predict = velocity.get();
    predict.normalize();
    predict.mult(25);
    PVector predictpos = PVector.add(position, predict);
    PVector normal = null;
    PVector target = null;
    float worldRecord = 1000000;  
    for (int i = 0; i < p.points.size(); i++) {
      PVector a = p.points.get(i);
      PVector b = p.points.get((i+1)%p.points.size());
      PVector normalPoint = getNormalPoint(predictpos, a, b);

      // Check if normal is on line segment
      PVector dir = PVector.sub(b, a);
 
      if (normalPoint.x < min(a.x,b.x) || normalPoint.x > max(a.x,b.x) || normalPoint.y < min(a.y,b.y) || normalPoint.y > max(a.y,b.y)) {
        normalPoint = b.get();
        // If we're at the end we really want the next line segment for looking ahead
        a = p.points.get((i+1)%p.points.size());
        b = p.points.get((i+2)%p.points.size());  // Path wraps around
        dir = PVector.sub(b, a);
      }

      // How far away are we from the path?
      float d = PVector.dist(predictpos, normalPoint);
      if (d < worldRecord) {
        worldRecord = d;
        normal = normalPoint;

        dir.normalize();
        
        dir.mult(25);
        target = normal.get();
        target.add(dir);

      }
    }

    if (worldRecord > p.radius) {
      return seek(target);
    }
    else {
      return new PVector(0, 0);
    }
  }


  PVector getNormalPoint(PVector p, PVector a, PVector b) {
    // Vector from a to p
    PVector ap = PVector.sub(p, a);
    // Vector from a to b
    PVector ab = PVector.sub(b, a);
    ab.normalize(); // Normalize the line
    ab.mult(ap.dot(ab));
    PVector normalPoint = PVector.add(a, ab);
    return normalPoint;
  }

  
}