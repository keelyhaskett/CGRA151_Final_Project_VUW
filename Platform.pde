
/**
* Interface exists here to make it easier to keep track of the different platforms.
*/ 
interface Platform {
  final float BROKEN_CHANCE = 0.1;  // a broken platform will disappear once the player has collided with it once.
  final float P_HEIGHT = 20;
  
  void display();
  float getY();
  float getX();
  float getXSize();
  float getYSize();
  void incrementY(float ySpeed);
  boolean getBroken();
}
