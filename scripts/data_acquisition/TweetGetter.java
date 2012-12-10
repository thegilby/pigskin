/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package twit1;

/**
 *
 * @author jacobportnoff
 */
import twitter4j.Status;
import twitter4j.StatusAdapter;
import twitter4j.StatusDeletionNotice;
import twitter4j.StatusListener;
import twitter4j.TwitterException;
import twitter4j.TwitterStream;
import twitter4j.TwitterStreamFactory;
import twitter4j.conf.ConfigurationBuilder;
import twitter4j.api.HelpMethods;
import twitter4j.HashtagEntity;
import twitter4j.ResponseList;
import java.util.*;
import java.io.Serializable;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.FileNotFoundException;
import java.io.IOException;

/**
 * Part1a
 * This program provides tweets from Twitter along with a count and a timer for
 * analysis fo these tweets.
 */
public final class TweetGetter extends StatusAdapter {
    
    public static void main(String[] args) throws IOException, TwitterException, FileNotFoundException {
        ConfigurationBuilder cb = new ConfigurationBuilder();
            cb.setDebugEnabled(true)
            .setOAuthConsumerKey("vGsMAca82HjVYYm7wQlN5Q")
            .setOAuthConsumerSecret("6mpRAAlMI6sIWruQNpomBzN1kIfodHexYBrKWPKmsuM")
            .setOAuthAccessToken("776768857-hCnK0Eu3orKK6qP98W7LyTF29QXadxydL21gIuon")
            .setOAuthAccessTokenSecret("V3VAJgO2x1zWO2JMHsRRrWLzYOeXxmlittF1pBBNWA4")
           ;
        
        TwitterStream twitterStream = new TwitterStreamFactory(cb.build()).getInstance();
        System.out.println("time " + System.currentTimeMillis());
        

        StatusListener listener = new StatusListener() {
            int counter=0;
            FileWriter fstream = new FileWriter("/Users/jacobportnoff/Desktop/week7SunJ.txt");
            BufferedWriter out = new BufferedWriter(fstream);
            long start = System.currentTimeMillis();
            double elapsedTimeSec = 0.0;
            public void onStatus(Status status) {
                HashtagEntity[] hashtags = status.getHashtagEntities();
                String hashes = "";
                if (hashtags.length == 0) {
                    hashes = "null";
                }
                else {
                    for (HashtagEntity hash: hashtags){
                        hashes = hashes+hash.getText()+ " ";
                    }
                }
                String tweet = status.getCreatedAt()+ "\t" + status.getUser().getScreenName() + "\t" + status.getText() + "\t" + status.getGeoLocation() + "\t" + hashes + "\n";
                //System.out.print(tweet);
                try {
                out.write(tweet);
                } catch (Exception e){//Catch exception if any
                    System.err.println("Error: " + e.getMessage());
                }
            }

            public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {
            }

            public void onTrackLimitationNotice(int numberOfLimitedStatuses) {
            }

            public void onScrubGeo(long userId, long upToStatusId) {
            }

            public void onException(Exception ex) {
                ex.printStackTrace();
            }
        };
        twitterStream.addListener(listener);
        twitterStream.sample();
    }
}
