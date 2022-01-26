/*
Alan Lu
Jan 25

3d environment
*/



import java.awt.Robot;

color black = #000000;
color white = #FFFFFF;
color blue  = #0000FF;
color red   = #FF0000;
color back  = #78A7FF;


int gridSize;
PImage map;

Robot bot;
boolean skipFrame;
PImage egirl;
PImage grasstop;
PImage grassside;


boolean wkey, akey, skey, dkey;
float eyex, eyey, eyez, focusx, focusy, focusz, tiltx, tilty, tiltz;
float leftRightHeadAngle, upDownHeadAngle;

void setup() {
  egirl = loadImage("sombra.png");
  grassside = loadImage("Grass_Block_Side.png");
  grasstop = loadImage("Grass_Block_Top.png");
  size(displayWidth, displayHeight, P3D);
  textureMode(NORMAL);
  wkey = akey = skey = dkey = false;
  eyex = width/2;
  eyey = height - 100;
  eyez = 0;
  focusx = width/2;
  focusy = height - 100;
  focusz = 10;
  tiltx = 0;
  tilty = 1;
  tiltz = 0;
  noCursor();


  leftRightHeadAngle = radians(270);

  try {
    bot = new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }
  skipFrame = false;
  map = loadImage("map.png");
  gridSize = 60;
}



void draw() {
  background(back);
  camera(eyex, eyey, eyez, focusx, focusy, focusz, tiltx, tilty, tiltz);

  //drawFloor();
  drawFocalPoint();
  controlCamera();

  drawMap();
}

//normal cubes
//void drawMap() {
//  for (int x = 0; x < map.width; x++) {
//    for (int y = 0; y < map.height; y++) {
//      color c = map.get(x, y);
//      if (c != white) {
//        pushMatrix(); 
//          fill(black);
//        stroke(255);
//        if (c == black) {
//          translate(x * gridSize - 2000 - gridSize/2, height - gridSize/2, y * gridSize - 2000 - gridSize/2);
//          box(gridSize, gridSize, gridSize);
//        } else if (c == red) {
//          translate(x * gridSize - 2000 - gridSize/2, height - gridSize, y * gridSize - 2000 - gridSize/2);
//          box(gridSize, gridSize*2, gridSize);
//        } else if (c == blue) {
//          translate(x * gridSize - 2000 - gridSize/2, height - gridSize*1.5, y * gridSize - 2000 - gridSize/2);
//          box(gridSize, gridSize*3, gridSize);
//        }
//        popMatrix();
//      }
//    }
//  }
//}

void drawMap() {

  //big sombra background
  //pushMatrix();
  //translate(-2000, -1500, -2000);
  //texturedCube(0, 0, 0, egirl, 5000);
  //popMatrix();

  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);

      pushMatrix(); 
      fill(black);
      stroke(255);

      //sombraland
      //if (c == black) {
      //  translate(x * gridSize - 2000, height - gridSize, y * gridSize - 2000);
      //  texturedCube(0, 0, 0, egirl, gridSize);
      //} else if (c == red) {
      //  translate(x * gridSize - 2000, height - gridSize*2, y * gridSize - 2000);
      //  texturedCube(0, 0, 0, egirl, gridSize);
      //} else if (c == blue) {
      //  translate(x * gridSize - 2000, height - gridSize*3, y * gridSize - 2000);
      //  texturedCube(0, 0, 0, egirl, gridSize);
      //} else if (c == white) {
      //  translate(x * gridSize - 2000, height, y * gridSize - 2000);
      //  texturedCube(0, 0, 0, egirl, gridSize);
      //}

      //grasslands
      if (c == black) {
        translate(x * gridSize - 2000, height - gridSize, y * gridSize - 2000);
        texturedCube(0, 0, 0, grasstop, grassside, gridSize);
      } else if (c == red) {
        translate(x * gridSize - 2000, height - gridSize*2, y * gridSize - 2000);
        texturedCube(0, 0, 0, grasstop, grassside, gridSize);
      } else if (c == blue) {
        translate(x * gridSize - 2000, height - gridSize*3, y * gridSize - 2000);
        texturedCube(0, 0, 0, grasstop, grassside, gridSize);
      } else if (c == white) {
        translate(x * gridSize - 2000, height, y * gridSize - 2000);
        texturedCube(0, 0, 0, grasstop, grassside, gridSize);
      }
      popMatrix();
    }
  }
}

void drawFocalPoint() {
  pushMatrix();
  translate(focusx, focusy, focusz);
  //sphere(5);

  popMatrix();
}

void drawFloor() {
  stroke(255);
  for (int x = -5000; x <= 5000; x = x + 60) {
    line(x, height, -5000, x, height, 5000);
    line(-5000, height, x, 5000, height, x);
  }
}

