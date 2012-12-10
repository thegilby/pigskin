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

dates=
pdt
oct 21
oct 28
pst
nov 04
nov 11
nov 18
nov 25
dec 02

times
(time >= 'sun oct 21 09:00:00 pdt 2012' AND time <= 'sun oct 21 23:59:59 pdt 2012') OR (time >= 'sun oct 28 09:00:00 pdt 2012' AND time <= 'sun oct 28 23:59:59 pdt 2012') OR (time >= 'sun nov 04 09:00:00 pst 2012' AND time <= 'sun nov 04 23:59:59 pst 2012') OR (time >= 'sun nov 11 09:00:00 pst 2012' AND time <= 'sun nov 11 23:59:59 pst 2012') OR (time >= 'sun nov 04 09:00:00 pst 2012' AND time <= 'sun nov 04 23:59:59 pst 2012') OR (time >= 'sun nov 25 09:00:00 pst 2012' AND time <= 'sun nov 25 23:59:59 pst 2012') OR (time >= 'sun dec 02 09:00:00 pst 2012' AND time <= 'sun dec 02 23:59:59 pst 2012')
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

week1nfb = FILTER nfb by (time >= 'sun nov 18 09:00:00 pst 2012' AND time <= 'sun nov 18 23:59:59 pst 2012');
week1nfbtweet_ngram = FOREACH week1nfb GENERATE id, time, FLATTEN(org.apache.pig.tutorial.NGramGenerator(tweet)) as ngram;
week1nfbngram_group = GROUP week1nfbtweet_ngram BY ngram;
week1nfbngram_count = FOREACH week1nfbngram_group GENERATE $0 as term, COUNT($1) as count_freq;
week1nfbngram_desc = ORDER week1nfbngram_count BY count_freq DESC;
week1nfbngram_filtered = FILTER week1nfbngram_desc BY (NOT (term matches 'a|able|about|above|abst|accordance|according|accordingly|across|act|actually|added|adj|affected|affecting|affects|after|afterwards|again|against|ah|all|almost|alone|along|already|also|although|always|am|among|amongst|an|and|announce|another|any|anybody|anyhow|anymore|anyone|anything|anyway|anyways|anywhere|apparently|approximately|are|aren|arent|arise|around|as|aside|ask|asking|at|auth|available|away|awfully|b|back|be|became|because|become|becomes|becoming|been|before|beforehand|begin|beginning|beginnings|begins|behind|being|believe|below|beside|besides|between|beyond|biol|both|brief|briefly|but|by|c|ca|came|can|cannot|can\'t|cause|causes|certain|certainly|co|com|come|comes|contain|containing|contains|could|couldnt|d|date|did|didn\'t|different|do|does|doesn\'t|doing|done|don\'t|down|downwards|due|during|e|each|ed|edu|effect|eg|eight|eighty|either|else|elsewhere|end|ending|enough|especially|et|et-al|etc|even|ever|every|everybody|everyone|everything|everywhere|ex|except|f|far|few|ff|fifth|first|five|fix|followed|following|follows|for|former|formerly|forth|found|four|from|further|furthermore|g|gave|get|gets|getting|give|given|gives|giving|go|goes|gone|got|gotten|h|had|happens|hardly|has|hasn\'t|have|haven\'t|having|he|hed|hence|her|here|hereafter|hereby|herein|heres|hereupon|hers|herself|hes|hi|hid|him|himself|his|hither|home|how|howbeit|however|hundred|i|id|ie|if|i\'ll|im|immediate|immediately|importance|important|in|inc|indeed|index|information|instead|into|invention|inward|is|isn\'t|it|itd|it\'ll|its|itself|i\'ve|j|just|k|keep|keeps|kept|kg|km|know|known|knows|l|largely|last|lately|later|latter|latterly|least|less|lest|let|lets|like|liked|likely|line|little|\'ll|look|looking|looks|ltd|m|made|mainly|make|makes|many|may|maybe|me|mean|means|meantime|meanwhile|merely|mg|might|million|miss|ml|more|moreover|most|mostly|mr|mrs|much|mug|must|my|myself|n|na|name|namely|nay|nd|near|nearly|necessarily|necessary|need|needs|neither|never|nevertheless|new|next|nine|ninety|no|nobody|non|none|nonetheless|noone|nor|normally|nos|not|noted|nothing|now|nowhere|o|obtain|obtained|obviously|of|off|often|oh|ok|okay|old|omitted|on|once|one|ones|only|onto|or|ord|other|others|otherwise|ought|our|ours|ourselves|out|outside|over|overall|owing|own|p|page|pages|part|particular|particularly|past|per|perhaps|placed|please|plus|poorly|possible|possibly|potentially|pp|predominantly|present|previously|primarily|probably|promptly|proud|provides|put|q|que|quickly|quite|qv|r|ran|rather|rd|re|readily|really|recent|recently|ref|refs|regarding|regardless|regards|related|relatively|research|respectively|resulted|resulting|results|right|run|s|said|same|saw|say|saying|says|sec|section|see|seeing|seem|seemed|seeming|seems|seen|self|selves|sent|seven|several|shall|she|shed|she\'ll|shes|should|shouldn\'t|show|showed|shown|showns|shows|significant|significantly|similar|similarly|since|six|slightly|so|some|somebody|somehow|someone|somethan|something|sometime|sometimes|somewhat|somewhere|soon|sorry|specifically|specified|specify|specifying|still|stop|strongly|sub|substantially|successfully|such|sufficiently|suggest|sup|sure|t|take|taken|taking|tell|tends|th|than|thank|thanks|thanx|that|that\'ll|thats|that\'ve|the|their|theirs|them|themselves|then|thence|there|thereafter|thereby|thered|therefore|therein|there\'ll|thereof|therere|theres|thereto|thereupon|there\'ve|these|they|theyd|they\'ll|theyre|they\'ve|think|this|those|thou|though|thoughh|thousand|throug|through|throughout|thru|thus|til|tip|to|together|too|took|toward|towards|tried|tries|truly|try|trying|ts|twice|two|u|un|under|unfortunately|unless|unlike|unlikely|until|unto|up|upon|ups|us|use|used|useful|usefully|usefulness|uses|using|usually|v|value|various|\'ve|very|via|viz|vol|vols|vs|w|want|wants|was|wasn\'t|way|we|wed|welcome|we\'ll|went|were|weren\'t|we\'ve|what|whatever|what\'ll|whats|when|whence|whenever|where|whereafter|whereas|whereby|wherein|wheres|whereupon|wherever|whether|which|while|whim|whither|who|whod|whoever|whole|who\'ll|whom|whomever|whos|whose|why|widely|willing|wish|with|within|without|won\'t|words|world|would|wouldn\'t|www|x|y|yes|yet|you|youd|you\'ll|your|youre|yours|yourself|yourselves|you\'ve|z|zero|rt|t|te|http|que|y|i m|d|que te|don t|t co|s|de|m|la|u|o|lo|ya|es|se|in the|too|en|http t|_|le|i ll|el|3|it s|lol|fuck|shit|damn|nigger|si|yo|can t|por|today|night|tomorrow|gonna|para|ve|that s|da|los|como|1|una|eu|las|pero|5|mas|don|mi|con|you re|ll|tu'));
week1nfb_tot = GROUP week1nfbngram_filtered ALL;
week1nfb_tot_count = FOREACH week1nfb_tot GENERATE COUNT($1) as tot_count;
week1nfb_cross = CROSS week1nfbngram_filtered, week1nfb_tot_count;
week1nfb_fin = FOREACH week1nfb_cross GENERATE $0 as ngram, (float)$1/(float)$2 as proportion;

