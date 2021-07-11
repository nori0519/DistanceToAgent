/*
 this agent can move with user's face
 and face to the use's face.
 It also has the act of spacing
 and when press the k key then the agent become big
 so the user can feel that the agent is closing to the user.
 Now aimming to let user feel there is a space in the wall,
 the virture agent was put in a room image. 
 */
import hypermedia.net.*;
UDP udp;
float easing = 0.01;
float pastLeftRight=0f;
float pastUpDown=0f;
float horizontalRadian; //horizontal axis (ear to ear)
float verticalRadian; //vertical axis (up through head)
float[] moveRadians_horizontal = new float[60];
float[] moveRadians_vertical = new float[60];
float x = 0.0; //position of agent's x
float y = 0.0; //position of agent's y
int i = 0;//counter for zoom in
/////////////////////////
int j=100;//counter for zoom out

int z = 0;
int pastI=0;//past of counter for zoom in

int pastJ=100;//past of counter for zoom out

int value = 0; //initial value of zoom in, for judging when to zoom in

int value_o=100; //initial value of zoom out,for judging when to zoom out

int odd=0;//counter of either "zoom in" or "zoom out" 
////////////////////////
head theHead;
body theBody;
arm theArm;
leg theLeg;
void setup() {
  frameRate(60);
  udp = new UDP( this, 29129 );
  udp.listen( true );
  size(1300, 760, P3D);  //fit on my display.
  smooth();
  theHead = new head();
  theBody = new body();
  theArm = new arm();
  theLeg = new leg();
}
void draw() {
  background(144);
  textSize(30);
  fill(0, 0, 0);
  text('1', 450, 300);
  text('2', 850, 300);
  text('3', 450, 600);
  text('4', 850, 600);
  line(1300/2,760/2,mouseX,mouseY);
  fill(0);
  text("("+mouseX+","+mouseY+")",mouseX+10,mouseY);
  noFill();
  //wall line
  line(0, 760, 333, 150);
  line(333, 0, 333, 150);
  line(333, 150, 967, 150);
  line(1300, 760, 967, 150);
  line(967, 0, 967, 150);
  //put the origin on the middle of the canvas
  translate(width/2, height/2, 0);
  //put the data of user's face into arrays
  moveRadians_horizontal[40] = horizontalRadian;
  moveRadians_vertical[40] =  verticalRadian;
  for (int i = 0; i <= 40; i++) {
    moveRadians_vertical[i] = moveRadians_vertical[i+1];
    moveRadians_horizontal[i] = moveRadians_horizontal[i+1];
  }
  //tan(angle)
  x = x + ((450*tan((PI/180)*moveRadians_horizontal[0]))-x) * easing;
  y = y + ((350*tan((PI/180)*moveRadians_vertical[0]))-y) * easing;
  //It's about the direction of face
  float leftRight;
  float upDown;
  if(IsOverUserHorizon()){
  leftRight=pastLeftRight;
  upDown=pastUpDown;
  value=0;
  println("Stop");
  }
  else{
  leftRight = ((PI/180)*moveRadians_horizontal[0]);
  upDown = ((PI/180)*moveRadians_vertical[0]);
  }
  rotateX(-upDown);//control up and down
  rotateY(leftRight);//control left and right
  pastLeftRight=leftRight;
  pastUpDown=upDown;
  //if value equal 0, won't move,
  //And it will make agent zoom in if value changed.
  if (value == 0 || value_o == 0){ 
    if(odd %2 == 0)
      translate(-x, -y, pastI);
    if(odd %2 != 0)
      translate(-x,-y,pastJ);
  } else {
    if ( horizontalRadian<15 && horizontalRadian>-15) {
      /////////////////////////////////////
        value = i;//counter for zoom in
        value_o= j;//counter for zoom out 
    }
    if(odd % 2 ==0){
      translate(-x, -y, value);
      //when value is less than 100,zoom in. so,parameter of both i and pastI use.
      i += 1;
      pastI=i;
      println("value:"+value);//for debug
      if(value==100){
        //reinstall value,i and pastI. 
        value=1;
        i=1;
        pastI=1;
        odd+=1;//switch to zoom out
        println("odd"+odd);//for debug
      }
    }
    if(odd % 2 != 0){
      translate(-x,-y,value_o);
      //when value is more than 100,zoom out. so,parameter of both j and pastJ use.
      j -= 1;
      pastJ=j;
      println("value_o:"+value_o);//for debug
      println("j:"+j);//for debug
      if(value_o == 1){
        //reinstall value_o,j and pastJ
        value_o=100;
        j=100;
        pastJ=100;
        odd+=1;//switch to zoom in
        println("odd"+odd);//for debug
      }
    }
    ///////////////////////////////
  }
  lights();
  //shininess(10.0);
  theHead.agent_head();
  translate(0, 0, 98);
  theHead.agent_eyeSocket();
  theHead.agent_eyeShine();
  theHead.agent_check();
  theHead.agent_mouth();
  translate(0, 100, -98);
  theBody.agent_body();
  translate(0, 40, 10);
  theArm.agent_arm();
  translate(0, 0, 0);
  theLeg.agent_left_spacing();
  theLeg.agent_right_spacing();
}
//to move or to stop 
void keyPressed() {
  if (key=='a'||key=='A') {
    //if press A or a it will make agent zoom in
    if(odd % 2 == 0){
      if (value == 0) {
        value=1;
      } else {
        value = 0;
      }
    }
    //if press A or a it will make agent zoom out
    if(odd % 2 !=0){
      if(value_o == 0 ){
        value_o=1;
      }else{
        value_o=0;
      }
    }
  }
}
boolean IsOverUserHorizon(){
  float max=10f;
 return max< horizontalRadian|| horizontalRadian<-max;
}
class head {
  float i = 0.0;
  void agent_head() {
    noStroke();
    fill(255, 255, 0);
    sphere(100);//randians 100
  }
  void agent_eyeSocket() {
    fill(0);
    ellipse(-31, 0, 26, 26);
    ellipse(31, 0, 26, 26);
  }
  void agent_eyeShine() {
    fill(255);
    ellipse(-33, 5, 6, 6);
    ellipse(33, 5, 6, 6);
  }
  void agent_check() {
    fill(252, 98, 93);
    ellipse(-45, 20, 28, 13);
    ellipse(45, 20, 28, 13);
  }
  void agent_mouth() {
    rect(-20,30,40,15);
    fill(220, 0, 0);
  }
}
class body {
  void agent_body() {
    fill(255, 230, 0);
    //box(w, h, d)
    box(100, 120, 80);
  }
}
class arm {
  void agent_arm() {
    stroke(0);
    strokeWeight(10);
    noFill();
    arc(0, 0, 145, 125, PI+QUARTER_PI, TWO_PI);
    arc(0, 0, 145, 125, PI, PI+QUARTER_PI);
  }
}
class leg {
  int i = 0;//control the speed of left leg spacing
  int j = 0;//control the speed of right leg spacing
  void agent_leg() {
    stroke(0);
    strokeWeight(10);
    line(-30, 0, -30, 85);
    line(30, 0, 30, 85);
  }
  void agent_left_spacing() {
    stroke(0);
    strokeWeight(10);
    if (i%100<=40) {
      line(-30, 0, -30, 85);
    } else {
      line(-30, 0, -30, 110);
    }
    i++;
  }
  void agent_right_spacing() {
    stroke(0);
    strokeWeight(10);
    if (j%100<=40) {
      line(30, 0, 30, 110);
    } else {
      line(30, 0, 30, 85);
    }
    j++;
  }
}
void receive( byte[] data) {
  //get data from faceAPI
  String message = new String(data);
  String[] message2 = splitTokens(message,"");
  println(message2);
  //get the vertival radian
  verticalRadian = Float.parseFloat(message2[3]);
  //get the horizontal radian
  horizontalRadian = Float.parseFloat(message2[4]);
}
