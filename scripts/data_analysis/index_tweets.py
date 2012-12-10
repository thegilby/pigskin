#! /usr/bin/env python

__author__ = 'Jacob Portnoff'
__email__ = 'jacob.portnoff@ischool.berkeley.edu'
__python_version = '3.2'

import re
import random
import os
import sys
import codecs
import string
from classes.weighting import weighting

def createDocument(dicts):
    #load proper doc
    #sanitize relevant data
    #check times
    #check tweets
    #check tweet @s
    #check hashes
    #check users
    #check geocodes
    #check rate
    
    '''test_loc="/Users/jacobportnoff/Dropbox/290-twitter/data/11_11_10.txt"
    test_file = open(test_loc, 'r')'''
    data_loc="/Users/jacobportnoff/Dropbox/290-twitter/data/"
    jdata_loc="/Users/jacobportnoff/Dropbox/290-twitter/Jdata/"
    storage_loc="/Users/jacobportnoff/Dropbox/290-twitter/Wdata/"
    storage_file="indexed_tweets2_w"
    txt=".txt"
    week_num=0
    week_holder=""
    data_lines=[]
    jdata_lines=[]
    '''for filename in os.listdir(data_loc):
        print(filename)
        if filename!=".DS_Store":
            data = open(data_loc+filename,'r')
            for line in data:
                data_lines.append(line)
            data.close()
         and filename2!="week1SunJ.txt" and filename2!="week2SunJ.txt" and filename2!="week3SunJ.txt"'''
    for filename2 in os.listdir(jdata_loc):
        if filename2!=".DS_Store":
            print(filename2)
            data = open(jdata_loc+filename2,'r')
            jdata = data.readlines()
            for line in jdata:
                if line!=jdata[-1]:
                    jdata_lines.append(line)
            data.close()
    print("game")
    '''return False
    
    file = open('week2SunJ.txt','r')
    dFileName=storage_loc+storage_file+str(week_num)+txt
    dFile = open(dFileName,'w')'''
    counter=0#start of week 4 5900137
    english_counter=0
    count=0
    longer_line=[]
    true_pos=0
    false_pos=0
    false_neg=0
    true_neg=0
    fb_num=0
    #fileObj = codecs.open( dFileName, "r", "utf-8" )
    for line in jdata_lines:
        #line=unicode(line,errors='replace')
        '''count+=1
        if count==20:
            break
        print(line)'''
        weight=0
        #print(line)
        line = line.strip('\n')
        if line=="":
            blip=0
        else:
            line = line.lower()
            line2 = line.split('\t')
            #print(str(line2) + " " + str(len(line2)))
            term_true=False
            name_true=False
            hashes_true=False
            at_true=False
            if (line2[0].find("sun oct")!=-1 or line2[0].find("sun nov")!=-1 or line2[0].find("sun dec")!=-1) and len(line2)==5:
                time = line2[0]
                holder = time.split()
                if week_holder!=holder[2]:
                    week_holder = holder[2]
                    if week_num!=0:
                        dFile.close()
                    week_num+=1
                    dFileName=storage_loc+storage_file+str(week_num)+txt
                    dFile = open(dFileName,'w')
                user_name = line2[1]
                tweet = line2[2]
                geo_code = line2[3]
                hashes = line2[4]
                metrics=weighting.decide_weight(user_name,tweet,hashes,dicts)
                #print(str(counter) + str(line2) + " P " + str(metrics))
                weight=metrics[0]
                teams=metrics[1]
                fb_teams="null"
                if len(teams)!=0:
                    fb_teams=""
                    for el in teams:
                        fb_teams+=el+" "
                new_line=str(counter)+"\t"+time+"\t"+user_name+"\t"+tweet+"\t"+geo_code+"\t"+hashes+"\t"+str(weight)+"\t"+fb_teams+"\n"
                dFile.write(new_line)
                if counter%10000==0:
                    print("check counter "+str(counter))
                counter+=1
            elif line2[0].find("sun oct")!=-1 or line2[0].find("sun nov")!=-1 or line2[0].find("sun dec")!=-1:
                #print(line2)
                longer_line=line2
                #print(longer_line)
            elif line2[0].find("sun oct")==-1 or line2[0].find("sun nov")==-1 or line2[0].find("sun dec")==-1:
                #print(line2)
                if len(line2)==1:
                    longer_line[2]+=line2[0]
                elif len(line2)>3:
                    longer_line[2]+=line2[0]
                    longer_line.append(line2[1])
                    longer_line.append(line2[2])
                    line2=longer_line
                    time = line2[0]
                    holder = time.split()
                    if week_holder!=holder[2]:
                        week_holder = holder[2]
                        if week_num!=3:
                            dFile.close()
                        week_num+=1
                        dFileName=storage_loc+storage_file+str(week_num)+txt
                        dFile = open(dFileName,'w')
                    user_name = line2[1]
                    tweet = line2[2]
                    geo_code = line2[3]
                    hashes = line2[4]
                    metrics=weighting.decide_weight(user_name,tweet,hashes,dicts)
                    #print(str(counter) + str(line2) + " P " + str(metrics))
                    weight=metrics[0]
                    teams=metrics[1]
                    fb_teams="null"
                    if len(teams)!=0:
                        fb_teams=""
                        for el in teams:
                            fb_teams+=el+" "
                    new_line=str(counter)+"\t"+time+"\t"+user_name+"\t"+tweet+"\t"+geo_code+"\t"+hashes+"\t"+str(weight)+"\t"+fb_teams+"\n"
                    dFile.write(new_line)
                    if counter%10000==0:
                        print("check counter "+str(counter))
                    counter+=1
                    long_line=[]


def main():
    #build a file per sunday
    # October dates take PDT, then PST afterwards
    array_of_dates = ['Oct 21']#,'Oct 28','Nov 04','Nov 11','Nov 18','Nov 25','Dec 02']
    #build a file for all sunday
    dicts = weighting.OpenCompleteFile('Total_term_list.txt')
    workablelines = createDocument(dicts)
        

if __name__ == '__main__':
        main()
