PFont font;
// The font must be located in the sketch's 
// "data" directory to load successfully

int alphaValue = 255;

String [] closer = {"Is that a face or not? No offense. Please come closer.", "Did you know? Infants who a million years ago were unable to recognize a face were less likely to win the heart of their parents. Don't you want me to win the heart of my parents? Please come closer."};

String [] distance = {"The total distance between faces is <distance>, assuming you're human and not secretly two cats in a trench coat.", "You've got <distance> units between you. Units of what you ask? That's between you and the machine."};

String [] friend = {"There are <number> of faces. Four eyes look smarter than two. Eight eyes look smarter than four. More eyes, please.", "Sometimes I see faces that aren't really there...probably because I'm lonely. I'd be less lonely if you found a friend to join us."};

boolean fadedIn = false;

void setup(){
 size(displayWidth, displayHeight);
 
}

void draw (){
background(255);
font = createFont("Karla-Bold.ttf", 16);
textFont(font);
text(closer[0], 50, 50);
text(distance[0], 300, 300);
text(friend[0], 500, 600);

fill(0, 0, 0, alphaValue);

}
//if (fadedIn == false) {
//  //if (alphaValue < 254) {
//    alphaValue++;
//      fadedIn = true;
//  }

//if (fadedIn == true) {
//  //if (alphaValue > 254) {
//    alphaValue--;
//}
//}