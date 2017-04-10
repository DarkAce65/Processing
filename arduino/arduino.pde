import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
int ledPin = 13;

void setup() {
	//println(Arduino.list());
	arduino = new Arduino(this, Arduino.list()[1], 57600);
}

void draw() {
	background(0);
	stroke(255);

	for(int i = 8; i <= 13; i++) {
		arduino.digitalWrite(i, arduino.HIGH);
		delay(100);
	}

	for(int i = 8; i <= 13; i++) {
		arduino.digitalWrite(i, arduino.LOW);
		delay(100);
	}
}
