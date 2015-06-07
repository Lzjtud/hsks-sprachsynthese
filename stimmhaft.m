%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% Erzeugung eines stimmhaften Lautes mittels einfacher Formantfilterung %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y , f , B]=stimmhaft(buchstaben,DUR,fs,syn)

%%%%%			PARAMETER			%%%%%
if (nargin==0) buchstaben={'ae';'oe';'ue';'a';'u';'e';'i';'o';'r'};end%Buchstaben
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz
%if (nargin<=3) B=[100 160]; end %bandwidth
if (nargin<=3) syn=1;	end %%soll synthetisieren?
	
Ts=1/fs;
%B1=B(1);	%Filterbandbreite Formant 1	Acoustic Phonetics von Kenneth N. Stevens!
%B2=B(2);	%Filterbandbreite Formant 2
f0=150;	% Grundschwingung, Tonhoehe
f1=f2=f3=0;%damit die in FKT definiert sind...
B1=B2=B3=0;%damit die in FKT definiert sind...
x=sourcesignal('vokal',DUR,fs);
disp(buchstaben);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:numel(buchstaben)
	buchstabe=buchstaben(i);
	
	switch char(buchstabe)
		case 'a'
			%f1=1000;
			%f2=1400;
			f1=732;
			f2=1195;
			f3=2516;
			B1=160.5;
			B2=136.4;
			B3=219.0;
		case 'e'
			%f1=500;
			%f2=2300;
			f1=372;
			f2=1983;
			f3=2500;
			B1=25.64;
			B2=65.47;
			B3=120.4;
		case 'i'
			%f1=320;
			%f2=3200;
			f1=200;
			f2=2211;
			f3=3076;
			B1=34.65;
			B2=84.69;
			B3=234.6;
		case 'o'
			%f1=500;
			%f2=1000;
			f1=359;
			f2=727;
			f3=2459;
			B1=161.4;
			B2=272.6;
			B3=247.5;
		case 'u'
			%f1=320;
			%f2=800;
			f1=362;
			f2=721;
			f3=2301;
			B1=159.3;
			B2=351.7;
			B3=279.2;
		case 'ae'
			%f1=700;
			%f2=1800;
			f1=596;
			f2=1421;
			f3=2299;
			B1=99.65;
			B2=173.0;
			B3=280.0;
		case 'oe'
			%f1=500;
			%f2=1400;
			f1=335;
			f2=1323;
			f3=2190;
			B1=51.23;
			B2=129.0;
			B3=110.6;
		case 'ue'
			%f1=320;
			%f2=1650;
			f1=284;
			f2=1635;
			f3=2077;
			B1=92.18;
			B2=177.6;
			B3=231.4;

	end
	if(syn == 1)
		y=formantfilter(x,Ts,f1,B1);	%1. Formantfilter
		y=formantfilter(y,Ts,f2,B2);	%2. Formantfilter
		y=formantfilter(y,Ts,f3,B3);	%3. Formantfilter
	else 
		y=x;
	end
	f=[f1 f2 f3];
	B=[B1 B2 B3];
	wavwrite(y'/max(y),fs,strcat('stimmhaft-',char(buchstabe),'.wav'));
end
