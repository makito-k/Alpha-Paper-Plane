import oscP5.*;
import netP5.*;

final int N_CHANNELS = 4;
final int BUFFER_SIZE = 970;
final float MAX_MICROVOLTS = 1682.815;
final float ALPHA_MICROVOLTS = 1;
final float DISPLAY_SCALE = 200.0;
final String LABEL = "Alpha";

final color BG_COLOR = color(0, 0, 0);
final color AXIS_COLOR = color(255, 0, 0);
final color GRAPH_COLOR = color(0, 0, 255);
final color LABEL_COLOR = color(255, 255, 0);
final int LABEL_SIZE = 21;
final float LIMIT = 0.7;

final int PORT = 5001;
OscP5 oscP5 = new OscP5(this, PORT);

float[][] buffer = new float[N_CHANNELS][BUFFER_SIZE];
int n_validCh;
int validCh;
int pointer = 0;
float offsetX;
float offsetY;
float sum; 
float[] value = new float[BUFFER_SIZE];
String[] status = new String[N_CHANNELS]; 


void setup(){
  size(1000, 600);
  frameRate(30);
  smooth();
  offsetX = 15;
  offsetY = height - 100;
}

void draw(){
  float x1, y1, x2, y2, value_ave;
  background(BG_COLOR);

  text("Ch1: "+ status[0], 800, 50);
  text("Ch2: "+ status[1], 800, 100);
  text("Ch3: "+ status[2], 800, 150);
  text("Ch4: "+ status[3], 800, 200);
  text("Valid Ch: "+ n_validCh, 800, 250);
  
  for(int t = 0; t < BUFFER_SIZE; t++){
      stroke(GRAPH_COLOR);
      x1 = offsetX + t;
      y1 = offsetY - value[(t + pointer) % BUFFER_SIZE] * DISPLAY_SCALE;
      x2 = offsetX + t + 1;
      y2 = offsetY - value[(t + 1 + pointer) % BUFFER_SIZE] * DISPLAY_SCALE;
      line(x1, y1, x2, y2);
    }
    stroke(AXIS_COLOR);
    x1 = offsetX;
    y1 = offsetY;
    x2 = offsetX + BUFFER_SIZE;
    y2 = offsetY;
    line(x1, y1, x2, y2);
    
    value_ave = 0;
    for(int i = 0; i<10; i++){
      value_ave += value[(pointer+BUFFER_SIZE-10+i) % BUFFER_SIZE]/10;
    }
    textSize(60);
    if(value_ave > LIMIT){
      text("I feel Alpha!", 100, 100);
    }else{
      text("No Alpha..."+value_ave, 100, 100);
    }
    
  fill(LABEL_COLOR);
  textSize(LABEL_SIZE);
  text(LABEL, offsetX, offsetY); 
}

void oscEvent(OscMessage msg){
  float data;
  if(msg.checkAddrPattern("/muse/elements/alpha_relative")){
    for(int ch = 0; ch < N_CHANNELS; ch++){
      data = msg.get(ch).floatValue();
      data = (data - (ALPHA_MICROVOLTS / 2)) / (ALPHA_MICROVOLTS / 2); // -1.0 1.0
      buffer[ch][pointer] = data;
    }
    
    validCh = 0;
    sum = 0;
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
    
    pointer = (pointer + 1) % BUFFER_SIZE;
  }
}
