import 'package:flutter/cupertino.dart';

import '../model/user_login.dart';

class User with ChangeNotifier {
  String authorization = "";
  changeAuthorization(String authorizationNew) {
    authorization = authorizationNew;
    notifyListeners();
  }

  UserLogin user = UserLogin();
  changeUser(UserLogin newUser) {
    user = newUser;
    notifyListeners();
  }

  int countJobs = 0;
  changeCountJobs(int newCount) {
    countJobs = newCount;
    notifyListeners();
  }
}
