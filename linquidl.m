%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% 					   		   Liquidlaut-L								%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y=linquidl(buchstaben,DUR,fs,B)

%%%%%%%%%%%%%%%%%%%%%			Parameter 	 	%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin==0) buchstaben={'l'};end%Buchstaben
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz
if (nargin<=3) B=[100 160]; end %bandwidth

Ts=1/fs;
B1=B(1);	%Filterbandbreite Formant 1	Acoustic Phonetics von Kenneth N. Stevens!
B2=B(2);	%Filterbandbreite Formant 2
f0=150;	% Grundschwingung, Tonhoehe

x=sourcesignal('linquidl',DUR,fs);
disp(buchstaben);

%%%%%%%%%%%%%%%%%%%%%		Filter 	 	%%%%%%%%%%%%%%%%%%%%%%%%%




y = formantfilter(x,Ts,450,200);
%[b a] = butter(2,900/(0.5*fs),'low');	%Manipulation des Signals im Frequenzbereich mit Tiefpassfilter(f0 = 700HZ)
%l = filter(b,a,l);

[b a] = butter(3,[700/(0.5*fs),900/(0.5*fs)],'stop');
y = filter(b,a,y);

[b a] = butter(2,[1100/(0.5*fs),1300/(0.5*fs)],'stop');
y = filter(b,a,y);

y = formantfilter(y,Ts,1700,500);

[b a] = butter(5,3000/(0.5*fs),'low');	%Manipulation des Signals im Frequenzbereich mit Tiefpassfilter(f0 = 700HZ)
y = filter(b,a,y);

wind=tukeywin(length(y),.01);
y = y.*wind';
y = .5*y;

%z = fft(m(:).*hann(length(m)));	%DFT von Quellsignal
%plot(abs(log(z(1:10000))));

wavwrite(y'/max(y),fs,strcat('LQDl','.wav'));