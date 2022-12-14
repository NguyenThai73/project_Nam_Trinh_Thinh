// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nam_trinh_thinh/ui/screen/home/job_info_screen.dart';
import '../../../controllers/api.dart';
import '../../../model/company.dart';
import '../../../model/works.dart';
import '../../style/color.dart';
import '../home/home_screen.dart';

class EmployerInfo extends StatefulWidget {
  Company company;
  EmployerInfo({super.key, required this.company});
  @override
  State<EmployerInfo> createState() => _EmployerInfoState();
}

class _EmployerInfoState extends State<EmployerInfo> {
  int selectedTap = 0;
  List<Work> listWorkcompany = [];
  Future<List<Work>> getCountJobs() async {
    listWorkcompany = [];
    var response1 = await httpGet("/api/company/${widget.company.id}", context);
    var body1 = response1['body'];
    if (body1['jobs'] != null && body1['jobs'].length > 0) {
      for (var element in body1['jobs']) {
        Work item = Work(
          id: element['id'],
          company: widget.company,
          // job: Jobs(
          //   id: element['job']['id'],
          //   name: element['job']['name'],
          //   countJob: element['job']['countJob'],
          // ),
          name: element['name'],
          salary: element['salary'],
          sex: element['sex'],
          age: element['age'],
          experence: element['experence'],
          contactInfo: element['contactInfo'],
          area: element['area'],
          workAddress: element['workAddress'],
          description: element['description'],
          status: element['status'],
          codeAddress: element['codeAddress'],
          dateExpiration: element['dateExpiration'],
        );
        listWorkcompany.add(item);
      }
    }
    return listWorkcompany;
  }

  Map<int, String> provinces = {};
  getProvinces() async {
    var response2 = await httpGetNo("https://provinces.open-api.vn/api/?depth=1", context);
    if (response2.containsKey("body")) {
      List<dynamic> body = response2['body'];
      for (var element in body) {
        provinces[element['code']] = element['name'];
      }
    }
  }

  bool statusData = false;
  void callApi() async {
    await getCountJobs();
    await getProvinces();
    setState(() {
      statusData = true;
    });
  }

