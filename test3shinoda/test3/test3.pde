import oscP5.*;
import ddf.minim.*;

Minim minim;
AudioPlayer title;

final int BUFFER_SIZE = 220;
//jairo no ch no kazu
final int N_ACC_CHANNELS = 3;

float[][] acc_buffer = new float[N_ACC_CHANNELS][BUFFER_SIZE];
int acc_pointer = 0;
float[] acc_offsetX = new float[N_ACC_CHANNELS];
float[] acc_offsetY = new float[N_ACC_CHANNELS];
int draw_count = 0;

final int PORT = 5000;
OscP5 oscP5 = new OscP5(this, PORT);

float offsetX;
float offsetY;
int scene;
int mode = 0;
int count = 150;
int alt = 75;
float score = 0;
boolean Nod;
boolean Shake;
boolean Alpha;
PImage up,down,normal,horror1;


void setup(){
  size(1000, 600);
  frameRate(30);
  background(255);
  smooth();
  minim = new Minim(this);  
  title = minim.loadFile("../music/Final Fantasy XIII Main Menu Theme.mp3"); 
  up = loadImage("../img/airplain_up.png");
  down = loadImage("../img/airplain_down.png");
  normal = loadImage("../img/airplain_normal.png");
  horror1 = loadImage("../img/horror1.gif");
}

void draw(){
  if(draw_count <= 10){
   draw_count += 1;
  }
  
  println(acc_buffer[0][(acc_pointer+219)%BUFFER_SIZE]);
  if(draw_count > 10){
      for(int ch = 0; ch< N_ACC_CHANNELS; ch++){
        if(ch == 0){
          float a = 0;
          for(int t = 205; t < 210; t++){
            a += acc_buffer[ch][(acc_pointer + t) % BUFFER_SIZE];
          }
          a /= 5.0;
          if(acc_buffer[ch][(acc_pointer+219)%BUFFER_SIZE] - a > 500){
            Nod = true;
            draw_count = 0;  //yama ga torisugiru nowo 3byou matsu
          }
        }else if(ch == 2){
          float b = 0;
          for(int t = 205; t < 210; t++){
            b += acc_buffer[ch][(acc_pointer + t) % BUFFER_SIZE];
          }
          b /= 5.0;
          if(acc_buffer[ch][(acc_pointer+219)%BUFFER_SIZE] - b > 350){
            Shake = true;
            draw_count = 0;
          }
        }
      }
  }
    //println(acc_buffer[0][acc_pointer]);
    
  
  if(scene == 0){
    
    //----------title----------
    
    title.play();
    background(255);
    fill(0);  //moji no iro
    if(count==150){
      image(horror1,0,0,width,height);
    }
    count--;
    textSize(60);
    textAlign(CENTER);
    text("Paper Plane Game", width/2, height/2);
    
    if(Nod == true){
      Nod = false;
      Shake = false;
      scene = 1;
      println("scene1 ni natta");    //ok
    }
  }else if(scene == 1){  
    
    //----------mode select----------
    
    title.close();
    background(255);
    textAlign(LEFT);
    text("Select mode", 100, 100);
    text("Normal", 200, 250);
    text("Horror", 200, 350);
    text("Ero", 200, 450);
    if(Nod == true){
      println("Nod at 1");
      Nod = false;
      mode++;
      mode = mode % 3;
    }
    ellipse(150, mode*100+225, 10, 10);
    if(Shake == true){
      Shake = false;
      scene = 2;
    }
  }else if(scene == 2){
    
    //----------ready----------
    
    background(255);
    textAlign(CENTER);
    text("Relax", width/2, height/2-50);
    text(count/30, width/2, height/2+50);
    count--;
    if(count<0){
      scene = 3;
      count = 150;
    }
  }else if(scene == 3){
    
    //----------playing----------
    
    background(255);
    score++;
    textSize(30);
    text("SCORE: " + score/10 + "m", width*4/5, height/4);
    line(0,height-100,width,height-100);
    if(Alpha == true){
      Alpha = false;
      if(alt == 75){
        image(normal,200,alt*2-50,100,46.5);
      }
      if(alt > 75){
        alt--;
        image(up,200,alt*2-50,100,55.1);
      }
    }else{
      alt++;
      image(down,200,alt*2-50,100,57);
    }
    if(alt > 246){
      scene = 4;
      alt = 75;
    }
  }else if(scene == 4){
    
    //----------result----------
    
    textSize(60);
    text("Game Over", width/2, height/2);
    count--;
    if(count < 0){
      scene = 0;
      count = 150;
    }
  }
}


/*
void keyPressed() {
  if(keyCode == DOWN){
    Nod = true;
  }else if(keyCode == RIGHT){
    Shake = true;
  }else if(keyCode == UP){
    Alpha = true;
  }
}
*/

//jusinsitara jikkou
void oscEvent(OscMessage msg){
   float acc_data;
   if(msg.checkAddrPattern("/muse/acc")){
     for(int ch = 0; ch < N_ACC_CHANNELS; ch++){
       // 50kai/byou
       acc_data = msg.get(ch).floatValue();
       acc_buffer[ch][acc_pointer]=acc_data;
     }
     acc_pointer = (acc_pointer + 1) % BUFFER_SIZE;
   }
}
