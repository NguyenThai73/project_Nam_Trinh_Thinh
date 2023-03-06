import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nam_trinh_thinh/model/works.dart';
import 'package:provider/provider.dart';

import '../../../controllers/api.dart';
import '../../../controllers/provider.dart';
import '../../../model/company.dart';
import '../../../model/jobs.dart';
import '../../../model/recruiment.dart';
import '../../style/color.dart';
import '../../style/style.dart';

class RecruitmentScreen extends StatefulWidget {
  const RecruitmentScreen({super.key});
  @override
  State<RecruitmentScreen> createState() => _RecruitmentScreenState();
}

class _RecruitmentScreenState extends State<RecruitmentScreen> {
  Map<int, String> provinces = {};
  getProvinces() async {
    var response2 =
        await httpGetNo("https://provinces.open-api.vn/api/?depth=1", context);
    if (response2.containsKey("body")) {
      List<dynamic> body = response2['body'];
      for (var element in body) {
        provinces[element['code']] = element['name'];
      }
    }
  }

  Future<Map<int, Recruitment>> getListRecruitment(int userId) async {
    Map<int, Recruitment> listRecruitments = {};
    var response1 = await httpGet("/api/users/$userId", context);
    if (response1.containsKey("body")) {
      var body = response1['body'];
      var listJobs = body['listJobs'];
      for (var element in listJobs) {
        Recruitment item = Recruitment(
            work: Work(
              id: element['job']['id'],
              company: Company(
                id: element['job']['company']['id'],
                name: element['job']['company']['name'],
                phone: element['job']['company']['phone'],
                email: element['job']['company']['email'],
                address: element['job']['company']['address'],
                urlImg: element['job']['company']['urlImg'],
              ),
              job: Jobs(
                id: element['job']['job']['id'],
                name: element['job']['job']['name'],
                countJob: element['job']['job']['countJob'],
              ),
              name: element['job']['name'],
              salary: element['job']['salary'],
              sex: element['job']['sex'],
              age: element['job']['age'],
              experence: element['job']['experence'],
              contactInfo: element['job']['contactInfo'],
              area: element['job']['area'],
              workAddress: element['job']['workAddress'],
              description: element['job']['description'],
              status: element['job']['status'],
              codeAddress: element['job']['codeAddress'],
              dateExpiration: element['job']['dateExpiration'],
            ),
            status: element['status'],
            message: element['message']);
        print(item);
        listRecruitments[item.work?.id ?? 0] = item;
      }
    }
    return listRecruitments;
  }

  List<Recruitment> listRecruitmentChoPhanHoi = []; //Chờ phản hồi:1
  List<Recruitment> listRecruitmentChoPV = []; //Chờ phỏng vấn:2
  List<Recruitment> listRecruitmentPass = []; //Đã trúng tuyển:3
  List<Recruitment> listRecruitmentTuChoi = []; //Đã từ chối:4
  setupData() async {
    var user = Provider.of<User>(context, listen: false);
    Map<int, Recruitment> mapRecruitments =
        await getListRecruitment(user.user.id!);
    user.changeWorkUT(mapRecruitments);
    for (var element in mapRecruitments.keys) {
      if (mapRecruitments[element]?.status == 1) {
        listRecruitmentChoPhanHoi.add(mapRecruitments[element]!);
      } else if (mapRecruitments[element]?.status == 2) {
        listRecruitmentChoPV.add(mapRecruitments[element]!);
      } else if (mapRecruitments[element]?.status == 3) {
        listRecruitmentPass.add(mapRecruitments[element]!);
      } else if (mapRecruitments[element]?.status == 4) {
        listRecruitmentTuChoi.add(mapRecruitments[element]!);
      }
    }
    user.changeCountJobs(listRecruitmentChoPhanHoi.length);
  }

  bool statusData = false;
  void callAPI() async {
    await setupData();
    await getProvinces();
    setState(() {
      statusData = true;
    });
  }

