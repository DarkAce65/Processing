final int s = 500;
final int maxLightRadius = s / 5;
float lightRadius = 0;

PVector mouseShift = new PVector();

PVector[] sVectors = new PVector[5];
PVector direction = new PVector();

void drawSensors() {
	stroke(0, 0, 255);
	for(int i = 0; i < sVectors.length; i++) {
		line(0, 0, sVectors[i].x, sVectors[i].y);
	}
	stroke(0, 255, 0);
	line(0, 0, direction.x, direction.y);
}

void calculateSensorValues() {
	direction.setMag(0);
	for(int i = 0; i < sVectors.length; i++) {
		float diff = PVector.angleBetween(mouseShift, sVectors[i]);
		float multiplier = 0;
		if(diff < PI) {
			multiplier = 1 - diff / PI;
		}
		float m = max(0.001, min(s * 3 / 8, mouseShift.mag() * multiplier));
		sVectors[i].setMag(lerp(sVectors[i].mag(), m, 0.1));
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
	ellipse(0, 0, s / 5, s / 5);
	ellipse(0, 0, s * 3 / 4, s * 3 / 4);

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