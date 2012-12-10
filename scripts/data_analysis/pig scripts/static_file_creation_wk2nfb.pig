/*
* Name: Jacob Portnoff
* Email: jacob.portnoff@ischool
* Date: 11/4/2012
*/


/*
Total Corpus
Football trending terms
Overall trending terms
Tweets per sec
Football Tweets per sec
Individ Team Trending Terms
Individ Team Tweets per sec


times
(time >= 'sun oct 21 09:00:00 pdt 2012' AND time <= 'sun oct 21 23:59:59 pdt 2012') OR (time >= 'sun oct 28 09:00:00 pdt 2012' AND time <= 'sun oct 28 23:59:59 pdt 2012') OR (time >= 'sun nov 04 09:00:00 pst 2012' AND time <= 'sun nov 04 23:59:59 pst 2012') OR (time >= 'sun nov 11 09:00:00 pst 2012' AND time <= 'sun nov 11 23:59:59 pst 2012') OR (time >= 'sun nov 18 09:00:00 pst 2012' AND time <= 'sun nov 18 23:59:59 pst 2012') OR (time >= 'sun nov 25 09:00:00 pst 2012' AND time <= 'sun nov 25 23:59:59 pst 2012') OR (time >= 'sun dec 02 09:00:00 pst 2012' AND time <= 'sun dec 02 23:59:59 pst 2012')
*/
-- if not on my personal computer, use appropriate directory structure
REGISTER ./tutorial.jar;

--raw = LOAD 'Wdata/indexed_tweets_w1.txt' USING PigStorage('\t') AS (id, time, user, tweet, geoloc, hashes, weight, assoc);
--raw = LOAD 'Wdata/{indexed_tweets_w1.txt,indexed_tweets_w2.txt}' USING PigStorage('\t') AS (id, time, user, tweet, geoloc, hashes, weight, assoc);
raw = LOAD 'Wdata/{indexed_tweets_w1.txt,indexed_tweets_w2.txt,indexed_tweets_w3.txt,indexed_tweets_w4.txt,indexed_tweets_w5.txt,indexed_tweets_w6.txt,indexed_tweets_w7.txt}' USING PigStorage('\t') AS (id, time, user, tweet, geoloc, hashes, weight, assoc);

raw1 = SAMPLE raw 1.0;--0.001;

clean1 = FILTER raw1 BY org.apache.pig.tutorial.NonURLDetector(tweet);
clean1_group = GROUP clean1 ALL;
clean1_count = FOREACH clean1_group GENERATE COUNT($1);

clean11 = FILTER raw1 by tweet matches '[\\u0020-\\u007e]+'; 
fb = FILTER clean11 BY weight > 1;
nfb = FILTER clean11 BY weight <= 1;

/*
*
*  Week 2 NFB Chi-Square
*
*/

