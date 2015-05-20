%Dateianalyse zur Formantbestimmung

filepath='formant-a-test.txt';
A=dlmread(filepath,'\t',1,0);

mittel=mean(A);

f1=mittel(3);
b1=mittel(4);
f2=mittel(5);
b2=mittel(6);
f3=mittel(7);
b3=mittel(8);