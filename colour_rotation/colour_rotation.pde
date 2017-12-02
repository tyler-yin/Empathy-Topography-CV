
import gab.opencv.*;
import processing.video.*;
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

void setup() {
  size(640, 480);
  video = new Capture(this, width/scl, height/scl);
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
}


void draw() {
  scale(scl);
  opencv.loadImage(video);
  image(video, 0, 0 );
  //background(255); 
 
  Rectangle[] faces=opencv.detect();

 for (int i=0; i<faces.length; i++) {
    x = faces[i].x + (faces[i].width/2);
    y = faces[i].y + (faces[i].height/2);
    
    
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
 }





void captureEvent(Capture c) {
  c.read();
}