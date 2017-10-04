import ddf.minim.*;
import ddf.minim.analysis.*;

int sampleSize = 1024;
Minim minim;
AudioInput ain;
FFT fft;
BeatDetect beat;

boolean draw3D = false;
int z = 0;
int depth = 5;
int longestTrace = 100;
int avgSize = 0;
ArrayList<float[]> spectrum; // Bar data

void setup() {
	size(1600, 800, P3D);
	background(0);
	strokeWeight(2); // Thicken lines

	minim = new Minim(this); // Set up new Minim object
	ain = minim.getLineIn(Minim.MONO, sampleSize); // Get microphone input

	fft = new FFT(ain.bufferSize(), ain.sampleRate()); // Create new FFT from audio input
	fft.linAverages(200);
	beat = new BeatDetect(); // Create BeatDetect object

	avgSize = fft.avgSize();
	spectrum = new ArrayList<float[]>();
	spectrum.add(new float[avgSize]);
}

float traceFill(float i) {
	return 0.35 * exp(6.6 * i) + 1.18;
}

void draw3DRect(float x, float y, float width, float height) {
	x = x + width / 2;
	y = y + height / 2;
	translate(x, y, -depth / 2);
	box(width, height, depth);
	translate(-x, -y, depth / 2);
}

void draw() {
	fft.forward(ain.mix); // Run FFT on input
	beat.detect(ain.mix); // Run BeatDetect on input
	
	lights();
	camera(-mouseX + width, -mouseY + height, (height / 2) / tan(PI / 6), width / 2, height / 2, 0, 0, 1, 0);
	translate(0, 0, -100);

	background(0);
	spectrum.add(new float[avgSize]);
	if(spectrum.size() >= longestTrace) {
		spectrum.remove(0);
	}
	for(int i = 0; i < avgSize; i++) {
		float amplitude = fft.getAvg(i) * height / 100;
		spectrum.get(spectrum.size() - 1)[i] = lerp(spectrum.get(spectrum.size() - 2)[i], amplitude, 0.65);
	}

	noStroke();
	translate(0, 0, -spectrum.size() * depth);
	for(int i = 0; i < spectrum.size(); i++) {
		fill(traceFill((float) i / spectrum.size()));
		translate(0, 0, depth);
		for(int j = 0; j < avgSize; j++) {
			if(draw3D) {
				draw3DRect(j * width / avgSize, height, ceil((float) width / avgSize), min(-5, -spectrum.get(i)[j]));
			}
			else {
				rect(j * width / avgSize, height, ceil((float) width / avgSize), min(-5, -spectrum.get(i)[j]));
			}
		}
	}

	stroke(255);
	noFill();
	rect(0, 0, width, height);

	z++;
}
