static float mutationChance = 20;
static float mutationRate = 0.01;
static float neuronChance = 0.5;
static float layerChance = 0.1;

static int idleLimit = 100;
static int phmult = 5;
static int w = 50/phmult;
static int h = 50/phmult;


static int grav = 1;

Player[] players = new Player[100];

int[][] envPat = {
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1}
};

int[][] env;

void setup() 
{
  PImage map = loadImage("map.png");
  
  envPat = new int[map.height][map.width];
  
  for (int x = 0; x < map.width; x++) 
  {
    for (int y = 0; y < map.height; y++) 
    {
      if (map.get(x,y) == color(255)) 
      {
        envPat[y][x] = 0;
      }
      else
      {
        envPat[y][x] = 1;
      }
    }
  }
  
  env = new int[envPat.length*phmult][envPat[0].length*phmult];

  for (int x = 0; x < env[0].length; x++) 
  {
    for (int y = 0; y < env.length; y++) 
    {
      env[y][x] = envPat[y/phmult][x/phmult];
    }
  }


  size(1000, 500, P2D);
  frameRate(120);

  println(envPat.length);

  for (int i = 0; i < players.length; i++) 
  {
    players[i] = new Player(30, 3);
  }
}

int gen = 1;
int bestgen = 0;
int best = 0;
int t = 0;
float i = 0;
void draw() 
{
  Player[] ar = players;

  for (int i = 0; i < ar.length-1; i++)
  {
    int min = i;
    for (int j = i+1; j < ar.length; j++)
      if (ar[j].score < ar[min].score) min = j;
    Player temp = ar[i];
    ar[i] = ar[min];
    ar[min] = temp;
  }

  i = ar[ar.length-1].x-30;
  background(255);
  renderEnv(i);
  simPlayersPH();
  simPlayersAI();
  renderPlayers(i);
  
  stroke(0);
  fill(255);
  rect(0,0,120,65);
  fill(0);
  text("fps:" + frameRate,5,15);
  text("gen:" + gen,5,30);
  text("best gen:" + best,5,45);
  text("this gen:" + bestgen,5,60);
  
  if (mousePressed) 
  {
    if (mouseButton == LEFT) 
    {
      frameRate(frameRate/2);
    }
    
    if (mouseButton == RIGHT) 
    {
      frameRate(frameRate*2);
    }
  }
}


//-----------------------------------------------------------------------------------------------------
//sim
//-----------------------------------------------------------------------------------------------------

