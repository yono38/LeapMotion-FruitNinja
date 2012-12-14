import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

ArrayList<Vector> fingerPositions = new ArrayList<Vector>();

PBox2D e; // this is our world

ArrayList<Fruit> theFruits;
ArrayList<Splash> theSplashes;

int level = 0;

SampleListener listener;
Controller controller;

PImage backgroundImage;

int swipeR, swipeG, swipeB;

void setup()
{
  size(displayWidth, displayHeight, OPENGL);

  theFruits = new ArrayList<Fruit>();
  theSplashes = new ArrayList<Splash>();

  // this sets up the box2d physics engine to deal with us
  e = new PBox2D(this);
  e.createWorld();
  e.setGravity(0, -20);

  // Create a sample listener and assign it to a controller to receive events
  listener = listener = new SampleListener();
  controller = new Controller(listener);

  backgroundImage = loadImage("Background.png");

  swipeR = int(random(200, 255));
  swipeG = int(random(200, 255));
  swipeB = int(random(200, 255));
}

void draw()
{ 
  swipeR += random(-5, 5);
  swipeG += random(-5, 5);
  swipeB += random(-5, 5);
  swipeR = constrain(swipeR, 200, 255);
  swipeG = constrain(swipeG, 200, 255);
  swipeB = constrain(swipeB, 200, 255);

  background(0);
  tint(255);
  image(backgroundImage, 0, 0, width, height);

  fill(255);
  stroke(swipeR, swipeG, swipeB);
  strokeJoin(ROUND);
  strokeCap(ROUND);

  if ((listener.lastPos != null && listener.connected) || !listener.connected) {
    // remove the last position if fingerPositions has more than 20 positions
    if (fingerPositions.size() > 20) fingerPositions.remove(fingerPositions.size() - 1);

    Vector lastPos;

    if (listener.connected) {
      // add the new position at index 0
      lastPos = listener.lastPos;
    } 
    else {
      lastPos = new Vector(mouseX / (float)(width) * 400 - 200, (height - mouseY) / (float)(height) * 600, 0);
    }

    fingerPositions.add(0, lastPos);

    for (int i = 0; i < fingerPositions.size() - 1; i++) {
      Vector fingerPos1 = fingerPositions.get(i);
      Vector fingerPos2 = fingerPositions.get(i+1);

      float normalizedX1 = (float)(fingerPos1.getX() + 200) / 400 * width;
      float normalizedY1 = height - (float)(fingerPos1.getY()) / 600 * height;
      float normalizedX2 = (float)(fingerPos2.getX() + 200) / 400 * width;
      float normalizedY2 = height - (float)(fingerPos2.getY()) / 600 * height;

      //ellipse(normalizedX, normalizedY, fingerPositions.size() - i, fingerPositions.size() - i);

      strokeWeight(fingerPositions.size() - i);
      line(normalizedX1, normalizedY1, normalizedX2, normalizedY2);
    }
  }

  e.step(); // advances the physics engine one frame

  ArrayList<Splash> splashesToRemove = new ArrayList<Splash>();
  for (Splash splash: theSplashes)
  {
    splash.display();

    // remove splashes if their counter > 255
    if (splash.counter > 255) splashesToRemove.add(splash);
  }

  for (Splash splash: splashesToRemove) theSplashes.remove(splash);

  for (Fruit fruit: theFruits)
  {
    fruit.display();
  }


  // remove the fruits that are off the screen

  ArrayList<Fruit> fruitsToRemove = new ArrayList<Fruit>(); 
  for (Fruit fruit: theFruits) {
    Vec2 position = e.coordWorldToPixels(fruit.body.getPosition());
    if (position.y > height*2 && fruit.body.getLinearVelocity().y < 0) {
      fruitsToRemove.add(fruit);
    }
  }

  for (Fruit fruitToRemove: fruitsToRemove) {
    fruitToRemove.killBody();
    theFruits.remove(fruitToRemove);
  }
  fruitsToRemove.clear();

  // check if the swipe intersects any of the fruits.. if so, remove them and add splash
  for (Fruit fruit: theFruits) {
    if ((listener.hasHands || (!listener.connected)) && fingerPositions.size() > 0) {

      Vector fingerPos = fingerPositions.get(0);
      Vec2 fruitPosition = e.coordWorldToPixels(fruit.body.getPosition());      // center of fruit

      float fingerPosX = (float)(fingerPos.getX() + 200) / 400 * width;
      float fingerPosY = height - (float)(fingerPos.getY()) / 600 * height;
      
      float spriteSize = fruit.fruitSprite.width;    // width and height are same

      if (fingerPosX > fruitPosition.x - spriteSize/2.0 && fingerPosX < fruitPosition.x + spriteSize/2.0 && fingerPosY > fruitPosition.y - spriteSize/2.0 && fingerPosY < fruitPosition.y + spriteSize/2.0) {
        // swiped!
        println("SWIPED!");
        fruitsToRemove.add(fruit);
      }
    }
  }

  for (Fruit fruitToRemove: fruitsToRemove) {
    Vec2 fruitPosition = e.coordWorldToPixels(fruitToRemove.body.getPosition());

    // add splash
    Splash splash = new Splash(fruitToRemove.fruitName(), fruitPosition);
    theSplashes.add(splash);

    fruitToRemove.killBody();
    theFruits.remove(fruitToRemove);
  }


  // new level
  if (theFruits.size() == 0) {
    // increment the level... add fruits
    level++;
    int numFruits = (int)random(1, 6);
    for (int i = 0; i < numFruits; i++) {
      int randomX = int(random(0, width));
      int impulseX = int(random(0, width));
      if (randomX > width/2) impulseX *= -1; 

      Fruit p = new Fruit(randomX, height + 20); 
      theFruits.add(p);

      p.body.applyAngularImpulse(0.5);
      p.body.applyLinearImpulse(new Vec2(impulseX, random(height * 2, height * 3)), e.getBodyPixelCoord(p.body));
    }
  }
}

