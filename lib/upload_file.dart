import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shareapp/main.dart';
import 'package:shareapp/myuploads.dart';
import 'package:shareapp/dashboard.dart';
import 'package:shareapp/profile.dart';
import 'package:shareapp/changeemail.dart';
import 'package:shareapp/profilephoto.dart';
import 'package:shareapp/changepassword.dart';
import 'package:file_picker/file_picker.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var email = "Not signedin";
var username = "Not signedin";
var profilephoto = null;

TextEditingController description = new TextEditingController();

class uploadsfile extends StatefulWidget {
  const uploadsfile({Key? key}) : super(key: key);

  @override
  State<uploadsfile> createState() => _uploadsfileState();
}

class _uploadsfileState extends State<uploadsfile> {
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(80),
          child: Container(
            color: Color.fromARGB(221, 45, 43, 43),
            width: double.infinity,
            margin: EdgeInsets.all(20),
            //height: 200,
            child: Center(
              child: Column(children: [
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: description,
                    maxLines: 3,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black38,
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: "description",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    margin: EdgeInsets.all(20),
                    child: TextButton.icon(
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.black),
                        onPressed: () async {
                          if (description.text == null ||
                              description.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text('Description cannot be empty',
                                      textAlign: TextAlign.center)),
                            );
                          } else {
                            final response = await http.post(
                                Uri.parse(main_url +
                                    '/system/appcontrol/uploadfiles.php'),
                                body: {
                                  "id": id,
                                  "message": description.text,
                                });

                            var varidate = jsonDecode(response.body);

                            if (varidate) {
                              setState(() {
                                description.text = '';
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text('Saved',
                                        textAlign: TextAlign.center)),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                        'your chat contain offensive words',
                                        textAlign: TextAlign.center)),
                              );
                            }
                          }
                        },
                        icon: Icon(Icons.upload),
                        label: Text('Upload'))),
              ]),
            ),
          ),
        ),
      ),
    ));
  }
}
