// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use, prefer_const_constructors, use_build_context_synchronously, unused_local_variable, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_is_empty

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../controllers/api.dart';
import '../../../controllers/provider.dart';
import '../../../model/company.dart';
import '../../../model/jobs.dart';
import '../../../model/works.dart';
import '../../style/color.dart';
import 'job_info_screen.dart';
import 'list_jobs_screen.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});
  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  List<Work> listWork = [];
  List<Company> listCompanys = [];

  List<Work> listWorkHot = [];
  List<Work> listWorkFit = [];
  List<Work> listWorkNear = [];
  List<Work> listWorkNew = [];
  List<Work> listWorkSalary = [];

  Future<List<Work>> getJobs() async {
    listWork = [];
    listWorkHot = [];
    listWorkFit = [];
    listWorkNear = [];
    listWorkNew = [];
    listWorkSalary = [];
    var response1 = await httpPost("/api/listjobs/getjobs", {}, context);
    if (response1.containsKey("body")) {
      var body = response1['body'];

      var user = Provider.of<User>(context, listen: false);
      setState(() {
        for (var element in body) {
          Work item = Work(
            id: element['id'],
            company: Company(
              id: element['company']['id'],
              name: element['company']['name'],
              phone: element['company']['phone'],
              email: element['company']['email'],
              address: element['company']['address'],
              urlImg: element['company']['urlImg'],
            ),
            job: Jobs(
              id: element['job']['id'],
              name: element['job']['name'],
              countJob: element['job']['countJob'],
            ),
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
          if (user.user.codeAddress == item.codeAddress) listWorkNear.add(item);
          if (item.job!.id == hot1 || item.job!.id == hot2) listWorkHot.add(item);
          if (user.user.job!.id == item.job!.id) listWorkFit.add(item);
          if (listWorkNew.length < 10) listWorkNew.add(item);
          if (item.salary! > 15000000) listWorkSalary.add(item);
          listWork.add(item);
        }
      });
    }
    return listWork;
  }

  int hot1 = 0;
  int hot2 = 0;

  Future<List<Company>> getWorkHot() async {
    listCompanys = [];
    var response1 = await httpGet("/api/job/gethot", context);
    if (response1.containsKey("body")) {
      var body = response1['body'];
      setState(() {
        hot1 = body[0]['id'];
        hot2 = body[1]['id'];
      });
    }
    return listCompanys;
  }

  Future<List<Company>> getCompanys() async {
    listCompanys = [];
    var response1 = await httpGet("/api/company/getall", context);
    if (response1.containsKey("body")) {
      var body = response1['body'];
      setState(() {
        for (var element in body) {
          Company item = Company(
            id: element['id'],
            name: element['name'],
            phone: element['phone'],
            email: element['email'],
            address: element['address'],
            urlImg: element['urlImg'],
          );
          listCompanys.add(item);
        }
      });
    }
    return listCompanys;
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

  bool light = false;
  bool checkStt = false;
  void callApi() async {
    setState(() {
      checkStt = false;
    });
    await getWorkHot();
    await getJobs();
    await getProvinces();
    await getCompanys();
    setState(() {
      checkStt = true;
    });
  }

  @override
  void initState() {
    super.initState();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    return (checkStt)
        ? RefreshIndicator(
            onRefresh: () async {
              callApi();
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/b6.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    ListJobsBox(
                      title: "Việc làm hot",
                      listWorks: listWorkHot,
                      provinces: provinces,
                    ),
                    SizedBox(height: 15),
                    ListJobsBox(
                      title: "Việc làm phù hợp",
                      listWorks: listWorkFit,
                      provinces: provinces,
                    ),
                    SizedBox(height: 15),
                    ListJobsBox(
                      title: "Việc làm mới",
                      listWorks: listWorkNew,
                      provinces: provinces,
                    ),
                    SizedBox(height: 15),
                    ListJobsBox(
                      title: "Việc làm lương cao",
                      listWorks: listWorkSalary,
                      provinces: provinces,
                    ),
                    SizedBox(height: 15),
                    ListJobsBox(
                      title: "Việc làm gần bạn",
                      listWorks: listWorkNear,
                      provinces: provinces,
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5)),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => JobsScreen(titlePage: "Công việc", listJobs: listWork, province: provinces),
                            ),
                          );
                        },
                        child: Text(
                          "Xem tất cả",
                          style: TextStyle(color: colorBlack, fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 5),
                                const Icon(Icons.label, color: Color.fromARGB(255, 22, 173, 243), size: 25),
                                const SizedBox(width: 5),
                                Text(
                                  "Nhà tuyển dụng hàng đầu",
                                  style: TextStyle(color: colorBlack, fontSize: 22, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Xem tất cả",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 22, 173, 243),
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 200.0,
                            aspectRatio: 10 / 9,
                            viewportFraction: 0.3,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: false,
                            scrollDirection: Axis.horizontal,
                            padEnds: false,
                            // clipBehavior = Clip.hardEdge,
                          ),
                          items: listCompanys.map((item) {
                            return Builder(
                              builder: (BuildContext context) {
                                return TextButton(
                                    onPressed: () {},
                                    child: Column(
                                      children: [
                                        Container(
                                            color: maincolor,
                                            height: 120,
                                            child: Image.network(
                                              item.urlImg!,
                                              height: 120,
                                            )),
                                        SizedBox(height: 10),
                                        Text(
                                          item.name!,
                                          style: TextStyle(color: colorBlack),
                                        )
                                      ],
                                    ));
                              },
                            );
                          }).toList(),
                        )
                      ],
                    ),
                    SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

class ListJobsBox extends StatelessWidget {
  String? title;
  List<Work>? listWorks;
  Map<int, String>? provinces;
  ListJobsBox({Key? key, this.listWorks, this.title, this.provinces}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(width: 5),
                const Icon(Icons.label, color: Color.fromARGB(255, 22, 173, 243), size: 25),
                const SizedBox(width: 5),
                Text(
                  "$title",
                  style: TextStyle(color: colorBlack, fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => JobsScreen(titlePage: title!, listJobs: listWorks!, province: provinces!),
                  ),
                );
              },
              child: Text(
                "Xem tất cả",
                style: TextStyle(
                    color: Color.fromARGB(255, 22, 173, 243), fontSize: 15, fontStyle: FontStyle.italic, decoration: TextDecoration.underline),
              ),
            )
          ],
        ),
        (listWorks!.length > 0)
            ? CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  aspectRatio: 10 / 9,
                  viewportFraction: 0.7,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: false,
                  scrollDirection: Axis.horizontal,
                  padEnds: false,
                  // clipBehavior = Clip.hardEdge,
                ),
                items: listWorks!.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return TextButton(
                          onPressed: () {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => WorkInfo(
                                  work: item,
                                  province: "",
                                ),
                              ),
                            );
                          },
                          child: JobsBox(
                            work: item,
                            provinces: provinces,
                          ));
                    },
                  );
                }).toList(),
              )
            : Text("Không có việc làm phù hợp")
      ],
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
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Text(
                      work?.name! ?? "",
                      style: TextStyle(color: colorBlack, fontSize: 16, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
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
