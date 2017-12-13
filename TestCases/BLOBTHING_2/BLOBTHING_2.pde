// - Super Fast Blur v1.1 by Mario Klingemann <http://incubator.quasimondo.com>
// - BlobDetection library

import processing.video.*;
import blobDetection.*;

Capture cam;
BlobDetection theBlobDetection;
BlobDetection theBlobDetection2;
PImage imgSmall;
Blob theBiggestBlob;
PImage img;
PImage img2;
boolean newFrame=false;
float s=0;

// setup()
void setup()
{
	// Size of applet
	size(640, 480,P2D);

  
	// Capture
	cam = new Capture(this, 40*4, 30*4, 15);
        // Comment the following line if you use Processing 1.5
        cam.start();

	// BlobDetection
	// img which will be sent to detection (a smaller copy of the cam frame);
  BlobDetection.setConstants(1000,1000,750); // Be sure to have enough room for polygon (750 triangles max here for a blob)
  imgSmall = new PImage(40,30); // image which will be sent to detection (a smaller copy of the video frame);
  theBlobDetection = new BlobDetection(imgSmall.width, imgSmall.height);
  theBlobDetection.setPosDiscrimination(true);
  theBlobDetection.computeTriangles();
  theBlobDetection.setThreshold(0.4f); // will detect bright areas whose luminosity > 0.2xf;  

  
  img2 = new PImage(100,50);
  theBlobDetection2 = new BlobDetection(img2.width, img2.height);
  theBlobDetection2.setPosDiscrimination(true);
  theBlobDetection2.setThreshold(0.2f); 
}


// captureEvent()
void captureEvent(Capture cam)
{
	cam.read();
	newFrame = true;
}

// draw()
void draw()
{
   rect(-1,-1,width+1,height+1);
   fill(255,253,240);
   frameRate(30);
	if (newFrame)
	{
  
  
    imgSmall.copy(cam, 0, 0, cam.width, cam.height, 0, 0, imgSmall.width-1, imgSmall.height-1);
    fastblur(imgSmall, 3); 
    theBlobDetection.computeBlobs(imgSmall.pixels);
    theBiggestBlob = findBiggestBlob();
    
    drawBlobTextured(theBiggestBlob, cam);
    drawBlob(theBiggestBlob, true,true,false);   
     
    img2.copy(cam, 0, 0, cam.width, cam.height, 
        0, 0, img2.width, img2.height);
    fastblur(img2, 2);
    theBlobDetection2.computeBlobs(img2.pixels);
    drawBlobsAndEdges2(true,true);
    
	}

    

}  


Blob findBiggestBlob()
{
  Blob biggestBlob = null;
  float surface = 0.0f;
  float surfaceMax = 0.0f;
  Blob b=null;
  for (int i=0;i<theBlobDetection.getBlobNb();i++)
  {
    b = theBlobDetection.getBlob(i);
    surface = b.w * b.h;
    if (surface > surfaceMax)
    {
      surfaceMax=surface;
      biggestBlob = b;
    }
  }
  
  return biggestBlob; 
}