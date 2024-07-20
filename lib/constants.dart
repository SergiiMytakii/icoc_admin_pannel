import 'dart:ui';

const List<Color> dividerColors = [
  Color(0xFFFF595E),
  Color(0xffffca3a),
  Color(0xff8ac926),
  Color(0xff1982c4),
  Color(0xff6a4c93)
];

class ScreenColors {
  static const general = Color(0xff6a4c93);
  static const songBook = Color(0xffff595e);
  static const video = Color(0xffffca3a);
  static const bibleStudy = Color(0xff8ac926);
  static const QandA = Color(0xff1982c4);
}

const String email = 'serjmitaki@gmail.com';
const String payPalAccount = 'serjmitaki@gmail.com';
const String usdtWallet = 'TF9irV2F7CoGVpZFvDxvV7hzmT9esWanjf';
const String monoBankCard = '5375411432482466';
const appUrlPlayMarket =
    'https://play.google.com/store/apps/details?id=ru.icoc.app';
const appUrlAppStore = 'https://apps.apple.com/us/app/icoc/id1585486521';

enum SlideActions { AllSongs, Favorites, Playlists }

const YOUTUBE_API_KEY = 'AIzaSyA-Hp3iqUoRZKhVwZ3lqFOOwntlkOaZg5I';

const String YOUTUBE_TERMS_OF_SERVISES = 'https://www.youtube.com/t/terms';
const String YOUTUBE_PRIVACY_POLICIES = 'https://policies.google.com/privacy';
const String ICOC_WEB_PAGE = 'https://icoc.netlify.app';
const String fullLogoImageUrl =
    'https://firebasestorage.googleapis.com/v0/b/icoc-8f075.appspot.com/o/app%2Ffullicoclogo.png?alt=media&token=83d15371-2b6a-4cc1-8aca-7ad67a514827';
const String placeholderImageUrl =
    'https://firebasestorage.googleapis.com/v0/b/icoc-8f075.appspot.com/o/app%2Flogo_icoc_drawer.png?alt=media&token=e9179408-a329-4554-863b-b4373f20d40d';
const String videoGuideRussianId = 'luUmrJM3Ywg';
const String videoGuideEnglishId = 'hnJOc9ltntk';

class StorageKeys {
  static const String orderByTitle = 'orderByTitle';
  static const String allSongsLanguages = 'allSongsLanguages';
  static const String allSongsTextKeys = 'allSongsTextKeys';
  static const String locale = 'locale';
  static const String fontSize = 'fontSize';
  static const String bibleStudyLanguages = 'bibleStudyLanguages';
  static const String notifications = 'notifications';
  static const String videosAllLanguages = 'videosAllLanguages';
  static const String firstAppRunDate = 'firstAppRunDate';
  static const String shouldVideoFilterAnimate = 'shouldVideoFilterAnimate';
  static const String shouldShowTooltip = 'shouldShowTooltip';
  static const String shouldSongsFilterAnimate = 'shouldSongsFilterAnimate';
  static const String shouldBibleStudyFilterAnimate =
      'shouldBibleStudyFilterAnimate';
  // Add more keys as needed
}

Map<String, String> languagesCodes = {
  'en': 'English',
  'et': 'Estonian',
  'fr': 'French',
  'de': 'German',
  'bg': 'Bulgarian',
  'it': 'Italian',
  'lv': 'Latvian',
  'lt': 'Lithuanian',
  'no': 'Norwegian',
  'pl': 'Polish',
  'ro': 'Romanian',
  'ru': 'Russian',
  'es': 'Spanish',
  'sv': 'Swedish',
  'uk': 'Ukrainian',
  'sk': 'Slovak',
  'sl': 'Slovenian',
  'fi': 'Finnish',
  'al': 'Albanian',
  'be': 'Belarusian',
  'bs': 'Bosnian',
  'ca': 'Catalan',
  'hr': 'Croatian',
  'cz': 'Czech',
  'nl': 'Dutch',
  'gr': 'Greek',
  'hu': 'Hungarian',
  'is': 'Icelandic',
  'ga': 'Irish',
  'lb': 'Luxembourgish',
  'mk': 'Macedonian',
  'pt': 'Portuguese',
  'sr': 'Serbian',
};

enum FirebaseCollections {
  Songs,
  BibleStudy,
  Notifications,
  Video,
  Feedback,
  UsersLogs
}
