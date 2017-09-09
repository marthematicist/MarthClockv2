
PixelEngine PE;

void setup() {
  size( 800 , 480 );
  pg = createGraphics( width , height );
  halfWidth = width/2;
  halfHeight = height/2;
  xRes = float(width);
  yRes = float(height);
  
  PE = new PixelEngine(3);
}

void draw() {
  
  int[] pixelColors = PE.outputPixelData();
  PE.createNewThreads();
  PE.startThreads();
  
  loadPixels();
  for( int i = 0 ; i < width*height ; i++ ) {
    int r = 128;
    int g = 0;
    int b =255;
    int cv = ( 
      (255<<24) | 
      (round(constrain(r,0,255))<<16) | 
      (round(constrain(g,0,255))<<8) | 
      (round(constrain(b,0,255)) ) 
    );
    pixels[i] = pixelColors[i];
  }
  updatePixels();
  
  PE.waitForThreadsToFinish();
  println( frameCount );
  
}