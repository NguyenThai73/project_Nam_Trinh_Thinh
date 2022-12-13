// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_build_context_synchronously, unused_local_variable, prefer_final_fields, prefer_const_constructors_in_immutables, unused_element, unnecessary_string_interpolations, must_be_immutable
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nam_trinh_thinh/ui/style/color.dart';
import '../../../model/works.dart';
import 'job_info_screen.dart';

class JobsScreen extends StatefulWidget {
  List<Work> listJobs;
  String titlePage;
  Map<int, String> province;
  JobsScreen({
    Key? key,
    required this.listJobs,
    required this.titlePage,
    required this.province,
  }) : super(key: key);

  @override
  _JobsScreenState createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  @override
  void initState() {
    super.initState();
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
            for (var element in widget.listJobs)
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
