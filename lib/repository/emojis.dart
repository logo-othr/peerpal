import 'package:peerpal/repository/emoji_data.dart';

class Emojis {

  static const List<EmojiData> activityEmojis = const [
    biking, shopping, walking, music, games, celebration,
  ];

  static List<EmojiData> eatAndDrinkEmojis = const [
    coffee, beer, wine, champagne,  cake, pasta,
  ];

  static List<EmojiData> year = const [
    summer, winter, storm,
  ];

  static List<EmojiData> gestures = const [
    thumpsup, thumpsdown, wave, clap,
  ];

  static List<EmojiData> smileyAndEmotionsEmojis = const [
    smile, hug, wink, angry, sad, happy, laugh, love, ill, think, tongue,
  ];


// Aktivitäten
  static const EmojiData biking = const EmojiData('biking', '\u{1F6B2}',);
  static const EmojiData shopping = const EmojiData('shopping', '\u{1F6D2}',);
  static const EmojiData walking = const EmojiData('walking', '\u{1F6B6}',);
  static const EmojiData music = const EmojiData('music', '\u{1F3B6}',);
  static const EmojiData games = const EmojiData('games', '\u{1F3B2}',);
  static const EmojiData celebration = const EmojiData(
    'celebration', '\u{1F389}',);


//Essen und Trinken
  static const EmojiData coffee = const EmojiData('coffee', '\u{2615}',);
  static const EmojiData beer = const EmojiData('beer', '\u{1F37B}',);
  static const EmojiData wine = const EmojiData('wine', '\u{1F377}',);
  static const EmojiData champagne = const EmojiData('champagne', '\u{1F942}',);
  static const EmojiData cake = const EmojiData('cake', '\u{1F382}',);
  static const EmojiData pasta = const EmojiData('pasta', '\u{1F35D}',);

//Durch das Jahr
  static const EmojiData summer = const EmojiData('summer', '\u{2600}',);
  static const EmojiData winter = const EmojiData('winter', '\u{2744}',);
  static const EmojiData storm = const EmojiData('storm', '\u{26C8}',);



//Gesten
  static const EmojiData thumpsup = const EmojiData('thumpsup', '\u{1F44D}',);
  static const EmojiData thumpsdown = const EmojiData(
    'thumpsdown', '\u{1F44E}',);
  static const EmojiData wave = const EmojiData('wave', '\u{1F44B}',);
  static const EmojiData clap = const EmojiData('clap', '\u{1F44F}',);






//Smileys und Emotionen
  static const EmojiData smile = const EmojiData('smile', '\u{1F642}',);
  static const EmojiData hug = const EmojiData('hug', '\u{1F917}',);
  static const EmojiData wink = const EmojiData('wink', '\u{1F609}',);
  static const EmojiData angry = const EmojiData('angry', '\u{1F621}',);
  static const EmojiData sad = const EmojiData('sad', '\u{1F625}',);
  static const EmojiData happy = const EmojiData('happy', '\u{1F603}',);
  static const EmojiData laugh = const EmojiData('laugh', '\u{1F602}',);
  static const EmojiData love = const EmojiData('love', '\u{2764}',);
  static const EmojiData ill = const EmojiData('ill', '\u{1F637}',);
  static const EmojiData think = const EmojiData('think', '\u{1F914}',);
  static const EmojiData tongue = const EmojiData('tongue', '\u{1F60B}',);

}

