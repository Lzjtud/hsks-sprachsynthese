%# Bandpassfilterung mit Bandpass 2. Ordnung
%# y=formantfilter(x,Ts,f0)
%# y=formantfilter(x,Ts,f0,B)
function y=formantfilter(x,Ts,f0,B1,f2,U,O,B2)

if (nargin==3) B1=150; end	%default bandwidth
if (nargin<=4) f2=f0; end	%default second frequency
if (nargin<=5) U=1; end		%default kein Übergang
if (nargin<=6) O=1; end		%default kein offset
if (nargin<=7) B2=B1;end	%default bandwidth 2


w0=2*pi*f0; %Mittenkreisfrequenz
w2=2*pi*f2; 
Q1=f0/B1;		%Guete Q=f0/B1
Q2=f0/B2;		%Guete Q=f0/B1
%Bandpass 2. Ordnung
num=[w0/Q1 0];
den=[1 w0/Q1 w0^2];
num2=[w2/Q2 0];
den2=[1 w2/Q2 w2^2];
[numz1,denz1]=bilinear(num,den,Ts);
[numz2,denz2]=bilinear(num2,den2,Ts);

%Filterkoeffizienten nach Klatt 1980
C=-exp(-2*pi*B1*Ts);
BB=2*exp(-pi*B1*Ts)*cos(2*pi*f0*Ts);
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
