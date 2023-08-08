import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:shareapp/changepassword.dart';
import 'package:shareapp/dashboard.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_video_view/native_video_view.dart';

import 'package:shareapp/login.dart';
import 'package:shareapp/register.dart';

var title = 'The Keyboard';
//var main_url = 'https://keyboard.iim.co.tz/';
var main_url = 'https://greentanzania.org/thekeyboard/';

List searchdatas = [];
List originaldata = [];
List commentdata = [];
TextEditingController homeQuery = new TextEditingController();

var currentsearchstate = 0;

double? _progress;

int lastdownload = 0;

int showcomment = 0;

int commentstate = 0;

TextEditingController message = new TextEditingController();

var email = "Not signedin";
var username = "Not signedin";
var profilephoto = null;

void main() {
  runApp(Wellcome());
}

class Wellcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _getValidationData();
  }

  void _getValidationData() async {
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyApp())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 50,
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
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
  int currentPageIndex = 0;

  void getuserinfo() async {
    final SharedPreferences sharedPreferences1 =
        await SharedPreferences.getInstance();
    var id = sharedPreferences1.getString('id');
    if (id == null) {
      email = "Not signedin";
      username = "Not signedin";
      profilephoto = null;
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
    final response = await http
        .get(Uri.parse(main_url + '/system/appcontrol/showhomepage.php'));
    if (response.statusCode == 200) {
      searchdatas = jsonDecode(response.body);
      originaldata = jsonDecode(response.body);
      setState(() {});
    }
  }

  void videodata() async {
    final response = await http
        .get(Uri.parse(main_url + '/system/appcontrol/showvideopage.php'));
    if (response.statusCode == 200) {
      searchdatas = jsonDecode(response.body);
      originaldata = jsonDecode(response.body);
      setState(() {});
    }
  }

  void pdfdata() async {
    final response = await http
        .get(Uri.parse(main_url + '/system/appcontrol/showpdfpage.php'));
    if (response.statusCode == 200) {
      searchdatas = jsonDecode(response.body);
      originaldata = jsonDecode(response.body);
      setState(() {});
    }
  }

  void imgdata() async {
    final response = await http
        .get(Uri.parse(main_url + '/system/appcontrol/showimgpage.php'));
    if (response.statusCode == 200) {
      searchdatas = jsonDecode(response.body);
      originaldata = jsonDecode(response.body);
      setState(() {});
    }
  }

  void chatdata() async {
    final response = await http
        .get(Uri.parse(main_url + '/system/appcontrol/showchatpage.php'));
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
                  setState(() {
                    if (currentPageIndex == 0) {
                      getdata();
                    } else {
                      if (currentPageIndex == 1) {
                        videodata();
                      } else {
                        if (currentPageIndex == 2) {
                          pdfdata();
                        } else {
                          if (currentPageIndex == 3) {
                            imgdata();
                          } else {
                            if (currentPageIndex == 4) {
                              chatdata();
                            }
                          }
                        }
                      }
                    }
                  });
                },
                icon: Icon(Icons.refresh))
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
                onTap: () async {
                  final SharedPreferences sharedPreferences1 =
                      await SharedPreferences.getInstance();
                  var id = sharedPreferences1.getString('id');
                  if (id == null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => login()));
                  } else {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => dashboard()));
                  }
                },
                title: new Text(
                  "My Account",
                ),
                trailing: new Icon(Icons.arrow_forward_ios),
              ),
              Divider(),
              ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => register()));
                },
                title: new Text("Create Account"),
                trailing: new Icon(Icons.arrow_forward_ios),
              ),
              Divider(),
              ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                onTap: () => exit(0),
                title: new Text("Exit"),
                trailing: new Icon(Icons.arrow_forward_ios),
              ),
              Divider(),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              indicatorColor: Colors.blue.withOpacity(0.5),
              labelTextStyle:
                  MaterialStateProperty.all(TextStyle(color: Colors.white))),
          child: NavigationBar(
            animationDuration: const Duration(seconds: 2),
            backgroundColor: Colors.black87,
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
              if (index == 0) {
                getdata();
              } else {
                if (index == 1) {
                  videodata();
                } else {
                  if (index == 2) {
                    pdfdata();
                  } else {
                    if (index == 3) {
                      imgdata();
                    } else {
                      if (index == 4) {
                        chatdata();
                      }
                    }
                  }
                }
              }
            },
            selectedIndex: currentPageIndex,
            destinations: const <Widget>[
              NavigationDestination(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.video_file,
                  color: Colors.white,
                ),
                label: 'Video',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.picture_as_pdf,
                  color: Colors.white,
                ),
                label: 'Pdf',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.image,
                  color: Colors.white,
                ),
                label: 'Images',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.chat,
                  color: Colors.white,
                ),
                label: 'Chat',
              ),
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
            Container(
              color: Colors.black87,
              alignment: Alignment.center,
              child: _Listview(searchdatas),
            ),
            Container(
              color: Colors.black87,
              alignment: Alignment.center,
              child: _Listview(searchdatas),
            ),
            Container(
              color: Colors.black87,
              alignment: Alignment.center,
              child: _Listview(searchdatas),
            ),
            Container(
              color: Colors.black87,
              alignment: Alignment.center,
              child: _Listview(searchdatas),
            ),
          ][currentPageIndex],
        ));
  }

  ////home class to show data on screeen homepage

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
                          searchdata['file_type'] == "chat"
                              ? Text('')
                              : Expanded(
                                  flex: 1,
                                  child: IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        setState(() {
                                          lastdownload = i;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              content: Text(
                                                  '    Download started',
                                                  textAlign: TextAlign.center)),
                                        );
                                        FileDownloader.downloadFile(
                                            url: main_url +
                                                '/system/' +
                                                searchdata['file'],
                                            name: 'file',
                                            onProgress: (name, progress) {
                                              setState(() {
                                                _progress = progress;
                                              });
                                            },
                                            onDownloadCompleted: (path) {
                                              final File file = File(path);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    content: Text(
                                                      'Download complete',
                                                      textAlign:
                                                          TextAlign.center,
                                                    )),
                                              );
                                              setState(() {
                                                _progress = null;
                                              });
                                            },
                                            onDownloadError: (String error) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    content: Text(
                                                        'Download failed',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.center)),
                                              );
                                            });
                                      },
                                      icon: Icon(Icons.download)),
                                ),
                          Expanded(
                              flex: 5,
                              child: _progress == null
                                  ? Text('')
                                  : lastdownload == i
                                      ? Text(
                                          _progress.toString() + "%",
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.end,
                                        )
                                      : Text(''))
                        ],
                      ),
                      searchdata['file_type'] == "video"
                          ? Container(
                              alignment: Alignment.center,
                              child: NativeVideoView(
                                keepAspectRatio: true,
                                showMediaController: true,
                                enableVolumeControl: true,
                                useExoPlayer: true,
                                onCreated: (controller) {
                                  controller.setVideoSource(
                                    main_url + '/system/' + searchdata['file'],
                                    sourceType: VideoSourceType.network,
                                    requestAudioFocus: true,
                                  );
                                },
                                onPrepared: (controller, info) {
                                  debugPrint('NativeVideoView: Video prepared');
                                  // controller.play();
                                },
                                onError: (controller, what, extra, message) {
                                  // debugPrint(
                                  //     'NativeVideoView: Player Error ($what | $extra | $message)');
                                },
                                onCompletion: (controller) {
                                  //debugPrint(
                                  //    'NativeVideoView: Video completed');
                                },
                                onProgress: (progress, duration) {
                                  print('$progress | $duration');
                                },
                              ),
                            )
                          : searchdata['file_type'] == "chat"
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  //height: 200,
                                  child: Text(searchdata['content'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal)),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                            main_url +
                                                '/system/' +
                                                searchdata['thumb_nail'],
                                          ))),
                                ),
                      Divider(),
                      searchdata['file_type'] == "chat"
                          ? Text('')
                          : Text(
                              searchdata['content'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                      Divider(),
                      searchdata['file_type'] == "chat"
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Text('')),
                                    Center(
                                        child: Expanded(
                                            child: IconButton(
                                                onPressed: () {
                                                  comdata(
                                                      searchdata['upload_id'],
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
                            )
                          : Text(''),
                      Divider(),
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
                                      builder: (context) => MyApp()));
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
