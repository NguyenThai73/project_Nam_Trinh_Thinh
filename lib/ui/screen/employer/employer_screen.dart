// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use, prefer_const_constructors, use_build_context_synchronously, unused_local_variable, must_be_immutable
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:nam_trinh_thinh/controllers/api.dart';
import 'package:nam_trinh_thinh/model/company.dart';

import '../../style/color.dart';
import 'employer_info_screen.dart';

class EmployerScreen extends StatefulWidget {
  const EmployerScreen({super.key});
  @override
  State<EmployerScreen> createState() => _EmployerScreenState();
}

class _EmployerScreenState extends State<EmployerScreen> {
  List<Company> listCompanys = [];
  Future<List<Company>> getCompany() async {
    setState(() {
      listCompanys = [];
    });
    var response = await httpGet("/api/company/getall", context);
    var body = response['body'];
    for (var element in body) {
      Company item = Company(
        id: element['id'],
        name: element['name'],
        email: element['email'],
        address: element['address'],
        urlImg: element['urlImg'],
        phone: element['phone'],
        jobs: element['jobs'],
      );
      item.jobs = await getCountJobs(item.id!);
      setState(() {
        listCompanys.add(item);
      });
    }
    return listCompanys;
  }

  Future<int> getCountJobs(int idCompany) async {
    int count = 0;
    var response1 = await httpGet("/api/company/$idCompany", context);
    var body1 = response1['body'];
    if (body1['jobs'] != null && body1['jobs'].length > 0) {
      count = body1['jobs'].length;
    }
    return count;
  }

  Company selectedCompany = Company(id: 0, name: "Tất cả");
  Future<List<Company>> getCompanySearch() async {
    List<Company> listCompanysSearch = [];
    var response = await httpGet("/api/company/getall", context);
    var body = response['body'];
    for (var element in body) {
      Company item = Company(
        id: element['id'],
        name: element['name'],
        email: element['email'],
        address: element['address'],
        urlImg: element['urlImg'],
        phone: element['phone'],
        jobs: element['jobs'],
      );
      listCompanysSearch.add(item);
    }
    listCompanysSearch.insert(0, Company(id: 0, name: "Tất cả"));
    return listCompanysSearch;
  }

  bool checkStt = false;

  void callApi() async {
    await getCompany();
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
                  image: AssetImage("assets/images/b7.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                      decoration: BoxDecoration(border: Border.all(width: 1), color: colorWhite),
                      child: DropdownSearch<Company>(
                        hint: "Tên công ty",
                        mode: Mode.MENU,
                        maxHeight: 350,
                        showSearchBox: true,
                        onFind: (String? filter) => getCompanySearch(),
                        itemAsString: (Company? u) => "${u!.name}",
                        dropdownSearchDecoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 14, bottom: 5),
                        ),
                        selectedItem: selectedCompany,
                        onChanged: (value) {},
                      ),
                    ),
                    for (var i = 0; i < listCompanys.length; i++)
                      TextButton(
                        onPressed: () {
                          // EmployerInfo
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => EmployerInfo(
                                company: listCompanys[i],
                              ),
                            ),
                          );
                        },
                        child: CompanyBox(
                          company: listCompanys[i],
                        ),
                      )
                  ],
                ),
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

class CompanyBox extends StatelessWidget {
  Company company;
  CompanyBox({Key? key, required this.company}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10,right: 10,bottom: 15),
      width: MediaQuery.of(context).size.width,
      height: 150,
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        // crossAxisAlignment: ,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                width: 80,
                height: 80,
                decoration: BoxDecoration(border: Border.all(width: 1)),
                child: Image.network(company.urlImg ?? "", width: 80, height: 80),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.69,
                    child: Text(
                      company.name!,
                      style: TextStyle(color: colorBlack, fontSize: 19, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.69,
                    height: 50,
                    child: Text(
                      company.address!,
                      style: TextStyle(color: colorBlack, fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 200,
                height: 25,
                decoration: BoxDecoration(
                  color: maincolor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
                ),
                child: Center(
                    child: Text(
                  "Có ${company.jobs} tin tuyển dụng",
                  style: TextStyle(color: colorWhite, fontSize: 16),
                )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
