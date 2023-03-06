// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use, prefer_const_constructors, use_build_context_synchronously, unused_local_variable
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/provider.dart';
import '../../style/color.dart';
import '../login/login.dart';
import '../recruiment/recruiment-screen.dart';
import 'profile.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool light = false;
  bool checkStt = false;
  void callApi() async {
    // await getJobs();
    // await getProvinces();
    setState(() {
      checkStt = true;
    });
  }

  var urlAvatar =
      "https://scr.vn/wp-content/uploads/2020/07/Avatar-Facebook-tr%E1%BA%AFng.jpg";
  @override
  void initState() {
    super.initState();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    return (checkStt)
        ? Consumer<User>(
            builder: (context, user, child) => Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/b4.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        border: Border.all(width: 5),
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: ClipOval(
                          child: (user.user.urlImg == "" ||
                                  user.user.urlImg == null)
                              ? Image.network(urlAvatar,
                                  fit: BoxFit.cover, width: 180, height: 180)
                              : Image.network(user.user.urlImg!,
                                  fit: BoxFit.cover, width: 180, height: 180)),
                    ),
                    SizedBox(height: 10),
                    Text(user.user.fullName ?? "",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600)),
                    SizedBox(height: 10),
                    Text(
                      (user.user.job?.name != null && user.user.job!.name != "")
                          ? user.user.job!.name ??
                              "Chưa cập nhật vị trí công việc"
                          : "Chưa cập nhật vị trí công việc",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Switch(
                          // This bool value toggles the switch.
                          value: light,
                          activeColor: Colors.green,
                          onChanged: (bool value) {
                            // This is called when the user toggles the switch.
                            setState(() {
                              light = value;
                            });
                          },
                        ),
                        const SizedBox(width: 5),
                        (light)
                            ? Text(
                                "Trạng thái tìm việc đang bật",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.green),
                              )
                            : Text(
                                "Trạng thái tìm việc đang tắt",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Container(
                          margin:
                              EdgeInsets.only(left: 15, right: 15, bottom: 20),
                          height: 180,
                          decoration: BoxDecoration(
                              color: colorWhite,
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              SizedBox(height: 10),
                              Icon(Icons.person,
                                  size: 80,
                                  color: Color.fromARGB(255, 20, 149, 255)),
                              SizedBox(height: 5),
                              Text("NTD xem hồ sơ:",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 5),
                              SizedBox(
                                  height: 50,
                                  child: Text(
                                    "0",
                                    style: TextStyle(fontSize: 18),
                                  ))
                            ],
                          ),
                        )),
                        Expanded(
                            child: Container(
                          margin:
                              EdgeInsets.only(left: 15, right: 15, bottom: 20),
                          height: 180,
                          decoration: BoxDecoration(
                              color: colorWhite,
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              SizedBox(height: 10),
                              Icon(Icons.task_alt,
                                  size: 80,
                                  color: Color.fromARGB(255, 49, 240, 90)),
                              SizedBox(height: 5),
                              Text("Lượt lưu hồ sơ:",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 5),
                              SizedBox(
                                  height: 50,
                                  child: Text(
                                    "0",
                                    style: TextStyle(fontSize: 18),
                                  ))
                            ],
                          ),
                        ))
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Container(
                          margin:
                              EdgeInsets.only(left: 15, right: 15, bottom: 20),
                          height: 180,
                          decoration: BoxDecoration(
                              color: colorWhite,
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              SizedBox(height: 10),
                              Icon(Icons.perm_contact_calendar,
                                  size: 80,
                                  color: Color.fromARGB(255, 216, 166, 74)),
                              SizedBox(height: 5),
                              Text("CV:",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 5),
                              SizedBox(
                                  height: 50,
                                  child: Text(
                                    (user.user.urlCv != "" &&
                                            user.user.urlCv != null)
                                        ? "Đã có"
                                        : "Chưa có",
                                    style: TextStyle(fontSize: 18),
                                  ))
                            ],
                          ),
                        )),
                        Expanded(
                            child: Container(
                          margin:
                              EdgeInsets.only(left: 15, right: 15, bottom: 20),
                          height: 180,
                          decoration: BoxDecoration(
                              color: colorWhite,
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      RecruitmentScreen(),
                                ),
                              );
                            },
                            child: Column(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                Icon(Icons.work_history,
                                    size: 80,
                                    color: Color.fromARGB(255, 252, 151, 19)),
                                SizedBox(height: 5),
                                Text("Công việc ứng tuyển:",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: colorBlack)),
                                SizedBox(height: 5),
                                SizedBox(
                                    height: 50,
                                    child: Text(
                                      "${user.countJobs}",
                                      style: TextStyle(
                                          fontSize: 18, color: colorBlack),
                                    ))
                              ],
                            ),
                          ),
                        ))
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Container(
                          margin:
                              EdgeInsets.only(left: 15, right: 15, bottom: 20),
                          height: 180,
                          decoration: BoxDecoration(
                              color: colorWhite,
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              SizedBox(height: 10),
                              Icon(Icons.email,
                                  size: 80,
                                  color: Color.fromARGB(255, 54, 240, 29)),
                              SizedBox(height: 5),
                              Text("Email:",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 5),
                              SizedBox(
                                  height: 50,
                                  child: Text(
                                    (user.user.email != null &&
                                            user.user.email != "")
                                        ? user.user.email!
                                        : "",
                                    style: TextStyle(fontSize: 16.5),
                                  ))
                            ],
                          ),
                        )),
                        Expanded(
                            child: Container(
                          margin:
                              EdgeInsets.only(left: 15, right: 15, bottom: 20),
                          height: 180,
                          decoration: BoxDecoration(
                              color: colorWhite,
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              SizedBox(height: 10),
                              Icon(Icons.phone_android,
                                  size: 80,
                                  color: Color.fromARGB(255, 11, 142, 230)),
                              SizedBox(height: 5),
                              Text("SĐT:",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 5),
                              SizedBox(
                                  height: 50,
                                  child: Text(
                                    (user.user.phone != null &&
                                            user.user.phone != "")
                                        ? user.user.phone!
                                        : "",
                                    style: TextStyle(fontSize: 16.5),
                                  ))
                            ],
                          ),
                        ))
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 20),
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                            color: maincolor,
                            borderRadius: BorderRadius.circular(5)),
                        child: TextButton(
                            onPressed: () {
                              //
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const Profile(),
                                ),
                              );
                            },
                            child: Text(
                              "Cập nhật hồ sơ",
                              style: TextStyle(color: colorBlack, fontSize: 15),
                            ))),
                    Container(
                        margin: EdgeInsets.only(bottom: 20),
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                            color: maincolor,
                            borderRadius: BorderRadius.circular(5)),
                        child: TextButton(
                            onPressed: () {
                              //
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Đăng xuất",
                              style: TextStyle(color: colorBlack, fontSize: 15),
                            ))),
                  ],
                ),
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
