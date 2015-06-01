%# Bandpassfilterung mit Bandpass 2. Ordnung
%# y=formantfilter(x,Ts,f0)
%# y=formantfilter(x,Ts,f0,B)
function y=formantfilter(x,Ts,f0,B,f2,U,O)

if (nargin==3) B=150; end	%default bandwidth
if (nargin<=4) f2=f0; end	%default second frequency
if (nargin<=5) U=1; end		%default kein Übergang
if (nargin<=6) O=1; end		%default kein offset


w0=2*pi*f0; %Mittenkreisfrequenz
w2=2*pi*f2; 
Q=f0/B;		%Guete Q=f0/B

%Bandpass 2. Ordnung
num=[w0/Q 0];
den=[1 w0/Q w0^2];
num2=[w2/Q 0];
den2=[1 w2/Q w2^2];
[numz1,denz1]=bilinear(num,den,Ts);
[numz2,denz2]=bilinear(num2,den2,Ts);

%Filterkoeffizienten nach Klatt 1980
C=-exp(-2*pi*B*Ts);
BB=2*exp(-pi*B*Ts)*cos(2*pi*f0*Ts);
A=1-BB-C;


if(nargin<=4)
	y=filter(numz1,denz1,x);
	%y=filter(A,[1 -BB -C],x);
else
	y=time_filter_simple(numz1,denz1,x,U,O,numz2,denz2);
end
% Alternativ
%G=tf(numz,denz,Ts);
%y=lsim(G,x);
