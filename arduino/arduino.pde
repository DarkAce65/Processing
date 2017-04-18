import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

void setup() {
	surface.setSize(250, 100);
	arduino = new Arduino(this, Arduino.list()[1], 57600);
}

void draw() {
	background(0);
	stroke(255);

	for(int i = 1; i <= 3; i++) {
		int r = arduino.analogRead(i);
		text(r, 0, 20 * i);
	}
}
