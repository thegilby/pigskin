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
    file = open('Ground_Truth.txt','r')
    dFileName="test_result.txt"
    dFile = open(dFileName,'w')
    counter=0
    english_counter=0
    count=0
    longer_line=[]
    true_pos=0
    false_pos=0
    false_neg=0
    true_neg=0
    fb_num=0
    #fileObj = codecs.open( dFileName, "r", "utf-8" )
    for line in file:
        #line=unicode(line,errors='replace')
        '''count+=1
        if count==20:
            break'''
        #print(line)
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
            if (line2[0].find("sun oct")!=-1 or line2[0].find("sun nov")!=-1 or line2[0].find("sun dec")!=-1) and len(line2)==8:
                time = line2[0]
                user_name = line2[1]
                tweet = line2[2]
                geo_code = line2[3]
                hashes = line2[4]
                english = int(line2[5])
                fb_true = int(line2[6])
                association = line2[7]
                metrics=weighting.decide_weight(user_name,tweet,hashes,dicts)
                #print(str(counter) + str(line2) + " P " + str(metrics))
                weight=metrics[0]
                teams=metrics[1]
                counter+=1
                if english==1:
                    english_counter+=1
                if weight>1:
                    if fb_true==1:
                        true_pos+=1
                        fb_num+=1
                    else:
                        false_pos+=1
                else:
                    if fb_true==1:
                        print("X " + str(weight)+ " " +tweet)
                        false_neg+=1
                        fb_num+=1
                    else:
                        true_neg+=1
                new_line=time+"\t"+user_name+"\t"+tweet+"\t"+geo_code+"\t"+hashes+"\t"+str(english)+"\t"+str(fb_true)+"\t"+str(association)+"\t"+str(weight)+"\t"+str(teams)+"\n"
                dFile.write(new_line)
    total_pos=true_pos+false_pos
    total_neg=true_neg+false_neg
    print("Total Tweets Checked: "+str(counter))
    print("Total English Tweets Checked: "+str(english_counter))
    print("Total Football Tweets in Corpus: " + str(fb_num))
    print("Num True Positives/Total Positives: " +str(true_pos)+"/"+str(total_pos))
    print("Num False Negatives/Total Negatives: " +str(false_neg)+"/"+str(total_neg))

def main():
    #build a file per sunday
    # October dates take PDT, then PST afterwards
    array_of_dates = ['Oct 21']#,'Oct 28','Nov 04','Nov 11','Nov 18','Nov 25','Dec 02']
    #build a file for all sunday
    dicts = weighting.OpenCompleteFile('Total_term_list.txt')
    workablelines = createDocument(dicts)
        

if __name__ == '__main__':
        main()
