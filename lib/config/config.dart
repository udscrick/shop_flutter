class Config {
  final String firebaseKey;
  Config({this.firebaseKey = ""});
  factory Config.fromJson(Map<String, dynamic> jsonMap) {
    return new Config(firebaseKey: jsonMap["firebase_key"]);
  }
}