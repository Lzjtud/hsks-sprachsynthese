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
		
	bl=0.15;		%%Burst length
	peri_num = 1;	%% anzahl Perioden 
	disp(buchstaben);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1;
fac=1;
while i<=numel(buchstaben)
	buchstabe=buchstaben(i);
	i=i+1;
	switch buchstabe
		case 't'			
			peri_num = 0.5;
			fac = 0.7;
		case 'p'	
			peri_num = 3;
			fac = 0.1;
		case 'k'
			peri_num = 2;
			fac = 0.5;
	end
	disp(fac);
	time = linspace(0, 2*pi, fs*bl);
	cosi = cos(time*peri_num)+2;
	burs = burst(buchstabe,bl,fs);
	burs = burs/(2*max(burs(1:bl*fs)));
	burs = burs.*cosi;	
	wavwrite(burs'/(max(burs))*fac,fs,strcat('plosiv-stimmlos-',buchstaben,'.wav'));
	y=burs/(max(burs))*fac;
end
