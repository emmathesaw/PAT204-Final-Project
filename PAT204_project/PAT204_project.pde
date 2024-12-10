/* 

PAT 204 Final Project: Interactive Drum Machine Visualizer
Created by: Emma Sawdon, Fall 2024

This drum machine-based music visualizer takes in a beat-based rythm based on the MaxMSP output
and displays hearts with an aura glow and different properties depending on the drum sound 
(kick drum, snare drum, hi-hat symbol, and open hi-hat symbol).

In Max, the user also has the ability to manipulate the beat and change the tempo of the beat.
As the tempo changes, so does the color scheme of the hearts. There is also a panning option included,
which not only pans the audio, but the hearts follow and pan across the screen as well.

Referenced: https://forum.processing.org/beta/num_1246205739.html
Used to get a base of the heart shape in order for me to enhance it.
Also utilized Professor Hao-Wen Dong's Linear Crossfade Max patch and
drum machine using buffers Max patch.

*/

import oscP5.*;
import netP5.*;
OscP5 osc;
NetAddress addr;

int sliderVal = 50;
int ohatVal = 0;
int hihatVal = 0;
int snareVal = 0;
int kickVal = 0;
int tempoVal = 0;

ArrayList<BeatHeart> hearts; //an array list to store all of the created hearts

void setup() {
  size(800, 600);
  hearts = new ArrayList<BeatHeart>();
  
  addr = new NetAddress("127.0.0.1", 8888);
  osc = new OscP5(this, 8888);
}


void oscEvent(OscMessage oscMessage) {
  //print the address pattern and typetag of the received OSC message
  print("OSC message received");
  print(" | addrpattern: " + oscMessage.addrPattern());
  println(" | typetag: " + oscMessage.typetag());
  
  if (oscMessage.addrPattern().equalsIgnoreCase("/ohat")) {
     ohatVal = 1;
  }
  else if (oscMessage.addrPattern().equalsIgnoreCase("/hihat")) {
     hihatVal = 1;
  }
  else if (oscMessage.addrPattern().equalsIgnoreCase("/snare")) {
     snareVal = 1;
  }
  else if (oscMessage.addrPattern().equalsIgnoreCase("/kick")) {
     kickVal = 1;
  }
  if (oscMessage.addrPattern().equalsIgnoreCase("/slider")) {
     sliderVal = oscMessage.get(0).intValue();
  }
  if (oscMessage.addrPattern().equalsIgnoreCase("/tempo")) {
     tempoVal = oscMessage.get(0).intValue();
  }
}

void draw() {
  background(0);
  //map the slider value (0-100) to a pan offset (-width/3 to width/3)
  float panOffset = map(sliderVal, 0, 100, -width / 3, width / 3);

  //base range for the hearts (central range, reduced width)
  float minX = width / 2 - width / 8; //narrower central range
  float maxX = width / 2 + width / 8;

  //adjust the range with the pan offset
  float adjustedMinX = constrain(minX + panOffset, 0, width);
  float adjustedMaxX = constrain(maxX + panOffset, 0, width);

  //check different beat types and create corresponding hearts
  if (kickVal == 1) { //detects kick
    hearts.add(new BeatHeart(random(adjustedMinX, adjustedMaxX), random(height / 6, 5 * height / 6), "kick"));
    kickVal = 0;
  }
  if (snareVal == 1) { //detects snare
    hearts.add(new BeatHeart(random(adjustedMinX, adjustedMaxX), random(height / 6, 5 * height / 6), "snare"));
    snareVal = 0;
  }
  if (hihatVal == 1) { //detects hihat
    hearts.add(new BeatHeart(random(adjustedMinX, adjustedMaxX), random(height / 6, 5 * height / 6), "hat"));
    hihatVal = 0;
  }
  if (ohatVal == 1) { //detects open hihat
    hearts.add(new BeatHeart(random(adjustedMinX, adjustedMaxX), random(height / 6, 5 * height / 6), "ohat"));
    ohatVal = 0;
  }
  
  //update and display circles by looping through ArrayList starting from newly added
  for (int i = hearts.size() - 1; i >= 0; i--) {
    BeatHeart heart = hearts.get(i);
    //calls to member functions
    heart.update(); 
    heart.display();
    
    //remove circles that are fully faded
    if (heart.isFaded()) {
      hearts.remove(i);
    }
  }
}
