/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package twit1;

/**
 *
 * @author jacobportnoff
 */
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.LineNumberReader;
import twitter4j.Tweet;
import twitter4j.Twitter;
import twitter4j.TwitterFactory;
import twitter4j.Query;
import twitter4j.QueryResult;
import twitter4j.TwitterException;
import twitter4j.conf.ConfigurationBuilder;
import twitter4j.User;
import twitter4j.UserList;
import twitter4j.ResponseList;
import twitter4j.IDs;
import java.util.Scanner;
import java.util.Timer;
import java.util.TimerTask;
import java.util.Hashtable;
import java.util.Enumeration;
import java.lang.InterruptedException;
import java.io.File;
import java.util.StringTokenizer;

/*
 * Part2a
 * This program takes the people that I follow from my account JacobPortnoff and
 * returns their most recent tweets and their screen names.
 */
// BEFORE YOU RUN, be sure that the last line in the file is COMPLETE and did not get cut off when twitter failed!
public class screen_name_to_location_just_fbv3 {
     Timer timer;

     class lookup {
         Twitter twitter;
         String[] names;
         Hashtable Ilines;
         String s;
         Hashtable Unames;
         String[] lines;
         int x;
         String[] non_lines;
         BufferedWriter out;
         long seconds;
         
         public lookup(Twitter twitter,String[] names, Hashtable Ilines, String s, Hashtable Unames, String[] lines, int x, String[] non_lines, BufferedWriter out, long seconds)  throws InterruptedException{
            try {
               long cursor = -1;
               ResponseList<User> users = twitter.lookupUsers(names);

               //System.out.println("chceks");
               int q=0;
               for (User user : users) {
                   //System.out.println(lines[i]);
                   if (Ilines.containsKey(user.getScreenName().toLowerCase())){
                       //System.out.println(Ilines.containsKey(user.getScreenName().toLowerCase()) + " = " + user.getScreenName().toLowerCase() + " + " + Ilines.get(user.getScreenName().toLowerCase()));
                       s = Ilines.get(user.getScreenName().toLowerCase()).toString() + "\t" + user.getLang() + "\t" + user.getLocation() + "\n";
                       //System.out.println("@" + user.getScreenName() +  " " + user.getLang() + " " + user.getLocation());
                       //i++;
                       String checkname = user.getScreenName().toLowerCase().toString() + "#8557!";
                       if (Ilines.containsKey(checkname)) {
                           String l = Ilines.get(checkname).toString() + "\t" + user.getLang() + "\t" + user.getLocation() + "\n";
                           int w = new Integer(Unames.get(checkname).toString());
                           lines[w] = l;
                           Ilines.remove(checkname);
                       }
                       Ilines.remove(user.getScreenName().toLowerCase());
                       q++;
                       int p= new Integer(Unames.get(user.getScreenName().toLowerCase()).toString());
                       //System.out.println("heresss " + Unames.get("followthemonstr").toString());
                       lines[p] = s;
                   }
                   else {
                       System.out.println("--XXXXXXXXXXXXXXXX" + user.getScreenName().toLowerCase());
                   }
               }
               //System.out.println(q + " " + " " + users.size() + " " + Ilines.size() + " " + lines.length);

               //Enumeration nulls = Ilines.keys();
               for (Enumeration nulls = Ilines.keys(); nulls.hasMoreElements() ;) {
                   Object holder = nulls.nextElement();
                   int p= new Integer(Unames.get(holder).toString());
                   String o = Ilines.get(holder).toString() + "\tnull\tnull\n";
                   lines[p] = o;
               }
               System.out.println(q + " " + " " + users.size() + " " + Ilines.size() + " " + lines.length);
               int i=0;
               int non=0;
               int non_index=-1;
               int fb_index=-1;
               StringTokenizer a;
               StringTokenizer b;
               //System.out.println(non_lines[non] + " " + lines[i]);
               while (i<x){
                   System.out.println(i+ " " +lines[i]);
                   i++;
               }
               i=0;
               try {
                   //System.out.println(s);
                   // merge non fb and fb tweets and output them

                   while (i<x) {
                       if (non_lines[non]!=null){
                           a = new StringTokenizer(non_lines[non]);
                           non_index=new Integer(a.nextToken());
                       }
                       else {
                           non_index=non_index+1;
                           //System.out.println("huh " + non + " " + i);
                       }
                       if (lines[i]!=null){
                           b = new StringTokenizer(lines[i]);
                           fb_index=new Integer(b.nextToken());
                       }
                       //System.out.println(non_index + " " + fb_index);
                       if (fb_index<non_index){
                           if (lines[i] != null) {
                               out.write(lines[i]);
                               i++; 
                           }
                           else {
                               i=x;
                           }
                       }
                       else if (non_index < fb_index){
                           if (non_lines[non] != null) {
                               String non_out = non_lines[non] + "\tnull\tnull\n";
                               out.write(non_out);
                               non++;
                           }
                           else {
                               i=x;
                           }
                       }
                       else {
                           //System.out.println("Major problem, try again");
                       }
                   }
                   System.out.println(fb_index + " " + non_index);

               }
               catch (IOException ie){
                   ie.printStackTrace();
                   System.out.println("Failed to lookup users: " + ie.getMessage());
                   System.exit(-1);
               }
           } 
           catch (TwitterException te) {
                te.printStackTrace();
                System.out.println("Failed to lookup users: " + te.getMessage());
                Thread.sleep(seconds);
                new lookup(twitter, names, Ilines, s, Unames, lines, x, non_lines, out, seconds);
           }
         }
     }
     