week1nfbcompare = FILTER nfb by (time >= 'sun oct 21 09:00:00 pdt 2012' AND time <= 'sun oct 21 23:59:59 pdt 2012') OR (time >= 'sun oct 28 09:00:00 pdt 2012' AND time <= 'sun oct 28 23:59:59 pdt 2012') OR (time >= 'sun nov 11 09:00:00 pst 2012' AND time <= 'sun nov 11 23:59:59 pst 2012') OR (time >= 'sun nov 04 09:00:00 pst 2012' AND time <= 'sun nov 04 23:59:59 pst 2012') OR (time >= 'sun nov 25 09:00:00 pst 2012' AND time <= 'sun nov 25 23:59:59 pst 2012') OR (time >= 'sun dec 02 09:00:00 pst 2012' AND time <= 'sun dec 02 23:59:59 pst 2012');
week1nfbcomparetweet_ngram = FOREACH week1nfbcompare GENERATE id, time, FLATTEN(org.apache.pig.tutorial.NGramGenerator(tweet)) as ngram;
week1nfbcomparengram_group = GROUP week1nfbcomparetweet_ngram BY ngram;
week1nfbcomparengram_count = FOREACH week1nfbcomparengram_group GENERATE $0 as term, COUNT($1) as count_freq;
week1nfbcomparengram_desc = ORDER week1nfbcomparengram_count BY count_freq DESC;
week1nfbcomparengram_filtered = FILTER week1nfbcomparengram_desc BY (NOT (term matches 'a|able|about|above|abst|accordance|according|accordingly|across|act|actually|added|adj|affected|affecting|affects|after|afterwards|again|against|ah|all|almost|alone|along|already|also|although|always|am|among|amongst|an|and|announce|another|any|anybody|anyhow|anymore|anyone|anything|anyway|anyways|anywhere|apparently|approximately|are|aren|arent|arise|around|as|aside|ask|asking|at|auth|available|away|awfully|b|back|be|became|because|become|becomes|becoming|been|before|beforehand|begin|beginning|beginnings|begins|behind|being|believe|below|beside|besides|between|beyond|biol|both|brief|briefly|but|by|c|ca|came|can|cannot|can\'t|cause|causes|certain|certainly|co|com|come|comes|contain|containing|contains|could|couldnt|d|date|did|didn\'t|different|do|does|doesn\'t|doing|done|don\'t|down|downwards|due|during|e|each|ed|edu|effect|eg|eight|eighty|either|else|elsewhere|end|ending|enough|especially|et|et-al|etc|even|ever|every|everybody|everyone|everything|everywhere|ex|except|f|far|few|ff|fifth|first|five|fix|followed|following|follows|for|former|formerly|forth|found|four|from|further|furthermore|g|gave|get|gets|getting|give|given|gives|giving|go|goes|gone|got|gotten|h|had|happens|hardly|has|hasn\'t|have|haven\'t|having|he|hed|hence|her|here|hereafter|hereby|herein|heres|hereupon|hers|herself|hes|hi|hid|him|himself|his|hither|home|how|howbeit|however|hundred|i|id|ie|if|i\'ll|im|immediate|immediately|importance|important|in|inc|indeed|index|information|instead|into|invention|inward|is|isn\'t|it|itd|it\'ll|its|itself|i\'ve|j|just|k|keep|keeps|kept|kg|km|know|known|knows|l|largely|last|lately|later|latter|latterly|least|less|lest|let|lets|like|liked|likely|line|little|\'ll|look|looking|looks|ltd|m|made|mainly|make|makes|many|may|maybe|me|mean|means|meantime|meanwhile|merely|mg|might|million|miss|ml|more|moreover|most|mostly|mr|mrs|much|mug|must|my|myself|n|na|name|namely|nay|nd|near|nearly|necessarily|necessary|need|needs|neither|never|nevertheless|new|next|nine|ninety|no|nobody|non|none|nonetheless|noone|nor|normally|nos|not|noted|nothing|now|nowhere|o|obtain|obtained|obviously|of|off|often|oh|ok|okay|old|omitted|on|once|one|ones|only|onto|or|ord|other|others|otherwise|ought|our|ours|ourselves|out|outside|over|overall|owing|own|p|page|pages|part|particular|particularly|past|per|perhaps|placed|please|plus|poorly|possible|possibly|potentially|pp|predominantly|present|previously|primarily|probably|promptly|proud|provides|put|q|que|quickly|quite|qv|r|ran|rather|rd|re|readily|really|recent|recently|ref|refs|regarding|regardless|regards|related|relatively|research|respectively|resulted|resulting|results|right|run|s|said|same|saw|say|saying|says|sec|section|see|seeing|seem|seemed|seeming|seems|seen|self|selves|sent|seven|several|shall|she|shed|she\'ll|shes|should|shouldn\'t|show|showed|shown|showns|shows|significant|significantly|similar|similarly|since|six|slightly|so|some|somebody|somehow|someone|somethan|something|sometime|sometimes|somewhat|somewhere|soon|sorry|specifically|specified|specify|specifying|still|stop|strongly|sub|substantially|successfully|such|sufficiently|suggest|sup|sure|t|take|taken|taking|tell|tends|th|than|thank|thanks|thanx|that|that\'ll|thats|that\'ve|the|their|theirs|them|themselves|then|thence|there|thereafter|thereby|thered|therefore|therein|there\'ll|thereof|therere|theres|thereto|thereupon|there\'ve|these|they|theyd|they\'ll|theyre|they\'ve|think|this|those|thou|though|thoughh|thousand|throug|through|throughout|thru|thus|til|tip|to|together|too|took|toward|towards|tried|tries|truly|try|trying|ts|twice|two|u|un|under|unfortunately|unless|unlike|unlikely|until|unto|up|upon|ups|us|use|used|useful|usefully|usefulness|uses|using|usually|v|value|various|\'ve|very|via|viz|vol|vols|vs|w|want|wants|was|wasn\'t|way|we|wed|welcome|we\'ll|went|were|weren\'t|we\'ve|what|whatever|what\'ll|whats|when|whence|whenever|where|whereafter|whereas|whereby|wherein|wheres|whereupon|wherever|whether|which|while|whim|whither|who|whod|whoever|whole|who\'ll|whom|whomever|whos|whose|why|widely|willing|wish|with|within|without|won\'t|words|world|would|wouldn\'t|www|x|y|yes|yet|you|youd|you\'ll|your|youre|yours|yourself|yourselves|you\'ve|z|zero|rt|t|te|http|que|y|i m|d|que te|don t|t co|s|de|m|la|u|o|lo|ya|es|se|in the|too|en|http t|_|le|i ll|el|3|it s|lol|fuck|shit|damn|nigger|si|yo|can t|por|today|night|tomorrow|gonna|para|ve|that s|da|los|como|1|una|eu|las|pero|5|mas|don|mi|con|you re|ll|tu'));
week1nfbcompare_tot = GROUP week1nfbcomparengram_filtered ALL;
week1nfbcompare_tot_count = FOREACH week1nfbcompare_tot GENERATE COUNT($1) as tot_count;
week1nfbcompare_cross = CROSS week1nfbcomparengram_filtered, week1nfbcompare_tot_count;
week1nfbcompare_fin = FOREACH week1nfbcompare_cross GENERATE $0 as ngram, (float)$1/(float)$2 as proportion;

