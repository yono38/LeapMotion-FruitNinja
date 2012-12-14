class Splash {
  
 int counter = 0;
 PImage splashImage;
 Vec2 pos;
 
 Splash(String fruitName, Vec2 position) {
   splashImage = loadImage(fruitName + "_Splash.png");
   pos = position;
   pos.x -= 120;
   pos.y -= 120;
 }
 
 void display()
  {
    counter++;
    tint(255.0, 255-counter);
    image(splashImage, pos.x, pos.y, splashImage.width, splashImage.height);
  }
}
