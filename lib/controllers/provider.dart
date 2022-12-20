import 'package:flutter/cupertino.dart';
import 'package:nam_trinh_thinh/model/works.dart';

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

  List<WorkUT> listWorkUT = [];
  changeWorkUT(List<WorkUT> listWorkUTNew) {
    listWorkUT = listWorkUTNew;
    notifyListeners();
  }
}

class WorkUT {
  Work work;
  int status;
  WorkUT({required this.work, required this.status});
}
