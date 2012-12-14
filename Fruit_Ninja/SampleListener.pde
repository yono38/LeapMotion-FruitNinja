class SampleListener extends Listener {

  Vector lastPos;
  boolean hasHands;
  boolean connected = false;

  public void onInit(Controller controller) {
    println("Initialized");
  }

  public void onConnect(Controller controller) {
    println("Connected");
    connected = true;
  }

  public void onDisconnect(Controller controller) {
    println("Disconnected");
    connected = false;
  }

  public void onFrame(Controller controller) {
    // Get the most recent frame and report some basic information

    Frame frame = controller.frame();
    HandArray hands = frame.hands();
    long numHands = hands.size();
    System.out.println("Frame id: " + frame.id()
      + ", timestamp: " + frame.timestamp()
      + ", hands: " + numHands);

    if (numHands == 0) {
      hasHands = false;
    } 
    else {
      hasHands = true;
      // Get the first hand
      Hand hand = hands.get(0);

      // Check if the hand has any fingers
      FingerArray fingers = hand.fingers();
      long numFingers = fingers.size();
      if (numFingers >= 1) {
        // Calculate the hand's average finger tip position
        Vector pos = new Vector(0, 0, 0);
        for (int i = 0; i < numFingers; ++i) {
          Finger finger = fingers.get(i);
          Ray tip = finger.tip();
          pos.setX(pos.getX() + tip.getPosition().getX());
          pos.setY(pos.getY() + tip.getPosition().getY());
          pos.setZ(pos.getZ() + tip.getPosition().getZ());
        }
        pos = new Vector(pos.getX()/numFingers, pos.getY()/numFingers, pos.getZ()/numFingers);
        //        println("Hand has " + numFingers + " fingers with average tip position"
        //          + " (" + pos.getX() + ", " + pos.getY() + ", " + pos.getZ() + ")");

        lastPos = pos;
      }
    }
    
  }
}