week2nfb = FILTER nfb by time >= 'sun oct 28 09:00:00 pdt 2012' AND time <= 'sun oct 28 23:59:59 pdt 2012';
week2nfbtweet_ngram = FOREACH week2nfb GENERATE id, time, FLATTEN(org.apache.pig.tutorial.NGramGenerator(tweet)) as ngram;
week2nfbngram_group = GROUP week2nfbtweet_ngram BY ngram;
week2nfbngram_count = FOREACH week2nfbngram_group GENERATE $0 as term, COUNT($1) as count_freq;
week2nfbngram_desc = ORDER week2nfbngram_count BY count_freq DESC;
week2nfbngram_filtered = FILTER week2nfbngram_desc BY (NOT (term matches 'a|able|about|above|abst|accordance|according|accordingly|across|act|actually|added|adj|affected|affecting|affects|after|afterwards|again|against|ah|all|almost|alone|along|already|also|although|always|am|among|amongst|an|and|announce|another|any|anybody|anyhow|anymore|anyone|anything|anyway|anyways|anywhere|apparently|approximately|are|aren|arent|arise|around|as|aside|ask|asking|at|auth|available|away|awfully|b|back|be|became|because|become|becomes|becoming|been|before|beforehand|begin|beginning|beginnings|begins|behind|being|believe|below|beside|besides|between|beyond|biol|both|brief|briefly|but|by|c|ca|came|can|cannot|can\'t|cause|causes|certain|certainly|co|com|come|comes|contain|containing|contains|could|couldnt|d|date|did|didn\'t|different|do|does|doesn\'t|doing|done|don\'t|down|downwards|due|during|e|each|ed|edu|effect|eg|eight|eighty|either|else|elsewhere|end|ending|enough|especially|et|et-al|etc|even|ever|every|everybody|everyone|everything|everywhere|ex|except|f|far|few|ff|fifth|first|five|fix|followed|following|follows|for|former|formerly|forth|found|four|from|further|furthermore|g|gave|get|gets|getting|give|given|gives|giving|go|goes|gone|got|gotten|h|had|happens|hardly|has|hasn\'t|have|haven\'t|having|he|hed|hence|her|here|hereafter|hereby|herein|heres|hereupon|hers|herself|hes|hi|hid|him|himself|his|hither|home|how|howbeit|however|hundred|i|id|ie|if|i\'ll|im|immediate|immediately|importance|important|in|inc|indeed|index|information|instead|into|invention|inward|is|isn\'t|it|itd|it\'ll|its|itself|i\'ve|j|just|k|keep|keeps|kept|kg|km|know|known|knows|l|largely|last|lately|later|latter|latterly|least|less|lest|let|lets|like|liked|likely|line|little|\'ll|look|looking|looks|ltd|m|made|mainly|make|makes|many|may|maybe|me|mean|means|meantime|meanwhile|merely|mg|might|million|miss|ml|more|moreover|most|mostly|mr|mrs|much|mug|must|my|myself|n|na|name|namely|nay|nd|near|nearly|necessarily|necessary|need|needs|neither|never|nevertheless|new|next|nine|ninety|no|nobody|non|none|nonetheless|noone|nor|normally|nos|not|noted|nothing|now|nowhere|o|obtain|obtained|obviously|of|off|often|oh|ok|okay|old|omitted|on|once|one|ones|only|onto|or|ord|other|others|otherwise|ought|our|ours|ourselves|out|outside|over|overall|owing|own|p|page|pages|part|particular|particularly|past|per|perhaps|placed|please|plus|poorly|possible|possibly|potentially|pp|predominantly|present|previously|primarily|probably|promptly|proud|provides|put|q|que|quickly|quite|qv|r|ran|rather|rd|re|readily|really|recent|recently|ref|refs|regarding|regardless|regards|related|relatively|research|respectively|resulted|resulting|results|right|run|s|said|same|saw|say|saying|says|sec|section|see|seeing|seem|seemed|seeming|seems|seen|self|selves|sent|seven|several|shall|she|shed|she\'ll|shes|should|shouldn\'t|show|showed|shown|showns|shows|significant|significantly|similar|similarly|since|six|slightly|so|some|somebody|somehow|someone|somethan|something|sometime|sometimes|somewhat|somewhere|soon|sorry|specifically|specified|specify|specifying|still|stop|strongly|sub|substantially|successfully|such|sufficiently|suggest|sup|sure|t|take|taken|taking|tell|tends|th|than|thank|thanks|thanx|that|that\'ll|thats|that\'ve|the|their|theirs|them|themselves|then|thence|there|thereafter|thereby|thered|therefore|therein|there\'ll|thereof|therere|theres|thereto|thereupon|there\'ve|these|they|theyd|they\'ll|theyre|they\'ve|think|this|those|thou|though|thoughh|thousand|throug|through|throughout|thru|thus|til|tip|to|together|too|took|toward|towards|tried|tries|truly|try|trying|ts|twice|two|u|un|under|unfortunately|unless|unlike|unlikely|until|unto|up|upon|ups|us|use|used|useful|usefully|usefulness|uses|using|usually|v|value|various|\'ve|very|via|viz|vol|vols|vs|w|want|wants|was|wasn\'t|way|we|wed|welcome|we\'ll|went|were|weren\'t|we\'ve|what|whatever|what\'ll|whats|when|whence|whenever|where|whereafter|whereas|whereby|wherein|wheres|whereupon|wherever|whether|which|while|whim|whither|who|whod|whoever|whole|who\'ll|whom|whomever|whos|whose|why|widely|willing|wish|with|within|without|won\'t|words|world|would|wouldn\'t|www|x|y|yes|yet|you|youd|you\'ll|your|youre|yours|yourself|yourselves|you\'ve|z|zero|rt|t|te|http|que|y|i m|d|que te|don t|t co|s|de|m|la|u|o|lo|ya|es|se|in the|too|en|http t|_|le|i ll|el|3|it s|lol|fuck|shit|damn|nigger|si|yo|can t|por|today|night|tomorrow|gonna|para|ve|that s|da|los|como|1|una|eu|las|pero|5|mas|don|mi|con|you re|ll|tu'));
week2nfb_tot = GROUP week2nfbngram_filtered ALL;
week2nfb_tot_count = FOREACH week2nfb_tot GENERATE COUNT($1) as tot_count;
week2nfb_cross = CROSS week2nfbngram_filtered, week2nfb_tot_count;
week2nfb_fin = FOREACH week2nfb_cross GENERATE $0 as ngram, (float)$1/(float)$2 as proportion;

