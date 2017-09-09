
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

boolean debug = true;

void draw() {
  int st = millis();
  // Randomizer:
  // stop randomizer
  PE.interruptRandomizerThread();
  PE.waitForRandomizerThreadToFinish();
  if( debug ) { println( frameCount + " randomizer Thread Finished At " + (millis()-st) ); }
  // if randomizer is done, update with new random numbers
  if( PE.randomNumbersReady() ) {
    PE.updateRandomNumbers();
    if( debug ) { println( frameCount + " random Numbers Updated At " + (millis()-st) ); }
  }
  // update randomizer progress
  PE.updateRandomizerProgress();
  if( debug ) { println( frameCount + " randomizer progress updated at " + (millis()-st) ); }
  // restart randomizer thread
  PE.createNewRandomizerThread();
  PE.startRandomizerThread();
  if( debug ) { println( frameCount + " randomizer thread started at " + (millis()-st) ); }
  
  // get pixel data
  int[] pixelColors = PE.outputPixelData();
  if( debug ) { println( frameCount + " pixel data retrieved at " + (millis()-st) ); }
  
  // start pixel block threads
  //PE.createNewBlockThreads();
  //PE.startBlockThreads();
  if( debug ) { println( frameCount + " pixel threads started at " + (millis()-st) ); }
  
  // update pixels
  loadPixels();
  for( int i = 0 ; i < width*height ; i++ ) {
    pixels[i] = pixelColors[i];
  }
  updatePixels();
  if( debug ) { println( frameCount + " pixels drawn at " + (millis()-st) ); }
  
  PE.waitForBlockThreadsToFinish();
  if( debug ) { println( frameCount + " pixel threads done at " + (millis()-st) ); }
  
  if( frameCount%60 == 0 ) {
    println( frameCount , frameRate );
  }
  if( debug ) { println( frameCount + " frame over at " + (millis()-st) ); }
  if( debug ) { println( "_________________________" ); }
}