function x=sourcesignal(lauttyp,DUR,fs)

%%%%%			PARAMETER			%%%%%
if (nargin==0) lauttyp='none';end%Buchstaben
if (nargin<=1) DUR=2; end %duration in sec
if (nargin<=2) fs=44100; end %sampling freq in Hz

	Ts=1/fs;
	f0=125;	% Grundschwingung, Tonhoehe
	
	samples=ceil(DUR*fs);
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	t0=0:Ts:1/f0; %Zeitachse (Grundschwingung)
	t=0:Ts:(samples-1)*Ts;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	switch char(lauttyp)
		case 'zisch'
			x0=randn(size(t));
		case 'nasal'
			%x0=5.51*cos(2*pi*f0*t0+.119)+3.637*cos(4*pi*f0*t0-.366)+.796*cos(6*pi*f0*t0+.67);
			%x0=x0/max(x0);
			N = length(t0);
			N1 = floor(.125*N);
			N2 = floor(.25*N);
			N3 = floor(.5*N);
			N4 = floor(.5625*N);
			x0_1 = cos(4*pi*f0*t0(1:N1));
			x0_2 = .5*cos(4*pi*f0*t0(N1+1:N2));
			x0_3 = -.5*cos(2*pi*f0*(t0(N2+1:N3)-t0(N2)));
			x0_4 = .1*sin(16*pi*f0*(t0(N3+1:N4)-t0(N3)));
			x0_5 = sin(1.1*pi*f0*(t0(N4+1:N)-t0(N4)));
			x0 = [x0_1 x0_2 x0_3 x0_4 x0_5];
		case 'linquidl'
			N=length(t0);
			N1=floor(.5*N);
			N2=floor(.786*N);
			N3=floor(.929*N);
			x0_1=cos(3.5*pi*f0*t0(1:N1-1)-.25*pi);
			x0_2=.2*sin(3.5*pi*f0*(t0(N1:N2-1)-t0(N1)));
			x0_3=-.05*sin(14*pi*f0*(t0(N2:N3)-t0(N2)));
			x0_4=sin(3.5*pi*f0*(t0(N3+1:N)-t0(N3)));
			x0=[x0_1 x0_2 x0_3 x0_4];
		case 'fricationw'
			x0 = normrnd(0,1,[1 length(t0)]); 
		otherwise
			N=length(t0);
			N1=floor(.6*N);
			N2=floor(.8*N);
    
			x0_1=.5*(1-cos(pi*t0(1:N1-1)/t0(N1)));		%Anregungssignal aus meinem Buch. hinter .* stehen die Intervalle - wie setze ich so etwas zusammen?
			x0_2 = cos(2*pi*(t0(N1:N2-1)-t0(N1))/t0(N2));    %ANPASSUNG (mal 2)
			x0_3 = zeros(1,length(N2:N));
			x0=[x0_1 x0_2 x0_3];            %text2speech synthesis (paul taylor) p. 331
	end

N=ceil(DUR*f0);
x=repmat(x0,1,N);
x=x(1:samples);
	