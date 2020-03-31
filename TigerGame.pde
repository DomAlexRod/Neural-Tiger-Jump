//For each generation after first, keep best rest all mutations.
//globals:

//Objects
Sprite sprt;

//game values
int SPACE_BAR = 32;
float VEL = 5;
int counter = 0;
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<Sprite> sprites = new ArrayList<Sprite>();
ArrayList<Sprite> deadSprits = new ArrayList<Sprite>();
int framesSinceObst = 0;
int minFramesBetweenObst = 80;
boolean playing = true;
int Score = 0;
int PopulationSize = 10;
float nearestDist = width;
int generation = 1;
int currentBest = 0;
PrintWriter output;

//Files
PImage tiger;


void setup()
{
  size(1000, 650);
  println("Set up complete");
  tiger = loadImage("tiger.png");
  output = createWriter("best1.txt");
  
  //create initial random initial population
  for (int i = 0 ; i < PopulationSize; i++)
  {
    sprites.add(new Sprite(40, tiger));
  }
}

void draw()
{ 
  //setup window and text
  background(255);
  fill(0);
  textSize(25);
  textAlign(CENTER);
  text("Dino Game", width/2, 30);
  showScore();

  //Add ground line
  strokeWeight(1);
  line(0, 580, width, 580);

  if (playing)
  {
    nearestDist = nearestObstacleDistance();
    //Evolve and display sprites on screen.
    for (int i = 0; i < sprites.size(); i++)
    {
      sprites.get(i).think(VEL, sprites.get(i).y, nearestDist) ;
      sprites.get(i).evolve();
      sprites.get(i).display();
      sprites.get(i).score = counter;
      
    }
    //Generate Obstacles and evolve them
    generator();
    updateObstacles();
    displayObstacles();
    checkCollision();
    checkAllDead();
    //Speed up obstaces
    VEL += 0.005;

    counter++;
  } 
  else
  {
    resetGame();
    sprt.display();
    displayObstacles();
  }
}


void keyPressed()
{
  if (keyCode == SPACE_BAR)
  {
    //sprt.jump();
  }

  if (key == 'q')
  {
    output.flush(); // Writes the remaining data to the file
    output.close();
    exit();
  }
}

void showScore()
{
  fill(0);
  textSize(20);
  textAlign(CENTER);
  text("Score: ", 50, 40);
  textAlign(LEFT);
  text(Score, 80, 40);
  
  textSize(15);
  text("Generation: ", 15, 70);
  text(generation, 100, 70);
  
  text("Alive: " , 15, 90);
  text(sprites.size(), 60, 90);
  
  text("Best: ", 15, 110);
  text(currentBest, 60, 110); 
  
  text("Current: ", 15, 130);
  text(counter, 85, 130);
}
void generator()
{
  float decider = random(0, 200);
  if (decider < 10 && framesSinceObst > minFramesBetweenObst)
  {
    //println("New obstacle");
    obstacles.add(new Obstacle());
    framesSinceObst = 0;
  } else
  {
    framesSinceObst++;
  }
}

void updateObstacles()
{
  for (int i = 0; i < obstacles.size(); i++)
  {
    if (obstacles.get(i).x < 0)
    {
      obstacles.remove(i);
      i--;
      Score++;
    } else
    {
      obstacles.get(i).evolveObst(VEL);
    }
  }
}

void displayObstacles()
{
  for (int i = 0; i < obstacles.size(); i++)
  {
    obstacles.get(i).displayObst();
  }
}

void checkCollision()
{
  //Loops through all sprites and checks collion.
  //If collided; removes from list.
  for (int j = 0; j < sprites.size(); j++)
  {
    for (int i = 0; i<obstacles.size(); i++)
    {
      boolean inXRange = (obstacles.get(i).x > sprites.get(j).x) && ( obstacles.get(i).x < sprites.get(j).x + sprites.get(j).wdth) ;
      boolean inYRange = (sprites.get(j).y + sprites.get(j).hgth >= obstacles.get(i).yTop); 
      
      if (inXRange && inYRange)
      {
        deadSprits.add(sprites.get(j));
        sprites.remove(j);
        j--;
        break;
      }
    }
  }
}

float nearestObstacleDistance()
{
  int smallestIndexLoc = 0;
  float dist = width;
  if (obstacles.size() != 0)
  {
    for (int i = 0; i < obstacles.size(); i++)
    {
      if (obstacles.get(i).x < dist && (obstacles.get(i).x - 40) > 0)
      {
        smallestIndexLoc = i;
      }
    }
    return obstacles.get(smallestIndexLoc).x - 40;
  }
  else
  {
    return width;
  }
}

void calcFitness()
{
  float sum = 0.0f;
  for (int i =0; i< deadSprits.size(); i++)
  {
    sum+= deadSprits.get(i).score * deadSprits.get(i).score;
  }
  for (int i =0; i< deadSprits.size(); i++)
  {
    deadSprits.get(i).fitness = deadSprits.get(i).score * deadSprits.get(i).score/ sum;
    
    if (deadSprits.get(i).score > currentBest)
    {
      currentBest = deadSprits.get(i).score;
    }
  }
}

Sprite pickOne()
{
  calcFitness();
  int index = 0;
  float r = random(1);
  while (r > 0)
  {
    r = r - deadSprits.get(index).fitness;
    index++;
  }
  index--;
  
  return deadSprits.remove(index);
}

void newPop()
{
  NeuralNetwork previousBest = pickOne().brain;
  NeuralNetwork secondBest = pickOne().brain;
  NeuralNetwork thirdBest = pickOne().brain;
  //best from previous generation
  sprites.add(new Sprite(40, tiger, previousBest));
  sprites.add(new Sprite(40, tiger, secondBest));
  sprites.add(new Sprite(40, tiger, thirdBest));
  
  //add mutations of previous best
  for (int i = 0; i < PopulationSize - 33; i++)
  {
    sprites.add(new Sprite(40, tiger, previousBest.mutateNetwork() ) );
  }
  
  for (int i = 0; i < 20; i++)
  {
    sprites.add(new Sprite(40, tiger, secondBest.mutateNetwork() ) );
  }
  
  for (int i = 0; i < 10; i++)
  {
    sprites.add(new Sprite(40, tiger, thirdBest.mutateNetwork() ) );
  }
  
  
  output.println("Generation: " + generation + " Best: " + currentBest); 
}

void checkAllDead()
{
  if(sprites.size() == 0)
  {
    newPop();
    deadSprits = new ArrayList<Sprite>();
    obstacles = new ArrayList<Obstacle>();
    VEL = 5;
    counter = 0;
    framesSinceObst = 0;
    Score = 0;
    generation ++;
  }
}
void resetGame()
{
  fill(0);
  textSize(70);
  textAlign(CENTER);
  text("Play Again? (y/n)", width/2, height/2);

  if (key == 'y' || key == 'Y')
  {
    playing = true;
    obstacles = new ArrayList<Obstacle>();
    sprt.y = 500;
    VEL = 5;
    int counter = 0;
    framesSinceObst = 0;
    Score = 0;
  } else if (key == 'n')
  {
    exit();
  }
}
