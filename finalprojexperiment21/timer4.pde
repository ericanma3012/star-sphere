class Timer4 {

  int savedTime4; // When Timer started
  int totalTime4;// How long Timer should last

  Timer4(int tempTotaltime) {
    totalTime4 = tempTotaltime;
  }

  // Starting the timer
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime4 =  millis();
  }
  void drawTime() {
    int passedTime = millis()- savedTime4;
    if (passedTime > totalTime4) {
      //savedTime = millis();
    }
  }
  boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime4;
    if (passedTime > totalTime4) {
      return true;
    } else {
      return false;
    }
  }
}