week2nfbcompare = FILTER nfb by (time >= 'sun oct 21 09:00:00 pdt 2012' AND time <= 'sun oct 21 23:59:59 pdt 2012') OR (time >= 'sun nov 04 09:00:00 pst 2012' AND time <= 'sun nov 04 23:59:59 pst 2012') OR (time >= 'sun nov 11 09:00:00 pst 2012' AND time <= 'sun nov 11 23:59:59 pst 2012') OR (time >= 'sun nov 18 09:00:00 pst 2012' AND time <= 'sun nov 18 23:59:59 pst 2012') OR (time >= 'sun nov 25 09:00:00 pst 2012' AND time <= 'sun nov 25 23:59:59 pst 2012') OR (time >= 'sun dec 02 09:00:00 pst 2012' AND time <= 'sun dec 02 23:59:59 pst 2012');
week2nfbcomparetweet_ngram = FOREACH week2nfbcompare GENERATE id, time, FLATTEN(org.apache.pig.tutorial.NGramGenerator(tweet)) as ngram;
week2nfbcomparengram_group = GROUP week2nfbcomparetweet_ngram BY ngram;
week2nfbcomparengram_count = FOREACH week2nfbcomparengram_group GENERATE $0 as term, COUNT($1) as count_freq;
week2nfbcomparengram_desc = ORDER week2nfbcomparengram_count BY count_freq DESC;
week2nfbcomparengram_filtered = FILTER week2nfbcomparengram_desc BY (NOT (term matches 'a|able|about|above|abst|accordance|according|accordingly|across|act|actually|added|adj|affected|affecting|affects|after|afterwards|again|against|ah|all|almost|alone|along|already|also|although|always|am|among|amongst|an|and|announce|another|any|anybody|anyhow|anymore|anyone|anything|anyway|anyways|anywhere|apparently|approximately|are|aren|arent|arise|around|as|aside|ask|asking|at|auth|available|away|awfully|b|back|be|became|because|become|becomes|becoming|been|before|beforehand|begin|beginning|beginnings|begins|behind|being|believe|below|beside|besides|between|beyond|biol|both|brief|briefly|but|by|c|ca|came|can|cannot|can\'t|cause|causes|certain|certainly|co|com|come|comes|contain|containing|contains|could|couldnt|d|date|did|didn\'t|different|do|does|doesn\'t|doing|done|don\'t|down|downwards|due|during|e|each|ed|edu|effect|eg|eight|eighty|either|else|elsewhere|end|ending|enough|especially|et|et-al|etc|even|ever|every|everybody|everyone|everything|everywhere|ex|except|f|far|few|ff|fifth|first|five|fix|followed|following|follows|for|former|formerly|forth|found|four|from|further|furthermore|g|gave|get|gets|getting|give|given|gives|giving|go|goes|gone|got|gotten|h|had|happens|hardly|has|hasn\'t|have|haven\'t|having|he|hed|hence|her|here|hereafter|hereby|herein|heres|hereupon|hers|herself|hes|hi|hid|him|himself|his|hither|home|how|howbeit|however|hundred|i|id|ie|if|i\'ll|im|immediate|immediately|importance|important|in|inc|indeed|index|information|instead|into|invention|inward|is|isn\'t|it|itd|it\'ll|its|itself|i\'ve|j|just|k|keep|keeps|kept|kg|km|know|known|knows|l|largely|last|lately|later|latter|latterly|least|less|lest|let|lets|like|liked|likely|line|little|\'ll|look|looking|looks|ltd|m|made|mainly|make|makes|many|may|maybe|me|mean|means|meantime|meanwhile|merely|mg|might|million|miss|ml|more|moreover|most|mostly|mr|mrs|much|mug|must|my|myself|n|na|name|namely|nay|nd|near|nearly|necessarily|necessary|need|needs|neither|never|nevertheless|new|next|nine|ninety|no|nobody|non|none|nonetheless|noone|nor|normally|nos|not|noted|nothing|now|nowhere|o|obtain|obtained|obviously|of|off|often|oh|ok|okay|old|omitted|on|once|one|ones|only|onto|or|ord|other|others|otherwise|ought|our|ours|ourselves|out|outside|over|overall|owing|own|p|page|pages|part|particular|particularly|past|per|perhaps|placed|please|plus|poorly|possible|possibly|potentially|pp|predominantly|present|previously|primarily|probably|promptly|proud|provides|put|q|que|quickly|quite|qv|r|ran|rather|rd|re|readily|really|recent|recently|ref|refs|regarding|regardless|regards|related|relatively|research|respectively|resulted|resulting|results|right|run|s|said|same|saw|say|saying|says|sec|section|see|seeing|seem|seemed|seeming|seems|seen|self|selves|sent|seven|several|shall|she|shed|she\'ll|shes|should|shouldn\'t|show|showed|shown|showns|shows|significant|significantly|similar|similarly|since|six|slightly|so|some|somebody|somehow|someone|somethan|something|sometime|sometimes|somewhat|somewhere|soon|sorry|specifically|specified|specify|specifying|still|stop|strongly|sub|substantially|successfully|such|sufficiently|suggest|sup|sure|t|take|taken|taking|tell|tends|th|than|thank|thanks|thanx|that|that\'ll|thats|that\'ve|the|their|theirs|them|themselves|then|thence|there|thereafter|thereby|thered|therefore|therein|there\'ll|thereof|therere|theres|thereto|thereupon|there\'ve|these|they|theyd|they\'ll|theyre|they\'ve|think|this|those|thou|though|thoughh|thousand|throug|through|throughout|thru|thus|til|tip|to|together|too|took|toward|towards|tried|tries|truly|try|trying|ts|twice|two|u|un|under|unfortunately|unless|unlike|unlikely|until|unto|up|upon|ups|us|use|used|useful|usefully|usefulness|uses|using|usually|v|value|various|\'ve|very|via|viz|vol|vols|vs|w|want|wants|was|wasn\'t|way|we|wed|welcome|we\'ll|went|were|weren\'t|we\'ve|what|whatever|what\'ll|whats|when|whence|whenever|where|whereafter|whereas|whereby|wherein|wheres|whereupon|wherever|whether|which|while|whim|whither|who|whod|whoever|whole|who\'ll|whom|whomever|whos|whose|why|widely|willing|wish|with|within|without|won\'t|words|world|would|wouldn\'t|www|x|y|yes|yet|you|youd|you\'ll|your|youre|yours|yourself|yourselves|you\'ve|z|zero|rt|t|te|http|que|y|i m|d|que te|don t|t co|s|de|m|la|u|o|lo|ya|es|se|in the|too|en|http t|_|le|i ll|el|3|it s|lol|fuck|shit|damn|nigger|si|yo|can t|por|today|night|tomorrow|gonna|para|ve|that s|da|los|como|1|una|eu|las|pero|5|mas|don|mi|con|you re|ll|tu'));
week2nfbcompare_tot = GROUP week2nfbcomparengram_filtered ALL;
week2nfbcompare_tot_count = FOREACH week2nfbcompare_tot GENERATE COUNT($1) as tot_count;
week2nfbcompare_cross = CROSS week2nfbcomparengram_filtered, week2nfbcompare_tot_count;
week2nfbcompare_fin = FOREACH week2nfbcompare_cross GENERATE $0 as ngram, (float)$1/(float)$2 as proportion;

