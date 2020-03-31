public class Sprite
{
  float x;
  float y;
  float yBottom;
  float Vy;
  float grav = -1.0 ;
  float r;
  float hgth = 80;
  float wdth = 40;
  PImage tiger;
  NeuralNetwork brain;
  int score = 0;
  float fitness = 0;
  
  Sprite(int x0, PImage character)
  {
    x = x0;
    Vy = 0;
    y = 500;
    yBottom = y + hgth;
    tiger = character;
    brain = new NeuralNetwork();
  }
  
  Sprite(int x0, PImage character, NeuralNetwork preMadeBrain)
  {
    x = x0;
    Vy = 0;
    y = 500;
    yBottom = y + hgth;
    tiger = character;
    brain = preMadeBrain;
  }

  void evolve()
  {
    if (y != 500)
    {
       y -= Vy;
       Vy += grav;
    }
    
    if (y > 500)
    {
      y = 500;
      Vy = 0;
    } 
 
  }
    
  void display()
  {
      //fill(r, 0, 0, 50);
      //rect(x, y, wdth, hgth);
      image(tiger, x,y, wdth, hgth);
  }
  
  void jump()
  {
      if ( y == 500 )
      {
        Vy = 15;
        y -= Vy;
      } 
      else { /* do nothing */ }  
  }
  
  void think(float a, float b, float c)
  {
    float result = brain.result(a,b,c);
    if (result > 0.5)
    {
      jump();
    }
  } 
}
