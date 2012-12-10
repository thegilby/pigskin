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
raw = LOAD 'Wdata/{indexed_tweets_w1.txt,indexed_tweets_w2.txt,indexed_tweets_w3.txt,indexed_tweets_w4.txt,indexed_tweets_w6.txt,indexed_tweets_w7.txt}' USING PigStorage('\t') AS (id, time, user, tweet, geoloc, hashes, weight, assoc);

raw1 = SAMPLE raw 1.0;

clean1 = FILTER raw1 BY org.apache.pig.tutorial.NonURLDetector(tweet);
clean1_group = GROUP clean1 ALL;

clean11 = FILTER raw1 by tweet matches '[\\u0020-\\u007e]+'; 
fb = FILTER clean11 BY weight > 1 AND (NOT (geoloc matches 'null'));
/*
wk1 = FILTER fb BY (time >= 'sun oct 21 09:00:00 pdt 2012' AND time <= 'sun oct 21 23:59:59 pdt 2012')  AND weight > 1;
wk2 = FILTER fb by (time >= 'sun oct 28 09:00:00 pdt 2012' AND time <= 'sun oct 28 23:59:59 pdt 2012')  AND weight > 1; 
wk3 = FILTER fb by (time >= 'sun nov 04 09:00:00 pst 2012' AND time <= 'sun nov 04 23:59:59 pst 2012')  AND weight > 1;
wk4 = FILTER fb by (time >= 'sun nov 11 09:00:00 pst 2012' AND time <= 'sun nov 11 23:59:59 pst 2012')  AND weight > 1;
wk5 = FILTER fb by (time >= 'sun nov 18 09:00:00 pst 2012' AND time <= 'sun nov 18 23:59:59 pst 2012')  AND weight > 1;
wk6 = FILTER fb by (time >= 'sun nov 25 09:00:00 pst 2012' AND time <= 'sun nov 25 23:59:59 pst 2012')  AND weight > 1;
wk7 = FILTER fb by (time >= 'sun dec 02 09:00:00 pst 2012' AND time <= 'sun dec 02 23:59:59 pst 2012')  AND weight > 1;
*/

--'buf'
allbuf = FILTER fb BY (assoc matches '.*buf.*') AND weight > 1;
allbuf1 = FOREACH allbuf GENERATE time, tweet, geoloc, weight, assoc;
STORE allbuf1 INTO 'geoloc_all_buf' USING PigStorage();

--'mia'
allmia = FILTER fb BY (assoc matches '.*mia.*') AND weight > 1;
allmia1 = FOREACH allmia GENERATE time, tweet, geoloc, weight, assoc;
STORE allmia1 INTO 'geoloc_all_mia' USING PigStorage();

--'ne'
allne = FILTER fb BY (assoc matches '.*ne.*') AND weight > 1;
allne1 = FOREACH allne GENERATE time, tweet, geoloc, weight, assoc;
STORE allne1 INTO 'geoloc_all_ne' USING PigStorage();

--'nyj'
allnyj = FILTER fb BY (assoc matches '.*nyj.*')  AND weight > 1;
allnyj1 = FOREACH allnyj GENERATE time, tweet, geoloc, weight, assoc;
STORE allnyj1 INTO 'geoloc_all_nyj' USING PigStorage();

--'bal'
allbal = FILTER fb BY (assoc matches '.*bal.*')  AND weight > 1;
allbal1 = FOREACH allbal GENERATE time, tweet, geoloc, weight, assoc;
STORE allbal1 INTO 'geoloc_all_bal' USING PigStorage();

--    'cin',
allcin = FILTER fb BY (assoc matches '.*cin.*')  AND weight > 1;
allcin1 = FOREACH allcin GENERATE time, tweet, geoloc, weight, assoc;
STORE allcin1 INTO 'geoloc_all_cin' USING PigStorage();

--    'cle',
allcle = FILTER fb BY (assoc matches '.*cle.*')  AND weight > 1;
allcle1 = FOREACH allcle GENERATE time, tweet, geoloc, weight, assoc;
STORE allcle1 INTO 'geoloc_all_cle' USING PigStorage();

--    'pit'
allpit = FILTER fb BY (assoc matches '.*pit.*')  AND weight > 1;
allpit1 = FOREACH allpit GENERATE time, tweet, geoloc, weight, assoc;
STORE allpit1 INTO 'geoloc_all_pit' USING PigStorage();

--    'hou',
allhou = FILTER fb BY (assoc matches '.*hou.*')  AND weight > 1;
allhou1 = FOREACH allhou GENERATE time, tweet, geoloc, weight, assoc;
STORE allhou1 INTO 'geoloc_all_hou' USING PigStorage();

--    'ind',
allind = FILTER fb BY (assoc matches '.*ind.*')  AND weight > 1;
allind1 = FOREACH allind GENERATE time, tweet, geoloc, weight, assoc;
STORE allind1 INTO 'geoloc_all_ind' USING PigStorage();

--    'jac',
alljac = FILTER fb BY (assoc matches '.*jac.*')  AND weight > 1;
alljac1 = FOREACH alljac GENERATE time, tweet, geoloc, weight, assoc;
STORE alljac1 INTO 'geoloc_all_jac' USING PigStorage();

--    'ten',
allten = FILTER fb BY (assoc matches '.*ten.*')  AND weight > 1;
allten1 = FOREACH allten GENERATE time, tweet, geoloc, weight, assoc;
STORE allten1 INTO 'geoloc_all_ten' USING PigStorage();