week2nfbchi1 = JOIN week2nfb_fin BY ngram, week2nfbcompare_fin BY ngram;
week2nfbchi2 = FOREACH week2nfbchi1 GENERATE $0 as words, $1 as o_count, $3 as e_count;
week2nfbchi3 = FILTER week2nfbchi2 BY (o_count > e_count);
week2nfbchi4 = FOREACH week2nfbchi3 GENERATE words, ((o_count-e_count)*(o_count-e_count))/e_count as chi_sq_test;
week2nfbchi4_desc = ORDER week2nfbchi4 BY chi_sq_test DESC;
week2nfbchi4_lim = LIMIT week2nfbchi4_desc 100;
STORE week2nfbchi4_lim INTO 'Trending_terms_NFB_week2' USING PigStorage();

/*
*
* End Week 2 NFB Chi-Square
*
*/


/*
*
*  Week 21GNFB Chi-Square
*
*/
week21gnfb = FILTER nfb by time >= 'sun oct 28 10:00:00 pdt 2012' AND time <= 'sun oct 28 13:35:00 pdt 2012';
week21gnfbtweet_ngram = FOREACH week21gnfb GENERATE id, time, FLATTEN(org.apache.pig.tutorial.NGramGenerator(tweet)) as ngram;
week21gnfbngram_group = GROUP week21gnfbtweet_ngram BY ngram;
week21gnfbngram_count = FOREACH week21gnfbngram_group GENERATE $0 as term, COUNT($1) as count_freq;
week21gnfbngram_desc = ORDER week21gnfbngram_count BY count_freq DESC;
week21gnfbngram_filtered = FILTER week21gnfbngram_desc BY (NOT (term matches 'a|able|about|above|abst|accordance|according|accordingly|across|act|actually|added|adj|affected|affecting|affects|after|afterwards|again|against|ah|all|almost|alone|along|already|also|although|always|am|among|amongst|an|and|announce|another|any|anybody|anyhow|anymore|anyone|anything|anyway|anyways|anywhere|apparently|approximately|are|aren|arent|arise|around|as|aside|ask|asking|at|auth|available|away|awfully|b|back|be|became|because|become|becomes|becoming|been|before|beforehand|begin|beginning|beginnings|begins|behind|being|believe|below|beside|besides|between|beyond|biol|both|brief|briefly|but|by|c|ca|came|can|cannot|can\'t|cause|causes|certain|certainly|co|com|come|comes|contain|containing|contains|could|couldnt|d|date|did|didn\'t|different|do|does|doesn\'t|doing|done|don\'t|down|downwards|due|during|e|each|ed|edu|effect|eg|eight|eighty|either|else|elsewhere|end|ending|enough|especially|et|et-al|etc|even|ever|every|everybody|everyone|everything|everywhere|ex|except|f|far|few|ff|fifth|first|five|fix|followed|following|follows|for|former|formerly|forth|found|four|from|further|furthermore|g|gave|get|gets|getting|give|given|gives|giving|go|goes|gone|got|gotten|h|had|happens|hardly|has|hasn\'t|have|haven\'t|having|he|hed|hence|her|here|hereafter|hereby|herein|heres|hereupon|hers|herself|hes|hi|hid|him|himself|his|hither|home|how|howbeit|however|hundred|i|id|ie|if|i\'ll|im|immediate|immediately|importance|important|in|inc|indeed|index|information|instead|into|invention|inward|is|isn\'t|it|itd|it\'ll|its|itself|i\'ve|j|just|k|keep|keeps|kept|kg|km|know|known|knows|l|largely|last|lately|later|latter|latterly|least|less|lest|let|lets|like|liked|likely|line|little|\'ll|look|looking|looks|ltd|m|made|mainly|make|makes|many|may|maybe|me|mean|means|meantime|meanwhile|merely|mg|might|million|miss|ml|more|moreover|most|mostly|mr|mrs|much|mug|must|my|myself|n|na|name|namely|nay|nd|near|nearly|necessarily|necessary|need|needs|neither|never|nevertheless|new|next|nine|ninety|no|nobody|non|none|nonetheless|noone|nor|normally|nos|not|noted|nothing|now|nowhere|o|obtain|obtained|obviously|of|off|often|oh|ok|okay|old|omitted|on|once|one|ones|only|onto|or|ord|other|others|otherwise|ought|our|ours|ourselves|out|outside|over|overall|owing|own|p|page|pages|part|particular|particularly|past|per|perhaps|placed|please|plus|poorly|possible|possibly|potentially|pp|predominantly|present|previously|primarily|probably|promptly|proud|provides|put|q|que|quickly|quite|qv|r|ran|rather|rd|re|readily|really|recent|recently|ref|refs|regarding|regardless|regards|related|relatively|research|respectively|resulted|resulting|results|right|run|s|said|same|saw|say|saying|says|sec|section|see|seeing|seem|seemed|seeming|seems|seen|self|selves|sent|seven|several|shall|she|shed|she\'ll|shes|should|shouldn\'t|show|showed|shown|showns|shows|significant|significantly|similar|similarly|since|six|slightly|so|some|somebody|somehow|someone|somethan|something|sometime|sometimes|somewhat|somewhere|soon|sorry|specifically|specified|specify|specifying|still|stop|strongly|sub|substantially|successfully|such|sufficiently|suggest|sup|sure|t|take|taken|taking|tell|tends|th|than|thank|thanks|thanx|that|that\'ll|thats|that\'ve|the|their|theirs|them|themselves|then|thence|there|thereafter|thereby|thered|therefore|therein|there\'ll|thereof|therere|theres|thereto|thereupon|there\'ve|these|they|theyd|they\'ll|theyre|they\'ve|think|this|those|thou|though|thoughh|thousand|throug|through|throughout|thru|thus|til|tip|to|together|too|took|toward|towards|tried|tries|truly|try|trying|ts|twice|two|u|un|under|unfortunately|unless|unlike|unlikely|until|unto|up|upon|ups|us|use|used|useful|usefully|usefulness|uses|using|usually|v|value|various|\'ve|very|via|viz|vol|vols|vs|w|want|wants|was|wasn\'t|way|we|wed|welcome|we\'ll|went|were|weren\'t|we\'ve|what|whatever|what\'ll|whats|when|whence|whenever|where|whereafter|whereas|whereby|wherein|wheres|whereupon|wherever|whether|which|while|whim|whither|who|whod|whoever|whole|who\'ll|whom|whomever|whos|whose|why|widely|willing|wish|with|within|without|won\'t|words|world|would|wouldn\'t|www|x|y|yes|yet|you|youd|you\'ll|your|youre|yours|yourself|yourselves|you\'ve|z|zero|rt|t|te|http|que|y|i m|d|que te|don t|t co|s|de|m|la|u|o|lo|ya|es|se|in the|too|en|http t|_|le|i ll|el|3|it s|lol|fuck|shit|damn|nigger|si|yo|can t|por|today|night|tomorrow|gonna|para|ve|that s|da|los|como|1|una|eu|las|pero|5|mas|don|mi|con|you re|ll|tu'));
week21gnfb_tot = GROUP week21gnfbngram_filtered ALL;
week21gnfb_tot_count = FOREACH week21gnfb_tot GENERATE COUNT($1) as tot_count;
week21gnfb_cross = CROSS week21gnfbngram_filtered, week21gnfb_tot_count;
week21gnfb_fin = FOREACH week21gnfb_cross GENERATE $0 as ngram, (float)$1/(float)$2 as proportion;

