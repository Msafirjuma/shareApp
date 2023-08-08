import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'dart:developer';
import 'package:shareapp/profilephoto.dart';
import 'package:shareapp/changepassword.dart';

import 'package:shareapp/main.dart';
import 'package:shareapp/dashboard.dart';
import 'package:shareapp/upload_file.dart';
import 'package:shareapp/profile.dart';
import 'package:shareapp/changeemail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_video_view/native_video_view.dart';

List searchdatas = [];
List originaldata = [];
TextEditingController homeQuery = new TextEditingController();

var currentsearchstate = 0;

int currentPageIndex = 0;

double? _progress;

int lastdownload = 0;

var email = "Not signedin";
var username = "Not signedin";
var profilephoto = null;

class myuploads extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  void getuserinfo() async {
    final SharedPreferences sharedPreferences1 =
        await SharedPreferences.getInstance();
    var id = sharedPreferences1.getString('id');
    if (id == null) {
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

  void getdata() async {
    final response = await http.get(Uri.parse(
        main_url + '/system/appcontrol/showuserhomepage.php?id=' + id));
    if (response.statusCode == 200) {
      searchdatas = jsonDecode(response.body);
      originaldata = jsonDecode(response.body);
      setState(() {});
    }
  }

  void comdata(comid, chat) async {
    final response = await http.get(Uri.parse(
        main_url + '/system/appcontrol/showsinglechatpage.php?id=' + comid));
    if (response.statusCode == 200) {
      commentdata = jsonDecode(response.body);
      showcommentdata(comid, commentdata, chat);
      setState(() {});
    }
  }

  void search(String query) {
    if (query.isEmpty) {
      searchdatas = originaldata;
      setState(() {});
      return;
    }

    query = query.toLowerCase();
    print(query);
    List result = [];
    searchdatas.forEach((p) {
      var name = p["content"].toString().toLowerCase();
      if (name.contains(query)) {
        result.add(p);
      }
    });

    searchdatas = result;
    setState(() {});
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getdata();
    getuserinfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(
                onPressed: () {
                  if (currentsearchstate == 0) {
                    currentsearchstate = 1;
                    setState(() {});
                  } else {
                    currentsearchstate = 0;
                    setState(() {});
                  }
                },
                icon: Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  ;
                },
                icon: Icon(Icons.refresh)),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
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
                icon: Icon(Icons.logout))
          ],
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
        body: Scaffold(
          appBar: currentsearchstate == 0
              ? null
              : AppBar(
                  title: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: homeQuery,
                    onChanged: search,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      border: UnderlineInputBorder(),
                      hintText: "Search",
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          homeQuery.text = '';
                          search(homeQuery.text);
                        },
                      ),
                    ),
                  ),
                  backgroundColor: Color.fromARGB(221, 45, 43, 43),
                ),
          body: <Widget>[
            Container(
                color: Colors.black87,
                alignment: Alignment.center,
                child: _Listview(searchdatas)),
          ][currentPageIndex],
        ));
  }

  Widget _Listview(searchdatas) {
    if (searchdatas.length == 0) {
      return CircularProgressIndicator();
    }
    return ListView.builder(
      itemCount: searchdatas.length,
      itemBuilder: (BuildContext context, int i) {
        var searchdata = searchdatas[i];
        return Column(
          children: [
            //Divider(),
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Container(
                  color: Color.fromARGB(221, 45, 43, 43),
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(8),
                  width: double.infinity,
                  //height: 440,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                final response = await http.get(Uri.parse(
                                    main_url +
                                        '/system/appcontrol/deletedata.php?id=' +
                                        searchdata['upload_id']));
                                if (response.statusCode == 200) {
                                  var result = jsonDecode(response.body);
                                  if (result) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          content: Text('Deleted',
                                              style: TextStyle(
                                                  color: Colors.white),
                                              textAlign: TextAlign.center)),
                                    );
                                    getdata();
                                    setState(() {});
                                  }
                                }
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        //height: 200,
                        child: Text(searchdata['content'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.normal)),
                      ),
                      Divider(),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text('')),
                              Center(
                                  child: Expanded(
                                      child: IconButton(
                                          onPressed: () {
                                            comdata(searchdata['upload_id'],
                                                searchdata['content']);
                                          },
                                          icon: Icon(
                                            Icons.chat,
                                            color: Colors.white,
                                          )))),
                              Expanded(child: Text('')),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        searchdata['upload_created_at'],
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )),
            ),
          ],
        );
      },
    );
  }

  showcommentdata(ids, commentdata, chat) {
    final _formKey = GlobalKey<FormState>();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Card(
            child: Container(
              color: Colors.black87,
              child: Column(
                children: [
                  Text(
                    chat,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                      child: Center(
                    child: ListView.builder(
                        itemCount: commentdata.length,
                        itemBuilder: (BuildContext context, int i) {
                          var comdata = commentdata[i];

                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.all(10),
                                  color: Colors.grey,
                                  width: double.infinity,
                                  child: Text(
                                    comdata['comment'],
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          );
                        }),
                  )),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => myuploads()));
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (builder) {
                                    return Form(
                                      key: _formKey,
                                      child: AlertDialog(
                                          content: Row(
                                        children: [
                                          Expanded(
                                              flex: 3,
                                              child: TextFormField(
                                                controller: message,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'This fieled is Required';
                                                  }
                                                },
                                                maxLines: 3,
                                                style: TextStyle(
                                                    color: Colors.white),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.black38,
                                                  hintStyle: TextStyle(
                                                      color: Colors.white),
                                                  hintText: "description",
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                    borderSide: BorderSide(
                                                        color: Colors.white),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white)),
                                                ),
                                              )),
                                          IconButton(
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  final response = await http.post(
                                                      Uri.parse(main_url +
                                                          '/system/appcontrol/savecomment.php'),
                                                      body: {
                                                        "id": ids,
                                                        "message": message.text,
                                                      });
                                                  var varidate =
                                                      jsonDecode(response.body);

                                                  if (varidate) {
                                                    setState(() {
                                                      message.text = '';
                                                    });
                                                    comdata(ids, chat);
                                                  } else {
                                                    showDialog(
                                                        context: context,
                                                        builder: (builder) {
                                                          return AlertDialog(
                                                            content: Text(
                                                                'your chat contain offensive words'),
                                                          );
                                                        });
                                                  }
                                                }
                                              },
                                              icon: Icon(
                                                Icons.send,
                                                color: Colors.black87,
                                              ))
                                        ],
                                      )),
                                    );
                                  });
                            },
                            icon: Icon(
                              Icons.chat,
                              color: Colors.white,
                            )),
                      ),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                              onPressed: () {
                                comdata(ids, chat);
                              },
                              icon: Icon(
                                Icons.refresh,
                                color: Colors.white,
                              )))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
