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
	case 'ae'	lauttyp='vokal';
	case 'oe'	lauttyp='vokal';	
	case 'ue'	lauttyp='vokal';

	case 'r'	lauttyp='vibrant';

	case 'au'	lauttyp='diphthong';
	case 'ei'	lauttyp='diphthong';
	case 'eu'	lauttyp='diphthong';
	case 'ai'	lauttyp='diphthong';
	case 'oi'	lauttyo='diphthong';
	case 'ie'	lauttyp='diphthong';
	case 'ui'	lauttyp='diphthong';
	case 'ea'	lauttyp='diphthong';

	case 'da'	lauttyp='plosiv';
	case 'de'	lauttyp='plosiv';
	case 'di'	lauttyp='plosiv';
	case 'do'	lauttyp='plosiv';
	case 'du'	lauttyp='plosiv';

	case 'ba'	lauttyp='plosiv';	
	case 'be'	lauttyp='plosiv';
	case 'bi'	lauttyp='plosiv';
	case 'bo'	lauttyp='plosiv';
	case 'bu'	lauttyp='plosiv';

	case 'ga'	lauttyp='plosiv';
	case 'ge'	lauttyp='plosiv';
	case 'gi'	lauttyp='plosiv';	
	case 'go'	lauttyp='plosiv';
	case 'gu'	lauttyp='plosiv';

	case 't'	lauttyp='plosiv_st';
	case 'p'	lauttyp='plosiv_st';
	case 'k'	lauttyp='plosiv_st';

	case '_'	lauttyp='pause';

	case 'f'	lauttyp='zisch';
	case 's'	lauttyp='zisch';
	case 'sch'	lauttyp='zisch';
	%case 'z'	lauttyp='zisch';
	case 'ch'	lauttyp='zisch';
	
	case 'n'	lauttyp='nasal';
	case 'm'	lauttyp='nasal';
	
	case 'l'	lauttyp='linquidl';
	
	case 'w'	lauttyp='fricationw';
	
	otherwise 	lauttyp='none';
end
