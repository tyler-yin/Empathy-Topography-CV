// MORE FACES -> Threshold RATE ----- DONE
// AVG DIST -> Color VALUES ----- DONE
// RECTANGLE DESIGN ----- DONE?
// COPY ----- DONE?
// COLOR SCHEME ----- DONE?
// PGRAPHICS !!!!
// VIDEO


// ==================================================
// Import Libraries
// ==================================================
import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import blobDetection.*;
// import java.util.*

// ==================================================
// Declarations
// ==================================================
Capture video;
OpenCV opencv;

// Blob
BlobDetection theBlobDetection, newBlobDetection;
PImage img, newImg;
float increment, newIncrement, incRate;

// Face
float totalDist, avgDist;
float adjust;

// Color
color c;
// color background;
float hue, saturation, brightness;
float hue2, saturation2, brightness2, colorOffset;
float fade;

// Text
PFont font, font2;
String closer = "Is that a face or not? No offense. Please come closer.";
String [] distance = {"You've got ", " units between you. Units of what you ask? That's between you and the machine."};
String friend = "Four eyes look smarter than two. More eyes, please.";

// ==================================================
// SETUP
// ==================================================
void setup() {
  // size(1280, 720);
  fullScreen();
  pixelDensity(displayDensity());
  noCursor();

  // Video
  // video = new Capture(this, 40*4, 30*4,"FaceTime HD Camera", 60);
  // opencv = new OpenCV(this, 40*4, 30*4);
  video = new Capture(this, width/10, height/10, "FaceTime HD Camera", 60);
  opencv = new OpenCV(this, width/10, height/10);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  video.start();
  adjust = width/video.width;

  // Blob Detection
  img = new PImage(video.width, video.height);
  theBlobDetection = new BlobDetection(img.width, img.height);
  theBlobDetection.setPosDiscrimination(true);
  theBlobDetection.setThreshold(0.2f);
  increment = 0.2f;

  newImg = new PImage(video.width, video.height);
  newBlobDetection = new BlobDetection(newImg.width, newImg.height);
  newBlobDetection.setPosDiscrimination(true);
  newBlobDetection.setThreshold(0.6f);
  newIncrement = 0.5f;

  incRate = 0.005;

  // Blob Color
  fade = 50;
  //color(255, 25, 105);
  // starting color, creamy, not TECH
  c = color(215, 20, 20); //255, 15, 15 //255, 240, 200
  hue = hue(c);
  saturation = saturation(c);
  brightness = brightness(c);
  colorOffset = 40;
  hue2 = hue + colorOffset;
  saturation2 = 155;
  brightness2 = 35;
  // background = color(255); //140, 25, 155

  // Text
  // font = createFont("Karla-Bold.ttf", 16);
  font = loadFont("Akkurat-16.vlw");
  textFont(font, 24);
}

