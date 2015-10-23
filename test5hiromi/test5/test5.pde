import gifAnimation.*;
import ddf.minim.*;

int once = 0;
int scene;
int mode = 0;
int count = 0;
int alt = 75;
int x=600;
int scrollCount=0;
float random;
float score = 0;
boolean Nod;
boolean Shake;
boolean Alpha;

PImage up,down,normal,sky, bgNormal, bgHorror, bgEro, virus;
Gif airplain,horror1,horror2,ero1;
Minim minim;
AudioPlayer title_bgm,decision,cursor,mode0_bgm, mode0_gameover_bgm, mode1_bgm,mode2_bgm, error_bgm, hereWeGo;

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
  up = loadImage("img/airplain_up.png");
  down = loadImage("img/airplain_down.png");
  normal = loadImage("img/airplain_normal.png");
  sky = loadImage("img/sky.jpg");
  bgNormal = loadImage("img/mario(840*600).gif");
  bgEro = loadImage("img/black.JPG");
  virus = loadImage("img/virusWindow.jpg");
  airplain = new Gif(this, "img/title.gif");
  airplain.play(); 
  horror1 = new Gif(this,"img/horror1.gif");
  horror2 = new Gif(this,"img/horror2.gif");
  ero1 = new Gif(this,"img/ero1.gif");
}

void draw(){

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
    
    //background(255);
    stroke(0);
    score++;
    textSize(30);
    
    if(mode==0){//normal mode
      if(once == 0){
        hereWeGo.play();
        once++;
      }  
      mode0_bgm.play();
      image(bgNormal, scrollCount, 0);
      image(bgNormal, 840+scrollCount, 0);
      image(bgNormal, 1680+scrollCount, 0);
      scrollCount--;

    }else if(mode==1){
      mode1_bgm.play();
      background(0);
      fill(255,48,48);
      stroke(255,48,48);
      if(score>500 && score<659){
        horror1.play();
        image(horror1,0,0,width,height);
      }else if(score>700 && score<1020){
        horror2.play();
        image(horror2,0,0,width,height);
      }
    }else{
      mode2_bgm.play();
      image(bgEro, scrollCount, 0);
      image(bgEro, 978+scrollCount, 0);
      image(bgEro, 1956+scrollCount, 0);
      scrollCount--;
      fill(139,28,98);
      stroke(139,28,98);
      if(score>500 && score<635){
        ero1.play();
        image(ero1,0,0,width,height);
      }
      if(score>700 && score<790){
        mode2_bgm.pause();
        mode2_bgm.rewind();
        error_bgm.play();
        image(virus, 340,180);
        if(score>720 && score<790){
          error_bgm.play();
          image(virus, 0,0);
        }
        if(score>740 && score<790){
          error_bgm.play();
          image(virus,500,350);
        }
        if(score>760 && score<790){
          error_bgm.play();
          image(virus, 100,400);
        }
        if(score>770 && score<790){
          error_bgm.play();
          image(virus, 700,120);
        }
        
      }
      if(score>790){
        error_bgm.pause();
        error_bgm.rewind();
        mode2_bgm.play();  
      }
    }
    line(0,height-29,width,height-29);//GameOver line
    if(Alpha == true){
      Alpha = false;
      if(alt == 75){
        image(normal,200,alt*2-50,100,46.5);//(200,alt*2-50)から画像
      }
      if(alt > 75){
        alt--;
        image(up,200,alt*2-50,100,55.1);
      }
    }else{
      //alt++;
      image(down,200,alt*2-50,100,57);
    }
    if(alt > 282){//死ぬ高さ
      if (mode == 0){
        mode0_bgm.pause();
        mode0_bgm.rewind();
        mode0_gameover_bgm.play();
      }
      scene = 4;
      alt = 75;
    }else if(score>3000){
      scene = 5;
      alt = 75;      
    }
    text("SCORE: " + score/10 + "m", width*4/5, height/4);
  }else if(scene == 4){
    
    //----------Game Over----------
    
    textSize(60);
    text("Game Over", width/2, height/2);
    
    count--;
    if(count < 0){
      scene = 0;
      score = 0;
      count = 150;
      mode0_bgm.pause();
      mode0_bgm.rewind();
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
      scene = 0;
      score = 0;
      count = 150;
      mode0_bgm.pause();
      mode0_bgm.rewind();
      mode1_bgm.pause();
      mode1_bgm.rewind();
      mode2_bgm.pause();
      mode2_bgm.rewind();
    }  
  }
}

void keyPressed() {
  if(keyCode == DOWN){
    Nod = true;
  }else if(keyCode == RIGHT){
    Shake = true;
  }else if(keyCode == UP){
    Alpha = true;
  }
}