  @override
  void initState() {
    super.initState();
    callAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        title: Text("Danh sách ứng tuyển"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: colorWhite,
              size: 20,
            )),
      ),
      body: (statusData)
          ? Consumer<User>(
              builder: (context, user, child) => DefaultTabController(
                length: 3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 15),
                      child: TabBar(
                        indicatorWeight: 3,
                        isScrollable: true,
                        indicatorColor: maincolor,
                        tabs: [
                          Container(
                            decoration: BoxDecoration(
                              color: colorWhite,
                              border: Border.all(width: 1, color: maincolor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: 180,
                            height: 40,
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.receipt_long,
                                  color: maincolor,
                                ),
                                const SizedBox(width: 10),
                                Text("Đã ứng tuyển", style: AppStyles.medium()),
                              ],
                            ),
                          ),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     color: colorWhite,
                          //     border: Border.all(width: 1, color: maincolor),
                          //     borderRadius: BorderRadius.circular(20),
                          //   ),
                          //   width: 180,
                          //   height: 40,
                          //   child: Row(
                          //     children: [
                          //       const SizedBox(width: 10),
                          //       const Icon(
                          //         Icons.bookmark,
                          //         color: maincolor,
                          //       ),
                          //       const SizedBox(width: 10),
                          //       Text("Đã lưu", style: AppStyles.medium()),
                          //     ],
                          //   ),
                          // ),
                          Container(
                            decoration: BoxDecoration(
                              color: colorWhite,
                              border: Border.all(width: 1, color: maincolor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: 200,
                            height: 40,
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.phone_in_talk,
                                  color: maincolor,
                                ),
                                const SizedBox(width: 10),
                                Text("Chờ phỏng vấn",
                                    style: AppStyles.medium()),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: colorWhite,
                              border: Border.all(width: 1, color: maincolor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: 180,
                            height: 40,
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.history,
                                  color: maincolor,
                                ),
                                const SizedBox(width: 10),
                                Text("Lịch sử", style: AppStyles.medium()),
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
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height * 0.9,
                          decoration: BoxDecoration(
                            color: maincolor.withOpacity(0.1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for (var element in listRecruitmentChoPhanHoi)
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15, top: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 102, 97, 97)
                                            .withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 20,
                                        offset: const Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: TextButton(
                                      onPressed: () {},
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          // ignore: prefer_const_literals_to_create_immutables
                                          boxShadow: [
                                            BoxShadow(
                                                color:
                                                    colorBlack.withOpacity(0.1),
                                                spreadRadius: 1,
                                                blurRadius: 1,
                                                blurStyle: BlurStyle.solid),
                                          ],
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/image-background-card-3.jpg"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            Row(
                                              // FadeInImage.assetNetwork(placeholder: placeholder, image: image),
                                              children: [
                                                const SizedBox(width: 10),
                                                Image.network(
                                                  element.work?.company
                                                          ?.urlImg ??
                                                      "",
                                                  fit: BoxFit.fill,
                                                  width: 50,
                                                  height: 50,
                                                ),
                                                const SizedBox(width: 10),
                                                Flexible(
                                                  child: Text(
                                                    element.work?.name ?? "",
                                                    style:
                                                        AppStyles.appTextStyle(
                                                            size: 20,
                                                            color: colorBlack,
                                                            weight: FontWeight
                                                                .w600),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              element.work?.company!.name ?? "",
                                              style: AppStyles.appTextStyle(
                                                  color: colorBlack, size: 14),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                const SizedBox(width: 15),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.paid,
                                                        size: 25,
                                                        color: maincolor),
                                                    Text(
                                                        " ${element.work?.salary}",
                                                        style: AppStyles
                                                            .appTextStyle(
                                                                color:
                                                                    colorBlack,
                                                                size: 15,
                                                                weight:
                                                                    FontWeight
                                                                        .w400))
                                                  ],
                                                ),
                                                const SizedBox(width: 15),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.location_on,
                                                        size: 25,
                                                        color: maincolor),
                                                    Text(
                                                        " ${provinces[element.work?.codeAddress]}",
                                                        style: AppStyles
                                                            .appTextStyle(
                                                                color:
                                                                    colorBlack,
                                                                size: 15,
                                                                weight:
                                                                    FontWeight
                                                                        .w400))
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: const Divider(
                                                thickness: 1,
                                                color: colorBlack,
                                              ),
                                            ),
                                            Text("Đã ứng tuyển",
                                                style: AppStyles.appTextStyle(
                                                    color: colorBlack,
                                                    overFlow:
                                                        TextOverflow.ellipsis))
                                          ],
                                        ),
                                      )),
                                ),
                            ],
                          ),
                        ),
                        // Container(
                        //   margin: const EdgeInsets.all(10),
                        //   padding: const EdgeInsets.all(10),
                        //   width: MediaQuery.of(context).size.width * 1,
                        //   height: MediaQuery.of(context).size.height * 0.9,
                        //   decoration: BoxDecoration(
                        //     color: maincolor.withOpacity(0.1),
                        //   ),
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       for (var element in listRecruitmentSave)
                        //         JobItemList(
                        //           job: element.job ?? Jobs(name: '', employer: Employer(), careers: Careers()),
                        //           imageBackground: "assets/images/image-background-card-5.jpg",
                        //           province: provinces[element.job?.provinceCode],
                        //         )
                        //     ],
                        //   ),
                        // ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height * 0.9,
                          decoration: BoxDecoration(
                            color: maincolor.withOpacity(0.1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for (var element in listRecruitmentChoPV)
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15, top: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 102, 97, 97)
                                            .withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 20,
                                        offset: const Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: TextButton(
                                      onPressed: () {},
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          // ignore: prefer_const_literals_to_create_immutables
                                          boxShadow: [
                                            BoxShadow(
                                                color:
                                                    colorBlack.withOpacity(0.1),
                                                spreadRadius: 1,
                                                blurRadius: 1,
                                                blurStyle: BlurStyle.solid),
                                          ],
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/image-background-card-3.jpg"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            Row(
                                              // FadeInImage.assetNetwork(placeholder: placeholder, image: image),
                                              children: [
                                                const SizedBox(width: 10),
                                                Image.network(
                                                  element.work?.company
                                                          ?.urlImg ??
                                                      "",
                                                  fit: BoxFit.fill,
                                                  width: 50,
                                                  height: 50,
                                                ),
                                                const SizedBox(width: 10),
                                                Flexible(
                                                  child: Text(
                                                    element.work?.name ?? "",
                                                    style:
                                                        AppStyles.appTextStyle(
                                                            size: 20,
                                                            color: colorBlack,
                                                            weight: FontWeight
                                                                .w600),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              element.work?.company!.name ?? "",
                                              style: AppStyles.appTextStyle(
                                                  color: colorBlack, size: 14),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                const SizedBox(width: 15),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.paid,
                                                        size: 25,
                                                        color: maincolor),
                                                    Text(
                                                        " ${element.work?.salary}",
                                                        style: AppStyles
                                                            .appTextStyle(
                                                                color:
                                                                    colorBlack,
                                                                size: 15,
                                                                weight:
                                                                    FontWeight
                                                                        .w400))
                                                  ],
                                                ),
                                                const SizedBox(width: 15),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.location_on,
                                                        size: 25,
                                                        color: maincolor),
                                                    Text(
                                                        " ${provinces[element.work?.codeAddress]}",
                                                        style: AppStyles
                                                            .appTextStyle(
                                                                color:
                                                                    colorBlack,
                                                                size: 15,
                                                                weight:
                                                                    FontWeight
                                                                        .w400))
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: const Divider(
                                                thickness: 1,
                                                color: colorBlack,
                                              ),
                                            ),
                                            Text("Chờ phỏng vấn",
                                                style: AppStyles.appTextStyle(
                                                    color: colorBlack,
                                                    overFlow:
                                                        TextOverflow.ellipsis))
                                          ],
                                        ),
                                      )),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height * 0.9,
                          decoration: BoxDecoration(
                            color: maincolor.withOpacity(0.1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for (var element in listRecruitmentPass)
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15, top: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 102, 97, 97)
                                            .withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 20,
                                        offset: const Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: TextButton(
                                      onPressed: () {},
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          // ignore: prefer_const_literals_to_create_immutables
                                          boxShadow: [
                                            BoxShadow(
                                                color:
                                                    colorBlack.withOpacity(0.1),
                                                spreadRadius: 1,
                                                blurRadius: 1,
                                                blurStyle: BlurStyle.solid),
                                          ],
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/image-background-card-3.jpg"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            Row(
                                              // FadeInImage.assetNetwork(placeholder: placeholder, image: image),
                                              children: [
                                                const SizedBox(width: 10),
                                                Image.network(
                                                  element.work?.company!
                                                          .urlImg! ??
                                                      "",
                                                  fit: BoxFit.fill,
                                                  width: 50,
                                                  height: 50,
                                                ),
                                                const SizedBox(width: 10),
                                                Flexible(
                                                  child: Text(
                                                    element.work?.name ?? "",
                                                    style:
                                                        AppStyles.appTextStyle(
                                                            size: 20,
                                                            color: colorBlack,
                                                            weight: FontWeight
                                                                .w600),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.verified,
                                                  size: 30,
                                                  color: Colors.green,
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              element.work?.company!.name! ??
                                                  "",
                                              style: AppStyles.appTextStyle(
                                                  color: colorBlack, size: 14),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                const SizedBox(width: 15),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.paid,
                                                        size: 25,
                                                        color: maincolor),
                                                    Text(
                                                        " ${element.work?.salary}",
                                                        style: AppStyles
                                                            .appTextStyle(
                                                                color:
                                                                    colorBlack,
                                                                size: 15,
                                                                weight:
                                                                    FontWeight
                                                                        .w400))
                                                  ],
                                                ),
                                                const SizedBox(width: 15),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.location_on,
                                                        size: 25,
                                                        color: maincolor),
                                                    Text(
                                                        " ${provinces[element.work?.codeAddress]}",
                                                        style: AppStyles
                                                            .appTextStyle(
                                                                color:
                                                                    colorBlack,
                                                                size: 15,
                                                                weight:
                                                                    FontWeight
                                                                        .w400))
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: const Divider(
                                                thickness: 1,
                                                color: colorBlack,
                                              ),
                                            ),
                                            Text("Trúng tuyển ",
                                                style: AppStyles.appTextStyle(
                                                    color: colorBlack,
                                                    overFlow:
                                                        TextOverflow.ellipsis))
                                          ],
                                        ),
                                      )),
                                ),
                              for (var element in listRecruitmentTuChoi)
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15, top: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 102, 97, 97)
                                            .withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 20,
                                        offset: const Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: TextButton(
                                      onPressed: () {},
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          // ignore: prefer_const_literals_to_create_immutables
                                          boxShadow: [
                                            BoxShadow(
                                                color:
                                                    colorBlack.withOpacity(0.1),
                                                spreadRadius: 1,
                                                blurRadius: 1,
                                                blurStyle: BlurStyle.solid),
                                          ],
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/image-background-card-3.jpg"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            Row(
                                              // FadeInImage.assetNetwork(placeholder: placeholder, image: image),
                                              children: [
                                                const SizedBox(width: 10),
                                                Image.network(
                                                  element.work?.company!
                                                          .urlImg! ??
                                                      "",
                                                  fit: BoxFit.fill,
                                                  width: 50,
                                                  height: 50,
                                                ),
                                                const SizedBox(width: 10),
                                                Flexible(
                                                  child: Text(
                                                    element.work?.name ?? "",
                                                    style:
                                                        AppStyles.appTextStyle(
                                                            size: 20,
                                                            color: colorBlack,
                                                            weight: FontWeight
                                                                .w600),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.cancel,
                                                  size: 30,
                                                  color: Colors.red,
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              element.work?.company!.name! ??
                                                  "",
                                              style: AppStyles.appTextStyle(
                                                  color: colorBlack, size: 14),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                const SizedBox(width: 15),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.paid,
                                                        size: 25,
                                                        color: maincolor),
                                                    Text(
                                                        " ${element.work?.salary}",
                                                        style: AppStyles
                                                            .appTextStyle(
                                                                color:
                                                                    colorBlack,
                                                                size: 15,
                                                                weight:
                                                                    FontWeight
                                                                        .w400))
                                                  ],
                                                ),
                                                const SizedBox(width: 15),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.location_on,
                                                        size: 25,
                                                        color: maincolor),
                                                    Text(
                                                        " ${provinces[element.work?.codeAddress]}",
                                                        style: AppStyles
                                                            .appTextStyle(
                                                                color:
                                                                    colorBlack,
                                                                size: 15,
                                                                weight:
                                                                    FontWeight
                                                                        .w400))
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: const Divider(
                                                thickness: 1,
                                                color: colorBlack,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text("Chúc may mắn",
                                                  style: AppStyles.appTextStyle(
                                                      color: colorBlack,
                                                      overFlow: TextOverflow
                                                          .ellipsis)),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                            ],
                          ),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
