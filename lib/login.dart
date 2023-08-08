import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shareapp/main.dart';
import 'package:shareapp/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController email = new TextEditingController();
TextEditingController pass = new TextEditingController();
var valid = 0;

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(221, 45, 43, 43),
          title: Text(title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 170,
              ),
              ClipRect(
                child: Container(
                  color: Colors.black87,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      height: 400,
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
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextFormField(
                                    controller: email,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This fieled is Required';
                                      }
                                    },
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.mail,
                                          color: Colors.white,
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        label: Text('Email'),
                                        labelStyle:
                                            TextStyle(color: Colors.white)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextFormField(
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This fieled is Required';
                                      }
                                    },
                                    controller: pass,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        label: Text('Password'),
                                        labelStyle:
                                            TextStyle(color: Colors.white)),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.all(12),
                                    child: TextButton.icon(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          final response = await http.post(
                                              Uri.parse(main_url +
                                                  '/system/appcontrol/loginpage.php'),
                                              body: {
                                                "email": email.text,
                                                "password": pass.text
                                              });
                                          var varidate =
                                              jsonDecode(response.body);

                                          if (varidate == false) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  content: Text('Login Failed',
                                                      textAlign:
                                                          TextAlign.center)),
                                            );
                                          } else {
                                            final SharedPreferences
                                                sharedPreferences =
                                                await SharedPreferences
                                                    .getInstance();
                                            sharedPreferences.setString(
                                                'id', varidate);
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        dashboard()));
                                            setState(() {
                                              email.text = '';
                                              pass.text = '';
                                            });
                                          }
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                          primary: Colors.white,
                                          backgroundColor: Colors.black),
                                      label: Text('Login'),
                                      icon: Icon(Icons.login),
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