// ==================================================
// DRAW
// ==================================================
void draw() {
  // Mirroring
  pushMatrix();
  translate(width, 0);
  scale(-1, 1);
  opencv.loadImage(video);

  // Rectangle Array
  Rectangle[] faces = opencv.detect();
  println(faces.length);

  // Threshold Flux
  theBlobDetection.setThreshold(increment);
  if (increment <= 0.9f) {
    increment += incRate;
  } else {
    increment = 0.1f;
  }

  newBlobDetection.setThreshold(newIncrement);
  if (newIncrement <= 0.9f) {
    newIncrement += incRate;
  } else {
    newIncrement = 0.1f;
  }

  // Threshold Rates
  if (faces.length == 0) incRate = 0.0050;
  if (faces.length == 1) incRate = 0.0075;
  if (faces.length == 2) incRate = 0.0100;
  if (faces.length == 3) incRate = 0.0125;
  if (faces.length == 4) incRate = 0.0150;
  if (faces.length == 5) incRate = 0.0175;
  if (faces.length >= 6) incRate = 0.0200;

  // Blobs
  colorMode(HSB);
  // fill(background, fade);
  fill(hue, saturation2, brightness2, fade);  // BACKGROUND COLOR
  noStroke();
  rect(0, 0, width, height);
  if (mousePressed) image(video,0,0,video.width,video.height);  // TESTING PURPOSES
  img.copy(video, 0, 0, video.width, video.height, 0, 0, img.width, img.height);
  fastblur(img, 2);
  theBlobDetection.computeBlobs(img.pixels);
  newImg.copy(video, 0, 0, video.width, video.height, 0, 0, img.width, img.height);
  fastblur(newImg, 2);
  newBlobDetection.computeBlobs(newImg.pixels);
  drawBlobsAndEdges(true, true);

  // Face Detection Rectangles
  scale(adjust);
  for (int i = 0; i < faces.length; i++) {
    noFill();
    stroke(hue2, saturation, brightness);
    // stroke(255, 25, 105);
    // stroke(255);
    strokeWeight(2/adjust);
    // rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    drawBracket(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }

  // Face Connection Lines & AvgDist //PGRAPHIC?
  if (faces.length > 1) {
    for (int i = 0; i < faces.length-1; i++) {
      // line(faces[i].x, faces[i].y, faces[i+1].x, faces[i+1].y);
      // Distance
      totalDist += dist(faces[i].x, faces[i].y, faces[i+1].x, faces[i+1].y);
      float temp = totalDist/(faces.length-1);
      avgDist = map(temp, 0, 10, 0, 100);
      int average = int(avgDist);
      println("avgDist: " + average);
      totalDist = 0;
    }
  }

  // Color Mapping
  if (hue >= 360-colorOffset) hue2 = (hue + colorOffset) - 360;
  else hue2 = hue + colorOffset;
  if (faces.length > 1) {
    hue = map(avgDist, 0, width, 0, 360);     // WIDTH??
    if (saturation2 < saturation(c)) saturation2++;
    if (brightness2 < brightness(c)) brightness2++;
  } else {
    // return to normal
    if (hue < 140) hue++;
    if (hue > 140) hue--;
    if (saturation2 > 155) saturation2--;
    if (brightness2 > 35) brightness2--;
  }
  popMatrix();

  // Text Scenarios
  textScenario(faces.length, avgDist);
}

// ==================================================
// textScenario()
// ==================================================
void textScenario(int num, float dist) {
  // fill(hue, saturation, brightness);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(24);
  if (num == 0) text(closer, width/2, height/2);
  if (num == 1) text(friend, width/2, height/2);
  if (num > 1) text(distance[0] + int(dist) + distance[1], width/2, height/2);
}

// ==================================================
// drawBracket()
// ==================================================
void drawBracket(float x, float y, float w, float h) {
  line(x, y, x+5, y);
  line(x,y, x, y+5);
  line(x+w, y, x+w-5, y);
  line(x+w, y, x+w, y+5);
  line(x, y+h, x, y+h-5);
  line(x, y+h, x+5, y+h);
  line(x+w, y+h, x+w-5, y+h);
  line(x+w, y+h, x+w, y+h-5);
}

// ==================================================
// drawBlobsAndEdges()
// ==================================================
void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges) {
  // First Blob
  noFill();
  Blob b;
  EdgeVertex eA, eB;
  for (int n=0; n<theBlobDetection.getBlobNb(); n++)
  {
    b=theBlobDetection.getBlob(n);
    if (b!=null)
    {
      // Edges
      if (drawEdges)
      {
        colorMode(HSB);
        stroke(hue2, saturation, brightness);
        strokeWeight(1);
        for (int m=0; m<b.getEdgeNb(); m++)
        {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null)
            line(
              eA.x*width, eA.y*height,
              eB.x*width, eB.y*height
              );
        }
      }
    }
  }
  // Second Blob
  noFill();
  Blob c;
  EdgeVertex eC, eD;
  for (int n=0; n<newBlobDetection.getBlobNb(); n++)
  {
    c=newBlobDetection.getBlob(n);
    if (c!=null)
    {
      // Edges
      if (drawEdges)
      {
        // stroke(hue2, saturation, brightness);
        stroke(255);
        strokeWeight(1);
        for (int m=0; m<c.getEdgeNb(); m++)
        {
          eC = c.getEdgeVertexA(m);
          eD = c.getEdgeVertexB(m);
          if (eC !=null && eD !=null)
            line(
              eC.x*width, eC.y*height,
              eD.x*width, eD.y*height
              );
        }
      }
    }
  }
}

// ==================================================
// Super Fast Blur v1.1
// by Mario Klingemann
// <http://incubator.quasimondo.com>
// ==================================================
void fastblur(PImage img, int radius) {
  if (radius<1) {
    return;
  }
  int w=img.width;
  int h=img.height;
  int wm=w-1;
  int hm=h-1;
  int wh=w*h;
  int div=radius+radius+1;
  int r[]=new int[wh];
  int g[]=new int[wh];
  int b[]=new int[wh];
  int rsum, gsum, bsum, x, y, i, p, p1, p2, yp, yi, yw;
  int vmin[] = new int[max(w, h)];
  int vmax[] = new int[max(w, h)];
  int[] pix=img.pixels;
  int dv[]=new int[256*div];
  for (i=0; i<256*div; i++) {
    dv[i]=(i/div);
  }

  yw=yi=0;

  for (y=0; y<h; y++) {
    rsum=gsum=bsum=0;
    for (i=-radius; i<=radius; i++) {
      p=pix[yi+min(wm, max(i, 0))];
      rsum+=(p & 0xff0000)>>16;
      gsum+=(p & 0x00ff00)>>8;
      bsum+= p & 0x0000ff;
    }
    for (x=0; x<w; x++) {

      r[yi]=dv[rsum];
      g[yi]=dv[gsum];
      b[yi]=dv[bsum];

      if (y==0) {
        vmin[x]=min(x+radius+1, wm);
        vmax[x]=max(x-radius, 0);
      }
      p1=pix[yw+vmin[x]];
      p2=pix[yw+vmax[x]];

      rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
      gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
      bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
      yi++;
    }
    yw+=w;
  }

  for (x=0; x<w; x++) {
    rsum=gsum=bsum=0;
    yp=-radius*w;
    for (i=-radius; i<=radius; i++) {
      yi=max(0, yp)+x;
      rsum+=r[yi];
      gsum+=g[yi];
      bsum+=b[yi];
      yp+=w;
    }
    yi=x;
    for (y=0; y<h; y++) {
      pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
      if (x==0) {
        vmin[y]=min(y+radius+1, hm)*w;
        vmax[y]=max(y-radius, 0)*w;
      }
      p1=x+vmin[y];
      p2=x+vmax[y];

      rsum+=r[p1]-r[p2];
      gsum+=g[p1]-g[p2];
      bsum+=b[p1]-b[p2];

      yi+=w;
    }
  }
}

// ==================================================
// CAPTURE
// ==================================================
void captureEvent(Capture c) {
  c.read();
}