import ddf.minim.*;
import ddf.minim.analysis.*;

int sampleSize = 1024;
Minim minim;
AudioInput ain;
FFT fft;
BeatDetect beat;

int x;
int maxFreq = sampleSize; // Index of highest frequency for bars
float attack = 0.7; // Attack value for bar lerp
float decay = 0.1; // Decay value for bar lerp
float waveAmplitude; // Amplitude of waveform
float waveSmoothing = 0.45; // Value for wave lerp
float[] spectrum; // Bar data
float[] wave; // Waveform data

void setup() {
	size(1600, 800);
	background(0);
	strokeWeight(2); // Thicken lines

	minim = new Minim(this); // Set up new Minim object
	ain = minim.getLineIn(Minim.MONO, sampleSize); // Get microphone input

	fft = new FFT(ain.bufferSize(), ain.sampleRate()); // Create new FFT from audio input
	beat = new BeatDetect(); // Create BeatDetect object

	waveAmplitude = (height - 10) / 4.0; // Set waveAmplitude to 1/4 of height leaving 10 pixels at the bottom for beat indicator
	maxFreq = fft.freqToIndex(20000); // Set maxFreq to the index of 20000 Hz
	spectrum = new float[maxFreq]; // Create array of spectrum data
	wave = new float[sampleSize]; // Create array of waveform data
}

void draw() {
	fft.forward(ain.mix); // Run FFT on input
	beat.detect(ain.mix); // Run BeatDetect on input

	noStroke();
	fill(0);
	rect(0, 0, width, height - 10); // Clear canvas leaving 10 pixels at the bottom for beat indicator

	fill(beat.isOnset() ? 255 : 50); // Set color to 255 if this is a beat
	rect(x, height - 10, 1, 10); // Draw rectangle representing beat

	if(x < width / 10) { // Clear beat indicator
		fill(0);
		rect(x * 10, height, 10, -10);
	}

	fill(beat.isOnset() ? 255 : 150);
	for(int i = 0; i < maxFreq; i++) {
		float amplitude = fft.getBand(i) * height / 100;
		float smoothing = spectrum[i] < amplitude ? attack : decay; // Pick lerp constant based on change of value
		spectrum[i] = lerp(spectrum[i], amplitude, smoothing); // Smooth current bar value

		rect(i * width / maxFreq, height - 10, 1, -spectrum[i]); // Draw bar
	}

	stroke(beat.isOnset() ? 255 : 150);
	for(int i = 1; i < sampleSize; i++) {
		float amplitude = ain.mix.get(i);
		wave[i] = lerp(wave[i], amplitude, waveSmoothing); // Lerp current wave value

		float prev = waveAmplitude * wave[i - 1] + waveAmplitude * 2;
		float current = waveAmplitude * wave[i] + waveAmplitude * 2;
		line((i - 1) * width / sampleSize, prev, i * width / sampleSize, current); // Draw line from previous point to current point
	}

	x++;
	x %= width;
}
