// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_build_context_synchronously, unused_local_variable, prefer_final_fields, prefer_const_constructors_in_immutables, unused_element, unnecessary_string_interpolations, must_be_immutable
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nam_trinh_thinh/model/jobs.dart';
import 'package:nam_trinh_thinh/ui/style/color.dart';
import '../../../controllers/api.dart';
import '../../../model/works.dart';
import 'job_info_screen.dart';

class JobsScreen extends StatefulWidget {
  List<Work> listJobs;
  String titlePage;
  Map<int, String> province;
  bool? statusCheck;
  JobsScreen({Key? key, required this.listJobs, required this.titlePage, required this.province, this.statusCheck}) : super(key: key);

  @override
  _JobsScreenState createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  List<Work> listJobsView = [];
  void sortData() async {
    setState(() {
      listJobsView = [];
      listJobsView = widget.listJobs;
    });
  }

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

  Jobs selecteCareers = Jobs(id: 0, name: 'Tất cả');
  Map<int, String> listSalary = {0: "Tất cả", 1: "<10 triệu", 2: "10-20 triệu", 3: "20-30 triệu", 4: "30-40 triệu", 5: "40-50 triệu", 6: ">50 triệu"};
  int selectedSalary = 0;
  @override
  void initState() {
    super.initState();
    sortData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: Text('${widget.titlePage}'),
        backgroundColor: maincolor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: colorWhite,
              size: 20,
            )),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (widget.statusCheck == false) {
                    widget.statusCheck = true;
                  } else {
                    widget.statusCheck = false;
                  }
                });
              },
              icon: const Icon(
                Icons.filter_alt,
                size: 35,
                color: colorWhite,
              ))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/b6.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
            child: Column(
          children: [
            (widget.statusCheck != null && widget.statusCheck == true)
                ? Container(
                    height: 250,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: colorBlack.withOpacity(0.2),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Khu vực",
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: const BoxDecoration(
                                  color: colorWhite,
                                ),
                                height: 40,
                                child: DropdownSearch<Province>(
                                  mode: Mode.MENU,
                                  maxHeight: 350,
                                  showSearchBox: true,
                                  onFind: (String? filter) => getProvinces(),
                                  itemAsString: (Province? u) => u!.name,
                                  selectedItem: selecteProvince,
                                  dropdownSearchDecoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 14, bottom: 10),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromARGB(255, 102, 102, 102), width: 0.5),
                                    ),
                                    hintMaxLines: 1,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromARGB(255, 148, 148, 148), width: 0.5),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    selecteProvince = value!;
                                    // navigatePush(context,
                                    //     secondPage: JobsInfor(
                                    //       job: value,
                                    //     ));
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Ngành nghề",
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: const BoxDecoration(
                                  color: colorWhite,
                                ),
                                height: 40,
                                child: DropdownSearch<Jobs>(
                                  mode: Mode.MENU,
                                  maxHeight: 350,
                                  showSearchBox: true,
                                  onFind: (String? filter) => getNganhNghe(),
                                  itemAsString: (Jobs? u) => "${u!.name}",
                                  selectedItem: selecteCareers,
                                  dropdownSearchDecoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 14, bottom: 10),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromARGB(255, 102, 102, 102), width: 0.5),
                                    ),
                                    hintMaxLines: 1,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromARGB(255, 148, 148, 148), width: 0.5),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      selecteCareers = value!;
                                    });
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Mức lương",
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: colorWhite,
                                ),
                                height: 40,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    dropdownMaxHeight: 250,
                                    items: listSalary.entries.map((item) => DropdownMenuItem<int>(value: item.key, child: Text(item.value))).toList(),
                                    value: selectedSalary,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedSalary = value as int;
                                      });
                                    },
                                    buttonHeight: 40,
                                    itemHeight: 40,
                                    dropdownDecoration: BoxDecoration(
                                      border: Border.all(
                                        color: colorWhite,
                                      ),
                                    ),
                                    buttonDecoration: BoxDecoration(
                                      border: Border.all(width: 0.5, style: BorderStyle.solid, color: const Color.fromARGB(255, 102, 102, 102)),
                                      color: colorWhite,
                                    ),
                                    buttonElevation: 0,
                                    buttonPadding: const EdgeInsets.only(left: 0, right: 14),
                                    itemPadding: const EdgeInsets.only(left: 14, right: 14),
                                    dropdownElevation: 5,
                                    focusColor: colorWhite,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              margin: const EdgeInsets.only(right: 15),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15.0,
                                    horizontal: 5.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  backgroundColor: maincolor,
                                  primary: Theme.of(context).iconTheme.color,
                                  textStyle: Theme.of(context).textTheme.caption?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    listJobsView = [];
                                    if (selecteProvince.code != 0) {
                                      if (selecteCareers.id != 0) {
                                        if (selectedSalary != 0) {
                                          for (var element in widget.listJobs) {
                                            if (selectedSalary == 1) {
                                              if (element.salary! < 10000000 &&
                                                  selecteProvince.code == element.codeAddress &&
                                                  selecteCareers.id == element.job!.id) {
                                                listJobsView.add(element);
                                              }
                                            } else if (selectedSalary == 2 &&
                                                selecteProvince.code == element.codeAddress &&
                                                selecteCareers.id == element.job!.id) {
                                              if (element.salary! >= 10000000 && element.salary! <= 20000000) {
                                                listJobsView.add(element);
                                              }
                                            } else if (selectedSalary == 3 &&
                                                selecteProvince.code == element.codeAddress &&
                                                selecteCareers.id == element.job!.id) {
                                              if (element.salary! >= 20000000 && element.salary! <= 30000000) {
                                                listJobsView.add(element);
                                              }
                                            } else if (selectedSalary == 4 &&
                                                selecteProvince.code == element.codeAddress &&
                                                selecteCareers.id == element.job!.id) {
                                              if (element.salary! >= 30000000 && element.salary! <= 40000000) {
                                                listJobsView.add(element);
                                              }
                                            } else if (selectedSalary == 5 &&
                                                selecteProvince.code == element.codeAddress &&
                                                selecteCareers.id == element.job!.id) {
                                              if (element.salary! >= 40000000 && element.salary! <= 50000000) {
                                                listJobsView.add(element);
                                              }
                                            } else if (selectedSalary == 6 &&
                                                selecteProvince.code == element.codeAddress &&
                                                selecteCareers.id == element.job!.id) {
                                              if (element.salary! >= 50000000) {
                                                listJobsView.add(element);
                                              }
                                            }
                                          }
                                        } else {
                                          for (var element in widget.listJobs) {
                                            if (selecteProvince.code == element.codeAddress && selecteCareers.id == element.job!.id) {
                                              listJobsView.add(element);
                                            }
                                          }
                                        }
                                      } else {
                                        if (selectedSalary != 0) {
                                          for (var element in widget.listJobs) {
                                            if (selectedSalary == 1) {
                                              if (element.salary! < 10000000 && selecteProvince.code == element.codeAddress) {
                                                listJobsView.add(element);
                                              }
                                            } else if (selectedSalary == 2 && selecteProvince.code == element.codeAddress) {
                                              if (element.salary! >= 10000000 && element.salary! <= 20000000) {
                                                listJobsView.add(element);
                                              }
                                            } else if (selectedSalary == 3 && selecteProvince.code == element.codeAddress) {
                                              if (element.salary! >= 20000000 && element.salary! <= 30000000) {
                                                listJobsView.add(element);
                                              }
                                            } else if (selectedSalary == 4 && selecteProvince.code == element.codeAddress) {
                                              if (element.salary! >= 30000000 && element.salary! <= 40000000) {
                                                listJobsView.add(element);
                                              }
                                            } else if (selectedSalary == 5 && selecteProvince.code == element.codeAddress) {
                                              if (element.salary! >= 40000000 && element.salary! <= 50000000) {
                                                listJobsView.add(element);
                                              }
                                            } else if (selectedSalary == 6 && selecteProvince.code == element.codeAddress) {
                                              if (element.salary! >= 50000000) {
                                                listJobsView.add(element);
                                              }
                                            }
                                          }
                                        } else {
                                          for (var element in widget.listJobs) {
                                            if (selecteProvince.code == element.codeAddress) {
                                              listJobsView.add(element);
                                            }
                                          }
                                        }
                                      }
                                    } else {
                                      if (selecteCareers.id != 0) {
                                        if (selectedSalary != 0) {
                                          for (var element in widget.listJobs) {
                                            if (selectedSalary == 1) {
                                              if (element.salary! < 10000000 && selecteCareers.id == element.job!.id) {
                                                listJobsView.add(element);
                                              }
                                            } else if (selectedSalary == 2 && selecteCareers.id == element.job!.id) {
                                              if (element.salary! >= 10000000 && element.salary! <= 20000000) {
                                                listJobsView.add(element);
                                              }
                                            } else if (selectedSalary == 3 && selecteCareers.id == element.job!.id) {
                                              if (element.salary! >= 20000000 && element.salary! <= 30000000) {
                                                listJobsView.add(element);
                                              }
                                            } else if (selectedSalary == 4 && selecteCareers.id == element.job!.id) {
                                              if (element.salary! >= 30000000 && element.salary! <= 40000000) {
                                                listJobsView.add(element);
                                              }
                                            } else if (selectedSalary == 5 && selecteCareers.id == element.job!.id) {
                                              if (element.salary! >= 40000000 && element.salary! <= 50000000) {
                                                listJobsView.add(element);
                                              }
                                            } else if (selectedSalary == 6 && selecteCareers.id == element.job!.id) {
                                              if (element.salary! >= 50000000) {
                                                listJobsView.add(element);
                                              }
                                            }
                                          }
                                        } else {
                                          for (var element in widget.listJobs) {
                                            if (selecteCareers.id == element.job!.id) {
                                              listJobsView.add(element);
                                            }
                                          }
                                        }
                                      } else {
                                        if (selectedSalary != 0) {
                                          for (var element in widget.listJobs) {
                                            if (selectedSalary == 1) {
                                              if (element.salary! < 10000000) {
                                                listJobsView.add(element);
                                              }
                                            } else if (selectedSalary == 2) {
                                              if (element.salary! >= 10000000 && element.salary! <= 20000000) {
                                                listJobsView.add(element);
                                              }
                                            } else if (selectedSalary == 3) {
                                              if (element.salary! >= 20000000 && element.salary! <= 30000000) {
                                                listJobsView.add(element);
                                              }
                                            } else if (selectedSalary == 4) {
                                              if (element.salary! >= 30000000 && element.salary! <= 40000000) {
                                                listJobsView.add(element);
                                              }
                                            } else if (selectedSalary == 5) {
                                              if (element.salary! >= 40000000 && element.salary! <= 50000000) {
                                                listJobsView.add(element);
                                              }
                                            } else if (selectedSalary == 6) {
                                              if (element.salary! >= 50000000) {
                                                listJobsView.add(element);
                                              }
                                            }
                                          }
                                        } else {
                                          listJobsView = widget.listJobs;
                                        }
                                      }
                                    }
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    Text(
                                      "Lọc",
                                      style: TextStyle(fontSize: 20, color: colorWhite, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15.0,
                                    horizontal: 5.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  backgroundColor: Colors.red,
                                  primary: Theme.of(context).iconTheme.color,
                                  textStyle: Theme.of(context).textTheme.caption?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    selecteProvince = Province(code: 0, name: "Tất cả");
                                    selecteCareers = Jobs(id: 0, name: "Tất cả");
                                    selectedSalary = 0;
                                    listJobsView = widget.listJobs;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    Text(
                                      "Hủy lọc",
                                      style: TextStyle(fontSize: 20, color: colorWhite, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                : Row(),
            for (var element in listJobsView)
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
                  provinces: widget.province,
                ),
              )
          ],
        )),
      ),
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
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
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
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      work?.name! ?? "",
                      style: TextStyle(color: colorBlack, fontSize: 16, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.70,
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

class Province {
  int code;
  String name;
  Province({required this.code, required this.name});
}
