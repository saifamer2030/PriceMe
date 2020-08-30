import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final String auth_type = "auth_type";

//set data into shared preferences like this
  Future<void> setAuthType(String auth_type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.auth_type, auth_type);
  }

//get value from shared preferences
  Future<String> getAuthType() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String auth_type;
    auth_type = pref.getString(this.auth_type) ?? "";
    return auth_type;
  }
}