import processing.serial.*;
Serial port;
int leer;

int numeroBolas = 5;
int puntaje = 0;

PImage inicio;
PImage fondo;
PImage aste;

int maxpuntaje = 0;
int savedTime;
int totalTime = 12000;


float x =150;
float y =30;

int ancho=80;
int alto=100;

float posX[];
float posY[];
float posX1;
float posY1;
int estado[];

PImage nave;

float vel=0;

float distancia=0;

int dir=1;
int dir2=1;

float mapeado;
boolean introScreen = true;

String sensores;

int potenciometro1;
int potenciometro2;

float posicionY1;
float posicionY2;

meteoros[] bolas = new meteoros[numeroBolas]; 

void setup() {
  size(600, 600);
  String NombrePuerto="COM5";
  port=new Serial(this, "COM5", 9600);

  inicio = loadImage("inicio.jpg");
  fondo = loadImage("fondo.jpg");
  aste= loadImage("meteoro.png");
  nave= loadImage("nave.png");
  textSize(20);
  savedTime = millis();

  for (int i = 0; i < bolas.length; i++) {
    bolas[i] = new meteoros();
  }
}

void draw() {
  background(1);

  if (keyPressed) {
    if (key == 'o'|| key == 'O') {
      introScreen = false;
    }
  }
  if (introScreen == true) {
    inicio.resize(600, 600);
    image(inicio, 0, 0);
    strokeWeight(10);
    fill(#8D17BC);

    text("Puntaje maximo : "+maxpuntaje, 200, 440);
  } else {

    for (int i = 0; i < bolas.length; i++) {
      bolas[i].caida();
      bolas[i].colision();
      bolas[i].puntaje();
      bolas[i].GAMEOVER();
    }
  }
   if (0 < port.available()) 
  {     
    //otra forma de enviar los datos a processing es no usando serial.write, sino serial.println, sin embargo en processing no se utiliza port.read(), sino port.readStringUntil('\n');
    sensores =  port.readStringUntil('\n');    
        
    if(sensores != null)
    {
      println(sensores);
      //se crea un arreglo que divide los datos y los guarda dentro del arreglo, para dividir los datos se hace con split cuando le llegue el caracter 'T',
      String[] datosSensor = split(sensores,'T');
      
      if(datosSensor.length == 2)
      {
        println(datosSensor[0]);
        println(datosSensor[1]);
        potenciometro1 = int(trim(datosSensor[0]));      
        potenciometro2 = int(trim(datosSensor[1]));
      }     
    }
    
    posicionY1 = map(potenciometro1,1023,0,200,0);
    posicionY2 = map(potenciometro2,1023,0,200,0);
  }
  
  //background(0);
  
  image(nave,0,posicionY1,120,50);
  image(nave,180,posicionY2,120,50);
  
}


class meteoros {
  float d = 50;
  float x = random(600);
  float y = random(height);

  void caida() {
    y = y +3 ;   //VELOCIDAD
    //fill(0,10,200,60);
    image(aste, x, y, d, d);

    if (y>height) {
      x = random(600);
      y = random(-100);
    }
  }

  void colision () {
    float distancia = dist(mapeado, 400, x, y);
    if (keyPressed) {
      if (key == 's'|| key == 'S') {


        if (distancia < d) {
          //println("hola");
          x = -1000;
          puntaje++;
          maxpuntaje = max(puntaje, maxpuntaje);
        }
      }
    }
  } 

  void puntaje () {
    fill(#FFF000);
    text("Puntaje = " +puntaje, 400, 20);
  }

  void GAMEOVER() {

    int passedTime = millis() - savedTime;  //resta de tiempo
    if (passedTime > totalTime) {
      introScreen = true;
      puntaje = 0;
      savedTime= millis();
      for (int i = 0; i < bolas.length; i++) {
        bolas[i] = new meteoros();
      }
    }
  }
}
