import oscP5.*;
import gifAnimation.*;
import ddf.minim.*;

final int BUFFER_SIZE = 220;
final int N_ACC_CHANNELS = 3;
final int N_CHANNELS = 4;
final float ALPHA_MICROVOLTS = 1.682815;

float[][] acc_buffer = new float[N_ACC_CHANNELS][BUFFER_SIZE];
int acc_pointer = 0;
int draw_count = 0;

float[][] buffer = new float[N_CHANNELS][BUFFER_SIZE];
float[] value = new float[BUFFER_SIZE];
String[] status = new String[N_CHANNELS]; 
int pointer = 0;
int n_validCh;
float value_ave;
float limit = 100;
float limit_ratio = 0.8;

final int PORT = 5000;
OscP5 oscP5 = new OscP5(this, PORT);

int scene;
int mode = 0;
int count = 0;
int alt = 75;
int x=600;
int scrollCount=0;
int scrollCount2=0;
float random;
float score = 0;
boolean Nod;
boolean Shake;
boolean Alpha;
String modename;

PImage up,down,normal,sky,horror6,horror7,bgNormal, bgHorror, bgEro, virus, resultbg;
Gif airplain,horror1,horror2,horror3,horror4,horror5,horror8,horror9,horror10,horror11,horror12,ero1;
Minim minim;
AudioPlayer title_bgm,decision,cursor,mode0_bgm,mode0_gameover_bgm, mode1_bgm,mode2_bgm, error_bgm, hereWeGo,nigasanai,tasukete,himei;

void setup(){
  size(1000, 600);
  frameRate(30);
  background(255);
  smooth();
  minim = new Minim(this);  
  title_bgm = minim.loadFile("music/Final Fantasy XIII Main Menu Theme.mp3");
  decision = minim.loadFile("music/decision.mp3");
  cursor = minim.loadFile("music/cursor.mp3");
  mode0_bgm = minim.loadFile("music/mario.mp3");
  mode0_gameover_bgm = minim.loadFile("music/marioDeath.mp3");
  mode1_bgm = minim.loadFile("music/radionoise.mp3");
  mode2_bgm = minim.loadFile("music/H na BGM.mp3");
  error_bgm = minim.loadFile("music/Windows20XP20Error.wav");
  hereWeGo = minim.loadFile("music/mario-herewego.WAV");
  nigasanai = minim.loadFile("music/nigasanai.mp3");
  tasukete = minim.loadFile("music/tasukete.mp3");
  himei = minim.loadFile("music/himei.mp3");
  up = loadImage("img/airplain_up.png");
  down = loadImage("img/airplain_down.png");
  normal = loadImage("img/airplain_normal.png");
  sky = loadImage("img/sky.jpg");
  bgNormal = loadImage("img/mario(840-600).jpg");
  bgEro = loadImage("img/black.JPG");
  virus = loadImage("img/virusWindow.jpg");
  horror6 = loadImage("img/horror6.jpg"); 
  horror7 = loadImage("img/horror7.jpg"); 
  resultbg = loadImage("img/result2_template.png");
  airplain = new Gif(this, "img/title.gif");
  airplain.play(); 
  horror1 = new Gif(this,"img/horror1.gif");
  horror2 = new Gif(this,"img/horror2.gif");
  horror3 = new Gif(this,"img/horror3.gif");
  horror4 = new Gif(this,"img/horror4.gif");
  horror5 = new Gif(this,"img/horror5.gif");
  horror8 = new Gif(this,"img/horror8.gif");
  horror9 = new Gif(this,"img/horror9.gif");
  horror10 = new Gif(this,"img/horror10.gif");
  horror11 = new Gif(this,"img/horror11.gif");
  horror12 = new Gif(this,"img/horror12.gif");
  ero1 = new Gif(this,"img/ero1.gif");
}

