import gab.opencv.*;
import processing.video.*;
import java.awt.*;
// import java.util.*

Capture video;
OpenCV opencv;

ArrayList<Particle> particles;

void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);

  video.start();

  particles = new ArrayList<Particle>();
  createParticles();
}

void draw() {
  scale(2);
  opencv.loadImage(video);
  // tint(255, 175);
  // blendMode(BLEND);

  //pushMatrix();
  //translate(video.width, 0);
  //scale(-1, 1);
  //image(video, 0, 0);
  //popMatrix();

  image(video, 0, 0);
  filter(GRAY);

  noFill();
  stroke(0, 255, 0);
  strokeWeight(1);
  //rectMode(CENTER);
  Rectangle[] faces = opencv.detect();
  println(faces.length);

  for (int i = 0; i < faces.length; i++) {
    //println(faces[i].x + "," + faces[i].y);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    textSize(8);
    text("face_0"+ (i+1), faces[i].x, faces[i].y-3);
  }
  if (faces.length > 1) {
    for (int i = 0; i < faces.length-1; i++) {
      line(faces[i].x, faces[i].y, faces[i+1].x, faces[i+1].y);
    }
  }

  // particles
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle particle = particles.get(i);
    particle.drawParticle();
    particle.moveParticle();
    particle.align(particles);
    particle.avoid(particles);
    particle.borders();
  }
}

void createParticles() {
  for (int i = 0; i < 30; i++) {
    particles.add(new Particle(random(0,width), random(0,height)));
  }
}

void captureEvent(Capture c) {
  c.read();
}
