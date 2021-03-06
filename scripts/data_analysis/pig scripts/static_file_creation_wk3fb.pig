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
*  Week 2 FB Chi-Square
*
*/

week1fb = FILTER fb by (time >= 'sun nov 04 09:00:00 pst 2012' AND time <= 'sun nov 04 23:59:59 pst 2012');
week1fbtweet_ngram = FOREACH week1fb GENERATE id, time, FLATTEN(org.apache.pig.tutorial.NGramGenerator(tweet)) as ngram;
week1fbngram_group = GROUP week1fbtweet_ngram BY ngram;
week1fbngram_count = FOREACH week1fbngram_group GENERATE $0 as term, COUNT($1) as count_freq;
week1fbngram_desc = ORDER week1fbngram_count BY count_freq DESC;
week1fbngram_filtered = FILTER week1fbngram_desc BY (NOT (term matches 'a|able|about|above|abst|accordance|according|accordingly|across|act|actually|added|adj|affected|affecting|affects|after|afterwards|again|against|ah|all|almost|alone|along|already|also|although|always|am|among|amongst|an|and|announce|another|any|anybody|anyhow|anymore|anyone|anything|anyway|anyways|anywhere|apparently|approximately|are|aren|arent|arise|around|as|aside|ask|asking|at|auth|available|away|awfully|b|back|be|became|because|become|becomes|becoming|been|before|beforehand|begin|beginning|beginnings|begins|behind|being|believe|below|beside|besides|between|beyond|biol|both|brief|briefly|but|by|c|ca|came|can|cannot|can\'t|cause|causes|certain|certainly|co|com|come|comes|contain|containing|contains|could|couldnt|d|date|did|didn\'t|different|do|does|doesn\'t|doing|done|don\'t|down|downwards|due|during|e|each|ed|edu|effect|eg|eight|eighty|either|else|elsewhere|end|ending|enough|especially|et|et-al|etc|even|ever|every|everybody|everyone|everything|everywhere|ex|except|f|far|few|ff|fifth|first|five|fix|followed|following|follows|for|former|formerly|forth|found|four|from|further|furthermore|g|gave|get|gets|getting|give|given|gives|giving|go|goes|gone|got|gotten|h|had|happens|hardly|has|hasn\'t|have|haven\'t|having|he|hed|hence|her|here|hereafter|hereby|herein|heres|hereupon|hers|herself|hes|hi|hid|him|himself|his|hither|home|how|howbeit|however|hundred|i|id|ie|if|i\'ll|im|immediate|immediately|importance|important|in|inc|indeed|index|information|instead|into|invention|inward|is|isn\'t|it|itd|it\'ll|its|itself|i\'ve|j|just|k|keep|keeps|kept|kg|km|know|known|knows|l|largely|last|lately|later|latter|latterly|least|less|lest|let|lets|like|liked|likely|line|little|\'ll|look|looking|looks|ltd|m|made|mainly|make|makes|many|may|maybe|me|mean|means|meantime|meanwhile|merely|mg|might|million|miss|ml|more|moreover|most|mostly|mr|mrs|much|mug|must|my|myself|n|na|name|namely|nay|nd|near|nearly|necessarily|necessary|need|needs|neither|never|nevertheless|new|next|nine|ninety|no|nobody|non|none|nonetheless|noone|nor|normally|nos|not|noted|nothing|now|nowhere|o|obtain|obtained|obviously|of|off|often|oh|ok|okay|old|omitted|on|once|one|ones|only|onto|or|ord|other|others|otherwise|ought|our|ours|ourselves|out|outside|over|overall|owing|own|p|page|pages|part|particular|particularly|past|per|perhaps|placed|please|plus|poorly|possible|possibly|potentially|pp|predominantly|present|previously|primarily|probably|promptly|proud|provides|put|q|que|quickly|quite|qv|r|ran|rather|rd|re|readily|really|recent|recently|ref|refs|regarding|regardless|regards|related|relatively|research|respectively|resulted|resulting|results|right|run|s|said|same|saw|say|saying|says|sec|section|see|seeing|seem|seemed|seeming|seems|seen|self|selves|sent|seven|several|shall|she|shed|she\'ll|shes|should|shouldn\'t|show|showed|shown|showns|shows|significant|significantly|similar|similarly|since|six|slightly|so|some|somebody|somehow|someone|somethan|something|sometime|sometimes|somewhat|somewhere|soon|sorry|specifically|specified|specify|specifying|still|stop|strongly|sub|substantially|successfully|such|sufficiently|suggest|sup|sure|t|take|taken|taking|tell|tends|th|than|thank|thanks|thanx|that|that\'ll|thats|that\'ve|the|their|theirs|them|themselves|then|thence|there|thereafter|thereby|thered|therefore|therein|there\'ll|thereof|therere|theres|thereto|thereupon|there\'ve|these|they|theyd|they\'ll|theyre|they\'ve|think|this|those|thou|though|thoughh|thousand|throug|through|throughout|thru|thus|til|tip|to|together|too|took|toward|towards|tried|tries|truly|try|trying|ts|twice|two|u|un|under|unfortunately|unless|unlike|unlikely|until|unto|up|upon|ups|us|use|used|useful|usefully|usefulness|uses|using|usually|v|value|various|\'ve|very|via|viz|vol|vols|vs|w|want|wants|was|wasn\'t|way|we|wed|welcome|we\'ll|went|were|weren\'t|we\'ve|what|whatever|what\'ll|whats|when|whence|whenever|where|whereafter|whereas|whereby|wherein|wheres|whereupon|wherever|whether|which|while|whim|whither|who|whod|whoever|whole|who\'ll|whom|whomever|whos|whose|why|widely|willing|wish|with|within|without|won\'t|words|world|would|wouldn\'t|www|x|y|yes|yet|you|youd|you\'ll|your|youre|yours|yourself|yourselves|you\'ve|z|zero|rt|t|te|http|que|y|i m|d|que te|don t|t co|s|de|m|la|u|o|lo|ya|es|se|in the|too|en|http t|_|le|i ll|el|3|it s|lol|fuck|shit|damn|nigger|si|yo|can t|por|today|night|tomorrow|gonna|para|ve|that s|da|los|como|1|una|eu|las|pero|5|mas|don|mi|con|you re|ll|tu'));
week1fb_tot = GROUP week1fbngram_filtered ALL;
week1fb_tot_count = FOREACH week1fb_tot GENERATE COUNT($1) as tot_count;
week1fb_cross = CROSS week1fbngram_filtered, week1fb_tot_count;
week1fb_fin = FOREACH week1fb_cross GENERATE $0 as ngram, (float)$1/(float)$2 as proportion;

