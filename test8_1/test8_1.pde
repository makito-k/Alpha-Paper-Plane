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
float value;
float sum;
String[] status = new String[N_CHANNELS]; 
int pointer = 0;
int pointer_stop;
int validCh;
int n_validCh;
int save = 0;
float value_ave;
float[] value_save = new float[100];
float limit = 100;
float limit_ratio = 1;

final int PORT = 5000;
OscP5 oscP5 = new OscP5(this, PORT);

int scene;
int mode;
int count;
int alt = 100;
int alt_downspeed = 2;
int alt_upspeed = 2;
int title_x = 600;
int scrollCount;
int scrollCount2;
float random;
float score;
boolean Nod;
boolean Shake;
boolean Alpha;
String[] modename = {"Normal","Horror","Ero"};
int difficulty = 1;
String[] difficultyname = {"Easy","Normal","Hard","Extream"};

//---------- object ----------
boolean object_switch;
float rate_of_occurrence; ///100
int maxn_object; //1~3
int n_object = 0;
int[] object = {0,0,0};
int[] obalt = new int[3];
int[] obx = new int[3];
int object_speed;

//---------- result ----------
String[][] result ={{"Cランク","Bランク","Aランク","Sランク"},{"ビビり","凡人","怖いもの知らず","人間じゃねぇ"},{"むっつり","プチ賢者","賢者","大賢者"}};
int rcount = 0;
PFont NormalFont = createFont("Monospaced", 36, true);
PFont MarioFont = createFont("ArcadeClassic", 36, true);
boolean resultReady;

PImage up,down,normal,sky,horror6,horror7,seishi_top,seishi_middle,seishi_bottom,seishi_dead,ranshi,bgNormal, bgHorror, bgEro, virus, object0 ,object1,object1r,object2,resultbg, resultero;
PImage[] eroimg = new PImage[50];
Gif airplain,horror1,horror2,horror3,horror4,horror5,horror8,horror9,horror10,horror11,horror12,erogif0,erogif1,erogif2,erogif3,erogif4,erogif5;
Minim minim;
AudioPlayer title_bgm,decision,cursor,mode0_bgm,mode0_gameover_bgm, mode0_gameclear_bgm, mode1_bgm,mode2_bgm, error_bgm, hereWeGo,nigasanai,tasukete,himei,rocky, meter, meter2, pon, don, snare, jan;

//エロのスライドショー用の変数
int eroimgID = 0;
int eroimgMaxID = 7;
int fadeAlpha = 768;
int fadeAlphaDefault = fadeAlpha;

//エロモード終盤に使う変数
int erogif5Alpha = 256;
int rx = 1250;
float dh = 2.0;
float dw = 2.0*389/450;
float h, w;

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
  mode0_gameclear_bgm = minim.loadFile("music/marioClear.mp3");
  mode1_bgm = minim.loadFile("music/radionoise.mp3");
  mode2_bgm = minim.loadFile("music/H na BGM.mp3");
  error_bgm = minim.loadFile("music/Windows20XP20Error.wav");
  hereWeGo = minim.loadFile("music/mario-herewego.WAV");
  nigasanai = minim.loadFile("music/nigasanai.mp3");
  tasukete = minim.loadFile("music/tasukete.mp3");
  himei = minim.loadFile("music/himei.mp3");
  rocky = minim.loadFile("music/Theme of Rocky.mp3");
  meter = minim.loadFile("music/meter.mp3");
  meter2 = minim.loadFile("music/meter2.mp3");
  pon = minim.loadFile("music/iyopon.mp3");
  don = minim.loadFile("music/don.mp3");
  snare = minim.loadFile("music/snareroll.mp3");
  jan = minim.loadFile("music/jan.mp3");
  up = loadImage("img/airplain_up.png");
  down = loadImage("img/airplain_down.png");
  normal = loadImage("img/airplain_normal.png");
  sky = loadImage("img/sky.jpg");
  bgNormal = loadImage("img/mario(840-600).jpg");
  bgEro = loadImage("img/black.JPG");
  virus = loadImage("img/virusWindow.jpg");
  resultbg = loadImage("img/result_kai.png");
  resultero = loadImage("img/result_ero.png");
  horror6 = loadImage("img/horror6.jpg"); 
  horror7 = loadImage("img/horror7.jpg"); 
  object0 = loadImage("img/object0.png");
  object1 = loadImage("img/object1.png");
  object1r = loadImage("img/object1r.png");
  object2 = loadImage("img/object2.png");
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
  
  int i = 0;
  while(i<=7){
    String imgName = "img/ero"+str(i+1)+".jpg";
    eroimg[i] = loadImage(imgName);
    i++;
  }
  seishi_top = loadImage("img/seishi_top.png");
  seishi_middle = loadImage("img/seishi_middle.png");
  seishi_bottom = loadImage("img/seishi_bottom.png");
  seishi_dead = loadImage("img/seishi_dead.png");
  ranshi = loadImage("img/ranshi.png");
  h = float(ranshi.height);
  w = float(ranshi.width);
  erogif0 = new Gif(this,"img/erogif0.gif");
  erogif1 = new Gif(this,"img/erogif1.gif");
  erogif2 = new Gif(this,"img/erogif2.gif");
  erogif3 = new Gif(this,"img/erogif3.gif");
  erogif4 = new Gif(this,"img/erogif4.gif");
  erogif5 = new Gif(this,"img/erogif5.gif");
}

