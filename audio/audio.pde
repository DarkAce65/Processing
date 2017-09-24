import ddf.minim.*;
import ddf.minim.analysis.*;

int sampleSize = 1024;
Minim minim;
AudioInput ain;
FFT fft;
BeatDetect beat;

int x;
int maxFreq = sampleSize;
float attack = 0.7;
float decay = 0.1;
float waveAmplitude;
float waveSmoothing = 0.45;
float[] spectrum;
float[] wave;

void setup() {
	size(1600, 800);
	waveAmplitude = (height - 10) / 4.0;
	background(0);
	noStroke();

	minim = new Minim(this);
	ain = minim.getLineIn(Minim.MONO, sampleSize);

	fft = new FFT(ain.bufferSize(), ain.sampleRate());
	beat = new BeatDetect();

	maxFreq = fft.freqToIndex(20000);
	spectrum = new float[maxFreq];
	wave = new float[sampleSize];
}

void draw() {
	fft.forward(ain.mix);
	beat.detect(ain.mix);

	noStroke();
	fill(0);
	rect(0, 0, width, height - 10);

	fill(beat.isOnset() ? 255 : 50);
	rect(x, height - 10, 1, 10);

	if(x < width / 10) {
		fill(0);
		rect(x * 10, height, 10, -10);
	}

	fill(beat.isOnset() ? 255 : 150);
	for(int i = 0; i < maxFreq; i++) {
		float amplitude = fft.getBand(i) * height / 100;
		float smoothing = spectrum[i] < amplitude ? attack : decay;
		spectrum[i] = lerp(spectrum[i], amplitude, smoothing);

		rect(i * width / maxFreq, height - 10, 1, -spectrum[i]);
	}

	stroke(beat.isOnset() ? 255 : 150);
	for(int i = 1; i < sampleSize; i++) {
		float amplitude = ain.mix.get(i);
		wave[i] = lerp(wave[i], amplitude, waveSmoothing);

		float prev = waveAmplitude * wave[i - 1] + waveAmplitude * 2;
		float current = waveAmplitude * wave[i] + waveAmplitude * 2;
		line((i - 1) * width / sampleSize, prev, i * width / sampleSize, current);
	}

	x++;
	x %= width;
}
