int m = 0;
int s = 500;

float[] sensorDirections = {PI / -4, PI / 4, PI, PI / 2, PI * 3 / 2};
int[][] sensorLocations = new int[5][2];
float[] sensorValues = new float[5];

void drawSensors() {
	for(int i = 0; i < sensorDirections.length; i++) {
		int x = floor(sensorLocations[i][0] + sensorValues[i] * cos(sensorDirections[i]));
		int y = floor(sensorLocations[i][1] + sensorValues[i] * sin(sensorDirections[i]));
		line(sensorLocations[i][0], sensorLocations[i][1], x, y);
	}
}

void calculateSensorValues() {
	for(int i = 0; i < sensorDirections.length; i++) {
		float a = tan((mouseY - sensorLocations[i][1]) / (mouseY - sensorLocations[i][1]));
		if(abs(sensorDirections[i] - a) < PI / 4) {
			sensorValues[i] = dist(sensorLocations[i][0], sensorLocations[i][1], mouseX, mouseY);
		}
	}
}

void setup() {
	surface.setSize(s, s);

	for(int i = 0; i < sensorDirections.length; i++) {
		sensorDirections[i] += PI / 2;
		sensorLocations[i][0] = floor(s / 10 * cos(sensorDirections[i]) + s / 2);
		sensorLocations[i][1] = floor(s / 10 * sin(sensorDirections[i]) + s / 2);
	}
}

void draw() {
	background(0);
	stroke(255, 0, 0);
	noFill();
	ellipse(s / 2, s / 2, s / 5, s / 5);
	ellipse(s / 2, s / 2, s * 3 / 4, s * 3 / 4);

	if(mousePressed) {
		stroke(255, (s / 5 - m) * 5.0 / s * 255);
		ellipse(mouseX, mouseY, m, m);
		if(m < s / 5) {
			m += 3;
		}
		else {
			m = 0;
		}

		calculateSensorValues();
	}
	drawSensors();
}
