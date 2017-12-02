import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;


// Number of faces detected over all time. Used to set IDs.
//int faceCount = 0;

// Scaling down the video

int scl = 2;

//float avgDistx; 

FaceCount facecount; 

void setup() {
  
  size(640, 480);
  video = new Capture(this, width/scl, height/scl);
  opencv = new OpenCV(this, width/scl, height/scl);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  facecount = new FaceCount();
  video.start();
  
}


void draw() {
  
  scale(scl);
  opencv.loadImage(video);
  image(video, 0, 0 );
  facecount.run(); 
 
}

void captureEvent(Capture c) {
  c.read();
}