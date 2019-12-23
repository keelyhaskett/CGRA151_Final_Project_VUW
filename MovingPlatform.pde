class MovingPlatform implements Platform {
  boolean isBroken = false;
  boolean movingLeft = true;
  
  float x;
  float y;
  float pWidth = width/5;
  float xSpeed;
  
  PImage plat;
  
  MovingPlatform(int y) {
    if (random(1) < BROKEN_CHANCE) {
      isBroken = true;
    }
    
    x = random(width- pWidth);
    this.y = y;
    xSpeed = random(1, 4);
    
    plat = loadImage("platformMoving.png");
  }
  
  
  /**
  * Check which way the platform should be moving, then move it that way on the x axis
  */
  void move() {
    if (x + pWidth + xSpeed >= width) {movingLeft = false;}
    else if (x <= 0) {movingLeft = true;}
    if (movingLeft) { x += xSpeed; }
    else {x -= xSpeed; }
  }
  
  
  /**
  * Helper Methods
  */
  float getY() {return y;}
  
  float getX() {return x;}
  
  float getXSize() {return pWidth;}
  
  float getYSize() {return P_HEIGHT;}
  
  boolean getBroken() {return isBroken;}
  
  void incrementY(float ySpeed) { y += ySpeed; }
  
  void display() {
    move();
    image(plat, x,y,pWidth,P_HEIGHT);
  }
}
