// Fluid Simulation
// Daniel Shiffman
// https://thecodingtrain.com/CodingChallenges/132-fluid-simulation.html
// https://youtu.be/alhpH6ECFvQ

// This would not be possible without:
// Real-Time Fluid Dynamics for Games by Jos Stam
// http://www.dgp.toronto.edu/people/stam/reality/Research/pdf/GDC03.pdf
// Fluid Simulation for Dummies by Mike Ash
// https://mikeash.com/pyblog/fluid-simulation-for-dummies.html

//Modified by Nekodigi
//curl noise implemented.
//The color was made with colorpy.

final int N = 256;
final int iter = 16;
final int SCALE = 2;
float t = 0;
PImage soapColor;

Fluid fluid;

void settings() {
  size(N*SCALE, N*SCALE);
}

void setup() {
  fluid = new Fluid(0.2, 0, 0);//0.0000001
  soapColor = loadImage("SoapColor.png");//load gradient image(made with colorpy)
  for (int i = 0; i < N; i++) {
      for (int j = 0; j < N; j++) {
        PVector noise = snoise(i/10.0, j/10.0).div(10000);
        fluid.addDensity(i, j, 30);
      }
  }
}

PVector snoise(float x, float y){
  //Find rate of change in X direction
  float n1 = noise(x + EPSILON, y);
  float n2 = noise(x - EPSILON, y); 

  //Average to find approximate derivative
  float a = (n1 - n2)/(2 * EPSILON);

  //Find rate of change in Y direction
  n1 = noise(x, y + EPSILON); 
  n2 = noise(x, y - EPSILON); 

  //Average to find approximate derivative
  float b = (n1 - n2)/(2 * EPSILON);

  return new PVector(b, -a);
}

//void mouseDragged() {
//}

void draw() {
  background(0);
  int cx = int(0.5*width/SCALE);
  int cy = int(0.5*height/SCALE);
  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      fluid.addDensity(cx+i, cy+j, random(50, 150));
      //fluid.addDensity(cx+i, cy+j, random(250, 350));
    }
  }
  for (int i = 0; i < 2; i++) {
    float angle = noise(t) * TWO_PI * 2;
    PVector v = PVector.fromAngle(angle);
    v.mult(0.2);
    t += 0.01;
    fluid.addVelocity(cx, cy, v.x, v.y );
  }
  
  for (int i = 0; i < 2; i++) {
    float angle = noise(t) * TWO_PI * 2;
    PVector v = PVector.fromAngle(angle);
    v.mult(0.2);
    t += 0.01;
    fluid.addVelocity(cx, cy, v.x, v.y );
  }
  
  //add curl noise to make more cimplex like soap surface
  for (int i = 0; i < N; i++) {
      for (int j = 0; j < N; j++) {
        PVector noise = snoise(i/10.0, j/10.0).div(10000);
        fluid.addVelocity(i, j, noise.x, noise.y );
      }
  }

  fluid.step();
  fluid.renderD();
  //fluid.renderV();
  //fluid.fadeD();
}
