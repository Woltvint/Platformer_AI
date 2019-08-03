class Player 
{
  int jumpSpeed = 6;
  int speed = 3;
  
  int x;
  int y;
  
  int ax;
  int ay;
  
  Player(int posx, int posy) 
  {
    x = posx;
    y = posy;
  }
  
  void jump() 
  {
    ay = -jumpSpeed;
  }
  
  void move(boolean move, boolean dir) 
  {
    if (!move) 
    {
      ax = 0;
      return;
    }
    if (dir) 
    {
      ax = speed;
    }
    else
    {
      ax = -speed;
    }
  }
  
}
