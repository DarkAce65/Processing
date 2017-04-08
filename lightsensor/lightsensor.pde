final int s = 500;
final int maxLightRadius = s / 5;
float lightRadius = 0;

PVector mouseShift = new PVector();

final int maxSensorRadius = s * 3 / 8;
PVector[] sVectors = new PVector[5];
PVector direction = new PVector();

final int thresholdRadius = s / 12;

void drawSensors() {
	stroke(0, 0, 255);
	for(int i = 0; i < sVectors.length; i++) {
		line(0, 0, sVectors[i].x, sVectors[i].y);
	}
	stroke(0, 255, 0);
	line(0, 0, direction.x, direction.y);
	noStroke();
	fill(255);
	ellipse(0, 0, 4, 4);
}

void calculateSensorValues() {
	direction.setMag(0);
	float dist = max(0, min(1, (maxSensorRadius - mouseShift.mag()) / maxSensorRadius));
	for(int i = 0; i < sVectors.length; i++) {
		float angle = cos(PVector.angleBetween(mouseShift, sVectors[i]));
		float mag = max(0.001, angle * dist * maxSensorRadius);

		sVectors[i].setMag(lerp(sVectors[i].mag(), mag, 0.1));
		direction.add(sVectors[i]);
	}
}

void setup() {
	surface.setSize(s, s);

	for(int i = 0; i < sVectors.length; i++) {
		float[] d = {PI / -4, PI / 4, PI, PI / 2, PI / -2};
		sVectors[i] = PVector.fromAngle(d[i] - PI / 2);
	}
}

void draw() {
	background(0);
	stroke(255, 0, 0);
	noFill();
	pushMatrix();
	mouseShift.x = mouseX - s / 2;
	mouseShift.y = mouseY - s / 2;
	translate(s / 2, s / 2);
	ellipse(0, 0, thresholdRadius * 2, thresholdRadius * 2);
	ellipse(0, 0, maxSensorRadius * 2, maxSensorRadius * 2);

	if(mousePressed) {
		stroke(255, 255 * (1 - lightRadius));
		ellipse(mouseShift.x, mouseShift.y, maxLightRadius * lightRadius, maxLightRadius * lightRadius);
		lightRadius += 0.01;
		lightRadius %= 1;
	}
	else {
		lightRadius = 0;
	}
	calculateSensorValues();
	drawSensors();
	popMatrix();
}