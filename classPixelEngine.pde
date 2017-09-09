

class PixelEngine {
  int numPixelBlocks;
  PixelBlock[] PixelBlocks;
  Thread[] BlockThreads;
  int numRenderedPixels;
  float tf = 0;
  float th = 0;
  float ts = 0;
  float tb = 0;
  
  PixelEngine( int numPixelBlocksIn ) {
    this.numPixelBlocks = numPixelBlocksIn;
    this.PixelBlocks = new PixelBlock[numPixelBlocks];
    this.BlockThreads = new Thread[numPixelBlocks];
    this.numRenderedPixels = 0;
    // create a temporary ArrayList of RenderedPixels
    ArrayList<RenderedPixel> PT = new ArrayList<RenderedPixel>();
    for( int x = 0 ; x < halfWidth ; x++ ) {
      for( int y = 0 ; y < halfHeight ; y++ ) {
        if( y <= x ) {
          PT.add( new RenderedPixel( x , y ) );
          numRenderedPixels++;
        }
      }
    }
    // portion out the temporary arraylist into smaller arraylists
    int numRenderedPixelsPerBlock = ceil( float(numRenderedPixels) / float(numPixelBlocks) );
    for( int i = 0 ; i < numPixelBlocks ; i++ ) {
      ArrayList<RenderedPixel> blockList = new ArrayList<RenderedPixel>();
      int startInd = i*numRenderedPixelsPerBlock;
      int endInd = (i+1)*numRenderedPixelsPerBlock;
      int numInd = endInd - startInd;
      if( endInd > numRenderedPixels ) { endInd = numRenderedPixels; }
      for( int j = 0 ; j < numInd ; j++ ) {
        blockList.add( PT.get( startInd + j ).copy() );
      }
      PixelBlocks[i] = new PixelBlock( blockList );
      
    }
  }
  
  int[] outputPixelData() {
    int[] out = new int[width*height];
    int[] temp = new int[width*height];
    for( int pb = 0 ; pb < numPixelBlocks ; pb++ ) {
      for( int rp = 0 ; rp < PixelBlocks[pb].numRenderedPixels ; rp++ ) {
        for( int i = 0 ; i < PixelBlocks[pb].RenderedPixels[rp].numChildPixels ; i++ ) {
          out[ PixelBlocks[pb].RenderedPixels[rp].iPixels[i] ] = PixelBlocks[pb].RenderedPixels[rp].colorValue;
          int ind = PixelBlocks[pb].RenderedPixels[rp].iPixels[i];
          temp[ind]++;
          int r = PixelBlocks[pb].RenderedPixels[rp].R;
          int g = PixelBlocks[pb].RenderedPixels[rp].G;
          int b = PixelBlocks[pb].RenderedPixels[rp].B;
          /*
          int cv = ( 
            (255<<24) | 
            (round(constrain(r,0,255))<<16) | 
            (round(constrain(g,0,255))<<8) | 
            (round(constrain(b,0,255)) ) 
          );
          println( out[ PixelBlocks[pb].RenderedPixels[rp].iPixels[i] ] );
          println( frameCount , r , g , b , cv ,  out[ PixelBlocks[pb].RenderedPixels[rp].iPixels[i] ] , PixelBlocks[pb].RenderedPixels[rp].iPixels[i] );
          */
        }
      }
    }
    return out;
  }
  
  void createNewThreads() {
    for( int i = 0 ; i < numPixelBlocks ; i++ ) {
      BlockThreads[i] = new Thread( PixelBlocks[i] ); 
    }
  }
  
  void startThreads() {
    tf += fSpeed*masterSpeed;
    th += hSpeed*masterSpeed;
    ts += sSpeed*masterSpeed;
    tb += bSpeed*masterSpeed; 
    for( int i = 0 ; i < numPixelBlocks ; i++ ) {
      PixelBlocks[i].setTimes( tf , th , ts , tb );
      BlockThreads[i].start(); 
    }
  }
  
  void waitForThreadsToFinish() {
    try {
      for( int i = 0 ; i < numPixelBlocks ; i++ ) {
        BlockThreads[i].join(); 
      }
    } catch(InterruptedException e) {
      return;
    }
  }
  
  
}