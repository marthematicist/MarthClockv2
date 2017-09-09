class PixelBlock implements Runnable {
  int numRenderedPixels;
  RenderedPixel[] RenderedPixels;
  float tf = 0;
  float th = 0;
  float ts = 0;
  float tb = 0;
  
  PixelBlock( ArrayList<RenderedPixel> RPin ) {
    this.numRenderedPixels = RPin.size();
    RenderedPixels = new RenderedPixel[numRenderedPixels];
    for( int i = 0 ; i < numRenderedPixels ; i++ ) {
      RenderedPixels[i] = RPin.get(i).copy();
    }
  }
  
  void run() {
    // update all pixels
    for( int i = 0 ; i < numRenderedPixels ; i++ ) {
      RenderedPixels[i].updateColor( tf , th , ts , tb );
    }
  }
  
  void setTimes( float tfIn , float thIn , float tsIn , float tbIn ) {
    tf = tfIn;  th = thIn;  ts = tsIn;  tb = tbIn;
  }
  
}