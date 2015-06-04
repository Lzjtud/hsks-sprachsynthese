%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% 		Erzeugung eines Diphthong Lautes mittels Formantfilterung 		%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y=diphthong(buchstaben,DUR,fs,B)

%%%%%			PARAMETER			%%%%%
if (nargin==0) buchstaben={'au';'ei';'eu';'ai'};end%Buchstaben
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz
if (nargin<=3) B=[100 160]; end %bandwidth	
	Ts=1/fs;
	B1=B(1);	%Filterbandbreite Formant 1	Acoustic Phonetics von Kenneth N. Stevens!
	B2=B(2);	%Filterbandbreite Formant 2

	%f0=150;	% Grundschwingung, Tonhoehe
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	x=sourcesignal('diphthong',DUR,fs);

	U = DUR*fs/3;	%%ein drittel der gesamtzeit wird uebergang
	O = DUR*fs/3;	%%ein Drittel der Zeit wird offset	

	disp(buchstaben);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:numel(buchstaben)
	buchstabe=buchstaben(i);
	switch char(buchstabe)
		case 'au'		%%au
			f11=732;
			f21=1195;
			f31=2516;
			f12=362;
			f22=721;
			f32=2301;
		case 'ai'		%%ai
			f11=732;
			f21=1195;
			f31=2516;
			f12=200;
			f22=2211;
			f32=3076;
		case 'ei'		%%ai
			f11=732;
			f21=1195;
			f31=2516;
			f12=200;
			f22=2211;
			f32=3076;
		case 'eu'		%%oi
			f11=359;
			f21=727;
			f31=2459;		
			f12=200;
			f22=2211;
			f32=3076;
	end
	
	y=formantfilter(x,Ts,f11,B1,f12, U, O);	%1. Formantfilter
	y=formantfilter(y,Ts,f21,B2,f22, U, O);	%2. Formantfilter
	y=formantfilter(y,Ts,f31,B2,f32, U, O);	%3. Formantfilter

	wavwrite(y'/max(y),fs,strcat('stimmhaft-',char(buchstabe),'.wav'));
end
