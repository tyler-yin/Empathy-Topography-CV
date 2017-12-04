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
float faceX, faceY;
float totalDist;
Path path;

/////////////////////////////////
// SETUP
/////////////////////////////////
void setup() {
  // size(640, 480, P2D); // for faster run-time?
  size(640, 480);
  // frameRate(30);
  // newPath();
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
  // MIRRORING
  // translate(video.width, 0);
  // scale(-1, 1);

  // Video Feed
  //scale(2);
  opencv.loadImage(video);
  image(video, 0, 0);
  filter(GRAY);

  //path.display();

  // Rectangle Array
  noFill();
  stroke(0, 255, 0);
  strokeWeight(2);
  Rectangle[] faces = opencv.detect();
  println(faces.length);

  println(oneface);

  // Face Detection Rectangles & Text
  for (int i = 0; i < faces.length; i++) {
    //println(faces[i].x + "," + faces[i].y);
    noFill();
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    textSize(10);
    fill(0, 255, 0);
    text("face0"+ (i+1), faces[i].x, faces[i].y-3);
  }

  // Face Connection Lines
  if (faces.length > 1) {
    for (int i = 0; i < faces.length-1; i++) {
      line(faces[i].x, faces[i].y, faces[i+1].x, faces[i+1].y);
      totalDist = dist(faces[i].x, faces[i].y, faces[i+1].x, faces[i+1].y);
      // use an arraylist?? to add up values
    }
  }

  // Scenarios
  // No Face Detected
  if (faces.length == 0) {
    pushMatrix();
    fill(0, 255, 0);
    textSize(12);
    text("THERE ARE [NO] FACE(S) DETECTED", 50, 50);
    text("THE TOTAL DISTANCE BETWEEN FACES IS [N/A]", 50, 65);
    text("REQUEST: DON'T BE A STRANGER", 50, 80);
    popMatrix();
  }

  // One Face Detected
  if (faces.length == 1) {
    pushMatrix();
    fill(0, 255, 0);
    textSize(12);
    text("THERE ARE [01] FACE(S) DETECTED", 50, 50);
    text("THE TOTAL DISTANCE BETWEEN FACES IS [N/A]", 50, 65);
    text("REQUEST: FIND A FRIEND TO JOIN YOU", 50, 80);
    popMatrix();

    faceX = faces[0].x;
    faceY = faces[0].y;
    oneface = true;
  } else {
    oneface = false;
  }

  // Two Faces Detected
  if (faces.length == 2) {
    pushMatrix();
    fill(0, 255, 0);
    textSize(12);
    text("THERE ARE [02] FACE(S) DETECTED", 50, 50);
    text("THE TOTAL DISTANCE BETWEEN FACES IS [" + totalDist + "]", 50, 65);
    if (totalDist < width/2) text("REQUEST: MAINTAIN RELATIONSHIP", 50, 80);
    if (totalDist >= width/2) text("REQUEST: GET CLOSER TO EACH OTHER - DO NOT BE SHY", 50, 80);
    popMatrix();
  }

  // Three Faces Detected
  if (faces.length >= 3) {
    pushMatrix();
    fill(0, 255, 0);
    textSize(12);
    text("THERE ARE [0" + faces.length + "] FACE(S) DETECTED", 50, 50);
    text("THE TOTAL DISTANCE BETWEEN FACES IS [" + totalDist + "]", 50, 65);
    text("REQUEST: START A PARTY", 50, 80);
    popMatrix();
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
// void newPath() {
//   // A more sophisticated path might be a curve
//   path = new Path();
//   float offset = 10;
//   path.addPoint(width/2 + offset, height/2);
//   path.addPoint(width/2 + offset*2/3, height/2-offset*2/3);
//   path.addPoint(width/2, height/2-offset);
//   path.addPoint(width/2 - offset*2/3, height/2-offset*2/3);
//   path.addPoint(width/2-offset, height/2);
//   path.addPoint(width/2 - offset*2/3, height/2+offset*2/3);
//   path.addPoint(width/2, height/2+offset);
//   path.addPoint(width/2 + offset*2/3, height/2+offset*2/3);
// }