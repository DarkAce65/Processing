final int s = 500;
final float sensorThreshold = s / 12;
final float sensitivity = s / 18;
final int lightThreshold = s / 8;
boolean lActive = false;
int lightRadius = s / 16;

boolean showSensors = true;
final int maxSensorRadius = s * 3 / 8;
float[] sAngles = {PI / -6, PI / 6, PI, HALF_PI, -HALF_PI};
PVector[] sVectors = new PVector[5];
PVector[] sLocations = new PVector[5];
PVector direction = new PVector();

boolean showMotors = false;
PVector mPower = new PVector();

PVector mouseShift = new PVector();

void drawVectors() {
	if(showSensors) {
		stroke(255);
		for(int i = 0; i < sVectors.length; i++) {
			line(0, 0, sVectors[i].x, sVectors[i].y);
		}

		noStroke();
		fill(255);
		for(int i = 0; i < sLocations.length; i++) {
			ellipse(sLocations[i].x, sLocations[i].y, 4, 4);
		}
	}

	stroke(0, 255, 0);
	if(direction.mag() < lightThreshold) {
		stroke(255, 0, 0);
	}
	line(0, 0, direction.x, direction.y);

	if(showMotors) {
		stroke(0, 0, 255);
		strokeWeight(6);
		line(s / -12, 0, s / -12, mPower.x);
		line(s / 12, 0, s / 12, mPower.y);
	}
}

void calculateSensorValues() {
	direction.setMag(0);
	float dist = constrain((maxSensorRadius - mouseShift.mag()) / maxSensorRadius, 0, 1);
	for(int i = 0; i < sVectors.length; i++) {
		float angle = cos(PVector.angleBetween(mouseShift, sVectors[i]));
		float mag = maxSensorRadius;
		if(sLocations[i].dist(mouseShift) > lightRadius) {
			mag = max(0.001, min(1, angle * dist) * maxSensorRadius);
		}

		sVectors[i].setMag(lerp(sVectors[i].mag(), mag, 0.1));
		if(i < 2) {
			direction.add(sVectors[i].copy().mult(sqrt(3) / 3));
		}
		else {
			direction.add(sVectors[i]);
		}
	}
}

void calculateMotorPower() {
	float d = direction.mag();
	float h = (direction.heading() + PI * 5 / 2) % TAU;
	float l = 1;
	float r = 1;
	if(d < lightThreshold && sVectors[0].mag() > sensorThreshold) {
		l = 0;
		r = 0;
	}
	else if(d > sensitivity) {
		if(h > PI) {
			h = TAU - h;
			l -= h / HALF_PI;
		}
		else {
			r -= h / HALF_PI;
		}
	}

	mPower.x = lerp(mPower.x, l * -30, 0.1);
	mPower.y = lerp(mPower.y, r * -30, 0.1);
}

void setup() {
	surface.setSize(s, s);
	strokeCap(SQUARE);

	for(int i = 0; i < sVectors.length; i++) {
		sVectors[i] = PVector.fromAngle(sAngles[i] - HALF_PI);
		sLocations[i] = sVectors[i].copy().setMag(s / 24);
	}
}

void keyTyped() {
	int k = int(key);
	if(k == ' ') {
		lActive = !lActive;
	}
	else if(k == '1') {
		showSensors = !showSensors;
	}
	else if(k == '2') {
		showMotors = !showMotors;
	}
}

void draw() {
	strokeWeight(2);
	background(0);
	stroke(255, 128);
	noFill();
	pushMatrix();
	mouseShift.x = mouseX - s / 2;
	mouseShift.y = mouseY - s / 2;
	translate(s / 2, s / 2);
	ellipse(0, 0, lightThreshold * 2, lightThreshold * 2);
	ellipse(0, 0, maxSensorRadius * 2, maxSensorRadius * 2);

	if(lActive) {
		fill(255, 64);
		ellipse(mouseShift.x, mouseShift.y, lightRadius * 2, lightRadius * 2);

		calculateSensorValues();
		calculateMotorPower();
	}
	else {
		direction.setMag(lerp(direction.mag(), 0, 0.1));
		for(int i = 0; i < sVectors.length; i++) {
			sVectors[i].setMag(lerp(sVectors[i].mag(), 0.001, 0.1));
		}
		mPower.setMag(lerp(mPower.mag(), 0, 0.1));
	}
	drawVectors();
	noStroke();
	fill(255);
	ellipse(0, 0, 4, 4);
	popMatrix();
}