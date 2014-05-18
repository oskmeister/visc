import oscP5.*;
import netP5.*;


// The next line is needed if running in JavaScript Mode with Processing.js
/* @pjs preload="moon.jpg"; */

import processing.video.*;
import java.io.FileOutputStream;

Capture video;

int DELTA = 5;

float[][] kernel = {{-1, -1, -1},
                    {-1, 9, -1},
                    {-1, -1, -1}};

float[][] blurkernel = {{ 1,  1,  1},
                        { 1,  1,  1},
                        { 1,  1,  1}};


int prevResult[];

long lastWrite = 0;

OscP5 oscP5;
/* a NetAddress contains the ip address and port number of a remote location in the network. */
NetAddress myBroadcastLocation;

int rc2cell(int r, int c, PImage img) {
   return img.width * r + c; 
}

void setup() { 
  //img = loadImage("/Users/osk/fun/midihack/skyline.jpg");// Load the original image
  size(640, 480);
  //noLoop();
  
  /* create a new instance of oscP5. 
   * 12000 is the port number you are listening for incoming osc messages.
   */
  oscP5 = new OscP5(this,12000);
  /* the address of the osc broadcast server */
  myBroadcastLocation = new NetAddress("127.0.0.1", 5400);
  
  // Uses the default video input, see the reference if this causes an error
  video = new Capture(this, width, height);
  video.start();  
    
  prevResult = new int[video.width];
}

int findMinPath(int[][] dp, PImage img, int row, int col) {
  if (row < DELTA || row >= img.height - DELTA) return (int)1e9;
  if (col == img.width) return 0;
  
  if (dp[row][col] != -1) return dp[row][col];
  
  int best = Integer.MAX_VALUE;
  int valueHere = int(brightness(img.pixels[row * img.width + col]));
  
  for (int d = -DELTA; d <= DELTA; ++d) {
    best = min(best, d*d + findMinPath(dp, img, row+d, col+1));
  }
  
  dp[row][col] = valueHere + best;
  return valueHere + best;
}

PImage applyKernel(PImage input, float[][] kernel) {
  int KERNEL_SIZE_X = (kernel[0].length - 1)/2;
  int KERNEL_SIZE_Y = (kernel.length -1)/2;
  
  PImage newImage = createImage(input.width, input.height, RGB);
  newImage.loadPixels();
  input.loadPixels();
  // Loop through every pixel in the image.
  for (int y = KERNEL_SIZE_Y; y < input.height-KERNEL_SIZE_Y; y++) { // Skip top and bottom edges
    for (int x = KERNEL_SIZE_X; x < input.width-KERNEL_SIZE_X; x++) { // Skip left and right edges
      float[] sum = new float[3]; // Kernel sum for this pixel
      for (int ky = -KERNEL_SIZE_Y; ky <= KERNEL_SIZE_Y; ky++) {
        for (int kx = -KERNEL_SIZE_X; kx <= KERNEL_SIZE_X; kx++) {
          // Calculate the adjacent pixel for this kernel point
          int pos = (y + ky)*input.width + (x+kx);
          // Image is not grayscale, red/green/blue may not be identical
          sum[0] += kernel[ky+KERNEL_SIZE_Y][kx+KERNEL_SIZE_X] * red(input.pixels[pos]);
          sum[1] += kernel[ky+KERNEL_SIZE_Y][kx+KERNEL_SIZE_X] * green(input.pixels[pos]);
          sum[2] += kernel[ky+KERNEL_SIZE_Y][kx+KERNEL_SIZE_X] * blue(input.pixels[pos]);
          
//          // Multiply adjacent pixels based on the kernel values
//          sum += val;
        }
      }
      // For this pixel in the new image, set the gray value
      // based on the sum from the kernel
      int ksize = (KERNEL_SIZE_Y*2+1)*(KERNEL_SIZE_X*2+1);
      newImage.pixels[y*video.width + x] = color(sum[0]/ksize, sum[1]/ksize, sum[2]/ksize);
    }
  }
  
  newImage.updatePixels();
  return newImage;
}

