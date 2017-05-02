float x, y;
float len1 = 175;
float len2 = 150;
float angle1 = PI / 4;
float angle2 = PI/2;

void segment(float x, float y, float length, float a) {
	translate(x, y);
	rotate(a);
	line(0, 0, length, 0);
}

void setup() {
	size(500, 500);
	background(0);
	stroke(255, 160);

	x = width * 0.5;
	y = height;
}

void draw() {
	background(0);
	float mx = mouseX - x;
	float my = y - mouseY;
	float d = mag(mx, my);
	float targetAngle1 = atan2(my, mx) + acos((pow(len1, 2) + d*d - pow(len2, 2)) / (2 * len1 * d));
	float targetAngle2 = acos((pow(len1, 2) - d*d + pow(len2, 2)) / (2 * len1 * len2));
	if(Float.isNaN(targetAngle1)) {
		targetAngle1 = PI;
	}
	if(Float.isNaN(targetAngle2)) {
		targetAngle2 = 0;
	}

	angle1 = lerp(angle1, constrain(targetAngle1, PI / 18, PI * 2 / 3), 0.2);
	angle2 = lerp(angle2, constrain(targetAngle2, PI / 18, PI * 17 / 18), 0.2);

	pushMatrix();
	strokeWeight(20);
	segment(x, y, len1, -angle1);
	strokeWeight(15);
	segment(len1, 0, len2, PI - angle2);
	popMatrix();
}