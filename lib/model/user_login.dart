import 'package:intl/intl.dart';

import 'jobs.dart';

class UserLogin {
  int? id;
  String? fullName;
  String? auth;
  String? birthDay;
  bool? sex;
  String? urlImg;
  String? uuid;
  String? email;
  Jobs? job;
  String? address;
  String? cccd;
  String? phone;
  String? experence;
  String? urlCv;
  int? codeAddress;
  UserLogin(
      {this.id,
      this.fullName,
      this.birthDay,
      this.sex,
      this.urlImg,
      this.uuid,
      this.email,
      this.job,
      this.address,
      this.cccd,
      this.phone,
      this.auth,
      this.experence,
      this.urlCv,
      this.codeAddress});
  factory UserLogin.fromJson(Map<dynamic, dynamic> json) {
    return UserLogin(
      id: json['user']['id'],
      fullName: json['user']['fullName'] ?? "",
      email: json['user']['email'] ?? "",
      birthDay: (json['user']['birthDay'] != null && json['user']['birthDay'] != "")
          ? DateFormat('dd-MM-yyyy').format(DateTime.parse(json['user']['birthDay']).toLocal())
          : null,
      sex: json['user']['sex'],
      urlImg: json['user']['urlImg'] ?? "",
      urlCv: json['user']['urlCv'] ?? "",
      job: (json['user']['job'] != null) ? Jobs(id: json['user']['job']['id'], name: json['user']['job']['name']) : Jobs(),
      cccd: (json['user']['profile'] != null) ? json['user']['profile']['cccd'] : "",
      phone: (json['user']['profile'] != null) ? json['user']['profile']['phone'] : "",
      address: (json['user']['profile'] != null) ? json['user']['profile']['address'] : "",
      experence: (json['user']['profile'] != null) ? json['user']['profile']['experence'] : "",
      codeAddress: (json['user']['profile'] != null) ? json['user']['profile']['codeAddress'] : "",
    );
  }
}
