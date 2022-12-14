// ignore_for_file: must_be_immutable, unnecessary_string_interpolations, unused_element, use_build_context_synchronously, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nam_trinh_thinh/controllers/api.dart';
import 'package:provider/provider.dart';
import '../../../controllers/provider.dart';
import '../../../model/company.dart';
import '../../../model/jobs.dart';
import '../../../model/works.dart';
import '../../style/color.dart';
import 'home_screen.dart';

class WorkInfo extends StatefulWidget {
  Work work;
  String? province;
  WorkInfo({super.key, required this.work, this.province});
  @override
  State<WorkInfo> createState() => _WorkInfoState();
}

class _WorkInfoState extends State<WorkInfo> {
  Work workInfo = Work();
  Future<Work> getWork() async {
    var response = await httpGet("/api/listjobs/${widget.work.id}", context);
    var body = response['body'];
    setState(() {
      workInfo = Work(
        id: body['id'],
        company: Company(
          id: body['company']['id'],
          name: body['company']['name'],
          phone: body['company']['phone'],
          email: body['company']['email'],
          address: body['company']['address'],
          urlImg: body['company']['urlImg'],
        ),
        job: Jobs(
          id: body['job']['id'],
          name: body['job']['name'],
          countJob: body['job']['countJob'],
        ),
        name: body['name'],
        salary: body['salary'],
        sex: body['sex'],
        age: body['age'],
        experence: body['experence'],
        contactInfo: body['contactInfo'],
        area: body['area'],
        workAddress: body['workAddress'],
        description: body['description'],
        status: body['status'],
        codeAddress: body['codeAddress'],
        dateExpiration: body['dateExpiration'],
      );
    });
    return workInfo;
  }

