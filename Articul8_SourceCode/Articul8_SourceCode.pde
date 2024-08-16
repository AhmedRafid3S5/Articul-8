import processing.serial.*;

import net.java.games.input.*;
import org.gamecontrolplus.*;
import org.gamecontrolplus.gui.*;

import cc.arduino.*;
import org.firmata.*;

ControlDevice ctrl;
ControlIO control;

Arduino arduino;
//Defining Button Variables
boolean X;
boolean circle;
boolean triangle;
boolean box;
boolean L1;
//Defining Stick Variables
float thumbval1;
float thumbval2;
float thumbval3;
float thumbval4;
float thumbval5;


void setup()
{
  size(500,500);
  
  control = ControlIO.getInstance(this);
  ctrl = control.getMatchedDevice("ALL_V1");
  
  if(ctrl == null)
{
 println("Couldn't Fetch Control File");
 System.exit(-1);
}

//println(Arduino.list());
arduino = new Arduino(this,Arduino.list()[0],57600);
//set pins with PWM as outputs
arduino.pinMode(6,Arduino.SERVO);
arduino.pinMode(9,Arduino.SERVO);
arduino.pinMode(10,Arduino.SERVO);
arduino.pinMode(11,Arduino.SERVO);
arduino.pinMode(3,Arduino.SERVO);

}

public void getUserInput(){
  
 //Get input data from controller and assign to variables.
 //Button data (Either True or False)
 X = ctrl.getButton("X").pressed();
 circle = ctrl.getButton("Circle").pressed();
 box = ctrl.getButton("Box").pressed();
 L1 = ctrl.getButton("L1").pressed();
 triangle =ctrl.getButton("Triangle").pressed();
 //Stick data (Ranging from -1 to +1)
 thumbval1 = map(ctrl.getSlider("S1").getValue(),-1,1,0,180);
 thumbval2 = map(ctrl.getSlider("S4").getValue(),-1,1,0,180);
 thumbval3 = map(ctrl.getSlider("S3").getValue(),-1,1,0,180);
 thumbval4 = map(ctrl.getSlider("S5").getValue(),-1,1,30,150); // Gripper Servo must not go beyond 30 or 150 .Rotation restricted due to geometry 
 thumbval5 = map(ctrl.getSlider("S2").getValue(),-1,1,0,180);
  
 //Print Input data (this instance)
 print(X);
 print(thumbval1);
 print(" ");
 print(circle);
 print(thumbval2);
 print(" ");
 print(box);
 println(thumbval3);
 print(L1);
 print(thumbval4);
 print(" ");
 print(triangle);
 print(thumbval5);
 println(" ");
 
}

void draw()  // Same as void loop()
{
getUserInput(); // Calls the user defined function and gets new data every loop cycle

// Pitch Servo Control (Doesn't require passive hold signal)
if(X == true) 
{
 arduino.servoWrite(6,(int)thumbval1);
 background(thumbval1,thumbval2,thumbval3);
}
//-----------------------------------------------------------------------------------
// Up/Down Servo (Requires passive hold due to stick drift)
if(circle == true)
{
 arduino.servoWrite(10,(int)thumbval2);
 background(thumbval1,thumbval2,thumbval3);
}
else if(circle == false)
{
arduino.servoWrite(10,90); // Holds Cont. Servo at current position
}
//------------------------------------------------------------------------------------
// Forward/Backward Servo (Non Cont. Servo, Doesn't require passive hold signal)
if(box == true)
{
 arduino.servoWrite(11,(int)thumbval3);
 background(thumbval1,thumbval2,thumbval3);
}
//-------------------------------------------------------------------------------------
// Gripper Servo (Doesn't need Passive hold signal)
if(L1 == true){
arduino.servoWrite(3,(int)thumbval4);
}
//--------------------------------------------------------------------------------------
// Arm Rotation Servo (Cont. Servo, Requires passive hold signal )
if(triangle == true)
{
 arduino.servoWrite(9,(int)thumbval5);
 background(thumbval1,thumbval2,thumbval3);
}
else if(triangle == false)
{
arduino.servoWrite(9,90);
}
//--------------------------------------------------------------------------------------
}
