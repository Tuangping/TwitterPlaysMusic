import ddf.minim.*;
import com.temboo.core.*;
import com.temboo.Library.Twitter.Search.*;

Minim minim;
AudioPlayer player;

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
}

void draw() {
  background(#97EBED);
  fill(200);
  text(tweetText, width/2, height/2);
  switch(loadScenes) {
  case 0:
    minim = new Minim(this); 
    player = minim.loadFile(dataFolder+"/music/"+emotion+"/1.mp3");
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
  if (!finishSearch) {
    for (TableRow row : table.rows()) {
      words = row.getString("words");
      println("comparing");
      //if(player.isPlaying()){
      //println("**hey**");
      //}
      if (tweetText.contains(words)==true) {
        println("pause music");
        player.pause();
        println("found!");
        emotion = row.getString("emotion");
        player = minim.loadFile(dataFolder+"/music/"+emotion+"/1.mp3");
        println("start playing");
        player.play();
        finishSearch = true;
        println("tweetNumber: "+tweetNumber+" / "+ (tweetArray.size()-1)+" ="+tweetText);
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