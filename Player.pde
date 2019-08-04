class Player 
{
  NeuralNet net;
  int score = 0;
  int idle = 0;
  
  boolean alive = true;
  color c;
  
  int jumpSpeed = 6;
  int speed = 3;
  
  int x;
  int y;
  
  int ax;
  int ay;
  
  Player(int posx, int posy) 
  {
    net = new NeuralNet(3,100,5);
    c = color(random(0,255),random(0,255),random(0,255));
    x = posx;
    y = posy;
  }
  
  void jump() 
  {
    ay = -jumpSpeed;
  }
  
  void move(boolean dir) 
  {
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
