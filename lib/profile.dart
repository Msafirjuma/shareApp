import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shareapp/main.dart';
import 'package:http/http.dart' as http;

import 'package:shareapp/myuploads.dart';
import 'package:shareapp/dashboard.dart';
import 'package:shareapp/profile.dart';
import 'package:shareapp/changeemail.dart';
import 'package:shareapp/upload_file.dart';
import 'package:http/http.dart' as http;
import 'package:shareapp/profilephoto.dart';
import 'package:shareapp/changepassword.dart';

import 'package:shared_preferences/shared_preferences.dart';

TextEditingController usernameshow = new TextEditingController();

var email = "Not signedin";
var username = "Not signedin";
var profilephoto = null;

class profile extends StatefulWidget {
  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  final _formKey = GlobalKey<FormState>();

  void getdata() async {
    final SharedPreferences sharedPreferences1 =
        await SharedPreferences.getInstance();
    var userid = sharedPreferences1.getString('id');
    if (userid == null) {
    } else {
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

        usernameshow.text = userinform['full_name'];
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
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(221, 45, 43, 43),
          title: Text(title),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => changepassword()));
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
              SizedBox(
                height: 50,
              ),
              ClipRect(
                child: Container(
                  color: Colors.black87,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      //height: 700,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Form(
                          key: _formKey,
                          child: Card(
                            color: Color.fromARGB(221, 45, 43, 43),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(19),
                                  child: Text(
                                    'Profile',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: usernameshow,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This fieled is Required';
                                      }
                                    },
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        label: Text('Full Name'),
                                        labelStyle:
                                            TextStyle(color: Colors.white)),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.all(8),
                                    child: TextButton.icon(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          final response = await http.post(
                                              Uri.parse(main_url +
                                                  '/system/appcontrol/profilepage.php?id=' +
                                                  id),
                                              body: {
                                                "username": usernameshow.text,
                                              });
                                          var varidate =
                                              jsonDecode(response.body);

                                          if (varidate) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  content: Text(
                                                      'Updated Successfull',
                                                      textAlign:
                                                          TextAlign.center)),
                                            );
                                            setState(() {});
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  content: Text('Failed ',
                                                      textAlign:
                                                          TextAlign.center)),
                                            );
                                          }
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                          primary: Colors.white,
                                          backgroundColor: Colors.black),
                                      label: Text('Save'),
                                      icon: Icon(Icons.save),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
