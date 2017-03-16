int w = 400;
int h = 200;
Node[] line1 = new Node[w / 4];

void setup() {
	surface.setSize(w, h);
	for(int i = 0; i < line1.length; i++) {
		line1[i] = new Node(i * w / line1.length, height / 2, 1);
	}
}

void draw() {
	Node n = new Node(3, 5, 1);
	for(int i = 1; i < line1.length; i++) {
		line(line1[i - 1].location.x, line1[i - 1].location.y, line1[i].location.x, line1[i].location.y);
	}
}

class Node {
	PVector location;
	PVector desiredLocation;
	float strength;

	Node(float dx, float dy, float strength) {
		this.desiredLocation = new PVector(dx, dy);
		this.location = desiredLocation.copy();
		this.strength = strength;
	}
}