week1fbcompare = FILTER fb by (time >= 'sun oct 21 09:00:00 pdt 2012' AND time <= 'sun oct 21 23:59:59 pdt 2012') OR (time >= 'sun oct 28 09:00:00 pdt 2012' AND time <= 'sun oct 28 23:59:59 pdt 2012') OR (time >= 'sun nov 11 09:00:00 pst 2012' AND time <= 'sun nov 11 23:59:59 pst 2012') OR (time >= 'sun nov 18 09:00:00 pst 2012' AND time <= 'sun nov 18 23:59:59 pst 2012') OR (time >= 'sun nov 25 09:00:00 pst 2012' AND time <= 'sun nov 25 23:59:59 pst 2012') OR (time >= 'sun dec 02 09:00:00 pst 2012' AND time <= 'sun dec 02 23:59:59 pst 2012');
week1fbcomparetweet_ngram = FOREACH week1fbcompare GENERATE id, time, FLATTEN(org.apache.pig.tutorial.NGramGenerator(tweet)) as ngram;
week1fbcomparengram_group = GROUP week1fbcomparetweet_ngram BY ngram;
week1fbcomparengram_count = FOREACH week1fbcomparengram_group GENERATE $0 as term, COUNT($1) as count_freq;
week1fbcomparengram_desc = ORDER week1fbcomparengram_count BY count_freq DESC;
week1fbcomparengram_filtered = FILTER week1fbcomparengram_desc BY (NOT (term matches 'a|able|about|above|abst|accordance|according|accordingly|across|act|actually|added|adj|affected|affecting|affects|after|afterwards|again|against|ah|all|almost|alone|along|already|also|although|always|am|among|amongst|an|and|announce|another|any|anybody|anyhow|anymore|anyone|anything|anyway|anyways|anywhere|apparently|approximately|are|aren|arent|arise|around|as|aside|ask|asking|at|auth|available|away|awfully|b|back|be|became|because|become|becomes|becoming|been|before|beforehand|begin|beginning|beginnings|begins|behind|being|believe|below|beside|besides|between|beyond|biol|both|brief|briefly|but|by|c|ca|came|can|cannot|can\'t|cause|causes|certain|certainly|co|com|come|comes|contain|containing|contains|could|couldnt|d|date|did|didn\'t|different|do|does|doesn\'t|doing|done|don\'t|down|downwards|due|during|e|each|ed|edu|effect|eg|eight|eighty|either|else|elsewhere|end|ending|enough|especially|et|et-al|etc|even|ever|every|everybody|everyone|everything|everywhere|ex|except|f|far|few|ff|fifth|first|five|fix|followed|following|follows|for|former|formerly|forth|found|four|from|further|furthermore|g|gave|get|gets|getting|give|given|gives|giving|go|goes|gone|got|gotten|h|had|happens|hardly|has|hasn\'t|have|haven\'t|having|he|hed|hence|her|here|hereafter|hereby|herein|heres|hereupon|hers|herself|hes|hi|hid|him|himself|his|hither|home|how|howbeit|however|hundred|i|id|ie|if|i\'ll|im|immediate|immediately|importance|important|in|inc|indeed|index|information|instead|into|invention|inward|is|isn\'t|it|itd|it\'ll|its|itself|i\'ve|j|just|k|keep|keeps|kept|kg|km|know|known|knows|l|largely|last|lately|later|latter|latterly|least|less|lest|let|lets|like|liked|likely|line|little|\'ll|look|looking|looks|ltd|m|made|mainly|make|makes|many|may|maybe|me|mean|means|meantime|meanwhile|merely|mg|might|million|miss|ml|more|moreover|most|mostly|mr|mrs|much|mug|must|my|myself|n|na|name|namely|nay|nd|near|nearly|necessarily|necessary|need|needs|neither|never|nevertheless|new|next|nine|ninety|no|nobody|non|none|nonetheless|noone|nor|normally|nos|not|noted|nothing|now|nowhere|o|obtain|obtained|obviously|of|off|often|oh|ok|okay|old|omitted|on|once|one|ones|only|onto|or|ord|other|others|otherwise|ought|our|ours|ourselves|out|outside|over|overall|owing|own|p|page|pages|part|particular|particularly|past|per|perhaps|placed|please|plus|poorly|possible|possibly|potentially|pp|predominantly|present|previously|primarily|probably|promptly|proud|provides|put|q|que|quickly|quite|qv|r|ran|rather|rd|re|readily|really|recent|recently|ref|refs|regarding|regardless|regards|related|relatively|research|respectively|resulted|resulting|results|right|run|s|said|same|saw|say|saying|says|sec|section|see|seeing|seem|seemed|seeming|seems|seen|self|selves|sent|seven|several|shall|she|shed|she\'ll|shes|should|shouldn\'t|show|showed|shown|showns|shows|significant|significantly|similar|similarly|since|six|slightly|so|some|somebody|somehow|someone|somethan|something|sometime|sometimes|somewhat|somewhere|soon|sorry|specifically|specified|specify|specifying|still|stop|strongly|sub|substantially|successfully|such|sufficiently|suggest|sup|sure|t|take|taken|taking|tell|tends|th|than|thank|thanks|thanx|that|that\'ll|thats|that\'ve|the|their|theirs|them|themselves|then|thence|there|thereafter|thereby|thered|therefore|therein|there\'ll|thereof|therere|theres|thereto|thereupon|there\'ve|these|they|theyd|they\'ll|theyre|they\'ve|think|this|those|thou|though|thoughh|thousand|throug|through|throughout|thru|thus|til|tip|to|together|too|took|toward|towards|tried|tries|truly|try|trying|ts|twice|two|u|un|under|unfortunately|unless|unlike|unlikely|until|unto|up|upon|ups|us|use|used|useful|usefully|usefulness|uses|using|usually|v|value|various|\'ve|very|via|viz|vol|vols|vs|w|want|wants|was|wasn\'t|way|we|wed|welcome|we\'ll|went|were|weren\'t|we\'ve|what|whatever|what\'ll|whats|when|whence|whenever|where|whereafter|whereas|whereby|wherein|wheres|whereupon|wherever|whether|which|while|whim|whither|who|whod|whoever|whole|who\'ll|whom|whomever|whos|whose|why|widely|willing|wish|with|within|without|won\'t|words|world|would|wouldn\'t|www|x|y|yes|yet|you|youd|you\'ll|your|youre|yours|yourself|yourselves|you\'ve|z|zero|rt|t|te|http|que|y|i m|d|que te|don t|t co|s|de|m|la|u|o|lo|ya|es|se|in the|too|en|http t|_|le|i ll|el|3|it s|lol|fuck|shit|damn|nigger|si|yo|can t|por|today|night|tomorrow|gonna|para|ve|that s|da|los|como|1|una|eu|las|pero|5|mas|don|mi|con|you re|ll|tu'));
week1fbcompare_tot = GROUP week1fbcomparengram_filtered ALL;
week1fbcompare_tot_count = FOREACH week1fbcompare_tot GENERATE COUNT($1) as tot_count;
week1fbcompare_cross = CROSS week1fbcomparengram_filtered, week1fbcompare_tot_count;
week1fbcompare_fin = FOREACH week1fbcompare_cross GENERATE $0 as ngram, (float)$1/(float)$2 as proportion;

