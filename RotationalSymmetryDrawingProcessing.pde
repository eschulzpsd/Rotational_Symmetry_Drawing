//Right click pen up/down
//Left click clear

////Inputs/////
int rotation = 8;//type in rotational symmetry
color backgroundColor = 255;//type in background color
//int penColor = color(255,0,0);//type in pen color
int xSize = 10;
int ySize = 10;
///////////////

boolean penTool = true;

import processing.serial.*;
Serial myPort;
int[] serialArray = new int[3];
int serialCount = 1;
int red;//serial input A0
int green;//serial input A1
int blue;//serial input A2
int penColor;//type in pen color 
boolean firstContact = false;

void setup() {
  size(500, 500);
  background(backgroundColor);
  noStroke();
  rectMode(CENTER);
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);

  instructions();
}

void instructions() {
  textSize(14);
  textAlign(LEFT);
  fill(0);
  text("Left click - pen up/down", 5, 493);
  textAlign(RIGHT);
  text("Right click - clear screen", 495, 493);
}

void serialEvent(Serial myPort) {
  int inByte = myPort.read();
  //println(inByte);
  if (firstContact == false) {
    if (inByte == 'A') {
      myPort.clear();
      firstContact = true;
      myPort.write('A');
      println('A');
    }
  } else {
    serialArray[serialCount] = inByte;
    serialCount++;
    if(serialCount > 2){
      red = serialArray[0]; 
      println("red: " + red);
      green = serialArray[1]; 
      println("green: " + green);
      blue = serialArray[2]; 
      println("blue: " + blue);
      delay(10);

      myPort.write('A');
      serialCount = 0;
    }
  }
}

void colorCheck(){
  fill(255);
  rect(width/2, 490, 120, 10);
  textAlign(LEFT);
  textSize(10);
  fill(0);
  text("R: " + red, (width/2)-60, 495);
  text("G: " + green, (width/2)-15, 495);
  text("B: " + blue, (width/2)+25, 495);
}

void draw() {
  penColor = color(red,green,blue);
  fill(penColor);
  rect(width/2, 480, 120, 10);
  rotation();//enter the sides in variable above
  colorCheck();
}

void mouseClicked() {
  if (mouseButton == LEFT) {
    penTool = !penTool;
  }
  if (mouseButton == RIGHT) {
    background(color(backgroundColor));
    instructions();
  }
}

void rotation() {
  mouseX -= width/2;
  mouseY -= height/2;

  if (penTool) {
    translate(width/2, height/2);
    for (int i = 0; i < rotation; i++) {
      rotate(2*PI/rotation);
      ellipse(mouseX, mouseY, xSize, ySize);
    }
  }
}
