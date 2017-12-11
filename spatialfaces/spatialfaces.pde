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
float increment, negIncrement, incRate;

// Face
float totalDist, avgDist;
float adjust;

// ==================================================
// SETUP
// ==================================================
void setup() {
  // size(1280, 720);
  fullScreen();
  pixelDensity(displayDensity());
  // video = new Capture(this, 40*4, 30*4,"FaceTime HD Camera", 60);
  // opencv = new OpenCV(this, 40*4, 30*4);
  video = new Capture(this, width/10, height/10,"FaceTime HD Camera", 60);
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
  newBlobDetection.setThreshold(0.5f);
  negIncrement = 0.5f;

  incRate = 0.005;
}

// ==================================================
// DRAW
// ==================================================

// MORE FACES -> Threshold RATE
// AVG DIST -> Color RATE
// RECT DESIGN

void draw() {
  // Mirroring                // ---------------------- !!!!!!!!!!
  translate(width, 0);
  scale(-1, 1);
  opencv.loadImage(video);

  // Rectangle Array
  Rectangle[] faces = opencv.detect();
  println(faces.length);

  // Threshold Flux
  theBlobDetection.setThreshold(increment);
  newBlobDetection.setThreshold(negIncrement);

  if (increment <= 0.8f) {
    increment += incRate;
  } else {
    increment = 0.2f;
  }

  if (negIncrement <= 0.8f) {
    negIncrement += incRate;
  } else {
    negIncrement = 0.2f;
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
  fill(0, 50);
  rect(0, 0, width, height);
  if (mousePressed) image(video,0,0,video.width,video.height);  // TESTING PURPOSES
  img.copy(video, 0, 0, video.width, video.height,
    0, 0, img.width, img.height);
  newImg.copy(video, 0, 0, video.width, video.height,
      0, 0, img.width, img.height);
  fastblur(img, 2);
  fastblur(newImg, 2);
  theBlobDetection.computeBlobs(img.pixels);
  newBlobDetection.computeBlobs(newImg.pixels);
  drawBlobsAndEdges(true, true);

  scale(adjust); // Adjust Scale for Face Detection

  // Face Detection Rectangles & Text
  for (int i = 0; i < faces.length; i++) {
    //println(faces[i].x + "," + faces[i].y);
    noFill();
    stroke(255, 25, 105);
    strokeWeight(4/adjust);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }

  // Face Connection Lines
  if (faces.length > 1) {
    for (int i = 0; i < faces.length-1; i++) {
      line(faces[i].x, faces[i].y, faces[i+1].x, faces[i+1].y);
      // line(faces[i].x + faces[i].width/2, faces[i].y + faces[i].height/2, faces[i+1].x + faces[i+1].width/2, faces[i+1].y + faces[i+1].height/2);
      totalDist += dist(faces[i].x, faces[i].y, faces[i+1].x, faces[i+1].y);
      avgDist = totalDist/(faces.length-1);
      int average = int(avgDist);
      println("avgDist: " + average);
      totalDist = 0;
    }
  }
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
        strokeWeight(1);
        stroke(0, 255, 0);

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
        strokeWeight(1);
        stroke(0, 155, 255);

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
