class Fruit
{
  Body body;
  BodyDef bd;
  FixtureDef fd;
  PImage fruitSprite;

  int type;

  String fruitName()
  {
    if (type == 0) {
     return "Apple"; 
    } else if (type == 1) {
     return "Apricot"; 
    } else if (type == 2) {
     return "Banana"; 
    } else if (type == 3) {
     return "Orange"; 
    } else if (type == 4) {
     return "Peach"; 
    } else if (type == 5) {
     return "Pear"; 
    } else if (type == 6) {
     return "Strawberry"; 
    }
    return "Apple";
  }

  Fruit(float x, float y)
  {
    type = (int)(random(0, 7));
    String spriteName = fruitName();
    
    fruitSprite = loadImage(spriteName + ".png");

    // make me a new body
    bd = new BodyDef();
    bd.type = BodyType.DYNAMIC; // it's gonna move
    bd.position.set(e.coordPixelsToWorld(x, y)); // this is where it starts
    body = e.createBody(bd); // registers it with the physics engine

    // this describes the shape of the thing
    CircleShape ps = new CircleShape();
    ps.m_radius = e.scalarPixelsToWorld(fruitSprite.width/2);
    // this makes the fixture
    fd = new FixtureDef();
    fd.shape = ps; // assigns the shape to the fixture

    // some parameters
    fd.density = 1.;
    fd.friction = 0.3;
    fd.restitution = 1.;
    fd.isSensor = true;

    body.createFixture(fd);
  }

  void display()
  {
    Vec2 pos = e.getBodyPixelCoord(body); // find out where it is
    float a = body.getAngle();
    
    rectMode(CENTER);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a/180*PI);
    translate(-fruitSprite.width/2.0, -fruitSprite.height/2.0);
    
    tint(255);
    image(fruitSprite, 0, 0, fruitSprite.width, fruitSprite.height);
        
    popMatrix();
  }

  void killBody()
  {
    e.destroyBody(body);
  }
}

