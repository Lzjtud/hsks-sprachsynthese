%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% 	Erzeugung von Zischlauten mittels einfacher Rauschquellenfilterung 	%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y,t]=zischlaut(buchstaben,DUR,fs,B)

%%%%%			PARAMETER			%%%%%
if (nargin==0) buchstaben={'s';'sch';'ch';'f'};end%Buchstaben
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz
if (nargin<=3) B=[1500 2000]; end %bandwidth
	
	Ts=1/fs;
	B1=B(1);	%Filterbandbreite Formant 1
	B2=B(2);	%Filterbandbreite Formant 2

	%f0=150;	% Grundschwingung, Tonhoehe
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%N=ceil(DUR*fs);
	%t=0:Ts:(N-1)*Ts;
	%x=randn(size(t));	%Rausch-Anregungssignal
	x=sourcesignal('zisch',DUR,fs);
	disp(buchstaben);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:numel(buchstaben)
	buchstabe=buchstaben(i);
	
	switch char(buchstabe)
		case 's'		%Orientierung an Narayanan et al. 'Noise Source Models for Fricative Consonants'
			%f1=6000;	%B1=500;
			%f2=7800;	%B2=1000;
			%B1=500;
			%B2=1000;
			b1=fir1(30,[6800 8200]/(fs/2),'DC-0');
			w1=1;
			b2=fir1(50,[4000 7000]/(fs/2),'DC-0');
			w2=.6;
		case 'sch'		%Orientierung an Narayanan et al. 'Noise Source Models for Fricative Consonants'
			%f1=2500;	%B1=300
			%f2=5500;	%B2=500
			%B1=300;
			%B2=500;
			b1=fir1(50,[1750 3200]/(fs/2),'DC-0');
			w1=1;
			b2=fir1(70,[4950 6400]/(fs/2),'DC-0');
			w2=.5;
		case 'ch'
			%f1=320;
			%f2=3200;
			b1=fir1(100,[2350 3200]/(fs/2),'DC-0');
			w1=1;
			b2=fir1(100,[4950 6400]/(fs/2),'DC-0');
			w2=.8;
		case 'f'		%Orientierung an Narayanan et al. 'Noise Source Models for Fricative Consonants'
			%f1=1000;
			%f2=8000;
			%B1=250;
			%B2=2000;
			b1=fir1(1,[5000]/(fs/2),'low');
			w1=.5;
			b2=fir1(1,[3000]/(fs/2),'low');
			w2=.5;
	end
	y=w1*filter(b1,1,x)+w2*filter(b2,1,x);
	%y=formantfilter(x,Ts,f1,B1)+formantfilter(x,Ts,f2,B2);	%Parallele Filterung, eventuell Wichtungsfaktoren
	
	wavwrite(y'/max(y),fs,strcat('zischlaut-',char(buchstabe),'.wav'));
end
