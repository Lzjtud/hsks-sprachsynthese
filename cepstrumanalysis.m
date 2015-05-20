%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%					HAUPTSEMINAR SPRACHSYNTHESE							%
%				  Cepstrum-Analyse von WAV-Files						%
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
cepstrum = ifft(log_spectrum);
%x_axis = (1:size(cepstrum));
plot(abs(cepstrum));		%man will doch den betrag?!

% Fensterung des cepstrums, vorerst mit 0.25
cepstrum = cepstrum(1:size(cepstrum)/2);

% Liftering (Filterung des Vokaltraktsignals mit Formanten)
lift = zeros(length(cepstrum),1);
lift(1:length(cepstrum)/4) = 1;
lift_cepstr = cepstrum.*lift;
mag_spec = fft(lift_cepstr);


% TODO: Fensterung, DFT, Maximumsbestimmung, Automatische Bearbeitung aller WAV-Files im Ordner


% offene Fragen: wie naechste Fensterung vornehmen?
% sind die Maxima der anschliessenden DFT die Formanten?
% Wie genau wird die Bandbreite der Formanten abgelesen?

