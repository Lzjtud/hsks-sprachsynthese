function x=sourcesignal(lauttyp,DUR,fs)

%%%%%			PARAMETER			%%%%%
if (nargin==0) lauttyp='none';end%Buchstaben
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz

	Ts=1/fs;
	f0=150;	% Grundschwingung, Tonhoehe
	
	samples=floor(DUR*fs);
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	t0=0:Ts:1/f0; %Zeitachse (Grundschwingung)
	t=0:Ts:(samples-1)*Ts;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	switch char(lauttyp)
		case 'zisch'
			x0=randn(size(t));
		case 'nasal'
			x0=5.51*cos(2*pi*f0*t0+.119)+3.637*cos(4*pi*f0*t0-.366)+.796*cos(6*pi*f0*t0+.67);
			x0=x0/max(x0);
		otherwise
			N=length(t0);
			N1=floor(.6*N);
			N2=floor(.8*N);
    
			x0_1=.5*(1-cos(pi*t0(1:N1)/t0(N1)));		%Anregungssignal aus meinem Buch. hinter .* stehen die Intervalle - wie setze ich so etwas zusammen?
			x0_2 = cos(2*pi*(t0(N1+1:N2)-t0(N1))/t0(N2));    %ANPASSUNG (mal 2)
			x0_3 = zeros(1,length(N2+1:N));
			x0=[x0_1 x0_2 x0_3];            %text2speech synthesis (paul taylor) p. 331
	end

N=ceil(DUR*f0);
x=repmat(x0,1,N);
x=x(1:samples);
	