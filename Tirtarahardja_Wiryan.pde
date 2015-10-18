//variables for entries
//changing the values of variables will change the piechart

//all the data entries
//a=family, b=friends, c=acquantances, d=anonynamous
int[] fam = {1};
int[] fri = {2,10,9,1,1,2};
int[] acq = {1,1,1};
int[] ano = {4,10,1};
//variable setup for catagory totals
int famtot=0;
int fritot=0;
int acqtot=0;
int anotot=0;
//array setup for pieChart array input
float[] degfam;
float[] degfri;
float[] degacq;
float[] degano;

void setup(){
  size(800,800);
  noLoop();
  noStroke();
  //declare var length for degree arrays
  float[] degfam = new float[fam.length];
  float[] degfri = new float[fri.length];
  float[] degacq = new float[acq.length];
  float[] degano = new float[ano.length];
}
void draw(){
  //value for CATAGORY total: xxxtot+=xxx[i]
  //convert ind.entry array into degree array
  //NullPointerErrors found in degxxx[i] map function
  for (int i=0; i<fam.length; i++){
    famtot+=fam[i];
    degfam[i] = map(fam[i],0,famtot,270,360);
  }
  for (int i=0; i<fri.length; i++){
    fritot+=fri[i];
    degfri[i] = map(fri[i],0,fritot,270,360);
  }
  for (int i=0; i<acq.length; i++){
    acqtot+=acq[i];
    degacq[i] = map(acq[i],1,acqtot,270,360);
  }
  for (int i=0; i<ano.length; i++){
    anotot+=ano[i];
    degano[i] = map(ano[i],1,anotot,270,360);
  }
  //radius calculations block
  int total = famtot+fritot+acqtot+anotot;
  int rad1fam = famtot;
  int rad1fri = famtot + fritot;
  int rad1acq = famtot + fritot + acqtot;
  int rad1ano = famtot + fritot + acqtot + anotot;
  //mapped radius for catagory circles
  float rad2fam = map(rad1fam,1,total,100,1400);
  float rad2fri = map(rad1fri,1,total,100,1400);
  float rad2acq = map(rad1acq,1,total,100,1400);
  float rad2ano = map(rad1ano,1,total,100,1400);
  
  fripieChart(rad2fri, degfri);
}
//friends-catagory pieChart
void fampieChart(float rad2fam, float[] data) {
  float lastAngle = 0;
  for (int i = 0; i < data.length; i++) {
    float gray = map(i, 0, data.length, 0, 255);
    fill(gray);
    arc(0, 800, rad2fam, rad2fam, lastAngle, lastAngle+radians(degfam[i]));
    lastAngle += radians(degfam[i]);
  }
}

//friends-catagory pieChart
void fripieChart(float rad2fri, float[] data) {
  float lastAngle = 0;
  for (int i = 0; i < data.length; i++) {
    float gray = map(i, 0, data.length, 0, 255);
    fill(gray);
    arc(0, 800, rad2fri, rad2fri, lastAngle, lastAngle+radians(degfri[i]));
    lastAngle += radians(degfri[i]);
  }
}

//friends-catagory pieChart
void acqpieChart(float rad2acq, float[] data) {
  float lastAngle = 0;
  for (int i = 0; i < data.length; i++) {
    float gray = map(i, 0, data.length, 0, 255);
    fill(gray);
    arc(0, 800, rad2acq, rad2acq, lastAngle, lastAngle+radians(degacq[i]));
    lastAngle += radians(degacq[i]);
  }
}

//friends-catagory pieChart
void anopieChart(float rad2ano, float[] data) {
  float lastAngle = 0;
  for (int i = 0; i < data.length; i++) {
    float gray = map(i, 0, data.length, 0, 255);
    fill(gray);
    arc(0, 800, rad2ano, rad2ano, lastAngle, lastAngle+radians(degano[i]));
    lastAngle += radians(degano[i]);
  }
}