week1fbchi1 = JOIN week1fb_fin BY ngram, week1fbcompare_fin BY ngram;
week1fbchi2 = FOREACH week1fbchi1 GENERATE $0 as words, $1 as o_count, $3 as e_count;
week1fbchi3 = FILTER week1fbchi2 BY (o_count > e_count);
week1fbchi4 = FOREACH week1fbchi3 GENERATE words, ((o_count-e_count)*(o_count-e_count))/e_count as chi_sq_test;
week1fbchi4_desc = ORDER week1fbchi4 BY chi_sq_test DESC;
week1fbchi4_lim = LIMIT week1fbchi4_desc 100;
STORE week1fbchi4_lim INTO 'Trending_terms_FB_week3' USING PigStorage();

/*
*
* End Week 2 FB Chi-Square
*
*/

/*
*
*  Week 21GFB Chi-Square
*
*/
week11gfb = FILTER fb by (time >= 'sun nov 04 09:00:00 pst 2012' AND time <= 'sun nov 04 23:59:59 pst 2012');
week11gfbtweet_ngram = FOREACH week11gfb GENERATE id, time, FLATTEN(org.apache.pig.tutorial.NGramGenerator(tweet)) as ngram;
week11gfbngram_group = GROUP week11gfbtweet_ngram BY ngram;
week11gfbngram_count = FOREACH week11gfbngram_group GENERATE $0 as term, COUNT($1) as count_freq;
week11gfbngram_desc = ORDER week11gfbngram_count BY count_freq DESC;
week11gfbngram_filtered = FILTER week11gfbngram_desc BY (NOT (term matches 'a|able|about|above|abst|accordance|according|accordingly|across|act|actually|added|adj|affected|affecting|affects|after|afterwards|again|against|ah|all|almost|alone|along|already|also|although|always|am|among|amongst|an|and|announce|another|any|anybody|anyhow|anymore|anyone|anything|anyway|anyways|anywhere|apparently|approximately|are|aren|arent|arise|around|as|aside|ask|asking|at|auth|available|away|awfully|b|back|be|became|because|become|becomes|becoming|been|before|beforehand|begin|beginning|beginnings|begins|behind|being|believe|below|beside|besides|between|beyond|biol|both|brief|briefly|but|by|c|ca|came|can|cannot|can\'t|cause|causes|certain|certainly|co|com|come|comes|contain|containing|contains|could|couldnt|d|date|did|didn\'t|different|do|does|doesn\'t|doing|done|don\'t|down|downwards|due|during|e|each|ed|edu|effect|eg|eight|eighty|either|else|elsewhere|end|ending|enough|especially|et|et-al|etc|even|ever|every|everybody|everyone|everything|everywhere|ex|except|f|far|few|ff|fifth|first|five|fix|followed|following|follows|for|former|formerly|forth|found|four|from|further|furthermore|g|gave|get|gets|getting|give|given|gives|giving|go|goes|gone|got|gotten|h|had|happens|hardly|has|hasn\'t|have|haven\'t|having|he|hed|hence|her|here|hereafter|hereby|herein|heres|hereupon|hers|herself|hes|hi|hid|him|himself|his|hither|home|how|howbeit|however|hundred|i|id|ie|if|i\'ll|im|immediate|immediately|importance|important|in|inc|indeed|index|information|instead|into|invention|inward|is|isn\'t|it|itd|it\'ll|its|itself|i\'ve|j|just|k|keep|keeps|kept|kg|km|know|known|knows|l|largely|last|lately|later|latter|latterly|least|less|lest|let|lets|like|liked|likely|line|little|\'ll|look|looking|looks|ltd|m|made|mainly|make|makes|many|may|maybe|me|mean|means|meantime|meanwhile|merely|mg|might|million|miss|ml|more|moreover|most|mostly|mr|mrs|much|mug|must|my|myself|n|na|name|namely|nay|nd|near|nearly|necessarily|necessary|need|needs|neither|never|nevertheless|new|next|nine|ninety|no|nobody|non|none|nonetheless|noone|nor|normally|nos|not|noted|nothing|now|nowhere|o|obtain|obtained|obviously|of|off|often|oh|ok|okay|old|omitted|on|once|one|ones|only|onto|or|ord|other|others|otherwise|ought|our|ours|ourselves|out|outside|over|overall|owing|own|p|page|pages|part|particular|particularly|past|per|perhaps|placed|please|plus|poorly|possible|possibly|potentially|pp|predominantly|present|previously|primarily|probably|promptly|proud|provides|put|q|que|quickly|quite|qv|r|ran|rather|rd|re|readily|really|recent|recently|ref|refs|regarding|regardless|regards|related|relatively|research|respectively|resulted|resulting|results|right|run|s|said|same|saw|say|saying|says|sec|section|see|seeing|seem|seemed|seeming|seems|seen|self|selves|sent|seven|several|shall|she|shed|she\'ll|shes|should|shouldn\'t|show|showed|shown|showns|shows|significant|significantly|similar|similarly|since|six|slightly|so|some|somebody|somehow|someone|somethan|something|sometime|sometimes|somewhat|somewhere|soon|sorry|specifically|specified|specify|specifying|still|stop|strongly|sub|substantially|successfully|such|sufficiently|suggest|sup|sure|t|take|taken|taking|tell|tends|th|than|thank|thanks|thanx|that|that\'ll|thats|that\'ve|the|their|theirs|them|themselves|then|thence|there|thereafter|thereby|thered|therefore|therein|there\'ll|thereof|therere|theres|thereto|thereupon|there\'ve|these|they|theyd|they\'ll|theyre|they\'ve|think|this|those|thou|though|thoughh|thousand|throug|through|throughout|thru|thus|til|tip|to|together|too|took|toward|towards|tried|tries|truly|try|trying|ts|twice|two|u|un|under|unfortunately|unless|unlike|unlikely|until|unto|up|upon|ups|us|use|used|useful|usefully|usefulness|uses|using|usually|v|value|various|\'ve|very|via|viz|vol|vols|vs|w|want|wants|was|wasn\'t|way|we|wed|welcome|we\'ll|went|were|weren\'t|we\'ve|what|whatever|what\'ll|whats|when|whence|whenever|where|whereafter|whereas|whereby|wherein|wheres|whereupon|wherever|whether|which|while|whim|whither|who|whod|whoever|whole|who\'ll|whom|whomever|whos|whose|why|widely|willing|wish|with|within|without|won\'t|words|world|would|wouldn\'t|www|x|y|yes|yet|you|youd|you\'ll|your|youre|yours|yourself|yourselves|you\'ve|z|zero|rt|t|te|http|que|y|i m|d|que te|don t|t co|s|de|m|la|u|o|lo|ya|es|se|in the|too|en|http t|_|le|i ll|el|3|it s|lol|fuck|shit|damn|nigger|si|yo|can t|por|today|night|tomorrow|gonna|para|ve|that s|da|los|como|1|una|eu|las|pero|5|mas|don|mi|con|you re|ll|tu'));
week11gfb_tot = GROUP week11gfbngram_filtered ALL;
week11gfb_tot_count = FOREACH week11gfb_tot GENERATE COUNT($1) as tot_count;
week11gfb_cross = CROSS week11gfbngram_filtered, week11gfb_tot_count;
week11gfb_fin = FOREACH week11gfb_cross GENERATE $0 as ngram, (float)$1/(float)$2 as proportion;

