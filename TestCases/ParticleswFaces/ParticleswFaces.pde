/////////////////////////////////
// Import Libraries
/////////////////////////////////
import gab.opencv.*;
import processing.video.*;
import java.awt.*;
// import java.util.*

/////////////////////////////////
// Declarations
/////////////////////////////////
Capture video;
OpenCV opencv;
ParticleSystem ps;
Boolean oneface = false;
Path path;

/////////////////////////////////
// SETUP
/////////////////////////////////
void setup() {
  size(640, 480);
  //frameRate(30);
  noStroke();
  newPath();
  ps = new ParticleSystem(new PVector(width/2, 50));

  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);

  video.start();
}

/////////////////////////////////
// DRAW
/////////////////////////////////
void draw() {
  translate(video.width, 0);
  scale(-1, 1);
  
  //scale(2);
  opencv.loadImage(video);
  image(video, 0, 0);
  filter(GRAY);

  //path.display();

  noFill();
  stroke(0, 255, 0);
  strokeWeight(2);
  Rectangle[] faces = opencv.detect();
  println(faces.length);
  println(oneface);

  // Face Detection Rectangles & Text
  for (int i = 0; i < faces.length; i++) {
    //println(faces[i].x + "," + faces[i].y);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    textSize(8);
    // text("face_0"+ (i+1), faces[i].x, faces[i].y-3);
  }

  // Face Connection Lines
  if (faces.length > 1) {
    for (int i = 0; i < faces.length-1; i++) {
      line(faces[i].x, faces[i].y, faces[i+1].x, faces[i+1].y);
    }
  }

  // if there's a face, change particles to follow mouse
  if (faces.length == 1) {
    oneface = true;
  } else {
    oneface = false;
  }

  // Particle System
  ps.run();
}

/////////////////////////////////
// CAPTURE
/////////////////////////////////
void captureEvent(Capture c) {
  c.read();
}

/////////////////////////////////
// PATH
/////////////////////////////////
void newPath() {
  // A more sophisticated path might be a curve
  path = new Path();
  float offset = 10;
  path.addPoint(width/2 + offset, height/2);
  path.addPoint(width/2 + offset*2/3, height/2-offset*2/3);
  path.addPoint(width/2, height/2-offset);
  path.addPoint(width/2 - offset*2/3, height/2-offset*2/3);
  path.addPoint(width/2-offset, height/2);
  path.addPoint(width/2 - offset*2/3, height/2+offset*2/3);
  path.addPoint(width/2, height/2+offset);
  path.addPoint(width/2 + offset*2/3, height/2+offset*2/3);
}
