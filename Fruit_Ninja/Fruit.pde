class Fruit
{
  Body body;
  BodyDef bd;
  FixtureDef fd;
  PImage fruitSprite;

  Fruit(float x, float y)
  {
    fruitSprite = loadImage("Apple.png");
    
    // make me a new body
    bd = new BodyDef();
    bd.type = BodyType.DYNAMIC; // it's gonna move
    bd.position.set(e.coordPixelsToWorld(x,y)); // this is where it starts
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
     image(fruitSprite, pos.x, pos.y, fruitSprite.width, fruitSprite.height);
     
  }
  
  void killBody()
  {
     e.destroyBody(body); 
  }
  
}