week1nfbchi1 = JOIN week1nfb_fin BY ngram, week1nfbcompare_fin BY ngram;
week1nfbchi2 = FOREACH week1nfbchi1 GENERATE $0 as words, $1 as o_count, $3 as e_count;
week1nfbchi3 = FILTER week1nfbchi2 BY (o_count > e_count);
week1nfbchi4 = FOREACH week1nfbchi3 GENERATE words, ((o_count-e_count)*(o_count-e_count))/e_count as chi_sq_test;
week1nfbchi4_desc = ORDER week1nfbchi4 BY chi_sq_test DESC;
week1nfbchi4_lim = LIMIT week1nfbchi4_desc 100;
STORE week1nfbchi4_lim INTO 'Trending_terms_NFB_week5' USING PigStorage();

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
week11gnfb = FILTER nfb by (time >= 'sun nov 18 09:00:00 pst 2012' AND time <= 'sun nov 18 23:59:59 pst 2012');
week11gnfbtweet_ngram = FOREACH week11gnfb GENERATE id, time, FLATTEN(org.apache.pig.tutorial.NGramGenerator(tweet)) as ngram;
week11gnfbngram_group = GROUP week11gnfbtweet_ngram BY ngram;
week11gnfbngram_count = FOREACH week11gnfbngram_group GENERATE $0 as term, COUNT($1) as count_freq;
week11gnfbngram_desc = ORDER week11gnfbngram_count BY count_freq DESC;
week11gnfbngram_filtered = FILTER week11gnfbngram_desc BY (NOT (term matches 'a|able|about|above|abst|accordance|according|accordingly|across|act|actually|added|adj|affected|affecting|affects|after|afterwards|again|against|ah|all|almost|alone|along|already|also|although|always|am|among|amongst|an|and|announce|another|any|anybody|anyhow|anymore|anyone|anything|anyway|anyways|anywhere|apparently|approximately|are|aren|arent|arise|around|as|aside|ask|asking|at|auth|available|away|awfully|b|back|be|became|because|become|becomes|becoming|been|before|beforehand|begin|beginning|beginnings|begins|behind|being|believe|below|beside|besides|between|beyond|biol|both|brief|briefly|but|by|c|ca|came|can|cannot|can\'t|cause|causes|certain|certainly|co|com|come|comes|contain|containing|contains|could|couldnt|d|date|did|didn\'t|different|do|does|doesn\'t|doing|done|don\'t|down|downwards|due|during|e|each|ed|edu|effect|eg|eight|eighty|either|else|elsewhere|end|ending|enough|especially|et|et-al|etc|even|ever|every|everybody|everyone|everything|everywhere|ex|except|f|far|few|ff|fifth|first|five|fix|followed|following|follows|for|former|formerly|forth|found|four|from|further|furthermore|g|gave|get|gets|getting|give|given|gives|giving|go|goes|gone|got|gotten|h|had|happens|hardly|has|hasn\'t|have|haven\'t|having|he|hed|hence|her|here|hereafter|hereby|herein|heres|hereupon|hers|herself|hes|hi|hid|him|himself|his|hither|home|how|howbeit|however|hundred|i|id|ie|if|i\'ll|im|immediate|immediately|importance|important|in|inc|indeed|index|information|instead|into|invention|inward|is|isn\'t|it|itd|it\'ll|its|itself|i\'ve|j|just|k|keep|keeps|kept|kg|km|know|known|knows|l|largely|last|lately|later|latter|latterly|least|less|lest|let|lets|like|liked|likely|line|little|\'ll|look|looking|looks|ltd|m|made|mainly|make|makes|many|may|maybe|me|mean|means|meantime|meanwhile|merely|mg|might|million|miss|ml|more|moreover|most|mostly|mr|mrs|much|mug|must|my|myself|n|na|name|namely|nay|nd|near|nearly|necessarily|necessary|need|needs|neither|never|nevertheless|new|next|nine|ninety|no|nobody|non|none|nonetheless|noone|nor|normally|nos|not|noted|nothing|now|nowhere|o|obtain|obtained|obviously|of|off|often|oh|ok|okay|old|omitted|on|once|one|ones|only|onto|or|ord|other|others|otherwise|ought|our|ours|ourselves|out|outside|over|overall|owing|own|p|page|pages|part|particular|particularly|past|per|perhaps|placed|please|plus|poorly|possible|possibly|potentially|pp|predominantly|present|previously|primarily|probably|promptly|proud|provides|put|q|que|quickly|quite|qv|r|ran|rather|rd|re|readily|really|recent|recently|ref|refs|regarding|regardless|regards|related|relatively|research|respectively|resulted|resulting|results|right|run|s|said|same|saw|say|saying|says|sec|section|see|seeing|seem|seemed|seeming|seems|seen|self|selves|sent|seven|several|shall|she|shed|she\'ll|shes|should|shouldn\'t|show|showed|shown|showns|shows|significant|significantly|similar|similarly|since|six|slightly|so|some|somebody|somehow|someone|somethan|something|sometime|sometimes|somewhat|somewhere|soon|sorry|specifically|specified|specify|specifying|still|stop|strongly|sub|substantially|successfully|such|sufficiently|suggest|sup|sure|t|take|taken|taking|tell|tends|th|than|thank|thanks|thanx|that|that\'ll|thats|that\'ve|the|their|theirs|them|themselves|then|thence|there|thereafter|thereby|thered|therefore|therein|there\'ll|thereof|therere|theres|thereto|thereupon|there\'ve|these|they|theyd|they\'ll|theyre|they\'ve|think|this|those|thou|though|thoughh|thousand|throug|through|throughout|thru|thus|til|tip|to|together|too|took|toward|towards|tried|tries|truly|try|trying|ts|twice|two|u|un|under|unfortunately|unless|unlike|unlikely|until|unto|up|upon|ups|us|use|used|useful|usefully|usefulness|uses|using|usually|v|value|various|\'ve|very|via|viz|vol|vols|vs|w|want|wants|was|wasn\'t|way|we|wed|welcome|we\'ll|went|were|weren\'t|we\'ve|what|whatever|what\'ll|whats|when|whence|whenever|where|whereafter|whereas|whereby|wherein|wheres|whereupon|wherever|whether|which|while|whim|whither|who|whod|whoever|whole|who\'ll|whom|whomever|whos|whose|why|widely|willing|wish|with|within|without|won\'t|words|world|would|wouldn\'t|www|x|y|yes|yet|you|youd|you\'ll|your|youre|yours|yourself|yourselves|you\'ve|z|zero|rt|t|te|http|que|y|i m|d|que te|don t|t co|s|de|m|la|u|o|lo|ya|es|se|in the|too|en|http t|_|le|i ll|el|3|it s|lol|fuck|shit|damn|nigger|si|yo|can t|por|today|night|tomorrow|gonna|para|ve|that s|da|los|como|1|una|eu|las|pero|5|mas|don|mi|con|you re|ll|tu'));
week11gnfb_tot = GROUP week11gnfbngram_filtered ALL;
week11gnfb_tot_count = FOREACH week11gnfb_tot GENERATE COUNT($1) as tot_count;
week11gnfb_cross = CROSS week11gnfbngram_filtered, week11gnfb_tot_count;
week11gnfb_fin = FOREACH week11gnfb_cross GENERATE $0 as ngram, (float)$1/(float)$2 as proportion;

