
///LIBRARIES////////////////////////////////////
import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
///////////////////////////////////////////////

int scl = 1;
int outnum;

int total = 200;

Lines line[] = new Lines[total];


float mX;
float mY;

void setup() {
  size(640, 480);
  video = new Capture(this, width/scl, height/scl);
  opencv = new OpenCV(this, width/scl, height/scl);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  for (int i = 0; i< total; i++) {
    line[i] = new Lines();
  }
  video.start();
}


void draw() {
  scale(scl);
  opencv.loadImage(video);
  image(video, 0, 0 ); 

  filter(GRAY); 

  Rectangle[] faces=opencv.detect();

  for (int i=0; i<faces.length; i++) {

    mX += 0.3 * (faces[i].x - mX);
    mY += 0.3 * (faces[i].y - mY);
  }

  for (int i = 0; i< total; i++) {
    line[i].render();
  }



    if (faces.length>1){
      
    for (int i=0; i<faces.length; i++) {

      mX += 1 * (faces[i].x - mX);
      mY += 1 * (faces[i].y - mY);
    }
  }
}








void captureEvent(Capture c) {
  c.read();
}