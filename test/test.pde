int w = 400;
int h = 200;
Node[][] lines = new Node[3][w / 4];

void setup() {
	stroke(255);
	surface.setSize(w, h);
	for(int l = 0; l < lines.length; l++) {
		for(int i = 0; i < lines[0].length; i++) {
			lines[l][i] = new Node(i * w / lines[l].length, height * (l + 1) / (lines.length + 1), 0.1);
		}
	}
}

void draw() {
	background(30);
	for(int l = 0; l < lines.length; l++) {
		lines[l][0].update();
		for(int i = 0; i < lines[0].length - 1; i++) {
			lines[l][i + 1].update();
			line(lines[l][i].location.x, lines[l][i].location.y, lines[l][i + 1].location.x, lines[l][i + 1].location.y);
		}
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
			diff.mult(4 / diff.mag());
			this.location.sub(diff);
		}
		location.lerp(desiredLocation, strength);
	}
}
