class Timer3 {

  int savedTime3; // When Timer started
  int totalTime3;// How long Timer should last

  Timer3(int tempTotaltime) {
    totalTime3 = tempTotaltime;
  }

  // Starting the timer
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime3 =  millis();
  }
  void drawTime() {
    int passedTime = millis()- savedTime3;
    if (passedTime > totalTime3) {
      //savedTime = millis();
    }
  }
  boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime3;
    if (passedTime > totalTime3) {
      return true;
    } else {
      return false;
    }
  }
}