void draw(){
  textSize(30);
  text("score = " + score, 100,100);
  text("scrollCount = " + scrollCount, 100,200);
  text("scene = " + scene, 100,300);
  text("count = " + count, 100,400);
  

  //---------- ACC ----------
  
    if(draw_count <= 10){
      draw_count += 1;
    }
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
            draw_count = 0;  //yama ga torisugiru nowo matsu
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
  
  //---------- ALPHA ----------
  
   value_ave = 0;
   for(int i = 0; i<10; i++){
     value_ave += value[(pointer+BUFFER_SIZE-10+i) % BUFFER_SIZE]/10;
   }
   if(scene==2 && count == 0){
     float value_ave_long = 0;
     for(int i = 0; i<100; i++){
       value_ave_long += value[(pointer+BUFFER_SIZE-100+i) % BUFFER_SIZE]/100;
     }
     limit = value_ave_long * limit_ratio;   
   }
   if(value_ave > limit){
     Alpha = true;
   }
  
  if(scene == 0){
    
    //----------title----------
    
    title_bgm.play();
    background(255);
    fill(0);  //moji no iro
            
    if(count<255){
      count++;
    }
    tint(255,255,255,count);
    image(sky,0,0,width,height);
    image(airplain,x,100);
    
    
    random=random(0,3);
    if(random>2){
      x++;
    }else if(random<1){
      x--;
    }
    
    textSize(60);
    textAlign(CENTER);
    text("Paper Plane Game", width/2, height/2-50);
    textSize(40);
    text("Please Nod.", width/2, height/2+50);
    if(Nod == true){
      Nod = false;
      Shake = false;
      decision.play();
      decision.rewind();
      scene = 1;
      background(255);
      count = 1800;
      title_bgm.pause(); 
      title_bgm.rewind();
    }
  }else if(scene == 1){  
    
    //----------mode select----------
    
    tint(255,255,255,200);
    image(sky,0,0,width,height);    
    if(mode == 0){
      mode2_bgm.pause();
      mode2_bgm.rewind();
      mode0_bgm.play();
      fill(255,255,255,50);
    }else if(mode == 1){
      mode0_bgm.pause();
      mode0_bgm.rewind();
      mode1_bgm.play();
      fill(25,25,112,50);
    }else{
      mode1_bgm.pause();
      mode1_bgm.rewind();
      mode2_bgm.play();
      fill(218,112,214,50);
    }
    rect(0,0,width,height);
    noStroke();
    fill(0,0,0,50);
    rect(25,0,450,height);
    fill(255,255,255,200);
    ellipse(250,100,425,25);
    rect(25, mode*100+210,450,50);
    fill(0);
    textSize(60);
    textAlign(CENTER);
    text("Select mode", 250, 100);
    text("Normal", 250, 250);
    text("Horror", 250, 350);
    text("Ero", 250, 450);
    
    textSize(30); 
    textAlign(LEFT);
    text("Ch1: "+ status[0], 800, 50);
    text("Ch2: "+ status[1], 800, 100);
    text("Ch3: "+ status[2], 800, 150);
    text("Ch4: "+ status[3], 800, 200);
    text("Valid Ch: "+ n_validCh, 800, 250);
    float x1, y1, x2, y2;
    int offsetX = width*11/20;
    int offsetY = height - 100;
    stroke(255, 0, 0);
    for(int t = 0; t < BUFFER_SIZE; t++){
      x1 = offsetX + t*2;
      y1 = offsetY - value[(t + pointer) % BUFFER_SIZE] * 200;
      x2 = offsetX + t*2 + 1;
      y2 = offsetY - value[(t + 1 + pointer) % BUFFER_SIZE] * 200;
      line(x1, y1, x2, y2);
    }
    stroke(0);
    line(offsetX,offsetY,offsetX + BUFFER_SIZE*2,offsetY);
    text("ALPHA", offsetX, offsetY); 
    
    stroke(0);
    image(airplain,550,100);
    if(Nod == true){
      Nod = false;
      cursor.play();
      cursor.rewind();
      mode++;
      mode = mode % 3;
      count = 1800;
    }
    if(Shake == true){
      Shake = false;
      mode0_bgm.pause();
      mode0_bgm.rewind();
      mode1_bgm.pause();
      mode1_bgm.rewind();
      mode2_bgm.pause();
      mode2_bgm.rewind();
      decision.play();
      decision.rewind();
      if(mode==0){
        modename = "Normal";
      }else if(mode == 1){
        modename = "Horror";
      }else{
        modename = "Ero";
      }
      scene = 2;
      count=150;
    }
    if(count<0){
      scene = 0;
      count = 0;
    }
    count--;
  }else if(scene == 2){
    
    //----------ready----------
    
    background(255);
    textSize(60);
    textAlign(CENTER);
    text("Relax", width/2, height/2-50);
    text(count/30, width/2, height/2+50);
    count--;
    if(count<0){
      scene = 3;
      count = 300;
    }
  }else if(scene == 3){
    
    //----------playing----------
    
    stroke(0);
    textSize(30);
    if(mode==0){
      if(score == 0){
        hereWeGo.play();
      }  
      mode0_bgm.play();
      scrollCount2 = scrollCount%840;
      image(bgNormal, scrollCount2, 0);
      image(bgNormal, 840+scrollCount2, 0);
      image(bgNormal, 1680+scrollCount2, 0);
      scrollCount--;
    }else if(mode==1){
      mode1_bgm.play();
      background(0);
      fill(255,48,48);
      stroke(255,48,48);
      if(score>300 && score<350){
        image(horror6,0,0,width,height);
      }else if(score>500 && score<659){
        horror1.play();
        image(horror1,0,0,width,height);
      }else if(score>700 && score<1020){
        horror2.play();
        image(horror2,0,0,width,height);
        tasukete.play();
      }else if(score>1200 && score<1250){
        image(horror7,0,0,width,height);
        nigasanai.play();
      }else if(score>1300 && score<1390){
        horror3.play();
        image(horror3,0,0,width,height);
      }else if(score>1500 && score<1660){
        horror4.play();
        image(horror4,0,0,width,height);
      }else if(score>1700 && score<2159){
        horror5.play();
        image(horror5,0,0,width,height);
      }else if(score>2300 && score<2390){
        horror8.play();
        image(horror8,0,0,width,height);
      }else if(score>2400 && score<2500){
        horror9.play();
        image(horror9,0,0,width,height);
      }else if(score>2500 && score<2773){
        horror10.play();
        image(horror10,0,0,width,height);
      }else if(score>2840 && score<2894){
        horror11.play();
        image(horror11,0,0,width,height);
        himei.play();
      }else if(score>2910 && score<2950){
        horror12.play();
        image(horror12,0,0,width,height);
      }
    }else{
      scrollCount2 = scrollCount%978;
      image(bgEro, scrollCount2, 0);
      image(bgEro, 978+scrollCount2, 0);
      image(bgEro, 1956+scrollCount2, 0);
      scrollCount--;
      fill(139,28,98);
      stroke(139,28,98);
      if(score==0){
        mode2_bgm.play();
      }
      if(score>500 && score<635){
        ero1.play();
        image(ero1,0,0,width,height);
      }
      //score 700~290 : errorlog      
      //score 790~1000 : blackout
      if(score>1000){
        error_bgm.pause();
        error_bgm.rewind();
        mode2_bgm.play();  
      }
    }
    line(0,height-29,width,height-29);//GameOver line
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
    if(alt > 282){
      scene = 4;
      count = 150;
      alt = 75;
    }else if(score>3000){
      scene = 5;
      count = 150;
      alt = 75;      
    }
    text("SCORE", width*3/5, height/10);
    text(score/10 + "m", width*3/5, height/5);
    text("MODE" , width*4/5, height/10);
    text(modename, width*4/5, height/5);
    score++;
    if(mode==2){// hikouki no ue ni hyouji
      if(score>=700 && score<790){
        if(score==700){
          mode2_bgm.pause();
          error_bgm.pause();
          error_bgm.rewind();
          error_bgm.play();
          image(virus, 340,180);
        }else{
          image(virus, 340,180);
        }
      } 
      if(score>=720 && score<790){
        if(score==720){
          error_bgm.pause();
          error_bgm.rewind();
          error_bgm.play();
          image(virus, 0,0);
        }else{
          image(virus, 0,0);  
        }
      }
      if(score>=740 && score<790){
        if(score==740){
          error_bgm.pause();
          error_bgm.rewind();
          error_bgm.play();
          image(virus, 500,350);
        }else{
          image(virus, 500,350);  
        }
      }
      if(score>=760 && score<790){
        if(score==760){
          error_bgm.pause();
          error_bgm.rewind();
          error_bgm.play();
          image(virus, 100,400);
        }else{
          image(virus, 100,400);  
        }
      }
      if(score>=780 && score<790){
        if(score==780){
          error_bgm.pause();
          error_bgm.rewind();
          error_bgm.play();
          image(virus, 700,120);
        }else{
          image(virus, 700,120);  
        }
      }
    if(score>790 && score<1000){
      background(0);
    }
  }else if(scene == 4){
        
    //----------Game Over----------

    if(mode==0 && count == 150){
      mode0_bgm.pause();
      mode0_bgm.rewind();
      mode0_gameover_bgm.play();
    }
    count--;
    textSize(60);
    text("Game Over", width/2, height/2);
    if(count < 0){
      scene = 6;
      count = 300;
      scrollCount = 0;
      mode1_bgm.pause();
      mode1_bgm.rewind();
      mode2_bgm.pause();
      mode2_bgm.rewind();
    }
  }else if(scene == 5){
    
    //----------Game Clear----------
    
    textSize(60);
    text("Congratulations!", width/2, height/2);
    count--;
    if(count < 0){
      scene = 6;
      count = 300;
      mode0_bgm.pause();
      mode0_bgm.rewind();
      mode1_bgm.pause();
      mode1_bgm.rewind();
      mode2_bgm.pause();
      mode2_bgm.rewind();
    }  
  }else if(scene == 6){
    
    //-----------Result------------
    
    count--;
    image(resultbg, 0,0, 100,600);
    if(count<290){
      textSize(35);
      textAlign(LEFT);
      text("Player name", 330, 130);
    }
    if(count<280){
      textSize(40);
      textAlign(CENTER);
      text("MODE",360, 205);
      if(count<270){
        text(modename, 360, 255);
      }
    }
    if(count<260){
      textSize(50);
      textAlign(LEFT);
      text(score/10 + "m", 720, 155);
    }
    //score meter
    
    noStroke();
    if(count<240){
      fill(255,0,0);
      rect(520, 197, 41, 38);
    }  
    if(count<230 && score>350){
      fill(255,25,0);
      rect(562, 197, 41, 38);    
    }
    if(count<220 && score>700){
      fill(255,51,0);
      rect(603, 197, 41, 38);    
    }
    if(count<210 && score>1050){
      fill(255,76,0);
      rect(645, 197, 41, 38);    
    }
    if(count<200 && score>1400){
      fill(255,102,0);
      rect(687, 197, 41, 38);    
    }
    if(count<190 && score>1750){
      fill(255,127,0);
      rect(729, 197, 41, 38);    
    }
    if(count<180 && score>2100){
      fill(255,153,0);
      rect(771, 197, 41, 38);    
    }
    if(count<170 && score>2450){
      fill(255,178,0);
      rect(813, 197, 41, 38);    
    }
    if(count<160 && score>2800){
      fill(255,204,0);
      rect(855, 197, 41, 38);    
    }
    if(count<150 && score>3000){
      fill(255,255,0);
      rect(897, 197, 41, 38);    
    }
    else{
      textSize(70);
      text("You are", 250, 450);
      if(score<1000){
        text("LittleKenja", 600, 450);
      }
      if(score<2000){
        text("MiddleKenja", 600, 450);
      }
      if(score<3000){
        text("BigKenja", 600, 450);
      }
      if(score>=3000){
        text("KingKenja", 600, 450);
      }
    }
    
    if(count < 0){
      scene = 0;
      score = 0;
      count = 150;
    }
  }
}
}


