import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'connection.dart';

import 'login 1.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var name = TextEditingController();
  var email = TextEditingController();
  var mobile_no = TextEditingController();
  var password = TextEditingController();

  Future<dynamic> getData() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    var sp = spref.getString('user_id');
    print(sp);

    var data = {
      "id": sp,
    };
    // print(data);
    var response =
    await post(Uri.parse('http://192.168.43.82/chatbotold/api/view.php'), body: data);
    print(response.body);
    var res = jsonDecode(response.body);
    return res;
  }

  Future<void> addData() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    var sp = spref.getString('user_id');
    print(sp);

    var data = {
      "id": sp,
      "name": name.text,
      "email": email.text,
      "mobile_no": mobile_no.text,
      "password": password.text
    };
    var response = await post(Uri.parse('http://192.168.43.82/chatbotold/api/update.php'), body: data);
    print(response.body);
    var res = jsonDecode(response.body);
    if (res['message'] == 'Added') {
      Fluttertoast.showToast(msg: 'Updated Successfully');
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return Login();
        },
      ));
    } else {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: getData(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/profile.jpeg', height: 200),
                          Text(
                            'Update your current Profile',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 136, 240),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              controller: name,
                              decoration: InputDecoration(
                                // labelText: 'Name',
                                hintText: snap.data![0]['name'],
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 5, 42, 208)),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Email Id';
                                }
                                return null;
                              },
                              controller: email,
                              decoration: InputDecoration(
                                // labelText: 'Email',
                                hintText: snap.data![0]['email'],
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 5, 42, 208)),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Mobile_no number';
                                }
                                return null;
                              },
                              controller: mobile_no,
                              decoration: InputDecoration(
                                // labelText: 'Mobile_no',
                                hintText: snap.data![0]['mobile_no'],
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 5, 42, 208)),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Password';
                                }
                                return null;
                              },
                              controller: password,
                              decoration: InputDecoration(
                                // labelText: 'Password',
                                hintText: snap.data![0]['password'],
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 5, 42, 208)),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          InkWell(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                addData();
                              }
                            },
                            child: Container(
                                height: 50,
                                width: 320,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color.fromARGB(149, 0, 136, 240),
                                ),
                                child: Center(
                                  child: Text(
                                    'Update',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          )
                        ]),
                  );
                }
              }),
        ),
      ),
    );
  }
}
