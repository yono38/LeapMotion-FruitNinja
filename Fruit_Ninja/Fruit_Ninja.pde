import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

PBox2D e; // this is our world

ArrayList<Fruit> theFruits;

int level = 0;

void setup()
{
  size(500, 500, OPENGL);

  theFruits = new ArrayList<Fruit>();

  // this sets up the box2d physics engine to deal with us
  e = new PBox2D(this);
  e.createWorld();
  e.setGravity(0, -20);
}

void draw()
{
  background(0);
  e.step(); // advances the physics engine one frame

  for (Fruit fruit: theFruits)
  {
    fruit.display();
  }


  // remove the fruits that are off the screen

  ArrayList<Fruit> fruitsToRemove = new ArrayList<Fruit>(); 
  for (Fruit fruit: theFruits) {
    Vec2 position = e.coordWorldToPixels(fruit.body.getPosition());
    if (position.y > height*2 && fruit.body.getLinearVelocity().y < 0) {
      println("UNDER THE SCREEN");
      fruitsToRemove.add(fruit);
    }
  }
  for (Fruit fruitToRemove: fruitsToRemove) {
    fruitToRemove.killBody();
    theFruits.remove(fruitToRemove);
  }

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
      
      
      p.body.applyLinearImpulse(new Vec2(impulseX, random(1500,2200)), e.getBodyPixelCoord(p.body));
    }
  }
}

