class Cube {
  float startingZ = -5000;
  float maxZ = 2000;

  float x, y, z;
  float rotX, rotY, rotZ;
  float sumRotX, sumRotY, sumRotZ;
  Cube() {
    x = random(0, width);
    y = random(0, height);
    z = random(startingZ, maxZ);

    rotX = random(0, 1);
    rotY = random(0, 1);
    rotZ = random(0, 1);
  }

  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {

    color displayColor = color(scoreLow * 0.85, scoreMid * 0.64, scoreHi * 0.80, intensity * 5);
    fill(displayColor, 0);
    color strokeColor = color(random(86, 120), 150-(20*intensity));
    stroke(strokeColor);
    strokeWeight((1 + scoreGlobal/5000));

    pushMatrix();
    translate(x, y, z);

    scale(2*(intensity/5000), 2*(intensity/100), 15);

    sumRotX += intensity*(rotX);
    sumRotY += intensity*(rotY);
    sumRotZ += intensity*(rotZ);

    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);

    box(200+(intensity/20));
    popMatrix();

    z+= (1+(intensity/5)+(pow((scoreGlobal/150), 2)));

    if (z >= maxZ) {
      x = random(0, width);
      y = random(0, height);
      z = startingZ;
    }

    if (timer4.isFinished()) {
      myAudioFFT.forward(myAudio.mix);
      for (int i = 0; i < myAudioRange; i++) {
        stroke(random(0, 255), random(0, 255));
        strokeWeight(random(1, 3));
        fill(random(0, 250), random(140, 230), random(135, 225), random(0, 255));
        rotate(360);

        float tempIndexAvg = (myAudioFFT.getAvg(i) * -myAudioAmp) * myAudioIndexAmp;
        rect(xStart + (i+xSpacing), yStart, rectSize, tempIndexAvg/1000);

        myAudioIndexAmp += myAudioIndexStep;
        myAudioIndexAmp = myAudioIndex;

        pushMatrix();
        translate(400, 300);
        rotate(radians(-180));
        rect(0 + (i+xSpacing), -yStart, rectSize, tempIndexAvg/100);
        popMatrix();

        pushMatrix();
        translate(x, y, z);
        rotate(radians(-180));
        rect(width/2 + (i+xSpacing), -yStart-200, rectSize, tempIndexAvg/100);
        popMatrix();

        pushMatrix();
        translate(x, y, z);
        rotate(radians(-180));
        rect(width/2 + (i+xSpacing), -yStart-600, rectSize, tempIndexAvg/100);
        popMatrix();

        pushMatrix();
        translate(x, y, z);
        rotate(radians(-235));
        rect(-xStart + (i+xSpacing), -yStart-900, rectSize, tempIndexAvg/100);
        popMatrix();

        pushMatrix();
        translate(x, y, z);
        rotate(radians(-270));
        rect(xStart + (i+xSpacing), -yStart-1200, rectSize, -tempIndexAvg);
        popMatrix();

        pushMatrix();
        translate(x, y, z);
        rotate(radians(-315));
        rect(xStart + (i+xSpacing), -yStart-1500, rectSize, -tempIndexAvg);
        popMatrix();
      }
    } 
      if (setsphere == 1) { 
        noFill();
        stroke(255, 0, 255, a);
        strokeWeight(random(0, 5));
        sphere(spheresize);
        a--;
      }

      if (setcolor == 1) {
        dotcolor = color(random(255), scoreLow *.15, scoreHi*10, intensity * myAudioAmp);
      }

      for (int s = 0; s < physics.particles.size(); s++) {
        VBoid boid = (VBoid) physics.particles.get(s);

        if (setcolor == 2) {
          h = boid.y;
          h += spheresize;
          dotcolor = color(scoreLow * 0.85, scoreMid * 0.64, scoreHi * 0.80, intensity * 5);
        }
        strokeWeight(dotsize);
        stroke(dotcolor);
        point(boid.x, boid.y, boid.z);
      }
    }
  }