     public screen_name_to_location_just_fbv3(long seconds, String s, int j, String[] names, Scanner scan, BufferedReader keysin, Twitter twitter, BufferedWriter out, Hashtable Unames, int last_indexed, int first_indexed) throws InterruptedException {
        timer = new Timer();
        int x=100;
        //System.out.println("seconds: " + seconds);
        int secs = 10;
        Boolean tf = false;
        Boolean check = false;
        String[] non_lines = new String[100000];
        String[] lines = new String[100];
        Hashtable<String, String> Ilines = new Hashtable<String, String>();
        System.out.println("Task scheduled. " + last_indexed);
        int last_count = first_indexed;
        int non_count = 0;
        int true_check=0;
        while (s!=null){
            //System.out.println("check1s " + last_count);
            if (last_count>last_indexed || last_indexed==0) {
                Thread.sleep(seconds);
                //check=false;
                //System.out.println("check1 " + last_count + " " + last_indexed);
                while (j<x){
                    String key = scan.next();
                    scan.next();
                    scan.next();
                    scan.next();
                    int fb_score = new Integer(scan.next());
                    //System.out.println("check2 " + key + " " + s);
                    if (fb_score>1) {
                        if (Unames.containsKey(key)) {
                            key=key+"#8557!";
                        }
                        Unames.put(key, j);
                        names[j] = key;
                        Ilines.put(key,s);
                        j++;
                        //System.out.println("FB Tweet " + j + " : "+ key + " " + Unames.get(key).toString());

                    }
                    else {
                        non_lines[non_count] = s;
                        //System.out.print(non_count + " " + s);
                        non_count++;
                    }
                    //System.out.println(key + " " + s);
                    try {
                        s = keysin.readLine();
                        if (s!=null){
                            s.replace("\n", "");
                            scan = new Scanner(s).useDelimiter("\\t");
                            scan.next();
                            scan.next();
                        }
                        else {
                            j=x;
                        }
                        //lines[j]=s;
                    }
                    catch (IOException ie){
                        ie.printStackTrace();
                        System.out.println("Failed to lookup users: " + ie.getMessage());
                        System.exit(-1);
                    }
                    
                }
                if (j==x){
                    tf=true;
                }
                if (tf==true){
                    new lookup(twitter, names, Ilines, s, Unames, lines, x, non_lines, out, seconds);
                    System.out.print("You have connected to the Twitter API this many times: " + true_check);
                    true_check++;
                    non_lines = new String[100000];
                    lines = new String[100];
                    j=0;
                    non_count=0;
                    names = new String[100];
                    tf=false;
                    Ilines.clear();
                    Unames.clear();
                    //System.exit(-1);
                }        
            }
            else {
                try {
                    s = keysin.readLine().replace("\n", "");
                    scan = new Scanner(s).useDelimiter("\\t");
                    scan.next();
                    scan.next();
                    //lines[j]=s;
                }
                catch (IOException ie){
                    ie.printStackTrace();
                    System.out.println("Failed to lookup users: " + ie.getMessage());
                    System.exit(-1);
                }
            }
            last_count++;
	}
        // start
        int non=0;
        if (names.length!=0) {
            new lookup(twitter, names, Ilines, s, Unames, lines, x, non_lines, out, seconds);
            names = new String[100];
            tf=false;
            Ilines.clear();
            Unames.clear();
        }
        if (non_lines[non]!=null) {
            while (non_lines[non] != null) {
                String non_out = non_lines[non] + "\tnull\tnull\n";
                try {
                    out.write(non_out);
                }
                catch (IOException ie){
                    ie.printStackTrace();
                    System.out.println("Failed to lookup users: " + ie.getMessage());
                    System.exit(-1);
                }
                non++;
            }
        }
        System.out.println("Fin.");
        System.exit(-1);
        // end
    }