week11gnfbchi1 = JOIN week11gnfb_fin BY ngram, week1nfbcompare_fin BY ngram;
week11gnfbchi2 = FOREACH week11gnfbchi1 GENERATE $0 as words, $1 as o_count, $3 as e_count;
week11gnfbchi3 = FILTER week11gnfbchi2 BY (o_count > e_count);
week11gnfbchi4 = FOREACH week11gnfbchi3 GENERATE words, ((o_count-e_count)*(o_count-e_count))/e_count as chi_sq_test;
week11gnfbchi4_desc = ORDER week11gnfbchi4 BY chi_sq_test DESC;
week11gnfbchi4_lim = LIMIT week11gnfbchi4_desc 100;
STORE week11gnfbchi4_lim INTO 'Trending_terms_NFB_week51g' USING PigStorage();

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
week12gnfb = FILTER nfb by (time >= 'sun nov 18 09:00:00 pst 2012' AND time <= 'sun nov 18 23:59:59 pst 2012');
week12gnfbtweet_ngram = FOREACH week12gnfb GENERATE id, time, FLATTEN(org.apache.pig.tutorial.NGramGenerator(tweet)) as ngram;
week12gnfbngram_group = GROUP week12gnfbtweet_ngram BY ngram;
week12gnfbngram_count = FOREACH week12gnfbngram_group GENERATE $0 as term, COUNT($1) as count_freq;
week12gnfbngram_desc = ORDER week12gnfbngram_count BY count_freq DESC;
week12gnfbngram_filtered = FILTER week12gnfbngram_desc BY (NOT (term matches 'a|able|about|above|abst|accordance|according|accordingly|across|act|actually|added|adj|affected|affecting|affects|after|afterwards|again|against|ah|all|almost|alone|along|already|also|although|always|am|among|amongst|an|and|announce|another|any|anybody|anyhow|anymore|anyone|anything|anyway|anyways|anywhere|apparently|approximately|are|aren|arent|arise|around|as|aside|ask|asking|at|auth|available|away|awfully|b|back|be|became|because|become|becomes|becoming|been|before|beforehand|begin|beginning|beginnings|begins|behind|being|believe|below|beside|besides|between|beyond|biol|both|brief|briefly|but|by|c|ca|came|can|cannot|can\'t|cause|causes|certain|certainly|co|com|come|comes|contain|containing|contains|could|couldnt|d|date|did|didn\'t|different|do|does|doesn\'t|doing|done|don\'t|down|downwards|due|during|e|each|ed|edu|effect|eg|eight|eighty|either|else|elsewhere|end|ending|enough|especially|et|et-al|etc|even|ever|every|everybody|everyone|everything|everywhere|ex|except|f|far|few|ff|fifth|first|five|fix|followed|following|follows|for|former|formerly|forth|found|four|from|further|furthermore|g|gave|get|gets|getting|give|given|gives|giving|go|goes|gone|got|gotten|h|had|happens|hardly|has|hasn\'t|have|haven\'t|having|he|hed|hence|her|here|hereafter|hereby|herein|heres|hereupon|hers|herself|hes|hi|hid|him|himself|his|hither|home|how|howbeit|however|hundred|i|id|ie|if|i\'ll|im|immediate|immediately|importance|important|in|inc|indeed|index|information|instead|into|invention|inward|is|isn\'t|it|itd|it\'ll|its|itself|i\'ve|j|just|k|keep|keeps|kept|kg|km|know|known|knows|l|largely|last|lately|later|latter|latterly|least|less|lest|let|lets|like|liked|likely|line|little|\'ll|look|looking|looks|ltd|m|made|mainly|make|makes|many|may|maybe|me|mean|means|meantime|meanwhile|merely|mg|might|million|miss|ml|more|moreover|most|mostly|mr|mrs|much|mug|must|my|myself|n|na|name|namely|nay|nd|near|nearly|necessarily|necessary|need|needs|neither|never|nevertheless|new|next|nine|ninety|no|nobody|non|none|nonetheless|noone|nor|normally|nos|not|noted|nothing|now|nowhere|o|obtain|obtained|obviously|of|off|often|oh|ok|okay|old|omitted|on|once|one|ones|only|onto|or|ord|other|others|otherwise|ought|our|ours|ourselves|out|outside|over|overall|owing|own|p|page|pages|part|particular|particularly|past|per|perhaps|placed|please|plus|poorly|possible|possibly|potentially|pp|predominantly|present|previously|primarily|probably|promptly|proud|provides|put|q|que|quickly|quite|qv|r|ran|rather|rd|re|readily|really|recent|recently|ref|refs|regarding|regardless|regards|related|relatively|research|respectively|resulted|resulting|results|right|run|s|said|same|saw|say|saying|says|sec|section|see|seeing|seem|seemed|seeming|seems|seen|self|selves|sent|seven|several|shall|she|shed|she\'ll|shes|should|shouldn\'t|show|showed|shown|showns|shows|significant|significantly|similar|similarly|since|six|slightly|so|some|somebody|somehow|someone|somethan|something|sometime|sometimes|somewhat|somewhere|soon|sorry|specifically|specified|specify|specifying|still|stop|strongly|sub|substantially|successfully|such|sufficiently|suggest|sup|sure|t|take|taken|taking|tell|tends|th|than|thank|thanks|thanx|that|that\'ll|thats|that\'ve|the|their|theirs|them|themselves|then|thence|there|thereafter|thereby|thered|therefore|therein|there\'ll|thereof|therere|theres|thereto|thereupon|there\'ve|these|they|theyd|they\'ll|theyre|they\'ve|think|this|those|thou|though|thoughh|thousand|throug|through|throughout|thru|thus|til|tip|to|together|too|took|toward|towards|tried|tries|truly|try|trying|ts|twice|two|u|un|under|unfortunately|unless|unlike|unlikely|until|unto|up|upon|ups|us|use|used|useful|usefully|usefulness|uses|using|usually|v|value|various|\'ve|very|via|viz|vol|vols|vs|w|want|wants|was|wasn\'t|way|we|wed|welcome|we\'ll|went|were|weren\'t|we\'ve|what|whatever|what\'ll|whats|when|whence|whenever|where|whereafter|whereas|whereby|wherein|wheres|whereupon|wherever|whether|which|while|whim|whither|who|whod|whoever|whole|who\'ll|whom|whomever|whos|whose|why|widely|willing|wish|with|within|without|won\'t|words|world|would|wouldn\'t|www|x|y|yes|yet|you|youd|you\'ll|your|youre|yours|yourself|yourselves|you\'ve|z|zero|rt|t|te|http|que|y|i m|d|que te|don t|t co|s|de|m|la|u|o|lo|ya|es|se|in the|too|en|http t|_|le|i ll|el|3|it s|lol|fuck|shit|damn|nigger|si|yo|can t|por|today|night|tomorrow|gonna|para|ve|that s|da|los|como|1|una|eu|las|pero|5|mas|don|mi|con|you re|ll|tu'));
week12gnfb_tot = GROUP week12gnfbngram_filtered ALL;
week12gnfb_tot_count = FOREACH week12gnfb_tot GENERATE COUNT($1) as tot_count;
week12gnfb_cross = CROSS week12gnfbngram_filtered, week12gnfb_tot_count;
week12gnfb_fin = FOREACH week12gnfb_cross GENERATE $0 as ngram, (float)$1/(float)$2 as proportion;

