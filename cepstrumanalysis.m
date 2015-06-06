%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	HAUPTSEMINAR SPRACHSYNTHESE%
%				  Cepstrum-Analyse von WAVFiles						%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%function y=cepstrumanalysis()

% Einlesen einer Datei
signal=wavread('a-karl.wav');

% Anzahl der Punkte für die spaetere FFT
nf=2^14;

% Normierung, zeitliche Begrenzung der Aufnahme
%signal = signal./max(abs(signal));
signal = signal((end-nf)/2:(end+nf-1)/2);

% Fensterung der Aufnahme mit einem Hanning-Fenster
h_window = hanning(nf);
signal = signal.*h_window;

% Berechnung des cepstrums
spectrum = fft(signal);
log_spectrum = log10(abs(spectrum));
cepstrum = real(ifft(log_spectrum));
%x_axis = (1:size(cepstrum));

% Fensterung des cepstrums, vorerst mit 0.5
cepstrum = cepstrum(1:size(cepstrum)/2);
%plot(cepstrum);

% Liftering (Filterung des Vokaltraktsignals mit Formanten)
lift = zeros(length(cepstrum),1);
length(cepstrum)
lift(1:length(cepstrum)/400) = 1;
lift_cepstr = cepstrum.*lift;
mag_spec = real(fft(lift_cepstr));
plot(mag_spec);

% Formantenbestimmung
k = 1;
formant = zeros(100,1);
while length(formant)<101
	for i = 2:(length(mag_spec)-1)
		if mag_spec(i-1)<mag_spec(i) && mag_spec(i)>mag_spec(i+1)
			formant(k) = mag_spec(k);
			k = k+1;
		else
			continue;
		end

	end
end
disp(length(formant))

% TODO: Maximumsbestimmung, Automatische Bearbeitung aller WAV-Files im Ordner


% offene Fragen: wie naechste Fensterung vornehmen?
% sind die Maxima der anschliessenden DFT die Formanten?
% Wie genau wird die Bandbreite der Formanten abgelesen?