void draw(){
  
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
  validCh = 0;
  value = 0;
  sum = 0;
  pointer_stop = pointer;
  for(int ch = 0; ch < N_CHANNELS; ch++){
     if(Float.isNaN(buffer[ch][(pointer_stop + BUFFER_SIZE-1)%BUFFER_SIZE])||( buffer[ch][(pointer_stop + BUFFER_SIZE-1)%BUFFER_SIZE] == buffer[ch][(pointer_stop + BUFFER_SIZE-2)%BUFFER_SIZE] && buffer[ch][(pointer_stop + BUFFER_SIZE-1)%BUFFER_SIZE] == buffer[ch][(pointer_stop + BUFFER_SIZE-10)%BUFFER_SIZE])){
       status[ch] = "NG";
     }else{
       status[ch] = "CLEAR";
       sum += abs(buffer[ch][(pointer_stop + BUFFER_SIZE-1)%BUFFER_SIZE]);
       validCh++;
     }
  }
  n_validCh = validCh;
  value = sum/n_validCh;
  println(value,limit);
  value_save[save] = value;
  save = (save +1)%100;
  
   value_ave = 0;
   for(int i = 0; i<10; i++){
     value_ave += value_save[(save+90+i)%100]/10;
   }
   if(scene==2 && count == 0){
     float value_ave_long = 0;
     for(int i = 0; i<100; i++){
       value_ave_long += value_save[(save+90+i)%100]/100;
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
    image(airplain,title_x,100);
    
    
    random=random(0,3);
    if(random>2){
      title_x++;
    }else if(random<1){
      title_x--;
    }
    
    textFont(NormalFont);
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
      mode0_bgm.play();
      fill(255,255,255,50);
    }else if(mode == 1){
      mode0_bgm.pause();
      mode0_bgm.rewind();
      mode1_bgm.play();
      fill(25,25,112,50);
    }else if(mode == 2){
      mode1_bgm.pause();
      mode1_bgm.rewind();
      mode2_bgm.play();
      fill(218,112,214,50);
    }else if(mode == 3){
      mode2_bgm.pause();
      mode2_bgm.rewind();
      fill(255,255,255,0);
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
    text(modename[0], 250, 250);
    text(modename[1], 250, 350);
    text(modename[2], 250, 450);
        
    textSize(40); 
    textAlign(LEFT);
    text("Difficulty: " + difficultyname[difficulty], 50, 550);
    textSize(30);
    text("Ch1: "+ status[0], 800, 50);
    text("Ch2: "+ status[1], 800, 100);
    text("Ch3: "+ status[2], 800, 150);
    text("Ch4: "+ status[3], 800, 200);
    text("Valid Ch: "+ n_validCh, 800, 250);
    float x1, y1, x2, y2;
    int offsetX = width*11/20;
    int offsetY = height - 100;
    stroke(255, 0, 0);
    if(Float.isNaN(value)){
      text("ERROR:", 500, 350); 
      text("Make sure of the MUSE connection.", 500, 400);
    }else{
      text("ALPHA:", 700, 350); 
      text(value, 750, 400);     
    } 
    
    stroke(0);
    image(airplain,550,100);
    if(Nod == true){
      Nod = false;
      cursor.rewind();
      cursor.play();
      mode++;
      mode = mode % 4;
      count = 1800;
    }
    if(Shake == true){
      Shake = false;
      if(mode == 3){
        difficulty++;
        difficulty = difficulty % 4;
        decision.play();
        decision.rewind();
      }else{      
        mode0_bgm.pause();
        mode0_bgm.rewind();
        mode1_bgm.pause();
        mode1_bgm.rewind();
        mode2_bgm.pause();
        mode2_bgm.rewind();
        decision.rewind();
        decision.play();
        scene = 2;
        if(difficulty == 0){
          alt_downspeed = 2;
          alt_upspeed = 2;
          object_switch = false;
        }else if(difficulty == 1){
          alt_downspeed = 2;
          alt_upspeed = 2;
          object_switch = true;
          rate_of_occurrence = 0.5; ///100
          maxn_object = 1; //1~3
          object_speed = 3;
        }else if(difficulty == 2){
          alt_downspeed = 3;
          alt_upspeed = 3;
          object_switch = true;
          rate_of_occurrence = 1; ///100
          maxn_object = 2; //1~3
          object_speed = 4;
        }else if(difficulty == 3){
          alt_downspeed = 4;
          alt_upspeed = 4;
          object_switch = true;
          rate_of_occurrence = 1; ///100
          maxn_object = 3; //1~3
          object_speed = 5;
        }
        count=150;
      }
    }
    if(count<0){
      mode0_bgm.pause();
      mode0_bgm.rewind();
      mode1_bgm.pause();
      mode1_bgm.rewind();
      mode2_bgm.pause();
      mode2_bgm.rewind();
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
      count = 150;
    }
  }else if(scene == 3){
    
    //---------- playing ----------
    
    stroke(0);
    
    //---------- Normal mode  background----------
    
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

    //---------- Horror mode background ----------

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
      
      //---------- Ero mode background ----------
      
    }else if (mode==2){
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
      imageMode(CENTER);
      if(score >= 120 && score < 1296){
        if(eroimgID < eroimgMaxID){
          if(fadeAlpha > 256){
            fadeAlpha -= 5;
            tint(255,fadeAlpha);
            image(eroimg[eroimgID],width/2,height/2);
          }else if(fadeAlpha <= 256 && fadeAlpha > 0){
            fadeAlpha -= 4;
            tint(255,255);
            image(eroimg[eroimgID+1],width/2,height/2);
            tint(255,fadeAlpha);
            image(eroimg[eroimgID],width/2,height/2);
          }else if(fadeAlpha <= 0){
            image(eroimg[eroimgID+1],width/2,height/2);
            fadeAlpha = fadeAlphaDefault;
            eroimgID++;
          }
        }
      }else if(score >= 1296 && score <= 1396){
        image(eroimg[eroimgID],width/2,height/2);
      }
      if(score>=1396 && score<1486){
        if(score==1396){
          mode2_bgm.pause();
          error_bgm.pause();
          error_bgm.rewind();
          error_bgm.play();
          image(virus, 340,180);
        }else{
          image(virus, 340,180);
        }
      } 
      if(score>=1416 && score<1486){
        if(score==1416){
          error_bgm.pause();
          error_bgm.rewind();
          error_bgm.play();
          image(virus, 0,0);
        }else{
          image(virus, 0,0);  
        }
      }
      if(score>=1436 && score<1486){
        if(score==1436){
          error_bgm.pause();
          error_bgm.rewind();
          error_bgm.play();
          image(virus, 500,350);
        }else{
          image(virus, 500,350);  
        }
      }
      if(score>=1456 && score<1486){
        if(score==1456){
          error_bgm.pause();
          error_bgm.rewind();
          error_bgm.play();
          image(virus, 100,400);
        }else{
          image(virus, 100,400);  
        }
      }
      if(score>=1476 && score<1486){
        if(score==1476){
          error_bgm.pause();
          error_bgm.rewind();
          error_bgm.play();
          image(virus, 700,120);
        }else{
          image(virus, 700,120);
        }
      }
      if(score>1486 && score<1600){
        background(0);
      }
      if(score==1600){
        error_bgm.pause();
        error_bgm.rewind();
        mode2_bgm.play();
      }
      if(score>1600 && score<1735){
        erogif0.play();
        image(erogif0,width/2,height/2);
      }else if(score >= 1735 && score < 1864){
        erogif1.play();
        image(erogif1,width/2,height/2);
      }else if(score >= 1864 && score < 1948){
        erogif2.play();
        image(erogif2,width/2,height/2);
      }else if(score >= 1948 && score < 2032){
        erogif3.play();
        image(erogif3,width/2,height/2);
      }else if(score >= 2032 && score < 2112){
        erogif4.play();
        image(erogif4,width/2,height/2);
      }else if(score >= 2112 && score < 2169){
        erogif5.play();
        image(erogif5,width/2,height/2);
      }else if(score >= 2169 && score < 2200){
        if(score == 2169){
          mode2_bgm.pause();
          mode2_bgm.rewind();
          rocky.play();
        }
        tint(255,erogif5Alpha);
        image(erogif5,width/2,height/2);
        erogif5Alpha -= 9;
      }else if(score >= 2200){
        if(h == 450.0){
          erogif5Alpha = 256;  //初期化
          dh = 8.0;
          dw = dh*389/450;
        }else if(h == 498.0){
        dh = -2;
        dw = dh*389/450;
        }
        if(rx > width/2){
          tint(255,255);
          image(ranshi,rx,height/2);
          tint(255,60);
          image(ranshi,rx,height/2,w+dw,h+dh);
          rx -= 1;
          h = h + dh;
          w = w + dw;
        }else{
          tint(255,255);
          image(ranshi,rx,height/2);
          tint(255,60);
          image(ranshi,rx,height/2,w+dw,h+dh);
          h = h + dh;
          w = w + dw;
        }
      }     
      imageMode(CORNER);
//score 1396~1486 : errorlog
//score 1486~1600 : blackout
    }
    
    tint(255,255);
    line(0,height-29,width,height-29);//GameOver line
    score++;
    
    //---------- Air plane----------
    
    if(Alpha == true){
      Alpha = false;
      if(alt <= 100){
        image(normal,200,alt,100,46.5);
      }
      if(alt > 100){
        alt -= alt_upspeed;
        image(up,200,alt,100,55.1);
      }
    }else{
      alt += alt_downspeed;
      image(down,200,alt,100,57);
    }
    if(alt > 514){
      for(int j = 0;j < maxn_object;j++){
        object[j] = 0;
      }
      scene = 4;
      alt = 100;
      count = 300;
    }else if(score>3000){
      for(int j = 0;j < maxn_object;j++){
        object[j] = 0;
      }
      scene = 5;
      alt = 100;
      count = 300;      
    }
    
    //---------- information ----------
    
    textFont(MarioFont);
    textSize(40);
    textAlign(CENTER);
    text("SCORE", width*3/5, height/10);
    text(score/10 + "m", width*3/5, height/5);
    text("MODE" , width*4/5, height/10);
    text(modename[mode], width*4/5, height/5);
    text(difficultyname[difficulty],width*9/10, height);
    
    //---------- make object ----------
    
    if(object_switch == true){
      random = random(0,100);
      if(random < rate_of_occurrence && n_object < maxn_object){
        for(int i = 0;i < maxn_object;i++){
          if(object[i] == 0){
            object[i] = 1;
            obalt[i] = alt;
            obx[i] = 1000;
            break;
          }
        }
        n_object++;
      }
      if(n_object > 0){
        for(int i = 0; i < maxn_object;i++){
          if(object[i] == 1){
            if(mode == 0){
              image(object0, obx[i],obalt[i]-25,100,100);
            }else if(mode == 1){
              if(100<obx[i] && obx[i]<350){
                image(object1,obx[i],obalt[i]-25,100,100);
              }else{        
                image(object1r,obx[i],obalt[i],50,50);
              }
            }else if(mode == 2){
              image(object2, obx[i],obalt[i]-25,100,100);
            }
            if(contact(obx[i], obalt[i], alt)==true){
              for(int j = 0;j < maxn_object;j++){
                object[j] = 0;
              }
              scene = 4;
              alt = 100;
              count = 300;
            }
            obx[i] -= object_speed;
            if(obx[i]<-100){
              object[i] = 0; 
              n_object --;
            }
          }
        }
      }
    }    
  }else if(scene == 4){
    
    //----------Game Over----------

    textSize(60);
    text("Game Over", width/2, height/2);
    if(count == 300){
      if(mode==0){
        mode0_bgm.pause();
        mode0_bgm.rewind();
        mode0_gameover_bgm.play();
      }
      if(mode==1){
        mode1_bgm.pause();
        mode1_bgm.rewind();
        horror1.stop();
        horror2.stop();
        horror3.stop();
        horror4.stop();
        horror5.stop();
        horror8.stop();
        horror9.stop();
        horror10.stop();
        horror11.stop();
        horror12.stop();
      }if(mode==2){
        mode2_bgm.pause();
        mode2_bgm.rewind();
        rocky.pause();
        rocky.rewind();
        erogif0.stop();
        erogif1.stop();
        erogif2.stop();
        erogif3.stop();
        erogif4.stop();
        erogif5.stop();
      }
    }
    count--;
    if(count < 150){
      scene = 6;
      count = 400;
      scrollCount = 0;
      resultReady = false;
      mode0_gameover_bgm.pause();
      mode0_gameover_bgm.rewind(); 
    }
  }else if(scene == 5){
    
    //----------Game Clear----------
    
    textSize(60);
    text("Congratulations!", width/2, height/2);
    if(count == 300){
      if(mode==0){
        mode0_bgm.pause();
        mode0_bgm.rewind();
        mode0_gameclear_bgm.play();
      }
      if(mode==1){
        mode1_bgm.pause();
        mode1_bgm.rewind();
        horror1.stop();
        horror2.stop();
        horror3.stop();
        horror4.stop();
        horror5.stop();
        horror8.stop();
        horror9.stop();
        horror10.stop();
        horror11.stop();
        horror12.stop();
      }if(mode==2){
        rocky.pause();
        rocky.rewind();
        erogif0.stop();
        erogif1.stop();
        erogif2.stop();
        erogif3.stop();
        erogif4.stop();
        erogif5.stop();
      }
    }
    count--;
    if(count < 90){
      scene = 6;
      count = 400;
      resultReady = false;
      mode0_gameclear_bgm.pause();
      mode0_gameclear_bgm.rewind();
    }  
  }else if(scene == 6){
    
     //-----------Result------------
     
    textFont(MarioFont);
    fill(0);
    count--;
    if(mode==0 || mode==1){
      image(resultbg, 0,0, 1000,600);
    }
    if(mode==2){
      image(resultero, 0,0, 1000,600);
    }
    pon.play();
    if(count<270){
      don.play();
      textSize(50);
      textAlign(CENTER);
      text("MODE",365, 205);
    }
    if(count<250){
      if(count==249){
        don.pause();
        don.rewind();
        don.play();
      } 
      text(modename[mode], 365, 255);
    }
    if(count<230){
      if(count==229){
        don.pause();
        don.rewind();
        don.play();
      } 
      textSize(60);
      textAlign(LEFT);
      text(score/10 + "m", 720, 155);
    }
    //score meter
    
    noStroke();
    
    if(count<210){
      meter.play();
      fill(255,0,0);
      rect(520, 195.5, 41, 39);
      fill(0);
      if(score<=350){
        resultReady=true;
      }
    }  
    if(count<205 && score>350){
      if(count==204){
        meter.pause();
        meter.rewind();
        meter.play();
      } 
      fill(255,25,0);
      rect(561, 195.5, 41, 39);
      fill(0);    
      if(score<=700){
        resultReady=true;
      }
    }
    if(count<200 && score>700){
      if(count==199){
        meter.pause();
        meter.rewind();
        meter.play();
      } 
      fill(255,51,0);
      rect(602, 195.5, 41, 39);
      fill(0);
      if(score<=1050){
        resultReady=true;
      }        
    }
    if(count<195 && score>1050){
      if(count==194){
        meter.pause();
        meter.rewind();
        meter.play();
      } 
      fill(255,76,0);
      rect(643, 195.5, 41, 39); 
      fill(0); 
      if(score<=1400){
        resultReady=true;
      }        
    }
    if(count<190 && score>1400){
      if(count==189){
        meter.pause();
        meter.rewind();
        meter.play();
      } 
      fill(255,102,0);
      rect(684, 195.5, 41, 39); 
      fill(0); 
      if(score<=1750){
        resultReady=true;
      }           
    }
    if(count<185 && score>1750){
      if(count==184){
        meter.pause();
        meter.rewind();
        meter.play();
      } 
      fill(255,127,0);
      rect(725, 195.5, 41, 39); 
      fill(0);
      if(score<=2100){
        resultReady=true;
      }   
    }
    if(count<180 && score>2100){
      if(count==179){
        meter.pause();
        meter.rewind();
        meter.play();
      } 
      fill(255,153,0);
      rect(766, 195.5, 41, 39); 
      fill(0);
      if(score<=2450){
        resultReady=true;
      }   
    }
    if(count<175 && score>2450){
      if(count==174){
        meter.pause();
        meter.rewind();
        meter.play();
      } 
      fill(255,178,0);
      rect(807, 195.5, 41, 39); 
      fill(0);
      if(score<=2800){
        resultReady=true;
      }   
    }
    if(count<170 && score>2800){
      if(count==169){
        meter.pause();
        meter.rewind();
        meter.play();
      } 
      fill(255,204,0);
      rect(848, 195.5, 41, 39); 
      fill(0);
      if(score<=3000){
        resultReady=true;
      }   
    }
    if(count<165 && score>3000){
      if(count==164){
        meter2.pause();
        meter2.rewind();
        meter2.play();
      } 
      fill(255,255,0);
      rect(889, 195.5, 50, 39); 
      fill(0);
      resultReady=true;
    }
    if(resultReady==true){
      textFont(NormalFont);
      rcount++;
      if(rcount>=30){
        if(rcount==30){
          snare.play();
        }
        textSize(70);
        text("あなたは", 200, 450);
      }
      if(rcount >=60){
        if(rcount==60){
          snare.pause();
          snare.rewind();
          jan.play();
        }
        if(score<1000){
          text(result[mode][0], 550, 450);
        }
        if(1000<=score && score<2000){
          text(result[mode][1], 550, 450);
        }
        if(2000<=score && score<3000){
          text(result[mode][2], 550, 450);
        }
        if(3000<=score){
          text(result[mode][3], 550, 450);
        }
      }
    }
    if(rcount > 150){
      scene = 0;
      score = 0;
      count = 150;
      rcount = 0;
      pon.pause();
      pon.rewind();
      meter.pause();
      meter.rewind();
      meter2.pause();
      meter2.rewind();
      jan.pause();
      jan.rewind();
    } 
  }
}

// ---------- Atarihantei ----------

boolean contact(float ob_x, float ob_y, float alt){
  if(100<ob_x && ob_x<300){
    if(abs(ob_y - alt)<60){
      return true;
    }else{
      return false;
    } 
  }else{
    return false;
  }
}

// ---------- keyboard control ----------

void keyPressed() {
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
    pointer = (pointer + 1)%BUFFER_SIZE;
  }  
}

void stop(){
  title_bgm.close();
  decision.close();
  cursor.close();
  mode0_bgm.close();
  mode0_gameover_bgm.close();
  mode0_gameclear_bgm.close();
  mode1_bgm.close();
  mode2_bgm.close();
  error_bgm.close();
  hereWeGo.close();
  nigasanai.close();
  tasukete.close();
  himei.close();
  rocky.close();
  meter.close();
  meter2.close();
  pon.close();
  don.close();
  snare.close();
  jan.close();
  minim.stop();
  super.stop();
}
