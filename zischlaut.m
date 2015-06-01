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

	f0=150;	% Grundschwingung, Tonhoehe
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%N=ceil(DUR*fs);
	%t=0:Ts:(N-1)*Ts;
	%x=randn(size(t));	%Rausch-Anregungssignal
	x=sourcesignal('zisch',DUR,fs);
	disp(buchstaben);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%for i=1:numel(buchstaben)
%	buchstabe=buchstaben(i);
	
	switch char(buchstaben)
		case 's'		%Orientierung an Narayanan et al. 'Noise Source Models for Fricative Consonants'
			f1=6000;	%B1=500;
			f2=7800;	%B2=1000;
			B1=500;
			B2=1000;
		case 'sch'		%Orientierung an Narayanan et al. 'Noise Source Models for Fricative Consonants'
			f1=2500;	%B1=300
			f2=5500;	%B2=500
			B1=300;
			B2=500;
		case 'ch'
			f1=320;
			f2=3200;
		case 'f'		%Orientierung an Narayanan et al. 'Noise Source Models for Fricative Consonants'
			f1=1000;
			f2=8000;
			B1=250;
			B2=2000;
	end
	
	y=formantfilter(x,Ts,f1,B1)+formantfilter(x,Ts,f2,B2);	%Parallele Filterung, eventuell Wichtungsfaktoren
	
	wavwrite(y'/max(y),fs,strcat('zischlaut-',char(buchstaben),'.wav'));
%end
