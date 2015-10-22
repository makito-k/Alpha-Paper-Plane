import gifAnimation.*;
import ddf.minim.*;

int scene;
int mode = 0;
int count = 0;
int alt = 75;
int x=600;
float random;
float score = 0;
boolean Nod;
boolean Shake;
boolean Alpha;

PImage up,down,normal,sky;
Gif airplain,horror1,horror2,ero1;
Minim minim;
AudioPlayer title_bgm,decision,cursor,mode0_bgm,mode1_bgm,mode2_bgm;

void setup(){
  size(1000, 600);
  frameRate(30);
  background(255);
  smooth();
  minim = new Minim(this);  
  title_bgm = minim.loadFile("/music/Final Fantasy XIII Main Menu Theme.mp3");
  decision = minim.loadFile("/music/decision.mp3");
  cursor = minim.loadFile("/music/cursor.mp3");
  mode0_bgm = minim.loadFile("/music/mario.mp3");
  mode1_bgm = minim.loadFile("/music/radionoise.mp3");
  mode2_bgm = minim.loadFile("/music/H na BGM.mp3");
  up = loadImage("/img/airplain_up.png");
  down = loadImage("/img/airplain_down.png");
  normal = loadImage("/img/airplain_normal.png");
  sky = loadImage("/img/sky.jpg");
  airplain = new Gif(this, "/img/title.gif");
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
    
    background(255);
    stroke(0);
    score++;
    textSize(30);
    if(mode==0){
      mode0_bgm.play();
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
      background(255,230,240);
      fill(139,28,98);
      stroke(139,28,98);
      if(score>500 && score<635){
        ero1.play();
        image(ero1,0,0,width,height);
      }
    }
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
