static int phmult = 5;
static int w = 50/phmult;
static int h = 50/phmult;


static int grav = 1;


Player[] players = new Player[1];

int[][] envPat = {
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0}, 
  {1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
};

int[][] env;

void setup() 
{
  env = new int[envPat.length*phmult][envPat[0].length*phmult];

  for (int x = 0; x < env[0].length; x++) 
  {
    for (int y = 0; y < env.length; y++) 
    {
      env[y][x] = envPat[y/phmult][x/phmult];
    }
  }


  size(1000, 500);
  frameRate(30);

  println(envPat.length);

  for (int i = 0; i < players.length; i++) 
  {
    players[i] = new Player(30, 3);
  }
}



float i = 0;
void draw() 
{
  i = players[0].x-30;
  background(255);
  renderEnv(i);
  renderPlayers(i);
  simPlayersPH();
}


//-----------------------------------------------------------------------------------------------------
//sim
//-----------------------------------------------------------------------------------------------------

void simPlayersPH() 
{
  for (int i = 0; i < players.length; i++) 
  {

    //y pos sim
    players[i].ay += grav;



    if (players[i].ay >= 0) {

      int d1 = 0;
      for (; d1 < players[i].ay; d1++) 
      {
        if (players[i].y + ((phmult-1)/2) + d1 > env.length-1 || env[players[i].y + ((phmult-1)/2) + d1][players[i].x + ((phmult-1)/2)] == 1)
        {
          break;
        }
      }

      int d2 = 0;
      for (; d2 < players[i].ay; d2++) 
      {
        if (players[i].y + ((phmult-1)/2) + d2 > env.length-1 || env[players[i].y + ((phmult-1)/2) + d2][players[i].x - ((phmult-1)/2)] == 1)
        {
          break;
        }
      }
      if (d1 * d1 * d2 > 0) 
      {
        if (d1 < d2) 
        {
          players[0].y += d1-1;
        } 
        else
        {
          players[0].y += d2-1;
        }
      }
    } 
    else
    {
      players[i].y += players[i].ay;
    }


    //x pos sim
    if (players[0].ax > 0) 
    {
      int d = 0;

      for (; d < players[0].ax; d++) 
      {
        if (env[players[i].y][players[i].x + ((phmult-1)/2) + d] == 1)
        {
          break;
        }
      }

      players[i].x += d-1;
    } 
    else
    {
      int d = 0;

      for (; d < -players[0].ax; d++) 
      {
        if (env[players[i].y][players[i].x - ((phmult-1)/2) - d - 1] == 1)
        {
          break;
        }
      }

      players[i].x -= d;
    }


    players[i].ax = 0;
  }

  if (mousePressed && mouseButton == LEFT && (env[players[0].y+ ((phmult-1)/2) + 1][players[0].x - ((phmult-1)/2)] == 1 || env[players[0].y+ ((phmult-1)/2) + 1][players[0].x + ((phmult-1)/2)] == 1)) 
  {
    players[0].jump();
  }

  //println("X:" + mouseX/w + " Y:" + mouseY/h + " b:" + env[mouseY/h][mouseX/w]);
}

//-----------------------------------------------------------------------------------------------------
//render
//-----------------------------------------------------------------------------------------------------

void renderPlayers(float offx) 
{
  //drawing players
  fill(128);
  stroke(128);

  for (int i = 0; i < players.length; i++) 
  {
    for (int x = -((phmult-1)/2); x <= (phmult-1)/2; x++) 
    {
      for (int y = -((phmult-1)/2); y <= (phmult-1)/2; y++) 
      {
        rect((players[i].x + x)*w - (offx*w), (players[i].y + y)*h, w, h);
      }
    }
  }
}

void renderEnv(float offx) 
{
  fill(0);
  stroke(0);

  for (int x = 0; x < env[0].length; x++) 
  {
    for (int y = 0; y < env.length; y++) 
    {
      if (x-offx < 0 || (x-offx)*w > width) 
      {
        continue;
      }
      if (env[y][x] == 1) 
      {
        rect(x*w-(offx*w), y*h, w, h);
      }
    }
  }
}
