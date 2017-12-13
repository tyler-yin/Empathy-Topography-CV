class FaceCount {

float avgDistx; 
int x, y ; 

FaceCount() {
  

}
  
  
 void run(){
   
   //noFill();
   strokeWeight(00.3);
   //stroke(255, 0, 0);

   Rectangle[] faces=opencv.detect();
   
    for (int i=0; i<faces.length; i++) {
    x = faces[i].x + (faces[i].width/2);
    y = faces[i].y + (faces[i].height/2);
    }
   
   if (faces.length == 1) {
     for (int i = 0; i < faces.length; i++) { 
        rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
        color colour = get(int(x), int(y)); 
        fill(colour); 
     }
     
     if (faces.length>1) {
    for (int i = 0; i < faces.length-1; i++) {
      avgDistx = (faces[i+1].x - faces[i].x)/2; 
      
      line(faces[i].x, faces[i].y, faces[i+1].x, faces[i+1].y);
       text(avgDistx, (faces[i].x/2), (faces[i].y/2));
       
    }
  }
   }
 }
}
 