int w = 400;
int h = 200;
Node[][] lines = new Node[1][w / 4];

void setup() {
	stroke(255);
	surface.setSize(w, h);
	for(int i = 0; i < lines[0].length; i++) {
		lines[0][i] = new Node(i * w / lines[0].length, height / 2, 0.1);
	}
}

void draw() {
	background(30);
	lines[0][0].update();
	for(int i = 0; i < lines[0].length - 1; i++) {
		lines[0][i + 1].update();
		line(lines[0][i].location.x, lines[0][i].location.y, lines[0][i + 1].location.x, lines[0][i + 1].location.y);
	}
}

class Node {
	PVector location;
	PVector desiredLocation;
	float strength;

	Node(float dx, float dy, float strength) {
		this.desiredLocation = new PVector(dx, dy);
		this.location = PVector.random2D().mult(50).add(this.desiredLocation);
		this.strength = strength;
	}

	void update() {
		if(mousePressed) {
			PVector diff = new PVector(mouseX - location.x, mouseY - location.y);
			diff.mult(10 / diff.mag());
			this.location.sub(diff);
		}
		location.lerp(desiredLocation, strength);
	}
}
