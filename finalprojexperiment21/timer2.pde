class Timer2 {

  int savedTime; // When Timer started
  int totalTime;// How long Timer should last

  Timer2(int tempTotaltime) {
    totalTime = tempTotaltime;
  }

  // Starting the timer
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime =  millis();
  }
  void drawTime() {
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      //savedTime = millis();
    }
  }
  boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    } else {
      return false;
    }
  }
}
