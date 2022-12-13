// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use, prefer_const_constructors, use_build_context_synchronously, unused_local_variable
import 'package:flutter/material.dart';

class EmployerScreen extends StatefulWidget {
  const EmployerScreen({super.key});
  @override
  State<EmployerScreen> createState() => _EmployerScreenState();
}

class _EmployerScreenState extends State<EmployerScreen> {
  bool light = false;
  bool checkStt = false;
  void callApi() async {
    // await getJobs();
    // await getProvinces();
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
        ? Container(
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
              child: Text("EmployerScreen"),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
