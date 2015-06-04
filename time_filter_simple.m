%# Filterung mittels IIR Filter
%FILTER 1 mit a1 und b1 geht in U zu FILTER 2 mit a2 und b2 über
%ACHTUNG BEDINGUNG IST, DASS a1 und a2, sowie b1 UND b2 gleich lang sind
%O ist der offset, nachdem der erst anfängt
function y=time_filter_simple(b1,a1,x,U,O,b2,a2)

a=a1;
b=b1;
ta=220;	%%aktualisierungszeit in abtastwerten
result_vec = zeros(1,length(x));  %%Ergebnisvektor
M = length(b) -1;
N = length(a) -1;


for counter = 1:1:length(x)
	condition = (counter<=O+U) && (counter >= O) && (mod(counter,ta) == 0);
	if condition	
		a=(a1*(U+O-counter)+a2*(counter-O))/U;
		b=(b1*(U+O-counter)+b2*(counter-O))/U;
	end

	endM = min(M,counter-1);	
	V1=1:1:(endM+1);
	V2=counter:(-1):counter-endM;
	result_1 = b(V1)*x(V2)';

	endN = min(N,counter-1);
	V1=2:1:(endN+1);
	V2=(counter-1):(-1):(counter-endN);
	result_2=a(V1)*result_vec(V2)';

	result_vec(counter)=(result_1-result_2)/a(1);
end
y=result_vec;

