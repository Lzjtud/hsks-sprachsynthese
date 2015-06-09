%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% 					   			 Fricationw								%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y=fricationw(buchstaben,DUR,fs,B)

%%%%%%%%%%%%%%%%%%%%%			Parameter 	 	%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin==0) buchstaben={'w'};end%Buchstaben
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz
if (nargin<=3) B=[100 160]; end %bandwidth

Ts=1/fs;
B1=B(1);	%Filterbandbreite Formant 1	Acoustic Phonetics von Kenneth N. Stevens!
B2=B(2);	%Filterbandbreite Formant 2
f0=150;	% Grundschwingung, Tonhoehe

x=sourcesignal('fricationw',DUR,fs);
disp(buchstaben);

%%%%%%%%%%%%%%%%%%%%%		Anregungssignal 	 %%%%%%%%%%%%%%%%%%%%%%%%%


w=x;
for i=0:1:5;
[b a] = butter(6-i,(100+i*100)/(0.5*fs),'low');	%Manipulation des Signals im Frequenzbereich mit Tiefpassfilter(f0 = 800HZ)
w = filter(b,a,w);
end

w = formantfilter(w,Ts,266,150);
w = formantfilter(w,Ts,900,150);

[b a] = butter(5,3000/(0.5*fs),'low');	%Manipulation des Signals im Frequenzbereich mit Tiefpassfilter(f0 = 700HZ)
w = filter(b,a,w);

y=w;

wavwrite(y'/max(y),fs,strcat('FRCw','.wav'));