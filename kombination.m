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
while charnum <= wordlength
	buchstabe=word(charnum);	%aktueller Buchstabe
	fprintf('Der %d. Laut ist:%c\n',charnum,buchstabe);
	
	
%%%%%	LAUTTYP BESTIMMEN	%%%%%
	if(length(word)>=charnum+1)			%Pruefen ob aufeinanderfolgende Laute zusammengehoeren
		lauttyp=lautliste(word(charnum:charnum+1));
		disp(lauttyp);
	else
		lauttyp=lautliste(buchstabe);	%Einzelbuchstaben am Ende
	end	
	
	if(strcmp(lauttyp,'none'))			%Keine Kombination der Laute gefunden
		lauttyp=lautliste(buchstabe);
	end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	
%%%%%	SOUND ERZEUGEN	%%%%%
	phonemelength_end = phonemelength;	%%kann länger werden bei diphton		direktes Anpassen mittels schleife/switch-case nach laenge des lautes (z.B. 3 bei sch, 2 bei ch)
charnum_temp=0; %temporäre Charnum	
	switch lauttyp					
		case 'diphthong'
			phonemelength_end = 2*phonemelength;
			sound=diphthong({word(charnum:charnum+1)},phonemelength_end,fs);				%Buchstabe, Zeitdauer (Samples*Samplingtime), Samplingfreq
			charnum_temp = charnum +2;%diphtong hat 2 Buchstaben		
		case 'vokal'
			sound=stimmhaft(buchstabe,phonemelength,fs);					%Buchstabe, Zeitdauer (Samples*Samplingtime), Samplingfreq
			charnum_temp = charnum +1;%vokal hat 1 Buchstaben			
		case 'zisch'
			sound=zischlaut(buchstabe,phonemelength,fs);					%Buchstabe, Zeitdauer (Samples*Samplingtime), Samplingfreq
			charnum_temp = charnum +1;%diphtong hat x Buchstaben(zurzeit nur 1 implementiert)
		case 'plosiv'
			phonemelength_end = phonemelength*1.5 + 0.083;
			sound=plosiv(word(charnum:charnum+1),phonemelength*1.5,fs);
			sound=[zeros(1,floor(0.083*fs)) sound];
			charnum_temp = charnum +2;%plosiv hat 2
		case 'pause'
			sound=zeros(1,phonemesamples);
			charnum_temp = charnum +1;%pause hat 1
			phonemelength_end = phonemelength;
	end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
phonemesamples_end=floor(phonemelength_end*fs);	

	
%%%%%	FENSTERUNG	%%%%%
	
	wind=tukeywin(phonemesamples_end,alpha);								%Window (Samples)
	sound_out = sound.*wind';										%Fenstern des Lautes
	if(max(sound_out) != 0) sound_out = sound_out/max(sound_out); end	%Normierung
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%	Laut hinzufuegen	%%%%%
	if (charnum == 1)		%Erster Laut
		final_out(1:phonemesamples_end) = sound_out(1:phonemesamples_end);
		anfang = phonemesamples_end-int32((alpha*(phonemesamples_end-1)/2))+1;	%Anfang des naechsten Lauts
	else
		ende = anfang + phonemesamples_end-1;
		disp(anfang);
		disp(ende);
		disp(charnum);
		final_out(anfang:ende) = final_out(anfang:ende) + sound_out(1:phonemesamples_end);	
		anfang = anfang + phonemesamples_end-int32((alpha*(phonemesamples-1)/2)); 	
	end
	charnum = charnum_temp;
end

wavwrite(final_out'/max(final_out),fs,outputname);
