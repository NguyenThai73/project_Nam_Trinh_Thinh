// ignore_for_file: avoid_unnecessary_containers, must_be_immutable, camel_case_types, constant_identifier_names, deprecated_member_use, use_build_context_synchronously
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:nam_trinh_thinh/controllers/api.dart';
import 'package:provider/provider.dart';
import '../../../controllers/provider.dart';
import '../../../model/jobs.dart';
import '../../common/app_text.dart';
import '../../common/date_picker_box.dart';
import '../../common/edit_text.dart';
import '../../style/color.dart';
import '../../style/style.dart';
import '../home/list_jobs_screen.dart';

class ProfileBody extends StatefulWidget {
  bool checkEdit;
  ProfileBody({super.key, required this.checkEdit});
  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

enum gioiTinh { Nam, Nu, Khac }

class _ProfileBodyState extends State<ProfileBody> {
  Future<List<Province>> getProvinces() async {
    List<Province> listProvinces = [Province(code: 0, name: "Tất cả")];
    var response2 = await httpGetNo("https://provinces.open-api.vn/api/?depth=1", context);
    if (response2.containsKey("body")) {
      List<dynamic> body = response2['body'];
      for (var element in body) {
        listProvinces.add(Province(code: element['code'], name: element['name']));
      }
    }
    return listProvinces;
  }

  Province selecteProvince = Province(code: 0, name: 'Tất cả');
  Jobs selectedItem = Jobs(id: 0, name: "");
  Future<List<Jobs>> getNganhNghe() async {
    List<Jobs> listCareer = [Jobs(id: 0, name: "Tất cả")];
    var response = await httpGet("/api/job/getall", context);
    var body = response['body'];
    for (var element in body) {
      Jobs item = Jobs(
        id: element['id'],
        name: element['name'],
        // countJob: element['parentId'],
      );
      listCareer.add(item);
    }
    return listCareer;
  }

