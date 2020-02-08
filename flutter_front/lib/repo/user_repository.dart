import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserRepository{
  
  Future<User> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('username');
    if (name != null) {
      return User(name);
    }

    return null;
  }

  Future<User> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', user.name);

    return user;
  }
}