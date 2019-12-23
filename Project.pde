boolean gameRun = false;        // is the game running? //<>//
boolean gameOver = false;       // has the player died?
boolean instructions = true;    // are we still in instructions phase?

//parameters for the user interactive buttons (values set in setup())
float startButtonLeft, startButtonTop;
float buttonSizeX, buttonSizeY;
float quitButtonLeft, quitButtonTop;
float menuButtonLeft, menuButtonTop;
float instrMenuButtonLeft, instrMenuButtonTop, instrMenuButtonSizeX, instrMenuButtonSizeY;

int score;
float currentNoPlatformInterval;   // makes sure there's always a platform within jumping distance
int maxWithoutPlatforms = 50;      // force generates a platform after this long
int minWithoutPlatforms = 10;      //  won't generate any platforms until this
float maxHeight;                   // stays the same, when frog reaches value, move game down
float platformGenerationChance;    // the probability that a platform will generate
float timeCounterForDifficulty;    // counter which resets self at certain point, ticks to decrease platformGenerationChancein
int maxTime = 400;                 // value at which to reset timeCounterForDifficulty
float randomDetermineCandy = 0.01; // probability of a candy generating if the field is null

//stored images for backgrounds (incl buttons)
PImage bgMenu;
PImage bgPlay;
PImage bgGameOver;
PImage bgStart;

//stored variables to handle values/objects which are setup in initializeGame()
Frog character;
ArrayList<Platform> platforms;
CandyHeart candy;
int currentBgHeight;



void setup() {
  size(400, 800);

  //set up parameters that are concerned by height/width
  maxHeight = height/10 * 2;
  startButtonLeft = width/20;
  startButtonTop = (height/4) * 3;
  buttonSizeX = (width/20) * 19;
  buttonSizeY = (height/80)*7;
  quitButtonLeft = width/20;
  quitButtonTop = (height/8) * 7;
  menuButtonLeft = width/20;
  menuButtonTop = (height/4) * 3 + 10;
  instrMenuButtonLeft = width/20;
  instrMenuButtonTop = (height/4) * 3;
  instrMenuButtonSizeX = (width/8) * 7;
  instrMenuButtonSizeY = (height/80) * 6;

  //load images
  bgMenu = loadImage("bgNoHover.png");
  bgPlay = loadImage("bgScroll.png");
  bgGameOver = loadImage("bgGameOver.png");
  bgStart = loadImage("bgStart.png");
}



void draw() {
  clear();
  background(255, 255, 255);
  
  //if instructions need to be shown
  if (instructions) {
    image(bgStart, 0, 0, width, height);
  }
  //if the game is in the start screen, display that
  else if (!gameRun && !gameOver) {
    image(bgMenu, 0, 0, width, height);
  }
  //if the player has died, show the game over screen
  else if (gameOver) {
    image(bgGameOver, 0, 0, width, height);
  } 
  //otherwise, draw the game objects and game background
  else {
    scrollGame();
    copy(bgPlay, 0, currentBgHeight, width, height, 0, 0, width, height);
    character.moveY(platforms);
    for (Platform p : platforms) {
      p.display();
    }
    if (candy != null) { 
      candy.display();
    }
    character.display();
    fill(255);
    textSize(40);
    text("Score: " + score, 10, 40);
  }
}


/**
 * Essentially, this just changes the loaded image based on whether or not the mouse is hovering over a button, so it can be coloured accordingly
 */
void mouseMoved() {
  if (instructions) {
    if (mouseX > instrMenuButtonLeft && mouseX < instrMenuButtonLeft + instrMenuButtonSizeX && mouseY > instrMenuButtonTop && mouseY < instrMenuButtonTop + instrMenuButtonSizeY) {
      bgStart = loadImage("bgStartHover.png");
    } else {
      bgStart = loadImage("bgStart.png");
    }
  } else if (!gameOver) {
    if (mouseX > startButtonLeft && mouseX < startButtonLeft + buttonSizeX && mouseY > startButtonTop && mouseY < startButtonTop + buttonSizeY) {
      bgMenu = loadImage("bgHoverStart.png");
    } else if (mouseX > quitButtonLeft && mouseX < quitButtonLeft + buttonSizeX && mouseY > quitButtonTop && mouseY < quitButtonTop + buttonSizeY) {
      bgMenu = loadImage("bgHoverQuit.png");
    } else {
      bgMenu = loadImage("bgNoHover.png");
    }
  } else {
    if (mouseX > menuButtonLeft && mouseX < menuButtonLeft + buttonSizeX && mouseY > menuButtonTop && mouseY < menuButtonTop + buttonSizeY) {
      bgGameOver = loadImage("bgGameOverHover.png");
    } else {
      bgGameOver = loadImage("bgGameOver.png");
    }
  }
}


/**
 * If the player clicks on a button, do the intended action based on the button.
 */
