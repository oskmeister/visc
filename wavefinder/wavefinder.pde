
// The next line is needed if running in JavaScript Mode with Processing.js
/* @pjs preload="moon.jpg"; */

import processing.video.*;

Capture video;

int DELTA = 10;

float[][] kernel = {{-1, -1, -1},
                    {-1,  9, -1},
                    {-1, -1, -1}};
int KERNEL_SIZE_X = (kernel[0].length - 1)/2;
int KERNEL_SIZE_Y = (kernel.length -1)/2;


int rc2cell(int r, int c, PImage img) {
   return img.width * r + c; 
}

void setup() { 
  //img = loadImage("/Users/osk/fun/midihack/skyline.jpg");// Load the original image
  size(640, 480);
  //noLoop();
  // Uses the default video input, see the reference if this causes an error
  video = new Capture(this, width, height);
  video.start();  
}

int findMinPath(int[][] dp, PImage img, int row, int col) {
  if (row < DELTA || row >= img.height - DELTA) return (int)1e9;
  if (col == img.width) return 0;
  
  if (dp[row][col] != -1) return dp[row][col];
  
  int best = Integer.MAX_VALUE;
  int valueHere = int(red(img.pixels[row * img.width + col]));
  
  for (int d = -DELTA; d <= DELTA; ++d) {
    best = min(best, d*d + findMinPath(dp, img, row+d, col+1));
  }
  
  dp[row][col] = valueHere + best;
  return valueHere + best;
}

void draw() {
  
  if (!video.available())
    return;
  
  video.read();
  image(video, 0, 0, width, height); // Draw the webcam video onto the screen
  video.loadPixels();
  // Create an opaque image of the same size as the original
  PImage edgeImg = createImage(video.width, video.height, RGB);
  // Loop through every pixel in the image.
  for (int y = KERNEL_SIZE_Y; y < video.height-KERNEL_SIZE_Y; y++) { // Skip top and bottom edges
    for (int x = KERNEL_SIZE_X; x < video.width-KERNEL_SIZE_X; x++) { // Skip left and right edges
      float sum = 0; // Kernel sum for this pixel
      for (int ky = -KERNEL_SIZE_Y; ky <= KERNEL_SIZE_Y; ky++) {
        for (int kx = -KERNEL_SIZE_X; kx <= KERNEL_SIZE_X; kx++) {
          // Calculate the adjacent pixel for this kernel point
          int pos = (y + ky)*video.width + (x+kx);
          // Image is not grayscale, red/green/blue may not be identical
          float val = red(video.pixels[pos]) * green(video.pixels[pos]) * blue(video.pixels[pos]);
          // Multiply adjacent pixels based on the kernel values
          sum += kernel[ky+KERNEL_SIZE_Y][kx+KERNEL_SIZE_X] * val;
        }
      }
      // For this pixel in the new image, set the gray value
      // based on the sum from the kernel
      edgeImg.pixels[y*video.width + x] = color(sum);
    }
  }
  // State that there are changes to edgeImg.pixels[]
  edgeImg.updatePixels();
  
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
  
  for (int i = 0; i < edgeImg.width-1; ++i) {
    int currentCell = rc2cell(currentRow, i, video);
      
    int matchingRow = -1;
    for (int d = -DELTA; d <= DELTA; ++d) {
      if (currentRow + d >= 0 && currentRow + d < edgeImg.height && 
            dp[currentRow][i] == d*d + ((int)red(edgeImg.pixels[currentCell])) + dp[currentRow+d][i+1]) {
        matchingRow = currentRow + d;
        break;
      }
    }
    if (matchingRow == -1) {
      System.out.println("ERRORZ");
      return; 
    }
    currentRow = matchingRow;
    System.out.println("row " + currentRow);
    point(i, currentRow);
  }
 
}

