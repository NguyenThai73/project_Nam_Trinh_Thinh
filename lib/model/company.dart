class Company {
  int? id;
  String? name;
  String? email;
  String? address;
  String? urlImg;
  String? phone;
  int? jobs;
  Company({this.id, this.name, this.email, this.address, this.urlImg, this.phone, this.jobs});
  factory Company.fromJson(Map<dynamic, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      address: json['address'],
      urlImg: json['urlImg'],
      phone: json['phone'],
      jobs: json['jobs'],
    );
  }
}