week21gnfbchi1 = JOIN week21gnfb_fin BY ngram, week2nfbcompare_fin BY ngram;
week21gnfbchi2 = FOREACH week21gnfbchi1 GENERATE $0 as words, $1 as o_count, $3 as e_count;
week21gnfbchi3 = FILTER week21gnfbchi2 BY (o_count > e_count);
week21gnfbchi4 = FOREACH week21gnfbchi3 GENERATE words, ((o_count-e_count)*(o_count-e_count))/e_count as chi_sq_test;
week21gnfbchi4_desc = ORDER week21gnfbchi4 BY chi_sq_test DESC;
week21gnfbchi4_lim = LIMIT week21gnfbchi4_desc 100;
STORE week21gnfbchi4_lim INTO 'Trending_terms_NFB_week21g' USING PigStorage();

/*
*
* End Week 21GNFB Chi-Square
*
*/

/*
*
*  Week 22GNFB Chi-Square
*
*/
week22gnfb = FILTER nfb by time >= 'sun oct 28 13:25:00 pdt 2012' AND time <= 'sun oct 28 17:05:00 pdt 2012';
week22gnfbtweet_ngram = FOREACH week22gnfb GENERATE id, time, FLATTEN(org.apache.pig.tutorial.NGramGenerator(tweet)) as ngram;
week22gnfbngram_group = GROUP week22gnfbtweet_ngram BY ngram;
week22gnfbngram_count = FOREACH week22gnfbngram_group GENERATE $0 as term, COUNT($1) as count_freq;
week22gnfbngram_desc = ORDER week22gnfbngram_count BY count_freq DESC;
week22gnfbngram_filtered = FILTER week22gnfbngram_desc BY (NOT (term matches 'a|able|about|above|abst|accordance|according|accordingly|across|act|actually|added|adj|affected|affecting|affects|after|afterwards|again|against|ah|all|almost|alone|along|already|also|although|always|am|among|amongst|an|and|announce|another|any|anybody|anyhow|anymore|anyone|anything|anyway|anyways|anywhere|apparently|approximately|are|aren|arent|arise|around|as|aside|ask|asking|at|auth|available|away|awfully|b|back|be|became|because|become|becomes|becoming|been|before|beforehand|begin|beginning|beginnings|begins|behind|being|believe|below|beside|besides|between|beyond|biol|both|brief|briefly|but|by|c|ca|came|can|cannot|can\'t|cause|causes|certain|certainly|co|com|come|comes|contain|containing|contains|could|couldnt|d|date|did|didn\'t|different|do|does|doesn\'t|doing|done|don\'t|down|downwards|due|during|e|each|ed|edu|effect|eg|eight|eighty|either|else|elsewhere|end|ending|enough|especially|et|et-al|etc|even|ever|every|everybody|everyone|everything|everywhere|ex|except|f|far|few|ff|fifth|first|five|fix|followed|following|follows|for|former|formerly|forth|found|four|from|further|furthermore|g|gave|get|gets|getting|give|given|gives|giving|go|goes|gone|got|gotten|h|had|happens|hardly|has|hasn\'t|have|haven\'t|having|he|hed|hence|her|here|hereafter|hereby|herein|heres|hereupon|hers|herself|hes|hi|hid|him|himself|his|hither|home|how|howbeit|however|hundred|i|id|ie|if|i\'ll|im|immediate|immediately|importance|important|in|inc|indeed|index|information|instead|into|invention|inward|is|isn\'t|it|itd|it\'ll|its|itself|i\'ve|j|just|k|keep|keeps|kept|kg|km|know|known|knows|l|largely|last|lately|later|latter|latterly|least|less|lest|let|lets|like|liked|likely|line|little|\'ll|look|looking|looks|ltd|m|made|mainly|make|makes|many|may|maybe|me|mean|means|meantime|meanwhile|merely|mg|might|million|miss|ml|more|moreover|most|mostly|mr|mrs|much|mug|must|my|myself|n|na|name|namely|nay|nd|near|nearly|necessarily|necessary|need|needs|neither|never|nevertheless|new|next|nine|ninety|no|nobody|non|none|nonetheless|noone|nor|normally|nos|not|noted|nothing|now|nowhere|o|obtain|obtained|obviously|of|off|often|oh|ok|okay|old|omitted|on|once|one|ones|only|onto|or|ord|other|others|otherwise|ought|our|ours|ourselves|out|outside|over|overall|owing|own|p|page|pages|part|particular|particularly|past|per|perhaps|placed|please|plus|poorly|possible|possibly|potentially|pp|predominantly|present|previously|primarily|probably|promptly|proud|provides|put|q|que|quickly|quite|qv|r|ran|rather|rd|re|readily|really|recent|recently|ref|refs|regarding|regardless|regards|related|relatively|research|respectively|resulted|resulting|results|right|run|s|said|same|saw|say|saying|says|sec|section|see|seeing|seem|seemed|seeming|seems|seen|self|selves|sent|seven|several|shall|she|shed|she\'ll|shes|should|shouldn\'t|show|showed|shown|showns|shows|significant|significantly|similar|similarly|since|six|slightly|so|some|somebody|somehow|someone|somethan|something|sometime|sometimes|somewhat|somewhere|soon|sorry|specifically|specified|specify|specifying|still|stop|strongly|sub|substantially|successfully|such|sufficiently|suggest|sup|sure|t|take|taken|taking|tell|tends|th|than|thank|thanks|thanx|that|that\'ll|thats|that\'ve|the|their|theirs|them|themselves|then|thence|there|thereafter|thereby|thered|therefore|therein|there\'ll|thereof|therere|theres|thereto|thereupon|there\'ve|these|they|theyd|they\'ll|theyre|they\'ve|think|this|those|thou|though|thoughh|thousand|throug|through|throughout|thru|thus|til|tip|to|together|too|took|toward|towards|tried|tries|truly|try|trying|ts|twice|two|u|un|under|unfortunately|unless|unlike|unlikely|until|unto|up|upon|ups|us|use|used|useful|usefully|usefulness|uses|using|usually|v|value|various|\'ve|very|via|viz|vol|vols|vs|w|want|wants|was|wasn\'t|way|we|wed|welcome|we\'ll|went|were|weren\'t|we\'ve|what|whatever|what\'ll|whats|when|whence|whenever|where|whereafter|whereas|whereby|wherein|wheres|whereupon|wherever|whether|which|while|whim|whither|who|whod|whoever|whole|who\'ll|whom|whomever|whos|whose|why|widely|willing|wish|with|within|without|won\'t|words|world|would|wouldn\'t|www|x|y|yes|yet|you|youd|you\'ll|your|youre|yours|yourself|yourselves|you\'ve|z|zero|rt|t|te|http|que|y|i m|d|que te|don t|t co|s|de|m|la|u|o|lo|ya|es|se|in the|too|en|http t|_|le|i ll|el|3|it s|lol|fuck|shit|damn|nigger|si|yo|can t|por|today|night|tomorrow|gonna|para|ve|that s|da|los|como|1|una|eu|las|pero|5|mas|don|mi|con|you re|ll|tu'));
week22gnfb_tot = GROUP week22gnfbngram_filtered ALL;
week22gnfb_tot_count = FOREACH week22gnfb_tot GENERATE COUNT($1) as tot_count;
week22gnfb_cross = CROSS week22gnfbngram_filtered, week22gnfb_tot_count;
week22gnfb_fin = FOREACH week22gnfb_cross GENERATE $0 as ngram, (float)$1/(float)$2 as proportion;

