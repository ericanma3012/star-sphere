class Drop {

  float x, y;   // Variables for location of raindrop
  color c;
  float r;      // Radius of raindrop
  float t;

  Drop() {
    r = random(5);                   // All raindrops are the same size
    x = random(width);       // Start with a random x location
    y = -r*4;                // Start a little above the window
  }

  // Move the raindrop down
  void move() {
    // Increment by speed
    y += myAudioAmp/random(myAudioAmp);
  }

  // Check if it hits the bottom
  boolean reachedBottom() {
    // If we go a little beyond the bottom
    if (y > height + r*4) { 
      return true;
    } else {
      return false;
    }
  }

  // Display the raindrop
  void display() {
    // Display the drop
    color(scoreHi * 0.6, scoreLow * 0.4, scoreMid * 0.3);
    noStroke();
    //stroke(dotcolor);
    for (int t = 0; t < r; t++ ) {
      ellipse(x, y + t*3.5, t*2, t*2);
    }
  }
}
