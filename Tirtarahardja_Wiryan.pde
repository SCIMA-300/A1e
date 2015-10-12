//variables for entries
//changing the values of variables will change the piechart

//all the data entries
//a=family, b=friends, c=acquantances, d=anonynamous
int[] fam = {1};
int[] fri = {2,10,9,1,1,2};
int[] acq = {1,1,1};
int[] ano = {4,10,1};

int angles[];

// number of contacts will affect catagory entry
//int fam = a0; //total family
//int fri = b0+b1+b2+b3+b4+b5; //total friends
//int acq = c0+c1+c2; //total acquaintances 
//int ano = d0+d1+d2; //total anonynamous
//int total = fam+fri+acq+ano;


//unmapped radius for catagory circle
int rad1fam = fam;
int rad1fri = fam + fri;
int rad1acq = fam + fri + acq;
int rad1ano = fam + fri + acq + ano;
//mapped radius for catagory circles
float rad2fam = map(rad1fam,1,total,100,1400);
float rad2fri = map(rad1fri,1,total,100,1400);
float rad2acq = map(rad1acq,1,total,100,1400);
float rad2ano = map(rad1ano,1,total,100,1400);

void setup(){
  size(800,800);
}

//testblock for circle w/o piechart
void draw(){
  //the idea is that the max circle size stays the same
  //regardless of entry size, and the divisions would change

  ellipse(0,800,rad2ano,rad2ano);
  ellipse(0,800,rad2acq,rad2acq);
  ellipse(0,800,rad2fri,rad2fri);
  ellipse(0,800,rad2fam,rad2fam);
}

void pieChart(float diameter, int[] data) {
  float lastAngle = 0;
  for (int i = 0; i < data.length; i++) {
    float gray = map(i, 0, data.length, 0, 255);
    fill(gray);
    arc(0, 800, diameter, diameter, lastAngle, lastAngle+(angles[i]));
    lastAngle += radians(angles[i]);
  }
}
