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
	f=B=0;
	switch char(doppellaut(2))
		case 'a'
			[y , f , B]=stimmhaft({'a'},DUR,fs,0);
		case 'e'
			[y , f , B]=stimmhaft({'e'},DUR,fs,0);
		case 'i'
			[y , f , B]=stimmhaft({'i'},DUR,fs,0);
		case 'o'
			[y , f , B]=stimmhaft({'o'},DUR,fs,0);
		case 'u'
			[y , f , B]=stimmhaft({'u'},DUR,fs,0);
		case 'ae'
			[y , f , B]=stimmhaft({'ae'},DUR,fs,0);
		case 'oe'
			[y , f , B]=stimmhaft({'oe'},DUR,fs,0);
		case 'ue'
			[y , f , B]=stimmhaft({'ue'},DUR,fs,0);	
	end
			f1=f(1);
			f2=f(2);
			B1=B(1);
			B2=B(2);


	y=formantfilter(x,Ts,f11,B1,f1, U, O);	%1. Formantfilter
	y=formantfilter(y,Ts,f21,B2,f2, U, O);	%2. Formantfilter

	wavwrite(y'/max(y),fs,strcat('plosiv-',buchstaben,'.wav'));
end