--    'den',
allden = FILTER fb BY (assoc matches '.*den.*')  AND weight > 1;
allden1 = FOREACH allden GENERATE time, tweet, geoloc, weight, assoc;
STORE allden1 INTO 'geoloc_all_den' USING PigStorage();

--    'kc',
allkc = FILTER fb BY (assoc matches '.*kc.*')  AND weight > 1;
allkc1 = FOREACH allkc GENERATE time, tweet, geoloc, weight, assoc;
STORE allkc1 INTO 'geoloc_all_kc' USING PigStorage();

--    'oak',
alloak = FILTER fb BY (assoc matches '.*oak.*')  AND weight > 1;
alloak1 = FOREACH alloak GENERATE time, tweet, geoloc, weight, assoc;
STORE alloak1 INTO 'geoloc_all_oak' USING PigStorage();

--    'sd',
allsd = FILTER fb BY (assoc matches '.*sd.*')  AND weight > 1;
allsd1 = FOREACH allsd GENERATE time, tweet, geoloc, weight, assoc;
STORE allsd1 INTO 'geoloc_all_sd' USING PigStorage();

--    'dal',
alldal = FILTER fb BY (assoc matches '.*dal.*')  AND weight > 1;
alldal1 = FOREACH alldal GENERATE time, tweet, geoloc, weight, assoc;
STORE alldal1 INTO 'geoloc_all_dal' USING PigStorage();

--    'nyg',
allnyg = FILTER fb BY (assoc matches '.*nyg.*')  AND weight > 1;
allnyg1 = FOREACH allnyg GENERATE time, tweet, geoloc, weight, assoc;
STORE allnyg1 INTO 'geoloc_all_nyg' USING PigStorage();

--    'phi',
allphi = FILTER fb BY (assoc matches '.*phi.*')  AND weight > 1;
allphi1 = FOREACH allphi GENERATE time, tweet, geoloc, weight, assoc;
STORE allphi1 INTO 'geoloc_all_phi' USING PigStorage();

--    'was',
allwas = FILTER fb BY (assoc matches '.*was.*') AND weight > 1;
allwas1 = FOREACH allwas GENERATE time, tweet, geoloc, weight, assoc;
 STORE allwas1 INTO 'geoloc_all_was' USING PigStorage();

--    'chi',
allchi = FILTER fb BY (assoc matches '.*chi.*') AND weight > 1;
allchi1 = FOREACH allchi GENERATE time, tweet, geoloc, weight, assoc;
STORE allchi1 INTO 'geoloc_all_chi' USING PigStorage();

--    'det',
alldet = FILTER fb BY (assoc matches '.*det.*') AND weight > 1;
alldet1 = FOREACH alldet GENERATE time, tweet, geoloc, weight, assoc;
STORE alldet1 INTO 'geoloc_all_det' USING PigStorage();

--    'gb',
allgb = FILTER fb BY (assoc matches '.*gb.*') AND weight > 1;
allgb1 = FOREACH allgb GENERATE time, tweet, geoloc, weight, assoc;
STORE allgb1 INTO 'geoloc_all_gb' USING PigStorage();

--    'min',
allmin = FILTER fb BY (assoc matches '.*min.*') AND weight > 1;
allmin1 = FOREACH allmin GENERATE time, tweet, geoloc, weight, assoc;
STORE allmin1 INTO 'geoloc_all_min' USING PigStorage();

--    'atl',
allatl = FILTER fb BY (assoc matches '.*atl.*') AND weight > 1;
allatl1 = FOREACH allatl GENERATE time, tweet, geoloc, weight, assoc;
STORE allatl1 INTO 'geoloc_all_atl' USING PigStorage();

--    'car',
allcar = FILTER fb BY (assoc matches '.*car.*') AND weight > 1;
allcar1 = FOREACH allcar GENERATE time, tweet, geoloc, weight, assoc;
STORE allcar1 INTO 'geoloc_all_car' USING PigStorage();

--    'no',
allno = FILTER fb BY (assoc matches '.*no.*') AND weight > 1;
allno1 = FOREACH allno GENERATE time, tweet, geoloc, weight, assoc;
STORE allno1 INTO 'geoloc_all_no' USING PigStorage();

--    'tb',
alltb = FILTER fb BY (assoc matches '.*tb.*')  AND weight > 1;
alltb1 = FOREACH alltb GENERATE time, tweet, geoloc, weight, assoc;
STORE alltb1 INTO 'geoloc_all_tb' USING PigStorage();

--    'ari',
allari = FILTER fb BY (assoc matches '.*ari.*')  AND weight > 1;
allari1 = FOREACH allari GENERATE time, tweet, geoloc, weight, assoc;
STORE allari1 INTO 'geoloc_all_ari' USING PigStorage();

--    'stl',
allstl = FILTER fb BY (assoc matches '.*stl.*')  AND weight > 1;
allstl1 = FOREACH allstl GENERATE time, tweet, geoloc, weight, assoc;
STORE allstl1 INTO 'geoloc_all_stl' USING PigStorage();

--    'sf',
allsf = FILTER fb BY (assoc matches '.*sf.*')  AND weight > 1;
allsf1 = FOREACH allsf GENERATE time, tweet, geoloc, weight, assoc;
STORE allsf1 INTO 'geoloc_all_sf' USING PigStorage();

--    'sea'
allsea = FILTER fb BY (assoc matches '.*sea.*')  AND weight > 1;
allsea1 = FOREACH allsea GENERATE time, tweet, geoloc, weight, assoc;
STORE allsea1 INTO 'geoloc_all_sea' USING PigStorage();