void simPlayersAI() 
{
  boolean alive = false; 

  for (int i = 0; i < players.length; i++) 
  {
    alive |= players[i].alive;
    if (!players[i].alive) 
    {
      continue;
    }
    if (players[i].y + ((phmult-1)/2)+1 >= env.length) 
    {
      players[i].alive = false;
      continue;
    }

    float[] input = new float[2500];

    for (int x = -25; x < 25; x++) 
    {
      for (int y = -25; y < 25; y++) 
      {
        if (x+players[i].x > 0 && x+players[i].x < env[0].length && y+players[i].y > 0 && y+players[i].y < env.length)
        {
          input[x+25+((y+25)*50)] = env[y+players[i].y][x+players[i].x];
        } else
        {
          input[x+25+((y+25)*50)] = 0;
        }
      }
    }

    float[] out = players[i].net.calcNet(input);

    //println("o1:" + out[0] + " o2:" + out[1] + " o3:" + out[2]);

    if (players[i].y + ((phmult-1)/2) + 1 < env.length)
    {
      if (out[0] > 0.5 && (env[players[i].y + ((phmult-1)/2) + 1][players[i].x - ((phmult-1)/2)] == 1 || env[players[i].y + ((phmult-1)/2) + 1][players[i].x + ((phmult-1)/2)] == 1)) 
      {
        players[i].jump();
      }
    }
    if (out[1] > out[2]) 
    {
      if (out[1] > 0.5) 
      {
        players[i].move(true);
      }
    } else
    {
      if (out[2] > 0.5) 
      {
        players[i].move(false);
      }
    }

    if (players[i].x > players[i].score) 
    {
      players[i].score = players[i].x;
      players[i].idle = 0;
    } else
    {
      players[i].idle++;

      if (players[i].idle > idleLimit) 
      {
        players[i].alive = false;
      }
    }
  }

  if (!alive) 
  {
    mutateNets();
  }
}


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
      if (d1 * d2 > 0) 
      {
        if (d1 < d2) 
        {
          players[i].y += d1-1;
        } else
        {
          players[i].y += d2-1;
        }
      }
    } else
    {
      players[i].y += players[i].ay;
    }


    //x pos sim
    if (players[i].ax > 0) 
    {
      int d1 = 0;

      for (; d1 < players[i].ax; d1++) 
      {
        if (env[players[i].y + ((phmult-1)/2)][players[i].x + ((phmult-1)/2) + d1] == 1)
        {
          break;
        }
      }

      int d2 = 0;

      for (; d2 < players[i].ax; d2++) 
      {
        if (env[players[i].y - ((phmult-1)/2)][players[i].x + ((phmult-1)/2) + d2] == 1)
        {
          break;
        }
      }

      if (d1 * d2 > 0) 
      {
        if (d1 < d2) 
        {
          players[i].x += d1 - 1;
        } else
        {
          players[i].x += d2 - 1;
        }
      }
    } else
    {
      int d1 = 0;

      for (; d1 < -players[i].ax; d1++) 
      {
        if (env[players[i].y + ((phmult-1)/2)][players[i].x - ((phmult-1)/2) - d1 -1] == 1)
        {
          break;
        }
      }

      int d2 = 0;

      for (; d2 < -players[i].ax; d2++) 
      {
        if (env[players[i].y - ((phmult-1)/2)][players[i].x - ((phmult-1)/2) - d2 -1] == 1)
        {
          break;
        }
      }

      if (d1 * d2 > 0) 
      {
        if (d1 < d2) 
        {
          players[i].x -= d1;
        } else
        {
          players[i].x -= d2;
        }
      }
    }


    players[i].ax = 0;
  }
/*
  if (mousePressed && mouseButton == LEFT && (env[players[0].y+ ((phmult-1)/2) + 1][players[0].x - ((phmult-1)/2)] == 1 || env[players[0].y+ ((phmult-1)/2) + 1][players[0].x + ((phmult-1)/2)] == 1)) 
  {
    players[0].jump();
  }*/

  //println("X:" + mouseX/w + " Y:" + mouseY/h + " b:" + env[mouseY/h][mouseX/w]);
}

//-----------------------------------------------------------------------------------------------------
//render
//-----------------------------------------------------------------------------------------------------

void renderPlayers(float offx) 
{
  //drawing players
  

  for (int i = 0; i < players.length; i++) 
  {
    fill(players[i].c);
    stroke(players[i].c);
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

//-----------------------------------------------------------------------------------------------------
//AI manager
//-----------------------------------------------------------------------------------------------------

void mutateNets() 
{
  Player[] ar = players;

  for (int i = 0; i < ar.length-1; i++)
  {
    int min = i;
    for (int j = i+1; j < ar.length; j++)
      if (ar[j].score < ar[min].score) min = j;
    Player temp = ar[i];
    ar[i] = ar[min];
    ar[min] = temp;
  }

  //println(ar[ar.length-1].score);

  if (ar[ar.length-1].score > best) 
  {
    best = ar[ar.length-1].score;
  }
  
  bestgen = ar[ar.length-1].score;

  Player[] newPlayers = new Player[players.length];

  for (int i = 0; i < newPlayers.length; i++) 
  {
    newPlayers[i] = new Player(30, 3);
    if (i == 0) 
    {
      newPlayers[i].net =  ar[ar.length-1].net.mutateNet();
    }
    else
    {
      newPlayers[i].net = ar[(int)random(ar.length-10, ar.length)].net.mutateNet();
    }
  }
  players = newPlayers;
  gen++;
}
