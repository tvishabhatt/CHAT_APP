import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';




class SharedPreferencesProvider extends ChangeNotifier{
  late String _name;
  late String _email;
  SharedPreferencesProvider(){
    _name="Default Name";
    _email = 'Default Email';
    _loadStrings();
  }
  String get name => _name;
  String get email => _email;

  Future<void> _loadStrings() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('name')??"Defult Name";
    _email = prefs.getString('email') ?? 'Default Email';

    notifyListeners();
  }

    Future<void> saveUserInfo(String name, String email) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('name', name);
      prefs.setString('email', email);
      notifyListeners();
    }
  Future<void> updateUserInfo(String newName, String newEmail) async {
    _name = newName;
    _email = newEmail;
    saveUserInfo(_name, _email);
    notifyListeners();
  }


}