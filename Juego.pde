int x=50;
int y=50;
int ancho=100;
int alto=100;

PImage fondo;
PImage nave;
PImage meteoro;


float posX[];
float posY[];

int estado[];

int puntaje =0;

float vel=0;

float distancia=0;
void setup()
{
  size(1000, 900);
  fondo=loadImage("fondo.jpg");
  nave=loadImage("nave.png");
  meteoro=loadImage("meteoro.png");

  posX = new float[100];
  posY = new float[100];
  estado = new int[100];

  for (int i=0; i<100; i++)
  {
    posX[i]=random(0, 400);
    posY[i]=random(0, 100);
    estado[i]=1;
  }
}

void draw()
{
  image(fondo, -100, 0);

  nave.resize(ancho, alto);
  image(nave, mouseX, mouseY);

  meteoro.resize(ancho, alto);
  image(meteoro, 0, 0);
  
  for(int i=0; i<100; i++)
  {
    vel=random(0.5,5);
    posY[i] = posY[i]+vel;
  }
  
  fill(230,0,130);
  for (int i=0; i<100; i++)
  {
    if(estado [i] == 1)
    {
    image(meteoro,posX[i],posY[i],20,20);
    }
  }
  
}
