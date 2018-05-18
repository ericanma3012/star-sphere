
class Star {
  float x;
  float y;
  float z;

  float pz;

  Star() {
    x = random(-width, width);
    y = random(-height, height);
    z = random(width);

    pz = z;
  }

  void update() {
    z = z - speed;
    if (z < 1) {
      z = width;
      x = random(-width, width);
      y = random(-height, height);
      pz = z;
    }
  }

  void show() {
      fill(random(163,185), random(66,88), random(0, 199), random(50, 255));
      noStroke();

      float sx = map(x / z, 0, 1, 0, width);
      float sy = map(y / z, 0, 1, 0, height);

      float r = map(z, 0, width, 12, 0);
      ellipse(sx, sy, r, r);

      float px = map(x / pz, 0, 1, 0, width);
      float py = map(y / pz, 0, 1, 0, height);

      pz = z;

      stroke(random(113, 236), random(143, 236), random(150, 236), random(255));
      line(px, py, sx, sy);
    }
  }
