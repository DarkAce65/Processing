import ddf.minim.*;
import ddf.minim.analysis.*;

int sampleSize = 1024;
Minim minim;
AudioInput ain;
FFT fft;
BeatDetect beat;

int z = 0;
int longestTrace = 100;
int maxFreq = sampleSize; // Index of highest frequency for bars
float attack = 0.7; // Attack value for bar lerp
float decay = 0.1; // Decay value for bar lerp
ArrayList<float[]> spectrum; // Bar data

void setup() {
	size(1600, 800, P3D);
	background(0);
	strokeWeight(2); // Thicken lines

	minim = new Minim(this); // Set up new Minim object
	ain = minim.getLineIn(Minim.MONO, sampleSize); // Get microphone input

	fft = new FFT(ain.bufferSize(), ain.sampleRate()); // Create new FFT from audio input
	beat = new BeatDetect(); // Create BeatDetect object

	maxFreq = fft.freqToIndex(20000); // Set maxFreq to the index of 20000 Hz
	spectrum = new ArrayList<float[]>();
	spectrum.add(new float[maxFreq]);
	// spectrum = new float[maxFreq][maxFreq]; // Create array of spectrum data
}

void draw() {
	fft.forward(ain.mix); // Run FFT on input
	beat.detect(ain.mix); // Run BeatDetect on input
	
	lights();
	camera(-mouseX + width, -mouseY + height, (height / 2) / tan(PI / 6), width / 2, height / 2, 0, 0, 1, 0);
	translate(0, 0, -100);

	background(0);
	spectrum.add(new float[maxFreq]);
	if(spectrum.size() >= longestTrace) {
		spectrum.remove(0);
	}
	for(int i = 0; i < maxFreq; i++) {
		float amplitude = fft.getBand(i) * height / 100;
		float smoothing = spectrum.get(spectrum.size() - 1)[i] < amplitude ? attack : decay; // Pick lerp constant based on change of value
		spectrum.get(spectrum.size() - 1)[i] = lerp(spectrum.get(spectrum.size() - 2)[i], amplitude, smoothing); // Smooth current bar value
	}

	noStroke();
	translate(0, 0, -spectrum.size());
	for(int i = 0; i < spectrum.size(); i++) {
		fill(255 * i / spectrum.size());
		translate(0, 0, 1);
		for(int j = 0; j < maxFreq; j++) {
			rect(j * width / maxFreq, height - 10, (j + 1) * width / maxFreq - j * width / maxFreq, -spectrum.get(i)[j]); // Draw bar
		}
	}

	stroke(255);
	noFill();
	rect(0, 0, width, height);

	z++;
}
