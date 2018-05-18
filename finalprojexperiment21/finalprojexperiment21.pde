
import punktiert.math.Vec;
import punktiert.physics.*;

/////////////////////////////////////////////////////////
Timer timer;
Timer timer2;
Timer timer3;
Timer timer4;

Minim minim;
AudioPlayer myAudio;
FFT myAudioFFT; //fast fourier transform--class used anytime i need to analyze audio

float specLow = 0.02;
float specMid = 0.125;
float specHi = 0.30;

///////////////////////////////////////////////////////////

float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

float oldScoreLow = scoreLow;
float oldScoreMid = scoreMid;
float oldScoreHi = scoreHi;

float scoreDecreaseRate = 20;

///////////////////////////////////////////////////////////
int nbStars;
Star[] stars;
float speed;

int nbCubes;
Cube[] cubes;

Drop[] drops;
int totalDrops = 0;

///////////////////////////////////////////////////////////

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import ddf.minim.ugens.Waves;
import ddf.minim.ugens.Wavetable;

int myAudioRange = 256;
int myAudioMax = 400;

float myAudioAmp = 25.0;
float myAudioIndex = 0.75;
float myAudioIndexAmp = myAudioIndex;
float myAudioIndexStep = 0.105;

////////////////////////////////////////////////////////////

int rectSize = 0;

int stageMargin = 500;
int stageWidth = (myAudioRange * rectSize + (stageMargin * 5));
int stageHeight = height;

float xStart = stageMargin;
float yStart = stageMargin;

int xSpacing = rectSize +-20;

///////////////////////////////////////////////////////////

float r = 11;
float g = 20;
float b = 55;

float x, y, z;
float intensity;

///////////////////////////////////////////////////////////
VPhysics physics;

int setsphere = 0; //0: false, 1: true
int spheresize = 250; //base sphere size
int numberofdots = 1200; //number of flocking dots
int dotsize = 2; //flocking dot size
float dotspeed = 4f; //flocking dot speed
int setcolor = 1; //0: monochrome, 1: intensity-based, 2: custom
color dotcolor = color(255, 255, 255);
float h = 0;
float a = 100;

float s;

////////////////////////////////////////////////////

void setup() {
  fullScreen(P3D);
  smooth();

  minim = new Minim(this); //import class to analyze sound
  myAudio = minim.loadFile("coffee.mp3");
  myAudio.play(); //or loop

  myAudioFFT = new FFT(myAudio.bufferSize(), myAudio.sampleRate()); //bufferSize = 1024 / sampleRate = 44100 Hz
  myAudioFFT.linAverages(myAudioRange); //calculate averages by grouping freq. bands in linear pattern

  physics = new VPhysics();

  for (int s = 0; s < numberofdots; s++) {

    Vec pos = new Vec(0, 0, 0).jitter(1);
    Vec vel = new Vec(random(-1, 1), random(-1, 1), random(-1, 1));
    VBoid p = new VBoid(pos, vel);

    p.swarm.setSeperationScale(5.0f);
    p.swarm.setSeperationRadius(2);
    p.swarm.setAlignScale(1f);
    p.swarm.setAlignRadius(100);
    p.swarm.setCohesionScale(.08f);
    p.swarm.setCohesionRadius(50);
    p.swarm.setMaxSpeed(dotspeed*myAudioAmp);
    physics.addParticle(p);

    VSpring anchor = new VSpring(new VParticle(p.x(), p.y(), p.z()), p, spheresize, 0.5f);
    physics.addSpring(anchor);
    timer4 = new Timer(50000);
    timer4.start();
  }
  nbCubes = (int)(myAudioFFT.specSize()*specLow/2);
  cubes = new Cube[nbCubes];

  for (int j = 0; j < nbCubes; j++) {
    cubes[j] = new Cube();
  }

  nbStars = (int)(myAudioFFT.specSize()*specHi);
  stars = new Star[nbStars];

  for (int j = 0; j < nbStars; j++) {
    stars[j] = new Star();
    timer3 = new Timer(154000);
    timer3.start();
  }
  drops = new Drop[300];    // Create 300 spots in the array
  timer = new Timer(21000);
  timer.start();
}

void draw() {
  physics.update();
  background(r, g, b);
  if (mouseX > height/2) {
    b = b + 2;
  } else {
    b = b - 1;
  }
  b = constrain(b, 55, 60);

  myAudioFFT.forward(myAudio.mix);

  oldScoreLow = scoreLow;
  oldScoreMid = scoreMid;
  oldScoreHi = scoreHi;

  scoreLow = 400;
  scoreMid = 400;
  scoreHi = 400;

  // Move and display all drops according to when timer ends
  if (timer.isFinished()) {
    timer.drawTime();
    drops[totalDrops] = new Drop(); // Initialize one drop
    totalDrops++ ; // Increment totalDrops
    if (totalDrops >= drops.length) {
      totalDrops = 0; // Start over
    }
  }
  for (int j = 0; j < totalDrops; j++ ) {
    drops[j].move();
    drops[j].display();
  }

  speed = map(mouseX, 0, width, 0, myAudioAmp);
  translate(width/2, height/2);
  if (timer3.isFinished()) {
    for (int j = 0; j < stars.length; j++) {
      stars[j].update();
      stars[j].show();
    }
  }

  myAudioFFT.forward(myAudio.mix);

  for (int j = 0; j < myAudioFFT.specSize()*specLow+specHi; j++)
  {
    scoreLow += myAudioFFT.getBand(j);
  }
  for (int j = (int)(myAudioFFT.specSize()*specLow); j < myAudioFFT.specSize()*specMid; j++)
  {
    scoreMid += myAudioFFT.getBand(j);
  }
  for (int j = (int)(myAudioFFT.specSize()*specLow); j < myAudioFFT.specSize()*specHi; j++)
  {
    scoreHi += myAudioFFT.getBand(j);
  }
  if (oldScoreLow > scoreLow) {
    scoreLow = oldScoreLow - scoreDecreaseRate;
  }

  if (oldScoreMid > scoreMid) {
    scoreMid = oldScoreMid - scoreDecreaseRate;
  }

  if (oldScoreHi > scoreHi) {
    scoreHi = oldScoreHi - scoreDecreaseRate;
  }
  float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;

  //cube band freq
  for (int j = 0; j < nbCubes; j++){
    float bandValue = myAudioFFT.getBand(j);
    cubes[j].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  }
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

      z+= (1+(intensity/5)+(pow((scoreGlobal/150), 2)));


      pushMatrix();
      //translate(400, 300);
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
void stop() {

  myAudio.close();
  minim.stop();
}