week22gnfbchi1 = JOIN week22gnfb_fin BY ngram, week2nfbcompare_fin BY ngram;
week22gnfbchi2 = FOREACH week22gnfbchi1 GENERATE $0 as words, $1 as o_count, $3 as e_count;
week22gnfbchi3 = FILTER week22gnfbchi2 BY (o_count > e_count);
week22gnfbchi4 = FOREACH week22gnfbchi3 GENERATE words, ((o_count-e_count)*(o_count-e_count))/e_count as chi_sq_test;
week22gnfbchi4_desc = ORDER week22gnfbchi4 BY chi_sq_test DESC;
week22gnfbchi4_lim = LIMIT week22gnfbchi4_desc 100;
STORE week22gnfbchi4_lim INTO 'Trending_terms_NFB_week22g' USING PigStorage();

/*
*
* End Week 22GNFB Chi-Square
*
*/

/*
*
*  Week 23GNFB Chi-Square
*
*/

week23gnfb = FILTER nfb by time >= 'sun oct 28 17:30:00 pdt 2012' AND time <= 'sun oct 28 21:05:00 pdt 2012';
week23gnfbtweet_ngram = FOREACH week23gnfb GENERATE id, time, FLATTEN(org.apache.pig.tutorial.NGramGenerator(tweet)) as ngram;
week23gnfbngram_group = GROUP week23gnfbtweet_ngram BY ngram;
week23gnfbngram_count = FOREACH week23gnfbngram_group GENERATE $0 as term, COUNT($1) as count_freq;
week23gnfbngram_desc = ORDER week23gnfbngram_count BY count_freq DESC;
week23gnfbngram_filtered = FILTER week23gnfbngram_desc BY (NOT (term matches 'a|able|about|above|abst|accordance|according|accordingly|across|act|actually|added|adj|affected|affecting|affects|after|afterwards|again|against|ah|all|almost|alone|along|already|also|although|always|am|among|amongst|an|and|announce|another|any|anybody|anyhow|anymore|anyone|anything|anyway|anyways|anywhere|apparently|approximately|are|aren|arent|arise|around|as|aside|ask|asking|at|auth|available|away|awfully|b|back|be|became|because|become|becomes|becoming|been|before|beforehand|begin|beginning|beginnings|begins|behind|being|believe|below|beside|besides|between|beyond|biol|both|brief|briefly|but|by|c|ca|came|can|cannot|can\'t|cause|causes|certain|certainly|co|com|come|comes|contain|containing|contains|could|couldnt|d|date|did|didn\'t|different|do|does|doesn\'t|doing|done|don\'t|down|downwards|due|during|e|each|ed|edu|effect|eg|eight|eighty|either|else|elsewhere|end|ending|enough|especially|et|et-al|etc|even|ever|every|everybody|everyone|everything|everywhere|ex|except|f|far|few|ff|fifth|first|five|fix|followed|following|follows|for|former|formerly|forth|found|four|from|further|furthermore|g|gave|get|gets|getting|give|given|gives|giving|go|goes|gone|got|gotten|h|had|happens|hardly|has|hasn\'t|have|haven\'t|having|he|hed|hence|her|here|hereafter|hereby|herein|heres|hereupon|hers|herself|hes|hi|hid|him|himself|his|hither|home|how|howbeit|however|hundred|i|id|ie|if|i\'ll|im|immediate|immediately|importance|important|in|inc|indeed|index|information|instead|into|invention|inward|is|isn\'t|it|itd|it\'ll|its|itself|i\'ve|j|just|k|keep|keeps|kept|kg|km|know|known|knows|l|largely|last|lately|later|latter|latterly|least|less|lest|let|lets|like|liked|likely|line|little|\'ll|look|looking|looks|ltd|m|made|mainly|make|makes|many|may|maybe|me|mean|means|meantime|meanwhile|merely|mg|might|million|miss|ml|more|moreover|most|mostly|mr|mrs|much|mug|must|my|myself|n|na|name|namely|nay|nd|near|nearly|necessarily|necessary|need|needs|neither|never|nevertheless|new|next|nine|ninety|no|nobody|non|none|nonetheless|noone|nor|normally|nos|not|noted|nothing|now|nowhere|o|obtain|obtained|obviously|of|off|often|oh|ok|okay|old|omitted|on|once|one|ones|only|onto|or|ord|other|others|otherwise|ought|our|ours|ourselves|out|outside|over|overall|owing|own|p|page|pages|part|particular|particularly|past|per|perhaps|placed|please|plus|poorly|possible|possibly|potentially|pp|predominantly|present|previously|primarily|probably|promptly|proud|provides|put|q|que|quickly|quite|qv|r|ran|rather|rd|re|readily|really|recent|recently|ref|refs|regarding|regardless|regards|related|relatively|research|respectively|resulted|resulting|results|right|run|s|said|same|saw|say|saying|says|sec|section|see|seeing|seem|seemed|seeming|seems|seen|self|selves|sent|seven|several|shall|she|shed|she\'ll|shes|should|shouldn\'t|show|showed|shown|showns|shows|significant|significantly|similar|similarly|since|six|slightly|so|some|somebody|somehow|someone|somethan|something|sometime|sometimes|somewhat|somewhere|soon|sorry|specifically|specified|specify|specifying|still|stop|strongly|sub|substantially|successfully|such|sufficiently|suggest|sup|sure|t|take|taken|taking|tell|tends|th|than|thank|thanks|thanx|that|that\'ll|thats|that\'ve|the|their|theirs|them|themselves|then|thence|there|thereafter|thereby|thered|therefore|therein|there\'ll|thereof|therere|theres|thereto|thereupon|there\'ve|these|they|theyd|they\'ll|theyre|they\'ve|think|this|those|thou|though|thoughh|thousand|throug|through|throughout|thru|thus|til|tip|to|together|too|took|toward|towards|tried|tries|truly|try|trying|ts|twice|two|u|un|under|unfortunately|unless|unlike|unlikely|until|unto|up|upon|ups|us|use|used|useful|usefully|usefulness|uses|using|usually|v|value|various|\'ve|very|via|viz|vol|vols|vs|w|want|wants|was|wasn\'t|way|we|wed|welcome|we\'ll|went|were|weren\'t|we\'ve|what|whatever|what\'ll|whats|when|whence|whenever|where|whereafter|whereas|whereby|wherein|wheres|whereupon|wherever|whether|which|while|whim|whither|who|whod|whoever|whole|who\'ll|whom|whomever|whos|whose|why|widely|willing|wish|with|within|without|won\'t|words|world|would|wouldn\'t|www|x|y|yes|yet|you|youd|you\'ll|your|youre|yours|yourself|yourselves|you\'ve|z|zero|rt|t|te|http|que|y|i m|d|que te|don t|t co|s|de|m|la|u|o|lo|ya|es|se|in the|too|en|http t|_|le|i ll|el|3|it s|lol|fuck|shit|damn|nigger|si|yo|can t|por|today|night|tomorrow|gonna|para|ve|that s|da|los|como|1|una|eu|las|pero|5|mas|don|mi|con|you re|ll|tu'));
week23gnfb_tot = GROUP week23gnfbngram_filtered ALL;
week23gnfb_tot_count = FOREACH week23gnfb_tot GENERATE COUNT($1) as tot_count;
week23gnfb_cross = CROSS week23gnfbngram_filtered, week23gnfb_tot_count;
week23gnfb_fin = FOREACH week23gnfb_cross GENERATE $0 as ngram, (float)$1/(float)$2 as proportion;

week23gnfbchi1 = JOIN week23gnfb_fin BY ngram, week2nfbcompare_fin BY ngram;
week23gnfbchi2 = FOREACH week23gnfbchi1 GENERATE $0 as words, $1 as o_count, $3 as e_count;
week23gnfbchi3 = FILTER week23gnfbchi2 BY (o_count > e_count);
week23gnfbchi4 = FOREACH week23gnfbchi3 GENERATE words, ((o_count-e_count)*(o_count-e_count))/e_count as chi_sq_test;
week23gnfbchi4_desc = ORDER week23gnfbchi4 BY chi_sq_test DESC;
week23gnfbchi4_lim = LIMIT week23gnfbchi4_desc 100;
STORE week23gnfbchi4_lim INTO 'Trending_terms_NFB_week23g' USING PigStorage();

/*
*
* End Week 23GNFB Chi-Square
*
*/