    public static void main(String args[]) throws IOException, TwitterException, FileNotFoundException, InterruptedException {
        ConfigurationBuilder cb = new ConfigurationBuilder();
            cb.setDebugEnabled(true)
            .setOAuthConsumerKey("vGsMAca82HjVYYm7wQlN5Q")
            .setOAuthConsumerSecret("6mpRAAlMI6sIWruQNpomBzN1kIfodHexYBrKWPKmsuM")
            .setOAuthAccessToken("776768857-hCnK0Eu3orKK6qP98W7LyTF29QXadxydL21gIuon")
            .setOAuthAccessTokenSecret("V3VAJgO2x1zWO2JMHsRRrWLzYOeXxmlittF1pBBNWA4");
        
        /*data_loc="/Users/jacobportnoff/Dropbox/290-twitter/data/"
        jdata_loc="/Users/jacobportnoff/Dropbox/290-twitter/Jdata/"
        storage_loc="/Users/jacobportnoff/Dropbox/290-twitter/Wdata/"
        storage_file="indexed_tweets_w"*/
        //String old_file[] = new String[5000000];
        int file_num = -1;
        Boolean first_line = true;
        FileReader keystream = new FileReader("/Users/jacobportnoff/Dropbox/290-twitter/Wdata/indexed_tweets_w7.txt");
        BufferedReader keysin = new BufferedReader(keystream);
        keysin.readLine();

        String names[] = new String[100];
        Hashtable<String, Integer> Unames = new Hashtable<String, Integer>();
        String s = keysin.readLine().replace("\n", "");
        Scanner scan = new Scanner(s).useDelimiter("\\t");
        scan.next();
        scan.next();
        int j=0;
        int first_indexed=0;
        long secs = 4000*3600/180+1000;
        Twitter twitter = new TwitterFactory(cb.build()).getInstance();
        File prev = new File("/Users/jacobportnoff/Dropbox/290-twitter/Indexed data/complete_tweets_w7.txt");
        int last_indexed = 0;
        FileWriter tempstream = new FileWriter("/Users/jacobportnoff/Desktop/tweet_holder.txt");
        BufferedWriter tempout = new BufferedWriter(tempstream);
        if (prev.exists()) {
            FileReader prev_file = new FileReader("/Users/jacobportnoff/Dropbox/290-twitter/Indexed data/complete_tweets_w7.txt");
            BufferedReader prev_in = new BufferedReader(prev_file);
 
            String strLine = "";
            String tmp = null;
            String hold = null;
            while ((tmp = prev_in.readLine()) != null)
            {
                if (first_line==true) {
                    first_line=false;
                }
                else {
                    hold = strLine + "\n";
                    //System.out.print(hold + " " + file_num);
                    tempout.write(hold);
                }
                strLine = tmp;
                file_num++;
            }

            String lastLine = strLine;
            if (file_num>0){
                if (hold != null) {
                    Scanner lastScan = new Scanner(hold).useDelimiter("\\t");
                    last_indexed = new Integer(lastScan.next().toString());
                    //System.out.println("error with this line: " + last_indexed);
                    //System.out.println(last_indexed + old_file[0]);
                }
            }
        }
        FileWriter fstream = new FileWriter("/Users/jacobportnoff/Dropbox/290-twitter/Indexed data/complete_tweets_w7.txt");
        BufferedWriter out = new BufferedWriter(fstream);
        if (last_indexed==0) {
            out.write("id\tdate_time\tscreen_name\ttweet\tgeoloc\thashtags\tfb_weight\tfb_assoc\tlang\tuser_loc\n");
        }
        else {
            int re = 0;
            FileReader temp = new FileReader("/Users/jacobportnoff/Desktop/tweet_holder.txt");
            BufferedReader temp_in = new BufferedReader(temp);
            String strLine = "";
            String tmp = null;
            
            while ((tmp = temp_in.readLine()) != null)
            {
                strLine = tmp + "\n";
                out.write(strLine);
                if (re==1) {
                    Scanner lastScan = new Scanner(strLine).useDelimiter("\\t");
                    first_indexed = new Integer(lastScan.next().toString());
                }
                re++;
            }
            temp_in.close();
        }
        System.out.println("last indexed: " +last_indexed + " num in file: " + file_num);
        new screen_name_to_location_just_fbv3(secs,s,j,names,scan,keysin,twitter,out,Unames,last_indexed,first_indexed);
    } 
}// BEFORE YOU RUN, be sure that the last line in the file is COMPLETE and did not get cut off when twitter failed!
