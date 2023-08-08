import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shareapp/main.dart';
import 'package:http/http.dart' as http;

TextEditingController email = new TextEditingController();
TextEditingController pass = new TextEditingController();
TextEditingController confpass = new TextEditingController();
TextEditingController username = new TextEditingController();
TextEditingController chanelname = new TextEditingController();

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
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
                                    'Register',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: username,
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: email,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This fieled is Required';
                                      } else {
                                        if (!RegExp(r'\S+@\S+\.\S+')
                                            .hasMatch(value)) {
                                          return 'Enter valid email';
                                        }
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: pass,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This fieled is Required';
                                      } else {
                                        if (value.length < 8) {
                                          return 'Password Must be atleast 8 character';
                                        }
                                      }
                                    },
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    obscureText: true,
                                    controller: confpass,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This fieled is Required';
                                      }
                                    },
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        label: Text('Confirm'),
                                        labelStyle:
                                            TextStyle(color: Colors.white)),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.all(8),
                                    child: TextButton.icon(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          if (pass.text == confpass.text) {
                                            final response = await http.post(
                                                Uri.parse(main_url +
                                                    '/system/appcontrol/registerpage.php'),
                                                body: {
                                                  "email": email.text,
                                                  "password": pass.text,
                                                  "username": username.text,
                                                });
                                            var varidate =
                                                jsonDecode(response.body);

                                            if (varidate) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    content: Text(
                                                        'Registered Successfull',
                                                        textAlign:
                                                            TextAlign.center)),
                                              );
                                              setState(() {
                                                email.text = '';
                                                pass.text = '';
                                                username.text = '';
                                                confpass.text = '';
                                              });
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    content: Text(
                                                        'Email Already Exist',
                                                        textAlign:
                                                            TextAlign.center)),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  content: Text(
                                                      'Passowrd Doesnot Match',
                                                      textAlign:
                                                          TextAlign.center)),
                                            );
                                          }
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                          primary: Colors.white,
                                          backgroundColor: Colors.black),
                                      label: Text('Register'),
                                      icon: Icon(Icons.app_registration),
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
