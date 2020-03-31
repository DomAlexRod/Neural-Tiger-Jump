public class Obstacle
{
  float hight;
  float width;
  float x = 1000;
  float Vx;
  float yTop;
  
  Obstacle()
  {
    hight = random(50,80);
    width = random(10,20);
    yTop = 580 - hght;
  }
  
  void displayObst()
  {
    fill(0, 0, 255);
    rect(x,yTop, width, hight);
  }
    
    
  void evolveObst(float VX)
  {
      Vx = VX;
      x -= Vx;
  }
}
