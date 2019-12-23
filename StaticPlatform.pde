class StaticPlatform implements Platform {
  boolean isBroken = false;
  
  float x;
  float y;
  float pWidth = width/5;
  
  PImage plat;
  
  
  
  StaticPlatform(int y) {
    if (random(1) < BROKEN_CHANCE) {
      isBroken = true;
    }
    x = random(width - pWidth);
    this.y = y;
    plat = loadImage("platformStatic.png");
  }
  

  /**
  * Helper Methods
  */
  float getY() {return y;}
  
  float getX() {return x;}
    
  float getXSize() {return pWidth;}
  
  float getYSize() {return P_HEIGHT;}
  
  void incrementY(float ySpeed) { y += ySpeed; }
  
  boolean getBroken() {return isBroken;}
  
  
  
  void display() {
    image(plat, x,y,pWidth,P_HEIGHT);
  }
}
