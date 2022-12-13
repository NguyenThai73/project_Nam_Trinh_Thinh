import 'package:nam_trinh_thinh/model/jobs.dart';
import 'company.dart';

class Work {
  int? id;
  String? name;
  int? salary;
  int? quantity;
  bool? sex;
  String? age;
  String? experence;
  String? contactInfo;
  String? area;
  String? workAddress;
  String? description;
  int? status;
  int? codeAddress;
  String? dateExpiration;
  Jobs? job;
  Company? company;

  Work({
    this.id,
    this.name,
    this.salary,
    this.quantity,
    this.sex,
    this.status,
    this.codeAddress,
    this.dateExpiration,
    this.description,
    this.age,
    this.workAddress,
    this.area,
    this.company,
    this.contactInfo,
    this.experence,
    this.job,
  });
}
