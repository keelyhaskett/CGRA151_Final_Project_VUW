/**
* This class exists as the scoring system.
* When the game scrolls, there is a chance that a candy heart will spawn (if one isn't already in game)
* If the player collides with the candy heart, they will gain a predetermined random number of score (between 1 and 6)
* If they fail to collect it, they lose the equivalent amount of points.
*/
class CandyHeart {
  PImage candy;
  int scoreValue;
  float x, y;
  final float C_WIDTH = 50;
  final float C_HEIGHT = 50;
  
  CandyHeart(int y) {
    this.y = y;
    x = random(width-C_WIDTH);
    candy = loadImage("candyHeart.png");
    scoreValue = (int)random(1, 6);
  }
  
  
  /**
  * Helper Methods
  */
  float getX() { return x; }
  
  float getY() { return y; }
  
  float getWidth() { return C_WIDTH; }
  
  float getHeight() { return C_HEIGHT; }
  
  float getScoreValue() { return scoreValue; }
  
  void incrementY(float y) { this.y += y; }
  
  
  void display() {
    image(candy, x, y, C_WIDTH, C_HEIGHT);
  }
}
