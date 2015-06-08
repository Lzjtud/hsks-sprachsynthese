%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%			HAUPSEMINAR KOMMUNIKATIONSSYSTEME SPRACHSYNTHESE		%%%%%
%%%%%					Kombination von Lauten							%%%%%
%%%%%							Mai 2015								%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%							 PARAMETER 								%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
phonemelength = .23;	%Laenge in sec
alpha = 0.9;			%%alpha for tukey window
ver =	int32((alpha*(phonemelength-1)/2));		%verbindungsfaktor 
fs=44100;
phonemesamples=floor(phonemelength*fs);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%							READ WORD								%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Bitte geben sie ein Wort ein, dass gesprochen werden soll:');
word = scanf('%s','C');
outputname = strcat(word , '.wav');
disp ('Das eingegebene Wort lautet:'), disp (word);
wordlength = length(word);	%spaeter runter nach der zerteilung des worts
disp ('und hat die laenge:'),disp (wordlength);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%							MANIPULATE WORD							%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
word = tolower(word);	%Aussprache interresiert Groß- und Kleinschreibung nicht
%...Fallunterscheidungen, Lautpaare, ...
%neues cellarray, was laute beinhaltet
%word cellarray, wordlength=numel(word)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%							SYNTHESIZE WORD							%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
final_out = zeros(1,wordlength*phonemesamples);	%%Vector,wo am ende alle Werte hineinkommen ggf. noch - ver
anfang = 0;
ende = 0;
charnum = 1;
num_laut = 1;	%%Welcher Laut wird jetzt generiert
while charnum <= wordlength
	buchstabe=word(charnum);	%aktueller Buchstabe

	
	
%%%%%	LAUTTYP BESTIMMEN	%%%%%
max_size=3;%Maximale Lautgröße, wird dann auf aktuelle angepasst
lauttyp = 'none';
  while(strcmp(lauttyp,'none'))
	if(max_size >= 0)
		max_size = max_size - 1;
	else
		lauttyp='Fail!';		%es wurde kein Laut gefunden!!!!
		disp('FAIL!!! Es wurde kein Lauttyp gefunden!!!');
		return;
	end	
	if(length(word)>=charnum+max_size)			%Pruefen ob aufeinanderfolgende Laute zusammengehoeren
		%disp(char(word(charnum:charnum+max_size)));	
		lauttyp=lautliste(word(charnum:charnum+max_size));
		%disp(lauttyp);
	end	
  end
	fprintf('Der %d. Laut ist:%s\n',num_laut,word(charnum:charnum+max_size));
	num_laut=num_laut+1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	
%%%%%	SOUND ERZEUGEN	%%%%%
charnum_temp=0; %temporäre Charnum
window = 1;		%soll noch gefenster werden?	
	switch lauttyp					
		case 'diphthong'
			sound=diphthong({word(charnum:charnum+1)},2*phonemelength,fs);			%Buchstabe, Zeitdauer (Samples*Samplingtime), Samplingfreq
			charnum_temp = charnum +2;												%diphtong hat 2 Buchstaben		
		case 'vokal'
			sound=stimmhaft({word(charnum:charnum+max_size)},phonemelength,fs);							%Buchstabe, Zeitdauer (Samples*Samplingtime), Samplingfreq
			charnum_temp = charnum +1;												%vokal hat 1 Buchstaben		
		case 'vibrant'
			sound=vibrant({word(charnum:charnum+max_size)},phonemelength,fs);							%Buchstabe, Zeitdauer (Samples*Samplingtime), Samplingfreq
			charnum_temp = charnum +1;												%vibrant hat 1 Buchstaben			
		case 'zisch'
			sound=zischlaut({word(charnum:charnum+max_size)},phonemelength,fs);		%Buchstabe, Zeitdauer (Samples*Samplingtime), Samplingfreq
			charnum_temp = charnum +max_size+1;										%Zisch hat x Buchstaben
		case 'plosiv'
			sound=plosiv(word(charnum:charnum+1),phonemelength*1.5,fs);
			sound=[zeros(1,floor(0.083*fs)) sound];
			charnum_temp = charnum +2;												%plosiv hat 2 Buchstaben
		case 'plosiv_st'
			sound=plosiv_stimmlos(word(charnum),phonemelength,fs);
			charnum_temp = charnum + 1;
			sound=[zeros(1,floor(0.1*fs)) sound];
			window = 0;		
		case 'pause'
			sound=zeros(1,phonemesamples*1.2);
			charnum_temp = charnum +1;												%pause hat 1
		case 'nasal'
			sound=nasal(word(charnum),phonemelength,fs);
			charnum_temp = charnum +1;
	end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
phonemesamples_end=numel(sound);	

	
%%%%%	FENSTERUNG	%%%%%
	
	wind=tukeywin(numel(sound),alpha);								%Window (Samples)
	sound_out = sound.*wind';										%Fenstern des Lautes
	if(max(sound_out) != 0) if(window == 1) sound_out = sound_out/max(sound_out); end end	%Normierung
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%	Laut hinzufuegen	%%%%%
	if (charnum == 1)		%Erster Laut
		final_out(1:phonemesamples_end) = sound_out(1:phonemesamples_end);
		anfang = phonemesamples_end-int32((alpha*(phonemesamples_end-1)/2))+1;	%Anfang des naechsten Lauts
	else
		ende = anfang + phonemesamples_end-1;
		%disp(anfang);
		%disp(ende);
		%disp(charnum);
		final_out(anfang:ende) = final_out(anfang:ende) + sound_out(1:phonemesamples_end);	
		anfang = anfang + phonemesamples_end-int32((alpha*(phonemesamples-1)/2)); 	
	end
	charnum = charnum_temp;
end

wavwrite(final_out'/max(final_out),fs,outputname);
