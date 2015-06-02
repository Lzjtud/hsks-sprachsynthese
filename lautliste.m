%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						HAUPTSEMINAR SPRACHSYNTHESE						%
% 								Lautliste 								%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function lauttyp=lautliste(laut)

switch laut
	case 'a'	lauttyp='vokal';
	case 'e'	lauttyp='vokal';
	case 'i'	lauttyp='vokal';
	case 'o'	lauttyp='vokal';
	case 'u'	lauttyp='vokal';
	case 'j'	lauttyp='vokal';
	
	case 'au'	lauttyp='diphthong';
	case 'ei'	lauttyp='diphthong';
	case 'eu'	lauttyp='diphthong';
	case 'ai'	lauttyp='diphthong';
	case 'ie'	lauttyp='diphthong';

	case 'de'	lauttyp='plosiv';
	case 'da'	lauttyp='plosiv';
	case 'do'	lauttyp='plosiv';
	case 'di'	lauttyp='plosiv';
	case 'du'	lauttyp='plosiv';
	case 'be'	lauttyp='plosiv';
	case 'ba'	lauttyp='plosiv';
	case 'bo'	lauttyp='plosiv';
	case 'bi'	lauttyp='plosiv';
	case 'bu'	lauttyp='plosiv';
	case '|a'	lauttyp='plosiv';

	case 't'	lauttyp='plosiv_st';
	case 'p'	lauttyp='plosiv_st';
	case 'k'	lauttyp='plosiv_st';


	case '_'	lauttyp='pause';

	case 'f'	lauttyp='zisch';
	case 's'	lauttyp='zisch';
	case 'sch'	lauttyp='zisch';
	
	case 'n'	lauttyp='nasal';
	case 'm'	lauttyp='nasal';
	
	otherwise 	lauttyp='none';
end
