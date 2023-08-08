import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shareapp/main.dart';
import 'package:shareapp/myuploads.dart';
import 'package:shareapp/upload_file.dart';
import 'package:shareapp/profile.dart';
import 'package:shareapp/changeemail.dart';
import 'package:shareapp/profilephoto.dart';
import 'package:shareapp/changepassword.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var total = '0';
var vtotal = '0';
var ptotal = '0';
var itotal = '0';

var id = '0';

var email = "Not signedin";
var username = "Not signedin";
var profilephoto = null;

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  void getdata() async {
    final SharedPreferences sharedPreferences1 =
        await SharedPreferences.getInstance();
    var userid = sharedPreferences1.getString('id');
    if (userid == null) {
    } else {
      id = userid;
      final responses = await http.get(Uri.parse(
          main_url + '/system/appcontrol/dashboardpage.php?id=' + id));

      if (responses.statusCode == 200) {
        var datasum = jsonDecode(responses.body);
        //var showsum = datasum[0];

        total = datasum['total'];
        vtotal = datasum['vtotal'];
        ptotal = datasum['ptotal'];
        itotal = datasum['itotal'];

        setState(() {});
      }
      final response = await http.get(Uri.parse(
          main_url + '/system/appcontrol/requestuserinfo.php?id=' + id));
      if (response.statusCode == 200) {
        List userinfo = jsonDecode(response.body);
        var userinform = userinfo[0];
        email = userinform['email'];
        if (userinform['photo_link'] == "icon") {
          profilephoto = null;
        } else {
          profilephoto = main_url + '/system/' + userinform['photo_link'];
        }
        ;
        username = userinform['full_name'];
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              },
              icon: Icon(Icons.home)),
          IconButton(
              onPressed: () async {
                final SharedPreferences sharedPreferences1 =
                    await SharedPreferences.getInstance();
                var id = sharedPreferences1.getString('id');
                if (id != null) {
                  sharedPreferences1.remove('id');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                }
              },
              icon: Icon(Icons.logout)),
        ],
        title: Text(title),
        backgroundColor: Color.fromARGB(221, 45, 43, 43),
      ),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(221, 45, 43, 43),
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(username),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.black87,
                child: profilephoto == null
                    ? Icon(
                        Icons.person,
                      )
                    : null,
                backgroundImage:
                    profilephoto != null ? NetworkImage(profilephoto) : null,
              ),
            ),
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => dashboard()));
              },
              title: new Text(
                "Dashboard",
              ),
              trailing: new Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => myuploads()));
              },
              title: new Text(
                "My Chat",
              ),
              trailing: new Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => uploadsfile()));
              },
              title: new Text(
                "Uploads Chat",
              ),
              trailing: new Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => profile()));
              },
              title: new Text(
                "Profile",
              ),
              trailing: new Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => changeemail()));
              },
              title: new Text(
                "Change Email",
              ),
              trailing: new Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => changephoto()));
              },
              title: new Text(
                "Change Profile Photo",
              ),
              trailing: new Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => changepassword()));
              },
              title: new Text(
                "Change Password",
              ),
              trailing: new Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: Container(
                color: Color.fromARGB(221, 45, 43, 43),
                width: double.infinity,
                margin: EdgeInsets.all(20),
                height: 200,
                child: Center(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total Uploads',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.all(20),
                        child: Text(
                          total,
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ))
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
