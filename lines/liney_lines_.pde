class Lines {

  ///VARIABLES////////////////////////////////////
  float thold = 5;
  float spifac = 1.05;
  float drag = 0.01;
  float X;
  float Y;
  float Xv;
  float Yv;
  float pX;
  float pY;
  float w;
  ///////////////////////////////////////////////



  Lines() {
    strokeWeight(1);
    fill(255, 255, 255);
    stroke(0, 255, 0);
    //background(0, 0, 0);   
    smooth();

    X = random(width);
    Y = random(height); 
    w = random(1 / thold, thold);
  }

  void render() {

    //ADD VALUES
    
    Xv /= spifac;
    Yv /= spifac;

  
    Xv += drag * (mX - X) * w;
    Yv += drag * (mY - Y) * w;
    X += Xv;
    Y += Yv;
    //line(X, Y, pX, pY);
    int length = 5;
    line(X-length, Y, pX+length, pY);
    line(X, Y-length, pX, pY+length);

    pX = X;
    pY = Y;
  }
}