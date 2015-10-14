// Draw the data as a series of points.
void drawDataPoints(int col) {
  int rowCount = data.getRowCount();
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      float value = data.getFloat(row, col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      point(x, y);
    }
  }
}

void drawDataLine(int col) {
  beginShape();
  int rowCount = data.getRowCount();
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      float value = data.getFloat(row, col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      vertex(x, y);
    }
  }
  endShape();
}


void keyPressed() { 
  if (key == '[') {
    currentColumn--;
    if (currentColumn < 0) {
      currentColumn = columnCount - 1;
    }
  } else if (key == ']') {
    currentColumn++;
    if (currentColumn == columnCount) {
      currentColumn = 0;
    }
  }
}

void drawYearLabels() { 
  fill(0);
  textSize(10);
  textAlign(CENTER, TOP);

  // Use thin, gray lines to draw the grid.
  stroke(255);
  strokeWeight(1);

  for (int row = 0; row < rowCount; row++) {
    if (years[row] % yearInterval == 0) {
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      text(years[row], x, plotY2 + 10);
      line(x, plotY1, x, plotY2);
    }
  }
}


void drawTitle() { 
  fill(0);
  textSize(20);
  textFont(plotFont);
  textAlign(LEFT, BASELINE);
  String title = data.getColumnName(currentColumn);
  text(title, plotX1, plotY1 - 10);
}


void drawVolumeLabels() { 
  fill(0);
  textSize(10);
  textAlign(RIGHT, CENTER);
  stroke(128);
  strokeWeight(1);

  for (float v = dataMin+5; v <= dataMax; v += volumeIntervalMinor) {
    if (v % volumeIntervalMinor == 0) { // If a tick mark
      float y = map(v, dataMin, dataMax, plotY2, plotY1);
      if (v % volumeInterval == 0) { // If a major tick mark
        if (v == dataMin) {
          textAlign(RIGHT); // Align by the bottom
        } else if (v == dataMax) {
          textAlign(RIGHT, TOP); // Align by the top
        } else {
          textAlign(RIGHT, CENTER); // Center vertically
        }
        text(floor(v), plotX1 - 10, y);
        line(plotX1 - 4, y, plotX1, y); // Draw major tick
      } else {
        //uncomment for small tick marks
        //line(plotX1 - 2, y, plotX1, y); // Draw minor tick
      }
    }
  }
}


void drawAxisLabels() { 
  fill(0);
  textSize(16);
  textLeading(15);
  textAlign(CENTER, CENTER);
  textFont(labelFont);
  // Use \n (aka enter or linefeed) to break the text into separate lines.
  text("Gallons\nconsumed\nper capita", labelX, (plotY1+plotY2)/2-10);
  textAlign(CENTER);
  text("Year", (plotX1+plotX2)/2, labelY);
}

void drawDataHighlight(int col) {
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      float value = data.getFloat(row, col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      if (dist(mouseX, mouseY, x, y) < 3) {
        strokeWeight(15);
        point(x, y);
        fill(0);
        textSize(14);
        textAlign(CENTER);
        text(nf(value, 0, 2) + " (" + years[row] + ")", x, y-12);
      }
    }
  }
}


void drawDataCurve(int col) {
  beginShape( );
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      float value = data.getFloat(row, col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      curveVertex(x, y);
      // Double the curve points for the start and stop
      if ((row == 0) || (row == rowCount-1)) {
        curveVertex(x, y);
      }
    }
  }
  vertex(plotX2, plotY2);
  vertex(plotX1, plotY2);
  endShape( );
}


void drawDataBars(int col) {
  noStroke( );
  rectMode(CORNERS);
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      //float value = data.getFloat(row, col); //OLD - not animated
      float value = interpolators[row].value; // New - uses integrator
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2); 
      float y = map(value, dataMin, dataMax, plotY2, plotY1); 
      rect(x-barWidth/2, y, x+barWidth/2, plotY2);
    }
  }
}


void drawTitleTabs() { 
  rectMode(CORNERS); 
  noStroke( ); 
  textSize(20); 
  textAlign(LEFT);
  if (tabLeft == null) {
    tabLeft = new float[columnCount];
    tabRight = new float[columnCount];

    tabImageNormal = new PImage[columnCount];
    tabImageHighlight = new PImage[columnCount];
    for (int col = 0; col < columnCount; col++) {
      String title = data.getColumnName(col);
      tabImageNormal[col] = loadImage(title + "_unselected.png");
      tabImageHighlight[col] = loadImage(title + "_selected.png");
    }
  }


  tabBottom = plotY1;
  // Size based on the height of the tabs by checking the 
  // height of the first (all images are the same height) 
  tabTop = plotY1 - tabImageNormal[0].height;

  for (int col = 0; col < columnCount; col++) {
    String title = data.getColumnName(col);
    tabLeft[col] = (col > 0) ? tabLeft[col-1]+tabImageNormal[col-1].width : plotX1;
    float titleWidth = tabImageNormal[col].width;
    tabRight[col] = tabLeft[col] + titleWidth;


    PImage tabImage = (col == currentColumn) ?
      tabImageHighlight[col] : tabImageNormal[col];
    image(tabImage, tabLeft[col], tabTop);
  }
}



//MOUSE FUNCTION


void mousePressed() {
  if (mouseY > tabTop && mouseY < tabBottom) {
    for (int col = 0; col < columnCount; col++) {
      if (mouseX > tabLeft[col] && mouseX < tabRight[col]) {
        setCurrent(col);
      }
    }
  }
}


void setCurrent(int col) {
  currentColumn = col;
  for (int row = 0; row < rowCount; row++) {
    interpolators[row].target(data.getFloat(row, col));
  }
}