void mouseReleased() {
  if (instructions) {
    if (mouseX > instrMenuButtonLeft && mouseX < instrMenuButtonLeft + instrMenuButtonSizeX && mouseY > instrMenuButtonTop && mouseY < instrMenuButtonTop + instrMenuButtonSizeY) {
      instructions = false;
    }
  }
  else if (!gameRun && !gameOver) {
    if (mouseX > startButtonLeft && mouseX < startButtonLeft + buttonSizeX && mouseY > startButtonTop && mouseY < startButtonTop + buttonSizeY && gameRun == false) {
      gameRun = true;
      initializeGame();
    } else if (mouseX > quitButtonLeft && mouseX < quitButtonLeft + buttonSizeX && mouseY > quitButtonTop && mouseY < quitButtonTop + buttonSizeY) {
      exit();
    }
  } else if (gameOver) {
    if (mouseX > menuButtonLeft && mouseX < menuButtonLeft + buttonSizeX && mouseY > menuButtonTop && mouseY < menuButtonTop + buttonSizeY) {
      gameOver = false;
    }
  }
}


/**
 * If user presses the arrow keys, move the player character in the correct direction
 */
void keyPressed() {
  if (keyCode == 37) {
    character.moveX(true);
  } else if (keyCode == 39) {
    character.moveX(false);
  }
}


/**
 * Method which is called everytime the game is started up.
 * Set all variables to their initial values and creates Frog and Platform objects
 * The platforms are initially generated so that an absolute minimum of height/60 platforms are generated
 * This probability adjusts based on i (how far down the game) and how many platforms have already generated
 * The accessPlat variable is intended to make sure the player has Something to jump on at the start of the game, to avoid instant death.
 */
void initializeGame() {
  currentNoPlatformInterval = 0;
  platformGenerationChance = 0.04;
  timeCounterForDifficulty = 0;
  currentBgHeight = 1600;
  score = 0;
  character = new Frog();
  platforms = new ArrayList<Platform>();
  float platsLeft = height/60;
  float platProb;

  //i starts at 25 to avoid platforms generating at the very top to begin with
  for (int i = 25; i < height; i++) {
    platProb = ((height - i)/((height/60) - platsLeft))/1000;
    if (i < height - 30) {
      if (random(1) < platProb) {
        generatePlatform(i);
        platsLeft--;
        i +=20;
      }
    } else if (i <= height - 10) {
      generatePlatform(i);
      break;
    }
  }
}


/**
 * This method exists to make the game 'scroll' when the player character reaches a certain height
 * When the frog reaches max height, do a lot of things.
 * Firstly, the timer increments, so when it reaches maxTime, the game gets more difficult (platforms become more sparse)
 * If the background image isn't already as far as it will go, move it down one pixel.
 * Assess and move all the platforms, and remove any that have gone off screen from the arrayList
 * Set the frogs y value to maxHeight so it can't ever go above that
 * If it has been the max amount of time without a new platform, force generate one, else give the program the chance to generate one
 * If there currently isn't a candy heart in the game area, theres a chance to generate one, this is also y incremented if exists
 */
void scrollGame() {
  if (character.getY() <= maxHeight) {
    timeCounterForDifficulty++; 

    if (timeCounterForDifficulty >= maxTime) {
      timeCounterForDifficulty = 0;
      platformGenerationChance -= 0.005;
    }
    if (currentBgHeight > 1) { 
      currentBgHeight --;
    }

    ArrayList<Platform> platformsToRemove = new ArrayList<Platform>();

    for (Platform p : platforms) {
      p.incrementY(character.getYSpeed());
      if (p.getY() >= height) {
        platformsToRemove.add(p);
      }
    }

    platforms.removeAll(platformsToRemove);
    character.setY(maxHeight);

    if (currentNoPlatformInterval >= maxWithoutPlatforms) {
      generatePlatform(0);
      currentNoPlatformInterval = 0;
    } else if (currentNoPlatformInterval > minWithoutPlatforms ) {
      if (random(1) < platformGenerationChance) { 
        generatePlatform(0);
        currentNoPlatformInterval = 0;
      } else {  
        currentNoPlatformInterval++;
      }
    } else { 
      currentNoPlatformInterval++;
    }
    if (random(1) < randomDetermineCandy && candy == null) {
      candy = new CandyHeart(0);
    } else if (candy != null) {
      candy.incrementY(character.getYSpeed());
      if (candy.getY() >= height) {
        score -= candy.getScoreValue();
        candy = null;
      }
    }
  }
}


/**
 * Helper method to determine whether a static platform or a moving platform is generated.
 */
void generatePlatform(int y) {
  if (random(1) > 0.3) {
    platforms.add(new StaticPlatform(y));
  } else {
    platforms.add(new MovingPlatform(y));
  }
}
