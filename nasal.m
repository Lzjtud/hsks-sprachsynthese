%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% 					   			 Nasallaute								%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y=nasal(buchstaben,DUR,fs,B)

%%%%%			PARAMETER			%%%%%
if (nargin==0) buchstaben={'m';'n'};end%Buchstaben
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz
if (nargin<=3) B=[100 160]; end %bandwidth

Ts=1/fs;
B1=B(1);	%Filterbandbreite Formant 1	Acoustic Phonetics von Kenneth N. Stevens!
B2=B(2);	%Filterbandbreite Formant 2
f0=150;	% Grundschwingung, Tonhoehe

x=sourcesignal('nasal',DUR,fs);
disp(buchstaben);

%%%%%%%%%%%%%%%%%		Filter(nur mit Tiefpassfilter)	 %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:numel(buchstaben)
	buchstabe=buchstaben(i);
	
	switch char(buchstabe)
		case 'm'
			n=3; %Filterordnung
			fg=800; %Grenzfrequenz
		case 'n'
			n=1; %Filterordnung
			fg=700;
	end
	
	[b a] = butter(n,fg/(.5*fs),'low');	%Manipulation des Signals im Frequenzbereich mit Tiefpassfilter
	y = filter(b,a,x);

	wavwrite(y'/max(y),fs,strcat('nasal-',char(buchstabe),'.wav'));
end