// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_build_context_synchronously, unused_local_variable, prefer_final_fields, prefer_const_constructors_in_immutables, unused_element
import 'package:flutter/material.dart';
import 'package:nam_trinh_thinh/ui/screen/home/home_body.dart';
import 'package:nam_trinh_thinh/ui/style/color.dart';
import 'package:provider/provider.dart';
import '../../../controllers/provider.dart';
import '../employer/employer_screen.dart';
import '../user/user_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  static List<Widget> _pages = <Widget>[
    HomeBody(),
    EmployerScreen(),
    UserScreen(),
  ];
  int _selectedIndex = 0;

  var urlAvatar = "https://scr.vn/wp-content/uploads/2020/07/Avatar-Facebook-tr%E1%BA%AFng.jpg";
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
        appBar: AppBar(
          toolbarHeight: 60,
          title: Text('${user.user.fullName}'),
          backgroundColor: maincolor,
          leading: Row(
            children: [
              SizedBox(width: 5),
              ClipOval(
                  child: (user.user.urlImg == "" || user.user.urlImg == null)
                      ? Image.network(urlAvatar, fit: BoxFit.cover, width: 50, height: 50)
                      : Image.network(user.user.urlImg!, fit: BoxFit.cover, width: 50, height: 50)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: colorWhite,
              ),
              tooltip: 'Show Snackbar',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Đây là phần thông báo'),
                  backgroundColor: Colors.blue,
                ));
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex, //New
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          }, //New
          selectedFontSize: 16,
          selectedIconTheme: IconThemeData(color: colorBlack, size: 40),
          selectedItemColor: colorBlack,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.business_center),
              label: 'Việc làm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apartment),
              label: 'Công ty',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Tài khoản',
            ),
          ],
        ),
      ),
    );
  }
}
