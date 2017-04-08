final int s = 500;
boolean lActive = false;
int lightRadius = s / 16;

PVector mouseShift = new PVector();

final int maxSensorRadius = s * 3 / 8;
float[] sAngles = {PI / -4, PI / 4, PI, PI / 2, PI / -2};
PVector[] sVectors = new PVector[5];
PVector[] sLocations = new PVector[5];
PVector direction = new PVector();

final int thresholdRadius = s / 8;

void drawVectors() {
	stroke(255);
	for(int i = 0; i < sVectors.length; i++) {
		line(0, 0, sVectors[i].x, sVectors[i].y);
	}
	noStroke();
	fill(255);
	for(int i = 0; i < sVectors.length; i++) {
		ellipse(sLocations[i].x, sLocations[i].y, 4, 4);
	}
	stroke(0, 255, 0);
	if(direction.mag() < thresholdRadius) {
		stroke(255, 0, 0);
	}
	line(0, 0, direction.x, direction.y);
}

void calculateSensorValues() {
	direction.setMag(0);
	float dist = max(0, min(1, (maxSensorRadius - mouseShift.mag()) / maxSensorRadius));
	for(int i = 0; i < sVectors.length; i++) {
		float angle = cos(PVector.angleBetween(mouseShift, sVectors[i]));
		float mag = maxSensorRadius;
		if(sLocations[i].dist(mouseShift) > lightRadius) {
			mag = max(0.001, min(1, angle * dist) * maxSensorRadius);
		}

		sVectors[i].setMag(lerp(sVectors[i].mag(), mag, 0.1));
		direction.add(sVectors[i]);
	}
}

void setup() {
	surface.setSize(s, s);
	strokeWeight(2);

	for(int i = 0; i < sVectors.length; i++) {
		sVectors[i] = PVector.fromAngle(sAngles[i] - PI / 2);
		sLocations[i] = sVectors[i].copy().setMag(s / 24);
	}
}

void keyTyped() {
	int k = int(key);
	if(k == 32) {
		lActive = !lActive;
	}
}

void draw() {
	background(0);
	stroke(255, 128);
	noFill();
	pushMatrix();
	mouseShift.x = mouseX - s / 2;
	mouseShift.y = mouseY - s / 2;
	translate(s / 2, s / 2);
	ellipse(0, 0, thresholdRadius * 2, thresholdRadius * 2);
	ellipse(0, 0, maxSensorRadius * 2, maxSensorRadius * 2);

	if(lActive) {
		fill(255, 64);
		ellipse(mouseShift.x, mouseShift.y, lightRadius * 2, lightRadius * 2);

		calculateSensorValues();
	}
	else {
		direction.setMag(lerp(direction.mag(), 0, 0.1));
		for(int i = 0; i < sVectors.length; i++) {
			sVectors[i].setMag(lerp(sVectors[i].mag(), 0.001, 0.1));
		}
	}
	drawVectors();
	noStroke();
	fill(255);
	ellipse(0, 0, 4, 4);
	popMatrix();
}