  @override
  void initState() {
    super.initState();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: colorBlack,
              size: 20,
            )),
        title: Text("Chi tiết công ty", style: TextStyle(color: colorBlack, fontSize: 23)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => HomePage(),
                  ),
                );
              },
              icon: const Icon(Icons.home, size: 25))
        ],
      ),
      body: (statusData)
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 220,
                    decoration: BoxDecoration(
                      color: maincolor,
                      image: DecorationImage(
                        image: AssetImage("assets/images/background-company.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              width: 120,
                              height: 120,
                              child: Image.network(widget.company.urlImg!),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                      widget.company.name!,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )),
                                SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(Icons.group, size: 20, color: colorWhite),
                                    SizedBox(width: 15),
                                    Text("20-150 người", style: TextStyle(fontSize: 16, color: colorWhite)),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(Icons.language, size: 20, color: colorWhite),
                                    SizedBox(width: 15),
                                    Text("Chưa cập nhật", style: TextStyle(fontSize: 16, color: colorWhite)),
                                  ],
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    height: 680,
                    child: DefaultTabController(
                      length: 2,
                      initialIndex: selectedTap,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 20, right: 40),
                            child: TabBar(
                              indicatorWeight: 3,
                              isScrollable: true,
                              // indicatorPadding: EdgeInsets.only(bottom: 10),
                              indicatorColor: colorWhite,
                              onTap: (value) {
                                setState(() {
                                  selectedTap = value;
                                });
                              },
                              tabs: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: (selectedTap == 0) ? maincolor : colorWhite,
                                    border: Border.all(width: 1, color: maincolor),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  width: 180,
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Gới thiệu",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: (selectedTap == 0) ? colorWhite : colorBlack,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: (selectedTap == 1) ? maincolor : colorWhite,
                                    border: Border.all(width: 1, color: maincolor),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  width: 180,
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Tuyển dụng",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: (selectedTap == 1) ? colorWhite : colorBlack,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(15),
                                width: MediaQuery.of(context).size.width * 1,
                                decoration: BoxDecoration(
                                  color: maincolor.withOpacity(0.3),
                                ),
                                child: ListView(
                                  controller: ScrollController(),
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    Text(
                                      "Giới thiệu",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 10),
                                    Text("Chưa cập nhật"),
                                    SizedBox(height: 30),
                                    Text(
                                      "Phúc lợi công ty",
                                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      "1. Chế độ đãi ngộ hấp dẫn",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 10),
                                    Text("-Mức thu nhập cao"),
                                    SizedBox(height: 10),
                                    Text("-Chế độ phúc lợi đặc biệt"),
                                    SizedBox(height: 10),
                                    Text("-Hỗ trợ đầy đủ các khoản phụ cấp"),
                                    SizedBox(height: 20),
                                    Text(
                                      "2. Đào tạo",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 10),
                                    Text("-Môi trường làm việc chuyên nghiệp"),
                                    SizedBox(height: 10),
                                    Text("-Có cơ hội học tập, phát triển, nâng cao năng lực"),
                                    SizedBox(height: 20),
                                    Text(
                                      "3. Cơ hội phát triển",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 10),
                                    Text("-Đào tạo để trở thành cán bộ nguồn của công ty"),
                                    SizedBox(height: 10),
                                    Text("-Đánh giá, đề bạt thăng chức 1 năm 2 lần"),
                                    SizedBox(height: 30),
                                    Text(
                                      "Liên hệ",
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 10),
                                    Text(widget.company.address ?? ""),
                                    SizedBox(height: 10),
                                    Text(widget.company.phone ?? ""),
                                    SizedBox(height: 10),
                                    Text(widget.company.email ?? ""),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width * 1,
                                decoration: BoxDecoration(
                                  color: maincolor.withOpacity(0.3),
                                ),
                                child: ListView(
                                  controller: ScrollController(),
                                  children: [
                                    for (var element in listWorkcompany)
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push<void>(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) => WorkInfo(
                                                work: element,
                                                province: "",
                                              ),
                                            ),
                                          );
                                        },
                                        child: JobsBox(
                                          work: element,
                                          provinces: provinces,
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ]),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class JobsBox extends StatelessWidget {
  Work? work;
  Map<int, String>? provinces;
  JobsBox({Key? key, this.work, this.provinces}) : super(key: key);
  final oCcy = NumberFormat("#,##0", "en_US");
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      height: 200,
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                width: 70,
                height: 70,
                decoration: BoxDecoration(border: Border.all(width: 1)),
                child: Image.network(work!.company!.urlImg ?? "", width: 70, height: 70),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.63,
                    child: Text(
                      work?.name! ?? "",
                      style: TextStyle(color: colorBlack, fontSize: 16, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.63,
                    child: Text(
                      work?.company!.name! ?? "",
                      style: TextStyle(color: colorBlack, fontSize: 14, fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            ],
          ),
          Row(
            children: [
              SizedBox(width: 10),
              Icon(Icons.location_on, size: 23, color: Color.fromARGB(255, 22, 173, 243)),
              SizedBox(width: 10),
              Text(
                (work?.codeAddress != null) ? "Khu vực: ${provinces![work?.codeAddress]}" : "Khu vực:",
                style: TextStyle(color: colorBlack, fontSize: 14, fontWeight: FontWeight.w400),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 10),
              Icon(Icons.paid, size: 23, color: Color.fromARGB(255, 22, 173, 243)),
              SizedBox(width: 10),
              Text(
                (work?.salary != null) ? "Mức lương: ${oCcy.format(work?.salary)} VNĐ" : "Mức lương:",
                style: TextStyle(color: colorBlack, fontSize: 14, fontWeight: FontWeight.w400),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 10),
              Icon(Icons.schedule, size: 23, color: Color.fromARGB(255, 22, 173, 243)),
              SizedBox(width: 10),
              Text(
                (work?.dateExpiration != null)
                    ? "Hạn tuyển dụng: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(work?.dateExpiration ?? ""))}"
                    : "Hạn tuyển dụng:",
                style: TextStyle(color: colorBlack, fontSize: 14, fontWeight: FontWeight.w400),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ],
      ),
    );
  }
}
