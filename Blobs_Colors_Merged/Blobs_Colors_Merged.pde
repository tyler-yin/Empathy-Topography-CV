// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/ce-2l2wRqO8

import processing.video.*;
import gab.opencv.*;
import java.awt.*;


Capture video;
OpenCV opencv;

// Number of faces detected over all time. Used to set IDs.
int faceCount = 0;

// Scaling down the video
int scl = 2;

int x, y;
float px, py; 
float outerRad;
float angle;
float pts;
float rot;


float avgDistx; 

color trackColor; 
float threshold = 20;
float distThreshold = 20;

ArrayList<Blob> blobs = new ArrayList<Blob>();

void setup() {
  size(640, 480);
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, width/scl, height/scl, cameras[3]);
  opencv = new OpenCV(this, width/scl, height/scl);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();
  
  px = 0;
  py = 0;
  angle = 0;
  pts = 26;
  rot = 360.0/pts;
  noStroke();
  smooth();
  
  trackColor = color(255, 0, 0);
}

void captureEvent(Capture video) {
  video.read();
}

void keyPressed() {
  if (key == 'a') {
    distThreshold++;
  } else if (key == 'z') {
    distThreshold--;
  }
  println(distThreshold);
}

void draw() {
  video.loadPixels();
  scale(scl);
  opencv.loadImage(video);
  image(video, 0, 0);

  blobs.clear();

  Rectangle[] faces=opencv.detect();

 for (int i=0; i<faces.length; i++) {
    x = faces[i].x + (faces[i].width/2);
    y = faces[i].y + (faces[i].height/2);
    
   int loc = faces[i].x + faces[i].y*(video.width/scl);
  trackColor = video.pixels[loc];
      //filter(BLUR, 6);

    
    
    // draw color wheel
    beginShape(TRIANGLE_STRIP); 
    for (int j = 0; j < pts; j++) {
      outerRad = faces[i].height * 0.9; // set outerRad to 90% of face height
      px = x + cos(radians(angle))*outerRad;
      py = y + sin(radians(angle))*outerRad;
      angle += rot;
      color colour = get(int(px), int(py)); // get colour of surrounding area
      fill(colour);
      vertex(px, py);
      vertex(x, y);
      angle += rot + 0.2; // animate rotation
    }
    endShape();
    
   }
  //threshold = map(mouseX, 0, width, 0, 100);
  threshold = 80;

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d < threshold*threshold) {

        boolean found = false;
        for (Blob b : blobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            found = true;
            break;
          }
        }

        if (!found) {
          Blob b = new Blob(x, y);
          blobs.add(b);
         
        }
      }
    }
  }

  for (Blob b : blobs) {
    if (b.size() > 500) {
      b.show();
    }
  }
}


float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}


float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

//void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
   //int loc = mouseX + mouseY*(video.width/scl);
  //trackColor = video.pixels[loc];
//}