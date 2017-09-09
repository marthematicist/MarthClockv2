
PixelEngine PE;

void setup() {
  size( 800 , 480 );
  pg = createGraphics( width , height );
  halfWidth = width/2;
  halfHeight = height/2;
  xRes = float(width);
  yRes = float(height);
  
  PE = new PixelEngine(3);
  PE.createNewRandomizerThread();
  PE.startRandomizerThread();
}

void draw() {
  // Randomizer:
  // stop randomizer
  PE.interruptRandomizerThread();
  PE.waitForRandomizerThreadToFinish();
  // if randomizer is done, update with new random numbers
  if( PE.randomNumbersReady() ) {
    PE.updateRandomNumbers();
  }
  // update randomizer progress
  PE.updateRandomizerProgress();
  // restart randomizer thread
  PE.createNewRandomizerThread();
  PE.startRandomizerThread();
  
  // get pixel data
  int[] pixelColors = PE.outputPixelData();
  
  // start pixel block threads
  PE.createNewBlockThreads();
  PE.startBlockThreads();
  
  // update pixels
  loadPixels();
  for( int i = 0 ; i < width*height ; i++ ) {
    pixels[i] = pixelColors[i];
  }
  updatePixels();
  
  PE.waitForBlockThreadsToFinish();
  
  if( frameCount%60 == 0 ) {
    println( frameCount , frameRate );
  }
}