week11gfbchi1 = JOIN week11gfb_fin BY ngram, week1fbcompare_fin BY ngram;
week11gfbchi2 = FOREACH week11gfbchi1 GENERATE $0 as words, $1 as o_count, $3 as e_count;
week11gfbchi3 = FILTER week11gfbchi2 BY (o_count > e_count);
week11gfbchi4 = FOREACH week11gfbchi3 GENERATE words, ((o_count-e_count)*(o_count-e_count))/e_count as chi_sq_test;
week11gfbchi4_desc = ORDER week11gfbchi4 BY chi_sq_test DESC;
week11gfbchi4_lim = LIMIT week11gfbchi4_desc 100;
STORE week11gfbchi4_lim INTO 'Trending_terms_FB_week31g' USING PigStorage();

/*
*
* End Week 21GFB Chi-Square
*
*/

/*
*
*  Week 22GFB Chi-Square
*
*/
week12gfb = FILTER fb by (time >= 'sun nov 04 09:00:00 pst 2012' AND time <= 'sun nov 04 23:59:59 pst 2012');
week12gfbtweet_ngram = FOREACH week12gfb GENERATE id, time, FLATTEN(org.apache.pig.tutorial.NGramGenerator(tweet)) as ngram;
week12gfbngram_group = GROUP week12gfbtweet_ngram BY ngram;
week12gfbngram_count = FOREACH week12gfbngram_group GENERATE $0 as term, COUNT($1) as count_freq;
week12gfbngram_desc = ORDER week12gfbngram_count BY count_freq DESC;
week12gfbngram_filtered = FILTER week12gfbngram_desc BY (NOT (term matches 'a|able|about|above|abst|accordance|according|accordingly|across|act|actually|added|adj|affected|affecting|affects|after|afterwards|again|against|ah|all|almost|alone|along|already|also|although|always|am|among|amongst|an|and|announce|another|any|anybody|anyhow|anymore|anyone|anything|anyway|anyways|anywhere|apparently|approximately|are|aren|arent|arise|around|as|aside|ask|asking|at|auth|available|away|awfully|b|back|be|became|because|become|becomes|becoming|been|before|beforehand|begin|beginning|beginnings|begins|behind|being|believe|below|beside|besides|between|beyond|biol|both|brief|briefly|but|by|c|ca|came|can|cannot|can\'t|cause|causes|certain|certainly|co|com|come|comes|contain|containing|contains|could|couldnt|d|date|did|didn\'t|different|do|does|doesn\'t|doing|done|don\'t|down|downwards|due|during|e|each|ed|edu|effect|eg|eight|eighty|either|else|elsewhere|end|ending|enough|especially|et|et-al|etc|even|ever|every|everybody|everyone|everything|everywhere|ex|except|f|far|few|ff|fifth|first|five|fix|followed|following|follows|for|former|formerly|forth|found|four|from|further|furthermore|g|gave|get|gets|getting|give|given|gives|giving|go|goes|gone|got|gotten|h|had|happens|hardly|has|hasn\'t|have|haven\'t|having|he|hed|hence|her|here|hereafter|hereby|herein|heres|hereupon|hers|herself|hes|hi|hid|him|himself|his|hither|home|how|howbeit|however|hundred|i|id|ie|if|i\'ll|im|immediate|immediately|importance|important|in|inc|indeed|index|information|instead|into|invention|inward|is|isn\'t|it|itd|it\'ll|its|itself|i\'ve|j|just|k|keep|keeps|kept|kg|km|know|known|knows|l|largely|last|lately|later|latter|latterly|least|less|lest|let|lets|like|liked|likely|line|little|\'ll|look|looking|looks|ltd|m|made|mainly|make|makes|many|may|maybe|me|mean|means|meantime|meanwhile|merely|mg|might|million|miss|ml|more|moreover|most|mostly|mr|mrs|much|mug|must|my|myself|n|na|name|namely|nay|nd|near|nearly|necessarily|necessary|need|needs|neither|never|nevertheless|new|next|nine|ninety|no|nobody|non|none|nonetheless|noone|nor|normally|nos|not|noted|nothing|now|nowhere|o|obtain|obtained|obviously|of|off|often|oh|ok|okay|old|omitted|on|once|one|ones|only|onto|or|ord|other|others|otherwise|ought|our|ours|ourselves|out|outside|over|overall|owing|own|p|page|pages|part|particular|particularly|past|per|perhaps|placed|please|plus|poorly|possible|possibly|potentially|pp|predominantly|present|previously|primarily|probably|promptly|proud|provides|put|q|que|quickly|quite|qv|r|ran|rather|rd|re|readily|really|recent|recently|ref|refs|regarding|regardless|regards|related|relatively|research|respectively|resulted|resulting|results|right|run|s|said|same|saw|say|saying|says|sec|section|see|seeing|seem|seemed|seeming|seems|seen|self|selves|sent|seven|several|shall|she|shed|she\'ll|shes|should|shouldn\'t|show|showed|shown|showns|shows|significant|significantly|similar|similarly|since|six|slightly|so|some|somebody|somehow|someone|somethan|something|sometime|sometimes|somewhat|somewhere|soon|sorry|specifically|specified|specify|specifying|still|stop|strongly|sub|substantially|successfully|such|sufficiently|suggest|sup|sure|t|take|taken|taking|tell|tends|th|than|thank|thanks|thanx|that|that\'ll|thats|that\'ve|the|their|theirs|them|themselves|then|thence|there|thereafter|thereby|thered|therefore|therein|there\'ll|thereof|therere|theres|thereto|thereupon|there\'ve|these|they|theyd|they\'ll|theyre|they\'ve|think|this|those|thou|though|thoughh|thousand|throug|through|throughout|thru|thus|til|tip|to|together|too|took|toward|towards|tried|tries|truly|try|trying|ts|twice|two|u|un|under|unfortunately|unless|unlike|unlikely|until|unto|up|upon|ups|us|use|used|useful|usefully|usefulness|uses|using|usually|v|value|various|\'ve|very|via|viz|vol|vols|vs|w|want|wants|was|wasn\'t|way|we|wed|welcome|we\'ll|went|were|weren\'t|we\'ve|what|whatever|what\'ll|whats|when|whence|whenever|where|whereafter|whereas|whereby|wherein|wheres|whereupon|wherever|whether|which|while|whim|whither|who|whod|whoever|whole|who\'ll|whom|whomever|whos|whose|why|widely|willing|wish|with|within|without|won\'t|words|world|would|wouldn\'t|www|x|y|yes|yet|you|youd|you\'ll|your|youre|yours|yourself|yourselves|you\'ve|z|zero|rt|t|te|http|que|y|i m|d|que te|don t|t co|s|de|m|la|u|o|lo|ya|es|se|in the|too|en|http t|_|le|i ll|el|3|it s|lol|fuck|shit|damn|nigger|si|yo|can t|por|today|night|tomorrow|gonna|para|ve|that s|da|los|como|1|una|eu|las|pero|5|mas|don|mi|con|you re|ll|tu'));
week12gfb_tot = GROUP week12gfbngram_filtered ALL;
week12gfb_tot_count = FOREACH week12gfb_tot GENERATE COUNT($1) as tot_count;
week12gfb_cross = CROSS week12gfbngram_filtered, week12gfb_tot_count;
week12gfb_fin = FOREACH week12gfb_cross GENERATE $0 as ngram, (float)$1/(float)$2 as proportion;

