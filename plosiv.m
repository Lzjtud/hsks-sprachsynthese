%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% 				Erzeugung einer Plosiv/Vokal-Lautkombination 			%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y=plosiv(buchstaben,DUR,fs,B)

%%%%%			PARAMETER			%%%%%
if (nargin==0) buchstaben={'de';'da';'do';'di'};end%Buchstaben
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz
if (nargin<=3) B=[100 160]; end %bandwidth	
	Ts=1/fs;
	B1=B(1);	%Filterbandbreite Formant 1	Acoustic Phonetics von Kenneth N. Stevens!
	B2=B(2);	%Filterbandbreite Formant 2

	f0=150;	% Grundschwingung, Tonhoehe
	
	x=sourcesignal('plosiv',DUR,fs);
	
if(buchstaben(1)=='b')
	U = 0.005*fs;  	%%empirisch ermittelt
	O = 0.01*fs;	%%ein Drittel der Zeit wird offset	
else
	U = 0.012*fs;  	%%empirisch ermittelt
	O = 0.005*fs;	%%ein Drittel der Zeit wird offset	
end

	disp(buchstaben);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1;
while i<=numel(buchstaben)
	buchstabe=buchstaben(i);
	if(length(buchstaben)-i>0)	%%nur wenn lang genug

		doppellaut = buchstaben(i:i+1);	%%Doppellaut
	else	
		doppellaut = [0, 0];	%%dann kein Doppellaut	
	end
	i=i+2;					%%erstmal um zwei erhöhen, wir gehen von einem Diphthong aus.
	disp(doppellaut);
	switch doppellaut
		case 'da'			%%http://www.influenzaarchive.org/cgi/p/pod/dod-idx?c=icmc;idno=bbp2372.2007.174
			f11=450;		%%startet 450 
			f21=1500;		%%startet 1500 ggf. mehr
		case 'de'			
			f11=120;		%%eigentlich kaum erkennbar
			f21=1600;		%%200 differenz
		case 'di'	
			f11=120;		%%kaum sichtbar
			f21=1800;		%%startet bei 1800 etwa
		case 'do'
			f11=250;		%%um etwa 80 gestiegen, hier etwa 100
			f21=1600;		%%fällt von etwa 1600+
		case 'du'
			f11=120;		%%schwer zu lesen...
			f21=1600;		%%fällt von etwa 1600+
		case 'ba'
			f11=413;		%%mit diesem wert angefangen. 1. Formant stimmt gut
			f21=800;		%%um 100Hz gestiegen 
		case 'be'	
			f11=300;		%%fängt bei etwas 300 an
			f21=1200;		%%fängt bei 1600 an
		case 'bi'		
			f11=160;		%%fängt bei 160 an
			f21=1500;		%%fängt bei etwa 1500 an
		case 'bo'
			f11=310;		%%fängt bei 250 an
			f21=300;		%%steigt um etwa 100
		case 'bu'		
			f11=250;		%%schwer auszuwerten
			f21=100;		%%unklar
		case 'ga'
			f11=390;		%%knapp 400
			f21=1700;		%%über 1650
		case 'ge'	
			f11=200;		%%beim 2.
			f21=2300;		%%beim 2. ungefähr
		case 'gi'		
			f11=100;		%%beim 2.
			f21=2500;		%%beim 1.
		case 'go'
			f11=250;		%%steigt um etwa 100
			f21=1250;		%%1. etwa 1250
		case 'gu'		
			f11=50;			%%unklar
			f21=1200;		%%könnte beim 2. interpretiert werden...

		case '|a'
			f11=1;
			f21=1;
	end
	switch char(doppellaut(2))
		case 'a'
			%f1=1000;
			%f2=1400;
			f1=732;
			f2=1195;
			B1=160.5;
			B2=136.4;
		case 'e'
			%f1=500;
			%f2=2300;
			f1=372;
			f2=1983;
			B1=25.64;
			B2=65.47;
		case 'i'
			%f1=320;
			%f2=3200;
			f1=200;
			f2=2211;
			B1=34.65;
			B2=84.69;
		case 'o'
			%f1=500;
			%f2=1000;
			f1=359;	
			f2=727;
			B1=161.4;
			B2=272.6;
		case 'u'
			%f1=320;
			%f2=800;
			f1=362;
			f2=721;
			B1=159.3;
			B2=351.7;
		case 'ae'
			%f1=700;
			%f2=1800;
			f1=596;
			f2=1421;
			B1=99.65;
			B2=173.0;
		case 'oe'
			%f1=500;
			%f2=1400;
			f1=335;
			f2=1323;
			B1=51.23;
			B2=129.0;
		case 'ue'
			%f1=320;
			%f2=1650;
			f1=284;
			f2=1635;
			B1=92.18;
			B2=177.6;		
	end
	y=formantfilter(x,Ts,f11,B1,f1, U, O);	%1. Formantfilter
	y=formantfilter(y,Ts,f21,B2,f2, U, O);	%2. Formantfilter

	wavwrite(y'/max(y),fs,strcat('plosiv-',buchstaben,'.wav'));
end
