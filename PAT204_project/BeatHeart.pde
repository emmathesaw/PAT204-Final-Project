/*BeatHeart class contructs a new heart and updates member variables.
Includes member functions to fade hearts and show them on the screen.*/

class BeatHeart {
  float x, y, size; //position variables
  float alpha; //opacity variable
  String type; //store the type of beat (kick, snare, hihat, open hihat)
  color c; //used to customize the color depending on the frequency

  /*BeatHeart constructor that takes in three parameters and creates a heart
  based on the type of beat being passed in*/
  BeatHeart(float x, float y, String type) {
    this.x = x;
    this.y = y;
    this.type = type;
    
    //size and alpha are based on beat type
    if (type.equals("kick")) {
      this.size = random(200, 220); //larger size for kick
      this.alpha = 230;
      //if tempo is 0-200, will be red
      if (tempoVal >= 0 && tempoVal <= 200) {
        this.c = color(random(235, 245), random(30, 45), random(90, 100));
      }
      //if tempo is 201-400, will be green
      else if (tempoVal >= 201 && tempoVal <= 400) {
        this.c = color(random(30, 43), random(95, 108), random(45, 60));
      }
      //if tempo is 401-600, will be blue
      else if (tempoVal >= 401 && tempoVal <= 600) {
        this.c = color(random(40, 50), random(110, 120), random(175, 185));
      }
    } 
    
    else if (type.equals("snare")) {
      this.size = random(110, 120); //medium size for snare
      this.alpha = 255;
      //if tempo is 0-200, will be pale pink
      if (tempoVal >= 0 && tempoVal <= 200) {
        this.c = color(random(240, 255), random(180, 200), random(195, 210));
      }
      //if tempo is 201-400, will be sage green
      else if (tempoVal >= 201 && tempoVal <= 400) {
        this.c = color(random(150, 165), random(185, 200), random(125, 135));
      }
      //if tempo is 401-600, will be light blue
      else if (tempoVal >= 401 && tempoVal <= 600) {
        this.c = color(random(160, 170), random(185, 195), random(215, 225));
      }
    } 
    
    else if (type.equals("hat")) {
      this.size = random(40, 45); //smaller size for hihat
      this.alpha = 160;
      //if tempo is 0-200, will be pink
      if (tempoVal >= 0 && tempoVal <= 200) {
        this.c = color(random(220, 255), random(15, 25), random(140, 150));
      }
      //if tempo is 201-400, will be very light green
      else if (tempoVal >= 201 && tempoVal <= 400) {
        this.c = color(random(225, 235), random(240, 250), random(220, 230));
      }
      //if tempo is 401-600
      else if (tempoVal >= 401 && tempoVal <= 600) {
        this.c = color(random(120, 130), random(150, 160), random(165, 175));
      }
    }
    
    else if (type.equals("ohat")) {
      this.size = random(30, 35); //smaller size for open hihat
      this.alpha = 190;
      //if tempo is 0-200, will be orange
      if (tempoVal >= 0 && tempoVal <= 200) {
        this.c = color(random(240, 255), random(125, 135), random(115, 126));
      }
      //if tempo is 201-400, will be beige
      else if (tempoVal >= 201 && tempoVal <= 400) {
        this.c = color(random(200, 210), random(180, 190), random(130, 140));
      }
      //if tempo is 401-600
      else if (tempoVal >= 401 && tempoVal <= 600) {
        this.c = color(random(237, 247), random(237, 247), random(245, 255));
      }
    }
  }

  void update() { //used to gradually fade out the heart
    alpha -= 5; 
  }

  void display() { //used to show the heart outline with a glowing aura
    smooth();
    
    //draw the aura
    for (int i = 10; i > 0; i--) { //10 layers of glow
        float glowSizeX = size + i * 5; //incremental increase in width for the glow
        float glowSizeY = size + i * 3; //smaller increase in height for the glow
        float glowAlpha = alpha * 0.05 * i; //decreasing alpha for fading effect
        noFill();
        stroke(this.c, glowAlpha); //glow color with decreasing transparency
        strokeWeight(2); //thinner stroke for glow layers

        beginShape();
        vertex(x, y - glowSizeY * 0.35);
        bezierVertex(x - glowSizeX * 0.3, y - glowSizeY * 0.8, x - glowSizeX * 0.8, y - glowSizeY * 0.2, x, y + glowSizeY * 0.3);
        vertex(x, y + glowSizeY * 0.3);
        bezierVertex(x + glowSizeX * 0.8, y - glowSizeY * 0.2, x + glowSizeX * 0.3, y - glowSizeY * 0.8, x, y - glowSizeY * 0.35);
        endShape(CLOSE);
    }

    //draw the main heart outline
    noFill();
    stroke(this.c, alpha); //set stroke color and transparency
    strokeWeight(6); //larger stroke weight for the main outline

    beginShape();
    vertex(x, y - size * 0.35);
    bezierVertex(x - size * 0.3, y - size * 0.8, x - size * 0.8, y - size * 0.2, x, y + size * 0.3);
    vertex(x, y + size * 0.3);
    bezierVertex(x + size * 0.8, y - size * 0.2, x + size * 0.3, y - size * 0.8, x, y - size * 0.35);
    endShape(CLOSE);
  }

  boolean isFaded() { //used to stop displaying heart
    return alpha < 0; 
  }
}
