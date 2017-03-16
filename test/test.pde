int w = 400;
int h = 200;
Node[] line1 = new Node[w / 4];

void setup() {
	surface.setSize(w, h);
	for(int i = 0; i < line1.length; i++) {
		line1[i] = new Node(i * w / line1.length, height / 2, 0.05);
	}
}

void draw() {
	background(255);
	for(int i = 0; i < line1.length - 1; i++) {
		line1[i].update();
		line(line1[i].location.x, line1[i].location.y, line1[i + 1].location.x, line1[i + 1].location.y);
	}
	line1[line1.length - 1].update();
	line(line1[line1.length - 1].location.x, line1[line1.length - 1].location.y, width, line1[line1.length - 1].desiredLocation.y);
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
			diff.mult(1 / diff.mag());
			this.location.sub(diff);
		}
		else {
			location.lerp(desiredLocation, strength);
		}
	}
}
