%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% Erzeugung eines stimmhaften Lautes mittels einfacher Formantfilterung %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y=stimmhaft(buchstaben,DUR,fs,B)

%%%%%			PARAMETER			%%%%%
if (nargin==0) buchstaben={'ae';'oe';'ue';'a';'u';'e';'i';'o'};end%Buchstaben
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz
if (nargin<=3) B=[100 160]; end %bandwidth
	
Ts=1/fs;
B1=B(1);	%Filterbandbreite Formant 1	Acoustic Phonetics von Kenneth N. Stevens!
B2=B(2);	%Filterbandbreite Formant 2
f0=150;	% Grundschwingung, Tonhoehe

x=sourcesignal('vokal',DUR,fs);
disp(buchstaben);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:numel(buchstaben)
	buchstabe=buchstaben(i);
	
	switch char(buchstabe)
		case 'a'
			f1=1000;
			f2=1400;
		case 'e'
			f1=500;
			f2=2300;
		case 'i'
			f1=320;
			f2=3200;
		case 'o'
			f1=500;
			f2=1000;
		case 'u'
			f1=320;
			f2=800;
		case 'ae'
			f1=700;
			f2=1800;
		case 'oe'
			f1=500;
			f2=1400;
		case 'ue'
			f1=320;
			f2=1650;
		case 'j'
			f1=250;
			f2=1950;
	end
	
	y=formantfilter(x,Ts,f1,B1);	%1. Formantfilter
	y=formantfilter(y,Ts,f2,B2);	%2. Formantfilter

	wavwrite(y'/max(y),fs,strcat('stimmhaft-',char(buchstabe),'.wav'));
end
