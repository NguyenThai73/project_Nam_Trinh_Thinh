// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_build_context_synchronously, unused_local_variable, must_be_immutable

import 'package:flutter/material.dart';
import 'package:nam_trinh_thinh/ui/style/color.dart';
import 'package:provider/provider.dart';
import '../../../controllers/api.dart';
import '../../../controllers/provider.dart';
import '../../../model/company.dart';
import '../../../model/jobs.dart';
import '../../../model/recruiment.dart';
import '../../../model/user_login.dart';
import '../../../model/works.dart';
import '../home/home_screen.dart';
import 'login-body.dart';

class LoginScreen extends StatefulWidget {
  String? email;
  LoginScreen({Key? key, this.email}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.email != null) _emailController.text = widget.email!;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> processing() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Center(child: const CircularProgressIndicator());
        },
      );
    }

    return Consumer<User>(
      builder: (context, user, child) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/b8.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LoginScreenBody(
                controller: _emailController,
                passWordController: _passwordController,
              ),
              Container(
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 22, 173, 243),
                    borderRadius: BorderRadius.circular(5)),
                child: TextButton(
                    onPressed: () async {
                      processing();
                      var requestBody = {
                        "username": _emailController.text,
                        "password": _passwordController.text
                      };
                      var response = await httpPostLogin(requestBody, context);
                      if (response.containsKey("body")) {
                        // var body = jsonDecode(response['body']);
                        var body = response['body'];
                        // Navigator.pop(context);
                        UserLogin userLogin = UserLogin.fromJson(body);
                        user.changeAuthorization(body['accessToken']);
                        user.changeUser(userLogin);
                        int count = (body['user']['listJobs'] != null)
                            ? body['user']['listJobs'].length
                            : 0;
                        user.changeCountJobs(count);
                        Map<int, Recruitment> listWorkUT = {};
                        for (var element in body['user']['listJobs']) {
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
                                dateExpiration: element['job']
                                    ['dateExpiration'],
                              ),
                              status: element['status'],
                              message: element['message']);
                          listWorkUT[item.work?.id ?? 0] = item;
                        }
                        user.changeWorkUT(listWorkUT);
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => HomePage(),
                          ),
                        );
                      }
                    },
                    child: Text('Đăng nhập',
                        style: TextStyle(color: colorWhite, fontSize: 25))),
              ),

              // const SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Text(
              //       "Chưa có tài khoản?",
              //       // style: textAppStyle,
              //     ),
              //     TextButton(
              //         onPressed: () {
              //           // Navigator.push<void>(
              //           //   context,
              //           //   MaterialPageRoute<void>(
              //           //     builder: (BuildContext context) => const SignScreen(),
              //           //   ),
              //           // );
              //         },
              //         child: Text("Đăng ký")),
              //     const SizedBox(width: 30),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
