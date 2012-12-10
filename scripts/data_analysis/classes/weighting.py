#! /usr/bin/env python

__author__ = 'Jacob Portnoff'
__email__ = 'jacob.portnoff@ischool.berkeley.edu'
__python_version = '3.2'

import re
import random
import os.path
import sys
import codecs
import string

class weighting:
    
    def eval(piece,dict,dict_num,weight,team_ident,prev_eval):
        if piece in dict.keys():
            if dict_num==0 or dict_num==6 or dict_num==7:
                weight+=1
            elif dict_num==1 or dict_num==8:
                weight+=3
            elif dict_num>1 and dict_num<6:
                weight+=2
            ident=term_dic[piece]
            if dict_num==9:
                if len(ident) < 4:
                    if ident not in team_ident:
                        team_ident[ident]=1
                        team_storage.append(ident)
                else:
                    ident=ident.split(',')
                    for id in ident:
                        if id not in team_ident:
                            team_ident[id]=1
                            team_storage.append(id)
            else:
                if ident not in team_ident:
                    team_ident[ident]=1
                    team_storage.append(ident)
            if piece not in prev_eval:
                prev_eval[piece]=1
        return weight, prev_eval, team_ident
    
    def __init__(self):
        id=1
    
    def term_check():
        return True
    
    # weights the tweet based on whether the terms found in the tweet, username, and hashtags are relevant to football
    def decide_weight(user_name,tweet,hashtags,dicts):
        weight=0
        weighter=weighting()
        team_storage=[]
        if re.search('[\\u0020-\\u007e]+',tweet)==None:
            return weight,team_storage
        name_pieces=user_name.split('_')
        tweet_pieces=tweet.split()
        hashtag_pieces=hashtags.split()
        name_pieces=weighter.ngram_v2(name_pieces,1)
        tweet_pieces=weighter.ngram_v2(tweet_pieces,2)
        hashtag_pieces=weighter.ngram_v2(hashtag_pieces,3)
        term_dic=dicts[0]
        hash_dic=dicts[1]
        team_dic=dicts[2]
        at_dic=dicts[3]
        player_dic=dicts[4]
        stadium_dic=dicts[5]
        str_nickname_dic=dicts[6]
        weak_nickname_dic=dicts[7]
        lastname_dic=dicts[8]
        team_ident={}
        prev_eval={}
        all_dics = [[term_dic,0],[at_dic,1],[team_dic,2],[player_dic,3],[stadium_dic,4],[str_nickname_dic,5],[weak_nickname_dic,6],[lastname_dic,7],[hash_dic,8]]
        ident=""
        for piece in tweet_pieces:
            for c in string.punctuation:
                if c != "@" and c != "#":
                    piece= piece.replace(c,"")
            piece=piece.strip()
            if piece not in prev_eval:
                for dic in all_dics:
                    dict=dic[0]
                    dict_num=dic[1]
                    results=weighter.eval(piece,dict,dict_num,weight,team_ident,prev_eval)
                    weight=results[0]
                    prev_eval=results[1]
                    team_ident=results[2]
            '''
            if piece in term_dic.keys():
                weight+=1
                ident=term_dic[piece]
                if ident not in team_ident:
                    team_ident[ident]=1
                    team_storage.append(ident)
        
            if piece in at_dic.keys():
                weight+=3
                ident=at_dic[piece]
                if ident not in team_ident:
                    team_ident[ident]=1
                    team_storage.append(ident)
        
            if piece in team_dic.keys():
                weight+=2
                ident=team_dic[piece]
                if ident not in team_ident:
                    team_ident[ident]=1
                    team_storage.append(ident)
        
            if piece in player_dic.keys():
                weight+=2
                ident=player_dic[piece]
                if ident not in team_ident:
                    team_ident[ident]=1
                    team_storage.append(ident)
            
            if piece in stadium_dic.keys():
                weight+=2
                ident=stadium_dic[piece]
                if ident not in team_ident:
                    team_ident[ident]=1
                    team_storage.append(ident)
                        
            if piece in str_nickname_dic.keys():
                weight+=2
                ident=str_nickname_dic[piece]
                if ident not in team_ident:
                    team_ident[ident]=1
                    team_storage.append(ident)
            
            if piece in weak_nickname_dic.keys():
                weight+=1
                ident=weak_nickname_dic[piece]
                if ident not in team_ident:
                    team_ident[ident]=1
                    team_storage.append(ident)

            if piece in lastname_dic.keys():
                weight+=1
                ident=lastname_dic[piece]
                if ident not in team_ident:
                    team_ident[ident]=1
                    team_storage.append(ident)'''
                        
        for piece in hashtag_pieces:
            for c in string.punctuation:
                if c != "@" and c != "#":
                    piece= piece.replace(c,"")
            piece=piece.strip()
        
            if piece in team_dic.keys():
                weight+=2
                ident=team_dic[piece]
                if ident not in team_ident:
                    team_ident[ident]=1
                    team_storage.append(ident)
        
            if piece in player_dic.keys():
                weight+=2
                ident=player_dic[piece]
                if ident not in team_ident:
                    team_ident[ident]=1
                    team_storage.append(ident)
        
            if piece in hash_dic.keys():
                weight+=3
                ident=hash_dic[piece]
                if len(ident) < 4:
                    if ident not in team_ident:
                        team_ident[ident]=1
                        team_storage.append(ident)
                else:
                    ident=ident.split(',')
                    for id in ident:
                        if id not in team_ident:
                            team_ident[id]=1
                            team_storage.append(id)
    
        for piece in name_pieces:
            for c in string.punctuation:
                if c != "@" and c != "#":
                    piece= piece.replace(c,"")
            piece=piece.strip()
            if piece in team_dic.keys():
                weight+=1
                ident=team_dic[piece]
                if ident not in team_ident:
                    team_ident[ident]=1
                    team_storage.append(ident)
    
        return weight, team_storage

    # adds phrases and joined words so that 'field' and 'goal' can be evaluated as 'field goal' by the weighting scheme
    def ngram_v2(self,pieces,type):
        count=0
        count2=1
        round=2
        trigam=1
        temp_piece=""
        temp_piece2=""
        init_len=len(pieces)-1
        check_len=init_len+1
        #print(str(pieces) + " " + str(init_len))
        if check_len <= 1:
            return pieces
        while count < len(pieces):
            #print(str(count)+"-"+pieces[count]+" "+str(count2)+"-"+pieces[count2]+" "+str(round) + " " + str(check_len) + " " + str(len(pieces)))
            if count2 != check_len:
                temp_piece=pieces[count]+" "+pieces[count2]
                pieces.append(temp_piece)
                count+=1
                count2+=1
            else:
                count2=round
                round+=1
                count+=1
                trigam+=1
                if round>check_len:
                    #print(str(pieces))
                    return pieces
                elif trigam>=3:
                    return pieces
        #print(str(pieces))
        return pieces

    def OpenCompleteFile(file_name):
        term_data = []
        term_dic={}
        file = open(file_name,'r')
        
        term_dic={}
        hash_dic={}
        name_dic={}
        at_dic={}
        player_dic={}
        stadium_dic={}
        str_nickname_dic={}
        weak_nickname_dic={}
        lastname_dic={}
        
        dividers = [["-Term List-",False,term_dic],["-Hashtag List-",False,hash_dic],["-Team name stems-",False,name_dic],["-@ names-",False,at_dic],["-Full Player Names-",False,player_dic],["-Stadiums-",False,stadium_dic],["-Strong Nicknames-",False,str_nickname_dic],["-Weak Nicknames-",False,weak_nickname_dic],["-Player Last Names-",False,lastname_dic]]
        for el in file:
            el2 = el.split('\t')
            line = el2[0]
            #print(line)
            val = el2[1]
            val = val.strip('\n')
            i=0
            for group in dividers:
                #print(str(i) + " "+ line+ " " +group[0])
                if line==group[0]:
                    #print(str(dividers[0][1]) + " " + line + group[0])
                    group[1]=True
                    if i>0:
                        dividers[i-1][1]=False
                if group[1]==True and val!="a":
                    #print("BINGO " + line + " " + str(dividers[0][1]))
                    line = line.lower()
                    if dividers[2][1]==True:
                        new_line=line+"s"
                        group[2][new_line]=val
                        new_line=line+"z"
                        group[2][new_line]=val
                        dividers[0][2][line]=val
                    else:
                        group[2][line]=val
                i+=1
    
        return term_dic, hash_dic, name_dic, at_dic, player_dic, stadium_dic, str_nickname_dic, weak_nickname_dic, lastname_dic