void keyPressed(){
  if(keyCode == DOWN){
    Nod = true;
  }else if(keyCode == RIGHT){
    Shake = true;
  }else if(keyCode == UP){
    Alpha = true;
  }
}

void oscEvent(OscMessage msg){
  
  //---------- ACC osc ----------
  
   float acc_data;
   if(msg.checkAddrPattern("/muse/acc")){
     for(int ch = 0; ch < N_ACC_CHANNELS; ch++){
       // 50kai/byou
       acc_data = msg.get(ch).floatValue();
       acc_buffer[ch][acc_pointer]=acc_data;
     }
     acc_pointer = (acc_pointer + 1) % BUFFER_SIZE;
   }
   
   //---------- ALPHA osc ----------
   
  float data;
  if(msg.checkAddrPattern("/muse/elements/alpha_relative")){
    for(int ch = 0; ch < N_CHANNELS; ch++){
      data = msg.get(ch).floatValue();
      data = (data - (ALPHA_MICROVOLTS / 2)) / (ALPHA_MICROVOLTS / 2); // -1.0 1.0
      buffer[ch][pointer] = data;
    }
    int validCh = 0;
    float sum = 0;
    for(int ch = 0; ch < N_CHANNELS; ch++){
      if(buffer[ch][(pointer+BUFFER_SIZE-1)%BUFFER_SIZE] == buffer[ch][(pointer+BUFFER_SIZE-2)%BUFFER_SIZE] && buffer[ch][(pointer+BUFFER_SIZE-1)%BUFFER_SIZE] == buffer[ch][(pointer+BUFFER_SIZE-10)%BUFFER_SIZE]){
        status[ch] = "NG";
      }else{
        status[ch] = "CLEAR";
        sum += abs(buffer[ch][pointer]);
        validCh++;
      }
    }
    n_validCh = validCh;
    value[pointer] = sum/n_validCh;
    pointer = (pointer + 1)%BUFFER_SIZE;
  }  
}