  bool statusData = false;
  int selectedTap = 0;
  final formatCurrency = NumberFormat("#,##0", "en_US");
  void callApi() async {
    workInfo = await getWork();
    setState(() {
      statusData = true;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedTap = 0;
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> processing() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
    }

    return Consumer<User>(
      builder: (context, user, child) => Scaffold(
          appBar: AppBar(
            title: Center(
                child: Text(
              "Chi tiết việc làm",
              style: TextStyle(fontSize: 23),
            )),
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
              ? Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/b6.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 15),
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  child: Image.network(
                                    "${workInfo.company!.urlImg}",
                                    fit: BoxFit.cover,
                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                                const SizedBox(width: 25),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 15, bottom: 5),
                                      width: MediaQuery.of(context).size.width*0.75,
                                      height: 48,
                                      child: Text(
                                        workInfo.name!,
                                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      workInfo.company!.name!,
                                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Icon(Icons.schedule, size: 23, color: Color.fromARGB(255, 22, 173, 243)),
                                    SizedBox(width: 10),
                                    Text(
                                      (workInfo.dateExpiration != null)
                                          ? "Hạn tuyển dụng: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(workInfo.dateExpiration ?? ""))}"
                                          : "Hạn tuyển dụng:",
                                      style: TextStyle(color: colorBlack, fontSize: 14, fontWeight: FontWeight.w400),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Text(
                                  (workInfo.dateExpiration != null) ? "Lượt xem hồ sơ:0" : "Lượt xem hồ sơ:",
                                  style: TextStyle(color: colorBlack, fontSize: 14, fontWeight: FontWeight.w400),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.71,
                        child: DefaultTabController(
                          length: 2,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(left: 20, right: 40),
                                child: TabBar(
                                  indicatorWeight: 3,
                                  isScrollable: true,
                                  indicatorColor: Color(0xf7fbfc),
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
                                            "Thông tin",
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
                                            "Công ty",
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
                                    height: MediaQuery.of(context).size.height * 0.73,
                                    padding: const EdgeInsets.only(left: 15, right: 15),
                                    // child: ListView(
                                    //   controller: ScrollController(),
                                    //   children: [
                                    //     const SizedBox(height: 15),
                                    //     Text(
                                    //       "Thông tin chung:",
                                    //       style: AppStyles.appTextStyle(size: 22, weight: FontWeight.w600),
                                    //     ),
                                    //     const SizedBox(height: 20),
                                    //     Row(
                                    //       children: [
                                    //         const SizedBox(width: 20),
                                    //         const Icon(Icons.paid, size: 20, color: maincolor),
                                    //         const SizedBox(width: 20),
                                    //         Column(
                                    //           mainAxisAlignment: MainAxisAlignment.start,
                                    //           crossAxisAlignment: CrossAxisAlignment.start,
                                    //           children: [
                                    //             Text(
                                    //               "Mức lương:",
                                    //               style: AppStyles.appTextStyle(size: 18, weight: FontWeight.w500),
                                    //             ),
                                    //             const SizedBox(height: 5),
                                    //             Text(
                                    //                 "${(int.tryParse(widget.job.salary!) != null) ? formatCurrency.format(int.parse(widget.job.salary ?? "0")) : widget.job.salary!}",
                                    //                 style: AppStyles.appTextStyle(size: 15)),
                                    //           ],
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     const SizedBox(height: 15),
                                    //     Row(
                                    //       children: [
                                    //         const SizedBox(width: 20),
                                    //         const Icon(Icons.person_add, size: 20, color: maincolor),
                                    //         const SizedBox(width: 20),
                                    //         Column(
                                    //           mainAxisAlignment: MainAxisAlignment.start,
                                    //           crossAxisAlignment: CrossAxisAlignment.start,
                                    //           children: [
                                    //             Text(
                                    //               "Số lượng:",
                                    //               style: AppStyles.appTextStyle(size: 18, weight: FontWeight.w500),
                                    //             ),
                                    //             const SizedBox(height: 5),
                                    //             Text(widget.job.qty!, style: AppStyles.appTextStyle(size: 15)),
                                    //           ],
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     const SizedBox(height: 15),
                                    //     Row(
                                    //       children: [
                                    //         const SizedBox(width: 20),
                                    //         const Icon(Icons.face_retouching_natural, size: 20, color: maincolor),
                                    //         const SizedBox(width: 20),
                                    //         Column(
                                    //           mainAxisAlignment: MainAxisAlignment.start,
                                    //           crossAxisAlignment: CrossAxisAlignment.start,
                                    //           children: [
                                    //             Text(
                                    //               "Độ tuổi:",
                                    //               style: AppStyles.appTextStyle(size: 18, weight: FontWeight.w500),
                                    //             ),
                                    //             const SizedBox(height: 5),
                                    //             Text(widget.job.age!, style: AppStyles.appTextStyle(size: 15)),
                                    //           ],
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     const SizedBox(height: 15),
                                    //     Row(
                                    //       children: [
                                    //         const SizedBox(width: 20),
                                    //         const Icon(Icons.language, size: 20, color: maincolor),
                                    //         const SizedBox(width: 20),
                                    //         Column(
                                    //           mainAxisAlignment: MainAxisAlignment.start,
                                    //           crossAxisAlignment: CrossAxisAlignment.start,
                                    //           children: [
                                    //             Text(
                                    //               "Trình độ tiếng anh:",
                                    //               style: AppStyles.appTextStyle(size: 18, weight: FontWeight.w500),
                                    //             ),
                                    //             const SizedBox(height: 5),
                                    //             Text(widget.job.englishLevel!, style: AppStyles.appTextStyle(size: 15)),
                                    //           ],
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     const SizedBox(height: 15),
                                    //     Row(
                                    //       children: [
                                    //         const SizedBox(width: 20),
                                    //         const Icon(Icons.workspace_premium, size: 20, color: maincolor),
                                    //         const SizedBox(width: 20),
                                    //         Column(
                                    //           mainAxisAlignment: MainAxisAlignment.start,
                                    //           crossAxisAlignment: CrossAxisAlignment.start,
                                    //           children: [
                                    //             Text(
                                    //               "Kinh nghiệm:",
                                    //               style: AppStyles.appTextStyle(size: 18, weight: FontWeight.w500),
                                    //             ),
                                    //             const SizedBox(height: 5),
                                    //             Text(widget.job.exp!, style: AppStyles.appTextStyle(size: 15)),
                                    //           ],
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     const SizedBox(height: 15),
                                    //     Row(
                                    //       children: [
                                    //         const SizedBox(width: 20),
                                    //         const Icon(Icons.location_on, size: 20, color: maincolor),
                                    //         const SizedBox(width: 20),
                                    //         Column(
                                    //           mainAxisAlignment: MainAxisAlignment.start,
                                    //           crossAxisAlignment: CrossAxisAlignment.start,
                                    //           children: [
                                    //             Text(
                                    //               "Địa chỉ:",
                                    //               style: AppStyles.appTextStyle(size: 18, weight: FontWeight.w500),
                                    //             ),
                                    //             const SizedBox(height: 5),
                                    //             Text(widget.job.addRess ?? "", style: AppStyles.appTextStyle(size: 15)),
                                    //           ],
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     const SizedBox(height: 25),
                                    //     Text(
                                    //       "Yêu cầu khác:",
                                    //       style: AppStyles.appTextStyle(size: 22, weight: FontWeight.w600),
                                    //     ),
                                    //     const SizedBox(height: 15),
                                    //     Row(
                                    //       children: [
                                    //         const SizedBox(width: 40),
                                    //         Text(widget.job.otherRequirements ?? "", style: AppStyles.appTextStyle(size: 15)),
                                    //       ],
                                    //     ),
                                    //   ],
                                    // ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                    height: MediaQuery.of(context).size.height * 0.73,
                                    // child: ListView(
                                    //   controller: ScrollController(),
                                    //   children: [
                                    //     Text(
                                    //       widget.job.employer.name ?? "",
                                    //       style: AppStyles.appTextStyle(size: 22, weight: FontWeight.w600),
                                    //     ),
                                    //     const SizedBox(height: 20),
                                    //     Row(
                                    //       children: [
                                    //         const SizedBox(width: 20),
                                    //         const Icon(Icons.location_on, size: 20, color: maincolor),
                                    //         const SizedBox(width: 20),
                                    //         Column(
                                    //           mainAxisAlignment: MainAxisAlignment.start,
                                    //           crossAxisAlignment: CrossAxisAlignment.start,
                                    //           children: [
                                    //             Text(
                                    //               "Địa chỉ:",
                                    //               style: AppStyles.appTextStyle(size: 18, weight: FontWeight.w500),
                                    //             ),
                                    //             const SizedBox(height: 5),
                                    //             SizedBox(
                                    //                 width: MediaQuery.of(context).size.width * 0.8,
                                    //                 child: Text(
                                    //                   widget.job.employer.addRess ?? "",
                                    //                   style: AppStyles.appTextStyle(size: 15),
                                    //                   maxLines: 3,
                                    //                 )),
                                    //           ],
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     const SizedBox(height: 15),
                                    //     Row(
                                    //       children: [
                                    //         const SizedBox(width: 20),
                                    //         const Icon(Icons.language, size: 20, color: maincolor),
                                    //         const SizedBox(width: 20),
                                    //         Column(
                                    //           mainAxisAlignment: MainAxisAlignment.start,
                                    //           crossAxisAlignment: CrossAxisAlignment.start,
                                    //           children: [
                                    //             Text(
                                    //               "Website:",
                                    //               style: AppStyles.appTextStyle(size: 18, weight: FontWeight.w500),
                                    //             ),
                                    //             const SizedBox(height: 5),
                                    //             Text(widget.job.employer.career!, style: AppStyles.appTextStyle(size: 15)),
                                    //           ],
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     const SizedBox(height: 25),
                                    //     Text(
                                    //       "Giới thiệu về công ty",
                                    //       style: AppStyles.appTextStyle(size: 22, weight: FontWeight.w600),
                                    //     ),
                                    //     const SizedBox(height: 15),
                                    //     Row(
                                    //       children: [
                                    //         const SizedBox(width: 40),
                                    //         SizedBox(
                                    //             width: MediaQuery.of(context).size.width * 0.8,
                                    //             child: Text(widget.job.employer.introduce ?? "", style: AppStyles.appTextStyle(size: 15))),
                                    //       ],
                                    //     ),
                                    //     const SizedBox(height: 25),
                                    //     Text(
                                    //       "Việc làm cùng công ty",
                                    //       style: AppStyles.appTextStyle(size: 22, weight: FontWeight.w600),
                                    //     ),
                                    //     const SizedBox(height: 25),
                                    //   ],
                                    // ),
                                  ),
                                ]),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: 200,
                              decoration: BoxDecoration(
                                color: maincolor,
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Ứng tuyển ngay",
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400,color: colorBlack),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator())),
    );
  }
}
