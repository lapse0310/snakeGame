//SnakeGame

//Arrays to store the grid coordinates of the snake
int[] xSnake = new int[500];
int[] ySnake = new int[500];
//Controls the current length of the snake
int current;
//Controls the length of the snake at the start of each level
int startingLength = 5;
//Controls the speed with which the snake moves
int snakeSpeed = 30;
//Counts the number of frames
int frameCounter = 0;
//Controls the direction of the snake
int snakeDirection=0;
//Array to store the position of the apples
int[] xApples = new int[500];
int[] yApples = new int[500];
//Controls the number of apples at the start of each level
int startingApples = 5;
//Controls the number of current apples in the level
int currentApples;
//Controls how fast the snake grows
int snakeGrowthRate=3;
//Controls how the snake grows
int grow=0;

//The number of rows and columns of squares
final int ROWS=20, COLS=15;
//The size of each square in pixels
final int SQ_SIZE=80;
//Color of the snake
final int SNAKE_COLOR = #EDA0A0;
//Background color
final int BG_COLOR = #A0EDEC;
//X change for down, left, up, right
final int[] X_DIRECTIONS = {0, -1, 0, +1};  
//Y change for down, left, up, right
final int[] Y_DIRECTIONS = {+1, 0, -1, 0};  
//Color of the apples
final int APPLE_COLOR = #54FC5B;

void setup()
{
  //Setup

  size(1200, 1600); //Must be COLS*SQ_SIZE,ROWS*SQ_SIZE
  background(BG_COLOR);
  resetSnake(); //Draws and resets the snake
  resetApples(); //Picks a random set of startingApples apples
}

void draw()
{
  //Draw

  if (!detectCrash())
  {
    frameCounter++;
    if (frameCounter%snakeSpeed==0)
    {
      //Moves the snake
      moveSnake(X_DIRECTIONS[snakeDirection], Y_DIRECTIONS[snakeDirection]);
      background(BG_COLOR);
    }
  } else
  {
    showGameOverMessage();
  }
  drawCircles(xSnake, ySnake, current, SNAKE_COLOR);
  drawCircles(xApples, yApples, currentApples, APPLE_COLOR);
  if (currentApples==0)
  {
    newLevel();
  }
}

void keyPressed()
{
  /*
  Use keyboard to control the motion of the snake
   */
  if (key=='l' || key=='d' ||key=='L' ||key=='D')
  {
    snakeDirection = (snakeDirection+1)%4;
  }
  if (key=='a' || key=='j' ||key=='A' ||key=='J')
  {
    snakeDirection = (snakeDirection+3)%4;
  }
}

void newLevel()
{
  /*
  This function starts a new level, moves the snake back to the top of the 
   canvas, new set of apples appear, higher levels have faster snakes and 
   more apples.
   */
  startingLength++;
  startingApples++;
  snakeDirection=0;
  snakeGrowthRate++;
  snakeSpeed = snakeSpeed - 3;
  grow=0;
  resetSnake();
  resetApples();
}

void showGameOverMessage()
{
  //Shows the game over message

  fill(0);
  textSize(100);
  textAlign(CENTER, CENTER);
  text("Game Over!", width/2, height/2);
}


boolean detectCrash()
{
  /*
  Returns true if the snake crashes into the boundaries or bites itself
   */
  return((xSnake[0]<0)||(xSnake[0]>=COLS)||(ySnake[0]<0)||(ySnake[0]>=ROWS)||
    (searchArrays(xSnake, ySnake, current, 1, xSnake[0], ySnake[0])>-1));
}

void deleteApple(int eatenApple)
{
  /*
  Deletes the apple at the given index(eatenApple)
   */
  for (int i=eatenApple; i<currentApples-1; i++)
  {
    xApples[i] = xApples[i+1];
    yApples[i] = yApples[i+1];
  }
  currentApples = currentApples-1;
}

int searchArrays(int[] x, int[] y, int n, int start, int keyX, int keyY)
{
  /*
  Finds a pair of coordinates (x[i],y[i]) in the first n elements of the 
   arrays x and y that are equal to (keyX, keyY). The search begins at index
   start. Returns the index if found, otherwise return -1.
   */
  for (int i=start; i<n; i++)
  {
    if (x[i]==keyX && y[i]==keyY)
    {
      return i;
    }
  }
  return -1;
}

void resetApples()
{
  /*
  Uses randomArray function to pick a random set of startingApples apples
   */
  currentApples=startingApples;
  xApples = randomArray(startingApples, COLS-1);
  yApples = randomArray(startingApples, ROWS-1);
}

int[] randomArray(int n, int max)
{
  /*
  Creates an integer array of n elements with random values from 0 to max
   */

  int[] array = new int[n];
  for (int i=0; i<n; i++)
  {
    array[i] = (int)random(0, max+1);
  }
  return array;
}

void moveSnake(int addX, int addY)
{
  /*
  Moves the snake by creating a new head right next to the old head, by 
   adding the indicated numbers to the x and y coordinates.
   */


  for (int i=current-1; i>=0; i--)
  { 
    xSnake[i+1] = xSnake[i];
    ySnake[i+1] = ySnake[i];
  }

  xSnake[0] = xSnake[0] + addX;
  ySnake[0] = ySnake[0] + addY;

  if (grow>0)
  {
    current = current+1;
    grow = grow-1;
  }
  int eatApple = searchArrays(xApples, yApples, currentApples, 0, xSnake[0], ySnake[0]);
  if (eatApple>=0)
  {
    grow = grow + snakeGrowthRate;
    deleteApple(eatApple);
  }
}

void resetSnake()
{
  /*
  Sets the current length of the snake to the starting length and
   creates a snake of that length with its head in the centre of the top 
   row, and going straight up from there.
   */

  current=startingLength;
  fillArray(xSnake, current, ceil(COLS/2), 0);
  fillArray(ySnake, current, 0, -1);
}

void drawCircles(int[] x, int[] y, int n, int colour)
{
  /*
  Draws n circles in the canvas, at the positions (x[i], y[i]) 
   specified by the first n elements of the x and y arrays, 
   and with the specified colour. The x and y values are in 
   grid coordinates, not pixels.  
   */

  for (int i=0; i<n; i++)
  {
    fill(colour);
    ellipse(x[i]*SQ_SIZE + SQ_SIZE/2, y[i]*SQ_SIZE + SQ_SIZE/2, SQ_SIZE, SQ_SIZE);
  }
}


void fillArray(int[] a, int n, int start, int delta)
{
  /*
  Fills the first n elements of the array a with data.
   The first element should be set to start, and each
   element after that should differ from the previous one by delta.
   */

  if (n<=a.length)
  {
    for (int i=0; i<n; i++)
    {
      a[i] = start + (i*delta);
    }
  }
}