PImage applyKernel2(PImage input, float[][] kernel) {
  int KERNEL_SIZE_X = (kernel[0].length - 1)/2;
  int KERNEL_SIZE_Y = (kernel.length -1)/2;
  
  PImage newImage = createImage(input.width, input.height, RGB);
  newImage.loadPixels();
  input.loadPixels();
  // Loop through every pixel in the image.
  for (int y = KERNEL_SIZE_Y; y < input.height-KERNEL_SIZE_Y; y++) { // Skip top and bottom edges
    for (int x = KERNEL_SIZE_X; x < input.width-KERNEL_SIZE_X; x++) { // Skip left and right edges
      float sum = 0; // Kernel sum for this pixel
      for (int ky = -KERNEL_SIZE_Y; ky <= KERNEL_SIZE_Y; ky++) {
        for (int kx = -KERNEL_SIZE_X; kx <= KERNEL_SIZE_X; kx++) {
          // Calculate the adjacent pixel for this kernel point
          int pos = (y + ky)*input.width + (x+kx);
          // Image is not grayscale, red/green/blue may not be identical
          float val = red(input.pixels[pos]) * green(input.pixels[pos]) * blue(input.pixels[pos]);
          
          // Multiply adjacent pixels based on the kernel values
          sum += kernel[ky+KERNEL_SIZE_Y][kx+KERNEL_SIZE_X] * val;
        }
      }
      // For this pixel in the new image, set the gray value
      // based on the sum from the kernel
      newImage.pixels[y*video.width + x] = color(sum);
    }
  }
  
  newImage.updatePixels();
  return newImage;
}

void treshold(PImage image, int t) {
  image.loadPixels();
  for (int i=0; i<image.pixels.length; i++) {
    image.pixels[i] = color(brightness(image.pixels[i]));
  }
  
  image.updatePixels();
}

void draw() {
  
  if (!video.available())
    return;
  
  video.read();
  
//  image(video, 0, 0, width/2, height);
  PImage blurred = applyKernel(video, blurkernel);
//  image(blurred, width/2, 0, width/2, height);
  
  // Create an opaque image of the same size as the original
  PImage edgeImg = applyKernel2(blurred, kernel);
  treshold(edgeImg, 127);
  
  image(edgeImg, 0, 0);
  
  int[][] dp = new int[edgeImg.height][edgeImg.width];

  for (int i = 0; i < edgeImg.height; ++i) {
    for (int j = 0; j < edgeImg.width; ++j) {
        dp[i][j] = -1;
    }
  }
  
  
  int minValue = Integer.MAX_VALUE;
  int index = -1;
  // For each row, calculate the optimal path from the beginning of that row.
  for (int i = 0; i < edgeImg.height-2; ++i) {
    int thisValue = findMinPath(dp, edgeImg, i, 0);
    if (thisValue < minValue) {
      minValue = thisValue;
      index = i; 
    }
  }
  
  System.out.println("best path from height " + index + " is " + findMinPath(dp, edgeImg, index, 0));
  
  // Backtracking to find the wave.
  int currentRow = index;
  
  stroke(0, 0, 255);
  strokeWeight(4);
  
  byte[] result = new byte[edgeImg.width];
  
  for (int i = 0; i < edgeImg.width-1; ++i) {
    int currentCell = rc2cell(currentRow, i, video);
      
    int matchingRow = -1;
    for (int d = -DELTA; d <= DELTA; ++d) {
      if (currentRow + d >= 0 && currentRow + d < edgeImg.height && 
            dp[currentRow][i] == d*d + ((int)brightness(edgeImg.pixels[currentCell])) + dp[currentRow+d][i+1]) {
        matchingRow = currentRow + d;
        break;
      }
    }
    if (matchingRow == -1) {
      System.out.println("ERRORZ");
      return; 
    }
    currentRow = matchingRow;
    
    int rowBetween = int(prevResult[i] + (currentRow - prevResult[i]) / 4.0);
    point(i, rowBetween);
    result[i] = (byte)map(rowBetween, 0, edgeImg.height, 0, 256);
    prevResult[i] = rowBetween;
  }
  
  stroke(0, 255, 0);
  line(0, height/2, 40, height/2);
  line(width, height/2, width-40, height/2);
  
  try {
//    if (millis() - 250 > lastWrite) {
      lastWrite = millis();
      
      /* create a new OscMessage with an address pattern, in this case /test. */
      OscMessage myOscMessage = new OscMessage("/buff");
      
      myOscMessage.add(result);
      
      /* send the OscMessage to a remote location specified in myNetAddress */
      oscP5.send(myOscMessage, myBroadcastLocation);
//    }
  } catch (Throwable e) {
    e.printStackTrace();
  }

}