void controlCamera() {
  if (wkey) {
    eyez = eyez + sin(leftRightHeadAngle)*10;
    eyex = eyex + cos(leftRightHeadAngle)*10;
  }
  if (skey) {
    eyez = eyez - sin(leftRightHeadAngle)*10;
    eyex = eyex - cos(leftRightHeadAngle)*10;
  }
  if (akey) {
    eyez = eyez - sin(leftRightHeadAngle + PI/2)*10;
    eyex = eyex - cos(leftRightHeadAngle + PI/2)*10;
  }
  if (dkey) {
    eyez = eyez + sin(leftRightHeadAngle + PI/2)*10;
    eyex = eyex + cos(leftRightHeadAngle + PI/2)*10;
  }

  if (skipFrame == false) {
    leftRightHeadAngle = leftRightHeadAngle + (mouseX - pmouseX)*0.01;
    upDownHeadAngle = upDownHeadAngle + (mouseY - pmouseY)*0.01;
  }

  if (upDownHeadAngle > PI/2.5) upDownHeadAngle = PI/2.5;
  if (upDownHeadAngle < -PI/2.5) upDownHeadAngle = -PI/2.5;


  focusx = eyex + cos(leftRightHeadAngle)*300;
  focusz = eyez + sin(leftRightHeadAngle)*300;
  focusy = eyey + tan(upDownHeadAngle)*300;

  if (mouseX < 2) {
    bot.mouseMove(width-3, mouseY);
    skipFrame = true;
  } else if (mouseX > width-2) {
    bot.mouseMove(3, mouseY);
    skipFrame = true;
  } else {
    skipFrame = false;
  }
}


void texturedCube(float x, float y, float z, PImage texture, float size) {
  pushMatrix();

  translate(x, y, z);
  scale(size);
  noStroke();


  beginShape(QUADS);
  texture(texture);

  //top
  //     x  y  z  tx ty
  vertex(0, 0, 0, 0, 0);
  vertex(1, 0, 0, 1, 0);
  vertex(1, 0, 1, 1, 1);
  vertex(0, 0, 1, 0, 1);
  //bottom
  vertex(0, 1, 0, 0, 0);
  vertex(1, 1, 0, 1, 0);
  vertex(1, 1, 1, 1, 1);
  vertex(0, 1, 1, 0, 1);
  //front
  vertex(0, 0, 1, 0, 0);
  vertex(1, 0, 1, 1, 0);
  vertex(1, 1, 1, 1, 1);
  vertex(0, 1, 1, 0, 1);
  //back
  vertex(0, 0, 0, 0, 0);
  vertex(1, 0, 0, 1, 0);
  vertex(1, 1, 0, 1, 1);
  vertex(0, 1, 0, 0, 1);
  //left
  vertex(1, 0, 1, 0, 0);
  vertex(1, 0, 0, 1, 0);
  vertex(1, 1, 0, 1, 1);
  vertex(1, 1, 1, 0, 1);
  //right
  vertex(0, 0, 1, 0, 0);
  vertex(0, 0, 0, 1, 0);
  vertex(0, 1, 0, 1, 1);
  vertex(0, 1, 1, 0, 1);

  endShape();


  popMatrix();
}

void texturedCube(float x, float y, float z, PImage topbottom, PImage side, float size) {
  pushMatrix();

  translate(x, y, z);
  scale(size);
  noStroke();


  beginShape(QUADS);
  texture(topbottom);

  //top
  //     x  y  z  tx ty
  vertex(0, 0, 0, 0, 0);
  vertex(1, 0, 0, 1, 0);
  vertex(1, 0, 1, 1, 1);
  vertex(0, 0, 1, 0, 1);

  //bottom
  vertex(0, 1, 0, 0, 0);
  vertex(1, 1, 0, 1, 0);
  vertex(1, 1, 1, 1, 1);
  vertex(0, 1, 1, 0, 1);

  endShape();

  beginShape(QUADS);
  texture(side);

  //front
  vertex(0, 0, 1, 0, 0);
  vertex(1, 0, 1, 1, 0);
  vertex(1, 1, 1, 1, 1);
  vertex(0, 1, 1, 0, 1);
  //back
  vertex(0, 0, 0, 0, 0);
  vertex(1, 0, 0, 1, 0);
  vertex(1, 1, 0, 1, 1);
  vertex(0, 1, 0, 0, 1);
  //left
  vertex(1, 0, 1, 0, 0);
  vertex(1, 0, 0, 1, 0);
  vertex(1, 1, 0, 1, 1);
  vertex(1, 1, 1, 0, 1);
  //right
  vertex(0, 0, 1, 0, 0);
  vertex(0, 0, 0, 1, 0);
  vertex(0, 1, 0, 1, 1);
  vertex(0, 1, 1, 0, 1);

  endShape();


  popMatrix();
}






void keyPressed() {

  if (key == 'W' || key == 'w') wkey = true;
  if (key == 'A' || key == 'a') akey = true;
  if (key == 'S' || key == 's') skey = true;
  if (key == 'D' || key == 'd') dkey = true;
}

void keyReleased() {

  if (key == 'W' || key == 'w') wkey = false;
  if (key == 'A' || key == 'a') akey = false;
  if (key == 'S' || key == 's') skey = false;
  if (key == 'D' || key == 'd') dkey = false;
}
