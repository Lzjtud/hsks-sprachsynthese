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
elseif(buchstaben(1)=='g')
	U = 0.030*fs;  	%%empirisch ermittelt
	O = 0.001*fs;	%%ein Drittel der Zeit wird offset	
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
			f3=f(3);
			B1=B(1);
			B2=B(2);
			B3=B(3);
	switch doppellaut
		case 'da'			%%http://www.influenzaarchive.org/cgi/p/pod/dod-idx?c=icmc;idno=bbp2372.2007.174
			f11=470;		%%startet 450 
			f21=1850;		%%startet 1850 ggf. mehr
			f31=2680;		%%startet bei etwa 2680
			%U=0.08*fs;		%%0.1s übergang
			%O=0;
		case 'de'			
			f11=320;		%%eigentlich kaum erkennbar
			f21=1900;		%%200 differenz
			f31=2700;
		case 'di'	
			f11=120;		%%kaum sichtbar??? zu hoch in aufnahmen?????
			f21=1750;		%%startet bei 1750 etwa
			f31=2500;		%%startet bei etwa 2500
		case 'do'
			f11=250;		%%???? kaum sichtbar?????????
			f21=1400;		%%fällt von etwa 1400, ggf. beim 2. 1440
			f31=2600;		%%2700 erstes 2500 2. mal
		case 'du'
			f11=120;		%%???? kaum sichtbar?????????
			f21=1500;		%%fällt von etwa 1500(2.Gut)
			f31=2600;		%% 1. zweites ???
		case 'ba'
			f11=400;		%%beginnt bei etwa 400
			f21=1080;		%%bei etwa 1080 begonnen beim 2.
			f31=2700;		%%2700 beim 2.
		case 'be'	
			f11=140;		%%kaum zu erkennen/2. 140
			f21=1200;		%%fängt bei 1200 an
			f31=2200;		%%fängt bei etwa 2200 an
		case 'bi'		
			f11=150;		%%fängt bei 150 an(einzelne werte 1 und 2)
			f21=1600;		%%fängt bei etwa 1600 an
			f31=2800;		%%beim ersten
		case 'bo'			%%nicht so gut...
			f11=120;		%%2. sagt 120Hz
			f21=f2-150;		%%steigt um etwa 100
			f31=2650;		%%2. mal über 2600
		case 'bu'			%%nicht so gut
			f11=120;		%%2. sagt etwa 120
			f21=f2;			%%unklar, vllt. sogar gleich
			f31=3000;		%%beim 2. aber unklar	???????????????????
		case 'ga'			%%schlecht
			f11=260;		%%fängt bei 260 an
			f21=1700;		%%fängt bei 1700 an
			f31=2100;		%%fängt bei etwa 2100 an
		case 'ge'	
			f11=200;		%%beim 1.
			f21=2300;		%%????????
			f31=2600;
		case 'gi'		
			f11=100;		%%beim 2.
			f21=2500;		%%beim 1.
			f31=3200;
		case 'go'
			f11=250;		%%steigt um etwa 100
			f21=1250;		%%1. etwa 1250
			f31=3000;		
		case 'gu'		
			f11=50;			%%unklar
			f21=1200;		%%könnte beim 2. interpretiert werden...,
			f31=2700;
	end

	y=formantfilter(x,Ts,f11,B1,f1, U, O);	%1. Formantfilter
	y=formantfilter(y,Ts,f21,B2,f2, U, O);	%2. Formantfilter
	y=formantfilter(y,Ts,f31,B3,f3, U, O);	%2. Formantfilter
	wavwrite(y'/max(y),fs,strcat('plosiv-',buchstaben,'.wav'));
end