  @override
  void initState() {
    super.initState();
    var user = Provider.of<User>(context, listen: false);
    selectedItem = user.user.job ?? Jobs(id: 0, name: "");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(builder: (context, user, child) {
      return Container(
        width: MediaQuery.of(context).size.width * 1,
        // ignore: prefer_const_constructors
        decoration: BoxDecoration(
          border: const Border(
            top: BorderSide(
              color: maincolor,
              width: 1.0,
            ),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: (MediaQuery.of(context).size.width / 2.6) - 24.0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 193, 231, 247),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(color: colorBlack.withOpacity(0.2), offset: const Offset(1.1, 1.1), blurRadius: 10.0),
                  ],
                ),
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 100),
                          (!widget.checkEdit)
                              ? Center(
                                  child: OutlinedButton(
                                  onPressed: () async {},
                                  child: const Text(
                                    "Thay ảnh",
                                  ),
                                ))
                              : Row(),
                          (!widget.checkEdit) ? const SizedBox(height: 20) : Row(),
                          EditInput(
                            widget: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Họ tên",
                                      style: TextStyle(fontSize: 23, color: colorBlack, fontWeight: FontWeight.w500),
                                    )),
                                Expanded(
                                  flex: 5,
                                  child: (!widget.checkEdit)
                                      ? AppTextFields(
                                          hint: '',
                                          controller: TextEditingController(text: "${user.user.fullName}"),
                                          onChanged: (name) {
                                            user.user.fullName = name;
                                          },
                                        )
                                      : Text("${user.user.fullName}", style: AppStyles.appTextStyle()),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          EditInput(
                            widget: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Email",
                                      style: TextStyle(fontSize: 23, color: colorBlack, fontWeight: FontWeight.w500),
                                    )),
                                Expanded(
                                  flex: 5,
                                  child: Text("${user.user.email}", style: AppStyles.appTextStyle()),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          EditInput(
                            widget: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      "SĐT",
                                      style: TextStyle(fontSize: 23, color: colorBlack, fontWeight: FontWeight.w500),
                                    )),
                                Expanded(
                                    flex: 5,
                                    child: (!widget.checkEdit)
                                        ? AppTextFields(
                                            hint: '',
                                            controller: TextEditingController(
                                                text: (user.user.phone != null && user.user.phone != "") ? "${user.user.phone}" : ""),
                                            onChanged: (name) {
                                              user.user.phone = name;
                                            },
                                          )
                                        : (user.user.phone != null && user.user.phone != "")
                                            ? Text("${user.user.phone}", style: AppStyles.appTextStyle())
                                            : const Text("")),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          EditInput(
                            widget: SizedBox(
                                height: 50,
                                child: (!widget.checkEdit)
                                    ? DatePickerBox(
                                        label: Text(
                                          'Ngày sinh',
                                          style: TextStyle(fontSize: 23, color: colorBlack, fontWeight: FontWeight.w500),
                                        ),
                                        flexLabel: 2,
                                        flexDatePiker: 5,
                                        realTime: (user.user.birthDay != null && user.user.birthDay != "") ? user.user.birthDay : null,
                                        callbackValue: (value) {
                                          user.user.birthDay = value;
                                        },
                                      )
                                    : Row(
                                        children: [
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Ngày sinh",
                                                style: TextStyle(fontSize: 23, color: colorBlack, fontWeight: FontWeight.w500),
                                              )),
                                          Expanded(
                                            flex: 5,
                                            child: (user.user.birthDay != null && user.user.birthDay != "")
                                                ? Text("${user.user.birthDay}", style: AppStyles.appTextStyle())
                                                : const Text(""),
                                          )
                                        ],
                                      )),
                          ),
                          const SizedBox(height: 20),
                          EditInput(
                            widget: (!widget.checkEdit)
                                ? Row(
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            "Giới tính",
                                            style: TextStyle(fontSize: 23, color: colorBlack, fontWeight: FontWeight.w500),
                                          )),
                                      Expanded(
                                        flex: 5,
                                        child: CustomRadioButton(
                                          width: 80,
                                          elevation: 0,
                                          unSelectedColor: maincolor,
                                          // ignore: prefer_const_literals_to_create_immutables
                                          buttonLables: [
                                            'Nam',
                                            'Nữ',
                                          ],
                                          // ignore: prefer_const_literals_to_create_immutables
                                          buttonValues: [
                                            true,
                                            false,
                                          ],
                                          defaultSelected: (user.user.sex != null)
                                              ? (user.user.sex!)
                                                  ? true
                                                  : false
                                              : true,
                                          buttonTextStyle: const ButtonTextStyle(
                                              selectedColor: colorWhite,
                                              unSelectedColor: colorBlack,
                                              textStyle: TextStyle(fontSize: 16, color: colorBlack, fontWeight: FontWeight.w500)),
                                          radioButtonValue: (value) {
                                            user.user.sex = value as bool;
                                          },
                                          selectedColor: maincolor,
                                          selectedBorderColor: maincolor,
                                          unSelectedBorderColor: maincolor,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            "Giới tính",
                                            style: TextStyle(fontSize: 23, color: colorBlack, fontWeight: FontWeight.w500),
                                          )),
                                      Expanded(
                                        flex: 5,
                                        child: (user.user.sex != null)
                                            ? (user.user.sex.toString() == "true")
                                                ? Text("Nam", style: AppStyles.appTextStyle())
                                                : Text("Nữ", style: AppStyles.appTextStyle())
                                            : const Text(""),
                                      )
                                    ],
                                  ),
                          ),
                          const SizedBox(height: 20),
                          EditInput(
                            widget: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      "CCCD",
                                      style: TextStyle(fontSize: 23, color: colorBlack, fontWeight: FontWeight.w500),
                                    )),
                                Expanded(
                                    flex: 5,
                                    child: (!widget.checkEdit)
                                        ? AppTextFields(
                                            hint: '',
                                            controller: TextEditingController(text: (user.user.cccd != null) ? "${user.user.cccd}" : ""),
                                            onChanged: (name) {
                                              user.user.cccd = name;
                                            },
                                          )
                                        : (user.user.cccd != null)
                                            ? Text("${user.user.cccd}", style: AppStyles.appTextStyle())
                                            : const Text("")),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          EditInput(
                            widget: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Địa chỉ",
                                      style: TextStyle(fontSize: 23, color: colorBlack, fontWeight: FontWeight.w500),
                                    )),
                                Expanded(
                                    flex: 5,
                                    child: (!widget.checkEdit)
                                        ? AppTextFields(
                                            hint: '',
                                            controller: TextEditingController(text: (user.user.address != null) ? "${user.user.address}" : ""),
                                            onChanged: (name) {
                                              user.user.address = name;
                                            },
                                          )
                                        : (user.user.address != null)
                                            ? Text("${user.user.address}", style: AppStyles.appTextStyle())
                                            : const Text("")),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          EditInput(
                            widget: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Khu vực",
                                      style: TextStyle(fontSize: 23, color: colorBlack, fontWeight: FontWeight.w500),
                                    )),
                                Expanded(
                                    flex: 5,
                                    child: (!widget.checkEdit)
                                        ? DropdownSearch<Province>(
                                            mode: Mode.MENU,
                                            maxHeight: 350,
                                            showSearchBox: true,
                                            onFind: (String? filter) => getProvinces(),
                                            itemAsString: (Province? u) => "${u!.name}",
                                            dropdownSearchDecoration: styleDropDown,
                                            selectedItem: selecteProvince,
                                            onChanged: (value) {
                                              selecteProvince = value!;
                                            },
                                          )
                                        : (user.user.job != null)
                                            ? Text("${user.user.job!.name}", style: AppStyles.appTextStyle())
                                            : const Text("")),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          EditInput(
                            widget: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Ngành",
                                      style: TextStyle(fontSize: 23, color: colorBlack, fontWeight: FontWeight.w500),
                                    )),
                                Expanded(
                                    flex: 5,
                                    child: (!widget.checkEdit)
                                        ? DropdownSearch<Jobs>(
                                            mode: Mode.MENU,
                                            maxHeight: 350,
                                            showSearchBox: true,
                                            onFind: (String? filter) => getNganhNghe(),
                                            itemAsString: (Jobs? u) => "${u!.name}",
                                            dropdownSearchDecoration: styleDropDown,
                                            selectedItem: selectedItem,
                                            onChanged: (value) {
                                              selectedItem = value!;
                                            },
                                          )
                                        : (user.user.job != null)
                                            ? Text("${user.user.job!.name}", style: AppStyles.appTextStyle())
                                            : const Text("")),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          EditInput(
                            widget: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      "CV",
                                      style: TextStyle(fontSize: 23, color: colorBlack, fontWeight: FontWeight.w500),
                                    )),
                                Expanded(
                                  flex: 5,
                                  child: (!widget.checkEdit)
                                      ? IconButton(onPressed: () async {}, icon: Icon(Icons.upload))
                                      : (user.user.urlCv != null)
                                          ? Row(
                                              children: [
                                                TextButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      "Đã tải CV (Nhấn để tải xuống)",
                                                      style: AppStyles.appTextStyle(color: colorBlack),
                                                    )),
                                              ],
                                            )
                                          : Text(""),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 25),
                  Center(
                    child: Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: maincolor, width: 5), borderRadius: BorderRadius.circular(120), color: maincolor),
                      child: (user.user.urlImg == "" || user.user.urlImg == null)
                          ? ClipOval(
                              //  clipper:C,
                              child: Image.network('https://scr.vn/wp-content/uploads/2020/07/Avatar-Facebook-tr%E1%BA%AFng.jpg',
                                  width: 200, height: 200, fit: BoxFit.cover),
                            )
                          : ClipOval(
                              //  clipper:C,
                              child: Image.network(user.user.urlImg!, width: 200, height: 200, fit: BoxFit.cover),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