week12gfbchi1 = JOIN week12gfb_fin BY ngram, week1fbcompare_fin BY ngram;
week12gfbchi2 = FOREACH week12gfbchi1 GENERATE $0 as words, $1 as o_count, $3 as e_count;
week12gfbchi3 = FILTER week12gfbchi2 BY (o_count > e_count);
week12gfbchi4 = FOREACH week12gfbchi3 GENERATE words, ((o_count-e_count)*(o_count-e_count))/e_count as chi_sq_test;
week12gfbchi4_desc = ORDER week12gfbchi4 BY chi_sq_test DESC;
week12gfbchi4_lim = LIMIT week12gfbchi4_desc 100;
STORE week12gfbchi4_lim INTO 'Trending_terms_FB_week32g' USING PigStorage();

/*
*
* End Week 22GFB Chi-Square
*
*/

/*
*
*  Week 23GFB Chi-Square
*
*/

week13gfb = FILTER fb by (time >= 'sun nov 04 09:00:00 pst 2012' AND time <= 'sun nov 04 23:59:59 pst 2012');
week13gfbtweet_ngram = FOREACH week13gfb GENERATE id, time, FLATTEN(org.apache.pig.tutorial.NGramGenerator(tweet)) as ngram;
week13gfbngram_group = GROUP week13gfbtweet_ngram BY ngram;
week13gfbngram_count = FOREACH week13gfbngram_group GENERATE $0 as term, COUNT($1) as count_freq;
week13gfbngram_desc = ORDER week13gfbngram_count BY count_freq DESC;
week13gfbngram_filtered = FILTER week13gfbngram_desc BY (NOT (term matches 'a|able|about|above|abst|accordance|according|accordingly|across|act|actually|added|adj|affected|affecting|affects|after|afterwards|again|against|ah|all|almost|alone|along|already|also|although|always|am|among|amongst|an|and|announce|another|any|anybody|anyhow|anymore|anyone|anything|anyway|anyways|anywhere|apparently|approximately|are|aren|arent|arise|around|as|aside|ask|asking|at|auth|available|away|awfully|b|back|be|became|because|become|becomes|becoming|been|before|beforehand|begin|beginning|beginnings|begins|behind|being|believe|below|beside|besides|between|beyond|biol|both|brief|briefly|but|by|c|ca|came|can|cannot|can\'t|cause|causes|certain|certainly|co|com|come|comes|contain|containing|contains|could|couldnt|d|date|did|didn\'t|different|do|does|doesn\'t|doing|done|don\'t|down|downwards|due|during|e|each|ed|edu|effect|eg|eight|eighty|either|else|elsewhere|end|ending|enough|especially|et|et-al|etc|even|ever|every|everybody|everyone|everything|everywhere|ex|except|f|far|few|ff|fifth|first|five|fix|followed|following|follows|for|former|formerly|forth|found|four|from|further|furthermore|g|gave|get|gets|getting|give|given|gives|giving|go|goes|gone|got|gotten|h|had|happens|hardly|has|hasn\'t|have|haven\'t|having|he|hed|hence|her|here|hereafter|hereby|herein|heres|hereupon|hers|herself|hes|hi|hid|him|himself|his|hither|home|how|howbeit|however|hundred|i|id|ie|if|i\'ll|im|immediate|immediately|importance|important|in|inc|indeed|index|information|instead|into|invention|inward|is|isn\'t|it|itd|it\'ll|its|itself|i\'ve|j|just|k|keep|keeps|kept|kg|km|know|known|knows|l|largely|last|lately|later|latter|latterly|least|less|lest|let|lets|like|liked|likely|line|little|\'ll|look|looking|looks|ltd|m|made|mainly|make|makes|many|may|maybe|me|mean|means|meantime|meanwhile|merely|mg|might|million|miss|ml|more|moreover|most|mostly|mr|mrs|much|mug|must|my|myself|n|na|name|namely|nay|nd|near|nearly|necessarily|necessary|need|needs|neither|never|nevertheless|new|next|nine|ninety|no|nobody|non|none|nonetheless|noone|nor|normally|nos|not|noted|nothing|now|nowhere|o|obtain|obtained|obviously|of|off|often|oh|ok|okay|old|omitted|on|once|one|ones|only|onto|or|ord|other|others|otherwise|ought|our|ours|ourselves|out|outside|over|overall|owing|own|p|page|pages|part|particular|particularly|past|per|perhaps|placed|please|plus|poorly|possible|possibly|potentially|pp|predominantly|present|previously|primarily|probably|promptly|proud|provides|put|q|que|quickly|quite|qv|r|ran|rather|rd|re|readily|really|recent|recently|ref|refs|regarding|regardless|regards|related|relatively|research|respectively|resulted|resulting|results|right|run|s|said|same|saw|say|saying|says|sec|section|see|seeing|seem|seemed|seeming|seems|seen|self|selves|sent|seven|several|shall|she|shed|she\'ll|shes|should|shouldn\'t|show|showed|shown|showns|shows|significant|significantly|similar|similarly|since|six|slightly|so|some|somebody|somehow|someone|somethan|something|sometime|sometimes|somewhat|somewhere|soon|sorry|specifically|specified|specify|specifying|still|stop|strongly|sub|substantially|successfully|such|sufficiently|suggest|sup|sure|t|take|taken|taking|tell|tends|th|than|thank|thanks|thanx|that|that\'ll|thats|that\'ve|the|their|theirs|them|themselves|then|thence|there|thereafter|thereby|thered|therefore|therein|there\'ll|thereof|therere|theres|thereto|thereupon|there\'ve|these|they|theyd|they\'ll|theyre|they\'ve|think|this|those|thou|though|thoughh|thousand|throug|through|throughout|thru|thus|til|tip|to|together|too|took|toward|towards|tried|tries|truly|try|trying|ts|twice|two|u|un|under|unfortunately|unless|unlike|unlikely|until|unto|up|upon|ups|us|use|used|useful|usefully|usefulness|uses|using|usually|v|value|various|\'ve|very|via|viz|vol|vols|vs|w|want|wants|was|wasn\'t|way|we|wed|welcome|we\'ll|went|were|weren\'t|we\'ve|what|whatever|what\'ll|whats|when|whence|whenever|where|whereafter|whereas|whereby|wherein|wheres|whereupon|wherever|whether|which|while|whim|whither|who|whod|whoever|whole|who\'ll|whom|whomever|whos|whose|why|widely|willing|wish|with|within|without|won\'t|words|world|would|wouldn\'t|www|x|y|yes|yet|you|youd|you\'ll|your|youre|yours|yourself|yourselves|you\'ve|z|zero|rt|t|te|http|que|y|i m|d|que te|don t|t co|s|de|m|la|u|o|lo|ya|es|se|in the|too|en|http t|_|le|i ll|el|3|it s|lol|fuck|shit|damn|nigger|si|yo|can t|por|today|night|tomorrow|gonna|para|ve|that s|da|los|como|1|una|eu|las|pero|5|mas|don|mi|con|you re|ll|tu'));
week13gfb_tot = GROUP week13gfbngram_filtered ALL;
week13gfb_tot_count = FOREACH week13gfb_tot GENERATE COUNT($1) as tot_count;
week13gfb_cross = CROSS week13gfbngram_filtered, week13gfb_tot_count;
week13gfb_fin = FOREACH week13gfb_cross GENERATE $0 as ngram, (float)$1/(float)$2 as proportion;

week13gfbchi1 = JOIN week13gfb_fin BY ngram, week1fbcompare_fin BY ngram;
week13gfbchi2 = FOREACH week13gfbchi1 GENERATE $0 as words, $1 as o_count, $3 as e_count;
week13gfbchi3 = FILTER week13gfbchi2 BY (o_count > e_count);
week13gfbchi4 = FOREACH week13gfbchi3 GENERATE words, ((o_count-e_count)*(o_count-e_count))/e_count as chi_sq_test;
week13gfbchi4_desc = ORDER week13gfbchi4 BY chi_sq_test DESC;
week13gfbchi4_lim = LIMIT week13gfbchi4_desc 100;
STORE week13gfbchi4_lim INTO 'Trending_terms_FB_week33g' USING PigStorage();

/*
*
* End Week 23GFB Chi-Square
*
*/