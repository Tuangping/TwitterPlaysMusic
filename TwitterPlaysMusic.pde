import ddf.minim.*;
import com.temboo.core.*;
import com.temboo.Library.Twitter.Search.*;

Minim minim;
Minim minim2;
AudioPlayer player;
AudioPlayer player2;
int playerOrder =0;

Table table;
String words;
String emotion="a";
String inputFolder = "/Users/Tuang/Documents/Documents/UCLA_WORKS/DMA_5_Winter_2018/Sound_of_Twiiter/data/";
File dataFolder = new File (inputFolder);
Boolean finishSearch = false;
String tweetText ="";
int loadScenes =0;

// twitter var
TembooSession session = new TembooSession("tuangt", "myFirstApp", "7s7zMsLTBsxC6S0exSAgSOzBiSayItWc");
JSONObject searchResults;
String searchText, tweetTime;
JSONObject tweetObj;
String[] times;
int tweetNumber=0;
JSONArray tweetArray;

void setup() {
  size(600, 400);
  background(#97EBED);
  textSize(16);
  textAlign(CENTER);
  noStroke();
  text("loading music", width/2, (height/2)+50);
  table = loadTable(dataFolder+"/words.csv", "header");
  println(table.getRowCount() + "total rows in table");
  //uncomment below to see what data in each row/column 
  //for (TableRow row : table.rows()) {  
  //    words = row.getString("words");
  //    emotion = row.getString("emotion");
  //    println(words);
  //    println(emotion);
  //}
  // minim library needs draw() to play music
  //tweet = "yelling";
  minim = new Minim(this); 
  player = minim.loadFile(dataFolder+"/music/"+emotion+"/1.mp3");
  minim2 = new Minim(this); 
  player2 = minim2.loadFile(dataFolder+"/music/"+emotion+"/1.mp3");
}

void draw() {
  background(#97EBED);
  fill(0);
  text(tweetText, width/2, height/2);
  switch(loadScenes) {
  case 0:
    thread("loadFile");
    loadScenes++;
    break;
  case 1:
    text("loading music", width/2, (height/2)+50);
    break;
  case 2:
    compare();
    break;
  }
}

void loadFile() {
  runTweetsChoreo();
  ///--------------/////
  getTweetFromJSON();
  ///--------------/////
  loadScenes++;
}

void compare() {
  if (!finishSearch && playerOrder==0) {
    for (TableRow row : table.rows()) {
      words = row.getString("words");
      println("comparing");
      if (tweetText.contains(words)==true) {
        //if (player.isPlaying()||player2.isPlaying()) {
        //  println("pause music");
        //  player.pause(); 
        //  player2.pause();
        //}
        println(words+" found!");

        if (playerOrder ==0) {
          emotion = row.getString("emotion");
          player = minim.loadFile(dataFolder+"/music/"+emotion+"/1.mp3");
          player.play();
          println(words+" start playing 1111111");
          playerOrder=1;
        } else if ( playerOrder==1) {
          emotion = row.getString("emotion");
          player2 = minim2.loadFile(dataFolder+"/music/"+emotion+"/1.mp3");
          println(words+" start playing 222222");
          player2.play();
          playerOrder=2;
        }

        //println("tweetNumber: "+tweetNumber+" / "+ (tweetArray.size()-1)+" ="+tweetText);
        finishSearch = true;
      } else {
        //println("not found!");
        finishSearch = true;
      }
    }
  } else {
    //println("stop searching");
  }
}


void runTweetsChoreo() {
  Tweets tweetsChoreo = new Tweets(session);

  // Set inputs
  tweetsChoreo.setQuery("#PlaythisMusicforyourTwitter");
  tweetsChoreo.setAccessToken("904713273655779330-7Vc2TQXB53uNJSfYiYPUTemXqUDpUBp");
  tweetsChoreo.setConsumerKey("rsUEYjmYikIO47jcrfVZIVRiQ");
  tweetsChoreo.setConsumerSecret("mCgWVRk5fFwP2Dvx8oY52p3MTSCUVOhdgnACW63M9j20FdV5lu");
  tweetsChoreo.setAccessTokenSecret("Cx4IIERskBUVU0V67MTJSZrdbfLALWTkDWrpAUrPouQqC");

  // Run the Choreo and store the results
  TweetsResultSet tweetsResults = tweetsChoreo.run();
  searchResults = parseJSONObject(tweetsResults.getResponse());
}
void getTweetFromJSON() {

  tweetArray = searchResults.getJSONArray("statuses"); // Create a JSON array of the Twitter statuses in the object
  tweetObj = tweetArray.getJSONObject(tweetNumber); // Grab the first tweet and put it in a JSON object
  tweetText = tweetObj.getString("text"); // Pull the tweet text from tweet JSON object
  tweetTime = tweetObj.getString("created_at");
  times = split(tweetTime, '+');
  //println(statuses.getJSONObject(0)); // Print tweet to console
  //println(tweetNumber+") "+tweetText+"|time :"+times[0]);
  //for (int i=0; i<tweetArray.size(); i++) {
  //println(i+" ) "+tweetArray.getJSONObject(i).getString("text"));
  //}
}

void keyPressed() {
  switch(keyCode) {
  case ENTER :
    //thread("updateTweets");
    break;
  case LEFT :
    if (tweetNumber==tweetArray.size()-1) {
      tweetNumber=0;
      getTweetFromJSON();
      finishSearch = false;
    } else {
      tweetNumber ++;
      getTweetFromJSON();
      finishSearch = false;
    }
    break;
  case RIGHT :
    if (tweetNumber==0) {
      tweetNumber= tweetArray.size()-1;
      getTweetFromJSON();
      finishSearch = false;
    } else {
      tweetNumber --;
      getTweetFromJSON();
      finishSearch = false;
    }
    break;
  }
}