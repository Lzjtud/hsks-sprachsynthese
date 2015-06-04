%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% 		Erzeugung eines Diphthong Lautes mittels Formantfilterung 		%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y=diphthong(buchstaben,DUR,fs)

%%%%%			PARAMETER			%%%%%
if (nargin==0) buchstaben={'au';'ei';'eu';'ai'};end%Buchstaben
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz
	Ts=1/fs;
	
	%f0=150;	% Grundschwingung, Tonhoehe
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	x=sourcesignal('diphthong',DUR,fs);

	U = DUR*fs/3;	%%ein drittel der gesamtzeit wird uebergang
	O = DUR*fs/3;	%%ein Drittel der Zeit wird offset	

	disp(buchstaben);
	f1=f2=B1=B2=0;	%%variablen global definiert...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:numel(buchstaben)
	buchstabe=buchstaben(i);
	switch char(buchstabe)
		case 'au'		%%au
			[y , f1 , B1]=stimmhaft({'a'},DUR,fs,0);
			[y , f2 , B2]=stimmhaft({'u'},DUR,fs,0);
		case 'ai'		%%ai
			[y , f1 , B1]=stimmhaft({'a'},DUR,fs,0);
			[y , f2 , B2]=stimmhaft({'i'},DUR,fs,0);
		case 'ei'		%%ai
			[y , f1 , B1]=stimmhaft({'a'},DUR,fs,0);
			[y , f2 , B2]=stimmhaft({'i'},DUR,fs,0);
		case 'eu'		%%oi
			[y , f1 , B1]=stimmhaft({'o'},DUR,fs,0);
			[y , f2 , B2]=stimmhaft({'i'},DUR,fs,0);
		case 'oi'		%%oi
			[y , f1 , B1]=stimmhaft({'o'},DUR,fs,0);
			[y , f2 , B2]=stimmhaft({'i'},DUR,fs,0);
		case 'ui'		%%ui
			[y , f1 , B1]=stimmhaft({'u'},DUR,fs,0);
			[y , f2 , B2]=stimmhaft({'i'},DUR,fs,0);
		case 'ea'		%%ea
			[y , f1 , B1]=stimmhaft({'e'},DUR,fs,0);
			[y , f2 , B2]=stimmhaft({'a'},DUR,fs,0);
	end
	f11=f1(1);
	f21=f1(2);
	f31=f1(3);
	B11 = B1(1);
	B21 = B1(2);
	B31 = B1(3);
	
	f12=f2(1);
	f22=f2(2);
	f32=f2(3);
	B12 = B2(1);
	B22 = B2(2);
	B32 = B2(3);

	y=formantfilter(x,Ts,f11,B11,f12, U, O,B12);	%1. Formantfilter
	y=formantfilter(y,Ts,f21,B21,f22, U, O,B22);	%2. Formantfilter
	y=formantfilter(y,Ts,f31,B31,f32, U, O,B32);	%3. Formantfilter

	wavwrite(y'/max(y),fs,strcat('stimmhaft-',char(buchstabe),'.wav'));
end
