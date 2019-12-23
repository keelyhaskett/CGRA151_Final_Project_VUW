/**
 * Class of the player character (frog)
 * Contains methods to create and control the character, and make sure everything is working properly
 
 */
class Frog {
  boolean bounce = false;
  boolean fall;
  int endJump;

  float x, y;
  final float F_HEIGHT = 150;
  final float F_WIDTH = 120;
  float hitBoxLeft, hitBoxRight;

  final float X_SPEED = 6;
  final float Y_SPEED = 3;

  PImage frogSprite;



  Frog() {
    bounce = true;
    y = height - F_HEIGHT;
    x = width/2 - F_WIDTH/2;
    hitBoxLeft = (F_WIDTH/11) * 3; 
    hitBoxRight = (F_WIDTH/11) * 9;
    endJump = 0;
    fall = false;
    checkFall();
    frogSprite = loadImage("frogUp.png");
  }


  /**
   * Moves the character on the y axis based on the assessments given by the two called methods
   */
  void moveY(ArrayList<Platform> platforms) {
    checkFall();
    checkCollisionPlat(platforms);
    checkCollisionCandy();

    if (fall) {
      y+=Y_SPEED;
    } else {
      y-=Y_SPEED;
    }
  }


  /**
   * Moves the character on the x axis based on user input
   * Doesn't allow movement if the character will go off screen as a result
   */
  void moveX(boolean direction) {
    if (direction) {
      if (x -X_SPEED > 0) {
        x-=X_SPEED;
      }
    } else {
      if ( x + X_SPEED + F_WIDTH < width) {
        x+=X_SPEED;
      }
    }
  }


  /**
   * If the frog is currently in jump mode, increment the current duration timer, and if it is over threshhold, end the jump cycle and initiate fall
   * else if it's falling, and below the game, end the game.
   */
  void checkFall() {
    if (fall == false) {
      endJump ++;
      if (endJump >= (int)(200/Y_SPEED)) {  //(200/Y_SPEED) keeps the timing consistent regardless of the value of Y_SPEED
        fall = true;
        endJump = 0;
        frogSprite = loadImage("frogDown.png");
      }
    } else {
      if (y > height) {
        gameOver = true;
        gameRun = false;
      }
    }
  }


  /**
   * If the frog is currently in jump mode:
   *  check through all the platforms to see if any collide
   *  if there is a collision, enable jump, adjust the y value, remove the platform if it was a broken one.
   */
  void checkCollisionPlat(ArrayList<Platform> platforms) {
    if (fall) {
      Platform toRemove = null;

      for (Platform p : platforms) {
        if (y+F_HEIGHT< p.getY() + Y_SPEED && y+F_HEIGHT > p.getY() - Y_SPEED ) {
          if ((x+hitBoxLeft >= p.getX() - X_SPEED && x + hitBoxLeft <= p.getX() + X_SPEED + p.getXSize()) || (x + hitBoxRight >= p.getX() - X_SPEED && x + hitBoxRight<= p.getX() + X_SPEED + p.getXSize()) ) {
            fall = false;
            frogSprite = loadImage("frogUp.png");
            y = p.getY() - p.getYSize() - F_HEIGHT;

            if (p.getBroken()) {
              toRemove = p;
            }

            break;
          }
        }
      }
      if (toRemove != null) {
        platforms.remove(toRemove);
      }
    }
  }

  /**
   * Checks for collisions with the candy hearts.
   * If collision occurs, gain score equal to the score value and nullify the candy heart
   */
  void checkCollisionCandy() {
    if (candy != null) {
      if (candy.getX() > x && candy.getX() < x + F_WIDTH && candy.getY() > y && candy.getY() < y + F_HEIGHT) {
        score += candy.getScoreValue();
        candy = null;
      } else if (candy.getX() + candy.getWidth() > x && candy.getX()+ candy.getWidth() < x + F_WIDTH && candy.getY() > y && candy.getY() < y + F_HEIGHT) {
        score += candy.getScoreValue();
        candy = null;
      } else if (candy.getX() > x && candy.getX() < x + F_WIDTH && candy.getY() + candy.getHeight() > y && candy.getY() + candy.getHeight()< y + F_HEIGHT) {
        score += candy.getScoreValue();
        candy = null;
      } else if (candy.getX() + candy.getWidth()> x && candy.getX() + candy.getWidth()< x + F_WIDTH && candy.getY() + candy.getHeight()> y && candy.getY() + candy.getHeight()< y + F_HEIGHT) {
        score += candy.getScoreValue();
        candy = null;
      }
    }
  }


  /**
   * Helper Methods
   */
  float getY() {
    return y;
  }

  float getYSpeed() {
    return Y_SPEED;
  }

  void setY(float y) {
    this.y = y;
  }


  void display() {
    image(frogSprite, x, y, F_WIDTH, F_HEIGHT);
  }
}