week12gnfbchi1 = JOIN week12gnfb_fin BY ngram, week1nfbcompare_fin BY ngram;
week12gnfbchi2 = FOREACH week12gnfbchi1 GENERATE $0 as words, $1 as o_count, $3 as e_count;
week12gnfbchi3 = FILTER week12gnfbchi2 BY (o_count > e_count);
week12gnfbchi4 = FOREACH week12gnfbchi3 GENERATE words, ((o_count-e_count)*(o_count-e_count))/e_count as chi_sq_test;
week12gnfbchi4_desc = ORDER week12gnfbchi4 BY chi_sq_test DESC;
week12gnfbchi4_lim = LIMIT week12gnfbchi4_desc 100;
STORE week12gnfbchi4_lim INTO 'Trending_terms_NFB_week52g' USING PigStorage();

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

week13gnfb = FILTER nfb by (time >= 'sun nov 18 09:00:00 pst 2012' AND time <= 'sun nov 18 23:59:59 pst 2012');
week13gnfbtweet_ngram = FOREACH week13gnfb GENERATE id, time, FLATTEN(org.apache.pig.tutorial.NGramGenerator(tweet)) as ngram;
week13gnfbngram_group = GROUP week13gnfbtweet_ngram BY ngram;
week13gnfbngram_count = FOREACH week13gnfbngram_group GENERATE $0 as term, COUNT($1) as count_freq;
week13gnfbngram_desc = ORDER week13gnfbngram_count BY count_freq DESC;
week13gnfbngram_filtered = FILTER week13gnfbngram_desc BY (NOT (term matches 'a|able|about|above|abst|accordance|according|accordingly|across|act|actually|added|adj|affected|affecting|affects|after|afterwards|again|against|ah|all|almost|alone|along|already|also|although|always|am|among|amongst|an|and|announce|another|any|anybody|anyhow|anymore|anyone|anything|anyway|anyways|anywhere|apparently|approximately|are|aren|arent|arise|around|as|aside|ask|asking|at|auth|available|away|awfully|b|back|be|became|because|become|becomes|becoming|been|before|beforehand|begin|beginning|beginnings|begins|behind|being|believe|below|beside|besides|between|beyond|biol|both|brief|briefly|but|by|c|ca|came|can|cannot|can\'t|cause|causes|certain|certainly|co|com|come|comes|contain|containing|contains|could|couldnt|d|date|did|didn\'t|different|do|does|doesn\'t|doing|done|don\'t|down|downwards|due|during|e|each|ed|edu|effect|eg|eight|eighty|either|else|elsewhere|end|ending|enough|especially|et|et-al|etc|even|ever|every|everybody|everyone|everything|everywhere|ex|except|f|far|few|ff|fifth|first|five|fix|followed|following|follows|for|former|formerly|forth|found|four|from|further|furthermore|g|gave|get|gets|getting|give|given|gives|giving|go|goes|gone|got|gotten|h|had|happens|hardly|has|hasn\'t|have|haven\'t|having|he|hed|hence|her|here|hereafter|hereby|herein|heres|hereupon|hers|herself|hes|hi|hid|him|himself|his|hither|home|how|howbeit|however|hundred|i|id|ie|if|i\'ll|im|immediate|immediately|importance|important|in|inc|indeed|index|information|instead|into|invention|inward|is|isn\'t|it|itd|it\'ll|its|itself|i\'ve|j|just|k|keep|keeps|kept|kg|km|know|known|knows|l|largely|last|lately|later|latter|latterly|least|less|lest|let|lets|like|liked|likely|line|little|\'ll|look|looking|looks|ltd|m|made|mainly|make|makes|many|may|maybe|me|mean|means|meantime|meanwhile|merely|mg|might|million|miss|ml|more|moreover|most|mostly|mr|mrs|much|mug|must|my|myself|n|na|name|namely|nay|nd|near|nearly|necessarily|necessary|need|needs|neither|never|nevertheless|new|next|nine|ninety|no|nobody|non|none|nonetheless|noone|nor|normally|nos|not|noted|nothing|now|nowhere|o|obtain|obtained|obviously|of|off|often|oh|ok|okay|old|omitted|on|once|one|ones|only|onto|or|ord|other|others|otherwise|ought|our|ours|ourselves|out|outside|over|overall|owing|own|p|page|pages|part|particular|particularly|past|per|perhaps|placed|please|plus|poorly|possible|possibly|potentially|pp|predominantly|present|previously|primarily|probably|promptly|proud|provides|put|q|que|quickly|quite|qv|r|ran|rather|rd|re|readily|really|recent|recently|ref|refs|regarding|regardless|regards|related|relatively|research|respectively|resulted|resulting|results|right|run|s|said|same|saw|say|saying|says|sec|section|see|seeing|seem|seemed|seeming|seems|seen|self|selves|sent|seven|several|shall|she|shed|she\'ll|shes|should|shouldn\'t|show|showed|shown|showns|shows|significant|significantly|similar|similarly|since|six|slightly|so|some|somebody|somehow|someone|somethan|something|sometime|sometimes|somewhat|somewhere|soon|sorry|specifically|specified|specify|specifying|still|stop|strongly|sub|substantially|successfully|such|sufficiently|suggest|sup|sure|t|take|taken|taking|tell|tends|th|than|thank|thanks|thanx|that|that\'ll|thats|that\'ve|the|their|theirs|them|themselves|then|thence|there|thereafter|thereby|thered|therefore|therein|there\'ll|thereof|therere|theres|thereto|thereupon|there\'ve|these|they|theyd|they\'ll|theyre|they\'ve|think|this|those|thou|though|thoughh|thousand|throug|through|throughout|thru|thus|til|tip|to|together|too|took|toward|towards|tried|tries|truly|try|trying|ts|twice|two|u|un|under|unfortunately|unless|unlike|unlikely|until|unto|up|upon|ups|us|use|used|useful|usefully|usefulness|uses|using|usually|v|value|various|\'ve|very|via|viz|vol|vols|vs|w|want|wants|was|wasn\'t|way|we|wed|welcome|we\'ll|went|were|weren\'t|we\'ve|what|whatever|what\'ll|whats|when|whence|whenever|where|whereafter|whereas|whereby|wherein|wheres|whereupon|wherever|whether|which|while|whim|whither|who|whod|whoever|whole|who\'ll|whom|whomever|whos|whose|why|widely|willing|wish|with|within|without|won\'t|words|world|would|wouldn\'t|www|x|y|yes|yet|you|youd|you\'ll|your|youre|yours|yourself|yourselves|you\'ve|z|zero|rt|t|te|http|que|y|i m|d|que te|don t|t co|s|de|m|la|u|o|lo|ya|es|se|in the|too|en|http t|_|le|i ll|el|3|it s|lol|fuck|shit|damn|nigger|si|yo|can t|por|today|night|tomorrow|gonna|para|ve|that s|da|los|como|1|una|eu|las|pero|5|mas|don|mi|con|you re|ll|tu'));
week13gnfb_tot = GROUP week13gnfbngram_filtered ALL;
week13gnfb_tot_count = FOREACH week13gnfb_tot GENERATE COUNT($1) as tot_count;
week13gnfb_cross = CROSS week13gnfbngram_filtered, week13gnfb_tot_count;
week13gnfb_fin = FOREACH week13gnfb_cross GENERATE $0 as ngram, (float)$1/(float)$2 as proportion;

week13gnfbchi1 = JOIN week13gnfb_fin BY ngram, week1nfbcompare_fin BY ngram;
week13gnfbchi2 = FOREACH week13gnfbchi1 GENERATE $0 as words, $1 as o_count, $3 as e_count;
week13gnfbchi3 = FILTER week13gnfbchi2 BY (o_count > e_count);
week13gnfbchi4 = FOREACH week13gnfbchi3 GENERATE words, ((o_count-e_count)*(o_count-e_count))/e_count as chi_sq_test;
week13gnfbchi4_desc = ORDER week13gnfbchi4 BY chi_sq_test DESC;
week13gnfbchi4_lim = LIMIT week13gnfbchi4_desc 100;
STORE week13gnfbchi4_lim INTO 'Trending_terms_NFB_week53g' USING PigStorage();

/*
*
* End Week 23GNFB Chi-Square
*
*/