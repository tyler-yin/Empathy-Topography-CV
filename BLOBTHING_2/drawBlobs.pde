void drawBlobTextured(Blob b, PImage tex)
{
  if (b==null) 
    return;

    BlobTriangle bTri;
    EdgeVertex eA,eB,eC;
    textureMode(NORMAL); 
    fill(255,253,240,20); // BACKGROUND <<<<<<<<<<<<
    rect(-1,-1,width+1,height+1);
    //noStroke();
    stroke(255,30);
    beginShape(TRIANGLE);
    texture(tex);
    for (int t=0;t<b.getTriangleNb();t++)
    {
      bTri = b.getTriangle(t);
      eA = b.getTriangleVertexA(bTri);
      eB = b.getTriangleVertexB(bTri);
      eC = b.getTriangleVertexC(bTri);

      vertex(eA.x*width, eA.y*height, eA.x, eA.y);
      vertex(eB.x*width, eB.y*height, eB.x, eB.y);
      vertex(eC.x*width, eC.y*height, eC.x, eC.y);

    }
   endShape(); 
}

void drawBlob(Blob b, boolean drawBlobs, boolean drawEdges, boolean drawTriangles)
{
  if (b==null) 
    return;

  // Edges
  noFill();
  EdgeVertex eA,eB;

  // > Edges
  if (drawEdges)
  {
   // CHANGING STROKE COLOR
        color from = color(100,100,255);
        color to = color(200, 100,255);
        //float c = map(mouseX,0,width,0,1);
        s += 0.02;
        float c = sin(s);
        color colorchange = lerpColor(from, to, c);
        stroke(colorchange);
    for (int m=0;m<b.getEdgeNb();m++)
    {
      eA = b.getEdgeVertexA(m);
      eB = b.getEdgeVertexB(m);
      if (eA !=null && eB !=null)
        line(eA.x*width, eA.y*height, eB.x*width, eB.y*height);
    }
  }

  // Boundings
  //if (drawBlobs)
  //{
  //  strokeWeight(1);
  //  stroke(255,0,0);
  //  rect(b.xMin*width,b.yMin*height,b.w*width,b.h*height);
  //}


}

// drawBlobsAndEdges()
void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges)
{
  noFill();
  Blob b;
  EdgeVertex eA,eB;
  for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
  {
    b=theBlobDetection.getBlob(n);
    if (b!=null)
    {
      // Edges
      if (drawEdges)
      {
        strokeWeight(1);

        // CHANGING STROKE COLOR
        color from = color(100,100,255);
        color to = color(200, 100,255);
        //float c = map(mouseX,0,width,0,1);
        s += 0.02;
        float c = sin(s);
        color colorchange = lerpColor(from, to, c);
        stroke(colorchange);

        for (int m=0;m<b.getEdgeNb();m++)
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
}

void drawBlobsAndEdges2(boolean drawBlobs2, boolean drawEdges2)
{
  noFill();
  Blob b2;
  EdgeVertex eA2,eB2;
  for (int n=0 ; n<theBlobDetection2.getBlobNb() ; n++)
  {
    b2=theBlobDetection2.getBlob(n);
    if (b2!=null)
    {
      // Edges
      if (drawEdges2)
      {
        strokeWeight(1);
        
        // CHANGING STROKE COLOR
        color from = color(255,200,100);
        color to = color(255, 200,240);
        //float c = map(mouseX,0,width,0,1);
        s += 0.02;
        float c = sin(s);
        color colorchange = lerpColor(from, to, c);
        stroke(colorchange);
       // fill(colorchange);
        for (int m=0;m<b2.getEdgeNb();m++)
        {
          eA2 = b2.getEdgeVertexA(m);
          eB2 = b2.getEdgeVertexB(m);
          if (eA2 !=null && eB2 !=null)
            line(
              eA2.x*width, eA2.y*height, 
              eB2.x*width, eB2.y*height
              );
         }
        }
      }
    }
}