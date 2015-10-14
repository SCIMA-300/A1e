FloatTable data;
float dataMin, dataMax;
float plotX1, plotY1;
float plotX2, plotY2;
float labelX, labelY;
int yearMin, yearMax;
int[] years;
int currentColumn = 0;
int columnCount;
PFont plotFont;
PFont labelFont;
PImage[] tabImageHighlight;
PImage[] tabImageNormal;
int yearInterval = 10;
int volumeInterval = 10;
int volumeIntervalMinor = 5;
int rowCount = 0;
float barWidth = 4;
float[] tabLeft, tabRight; // Add above setup() float tabTop, tabBottom;
float tabPad = 10;
float tabTop, tabBottom;
Integrator[] interpolators;

void setup() {
  size(720, 405);
  data = new FloatTable("milk-tea-coffee.tsv");
  columnCount = data.getColumnCount();
  rowCount = data.getRowCount();
  years = int(data.getRowNames()); 
  yearMin = years[0];
  yearMax = years[years.length - 1];
  dataMin = 0;
  dataMax = ceil(data.getTableMax()/volumeInterval) * volumeInterval;
  // Corners of the plotted time series
  plotX1 = 120;
  plotX2 = width - plotX1 * 2/3;
  plotY1 = 60;
  plotY2 = height - plotY1*7/6; 
  labelX = plotX1*5/12+2;
  labelY = height - plotY1*25/60;

  interpolators = new Integrator[rowCount];
  for (int row = 0; row < rowCount; row++) {
    float initialValue = data.getFloat(row, 0);
    interpolators[row] = new Integrator(initialValue);
    interpolators[row].attraction = 0.1; // Set lower than the default
  }



  plotFont = loadFont("BrandonText-Light-20.vlw");
  labelFont = loadFont("BrandonText-MediumItalic-16.vlw");
  textFont(plotFont, 20);


  smooth( );
}

void draw() { 
  background(255);
  // Show the plot area as a white box. fill(255);
  //rectMode(CORNERS);
  //noStroke( );
  //fill(255);
  //rect(plotX1, plotY1, plotX2, plotY2);

  drawTitle();
  drawVolumeLabels();

  strokeWeight(5);
  // Draw the data for the first column.
  fill(#5679C1);
  //drawDataCurve(currentColumn);
  //drawDataLine(currentColumn);
  stroke(#66FFFF);
  drawYearLabels();
  drawDataHighlight(currentColumn);
  drawAxisLabels( );
  fill(#5679C1);
  drawDataBars(currentColumn);
  drawTitleTabs();

  for (int row = 0; row < rowCount; row++) { 
    interpolators[row].update( );
  }
}