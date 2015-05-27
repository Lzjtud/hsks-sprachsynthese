%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% 					Erzeugung des Bursts von Plosiven					%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y,t]=burst(buchstabe,DUR,fs,B)

%%%%%			PARAMETER			%%%%%
if (nargin==0) buchstabe={'d'};end%Buchstaben
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz
if (nargin<=3) B=[1500 2000]; end %bandwidth
	
	Ts=1/fs;
	B1=B(1);	%Filterbandbreite Formant 1
	B2=B(2);	%Filterbandbreite Formant 2
	n=50;		%Bandpass n-ter Ordnung
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%N=ceil(DUR*fs);
	%t=0:Ts:(N-1)*Ts;
	%x=randn(size(t));	%Rausch-Anregungssignal
	x=sourcesignal('zisch',DUR,fs);			%%WGN????
	disp(buchstabe);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	switch char(buchstabe)
		case 'd'		%siehe Kordon Blatt
			f1=600;		
			f2=4000;	
			B1=200;
			B2=8000;
			c1=15;		%wichtung der Filter bei 15DB == 1
			c2=0;
		case 't'
			f1=300;	
			f2=6000;	
			B1=300;
			B2=4000;
			c1=5;		%wichtung der Filter
			c2=15;
		case 'b'
			f1=500;	
			f2=1500;	
			B1=500;
			B2=1000;
			c1=15;		%wichtung der Filter
			c2=1;
		case 'p'		
			f1=500;	
			f2=1500;	
			B1=500;
			B2=1000;
			c1=5;		%wichtung der Filter
			c2=-10;
	end
	b1=fir1(n,[(f1-B1/2)*Ts*2,(f1+B1/2)*Ts*2], "bandpass");
	b2=fir1(n,[(f2-B2/2)*Ts*2,(f2+B2/2)*Ts*2], "bandpass");

	y= 10^(c1/20)*filter(b1, 1, x)+10^(c2/20)*filter(b2, 1, x);
	%y=c1*formantfilter(x,Ts,f1,B1)+0*c2*formantfilter(x,Ts,f2,B2);	%Parallele Filterung, eventuell Wichtungsfaktoren
	
	wavwrite(y'/max(y),fs,strcat('burst-',char(buchstabe),'.wav'));
