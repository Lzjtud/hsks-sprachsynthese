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
		case 'de'			%%http://www.influenzaarchive.org/cgi/p/pod/dod-idx?c=icmc;idno=bbp2372.2007.174
			f11=250;
			f21=2000;
			f12=500;
			f22=2300;
		case 'da'
			f11=250;
			f21=2000;
			f12=1000;
			f22=1400;
		case 'do'
			f11=250;
			f21=2000;
			f12=500;
			f22=1000;
		case 'du'
			f11=250;
			f21=2000;
			f12=320;
			f22=800;
		case 'di'	
			f11=250;
			f21=2000;
			f12=320;
			f22=3200;
		case 'be'	
			f11=250;
			f21=1400;
			f12=500;
			f22=2300;
		case 'ba'
			f11=250;
			f21=1100;
			f12=1000;
			f22=1400;
		case 'bo'
			f11=250;
			f21=1100;
			f12=500;
			f22=1000;
		case 'bi'		
			f11=250;
			f21=1100;
			f12=320;
			f22=3200;
		case 'bu'		
			f11=250;
			f21=1100;
			f12=320;
			f22=800;
		case '|a'
			f11=1;
			f21=1;
			f12=1000;
			f22=1400;
		otherwise
			i = i-1;	%doch nur eins nach vorne
			switch char(buchstabe)
				case 'd'
					f11=250;
					f21=3100;
					f12=500;
					f22=2300;
				case 'b'
					f11=250;
					f21=1100;
					f12=500;
					f22=2300;
			end
	end
	y=formantfilter(x,Ts,f11,B1,f12, U, O);	%1. Formantfilter
	y=formantfilter(y,Ts,f21,B2,f22, U, O);	%2. Formantfilter

	wavwrite(y'/max(y),fs,strcat('plosiv-',buchstaben,'.wav'));
end
