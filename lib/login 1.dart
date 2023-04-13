import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'Register1.dart';
import 'connection.dart';
import 'home.dart';



class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var email = TextEditingController();
  var password = TextEditingController();
  Future<void> addData() async {
    var data = {
      "email": email.text,
      "password": password.text,
    };

    var response = await post(Uri.parse('http://192.168.43.82/chatbotold/api/log.php'), body: data);
    print(response.body);
    var res = jsonDecode(response.body);
    if (res['message'] == 'Successfully LoggedIn') {
      var id = res["register_id"];


      final spref = await SharedPreferences.getInstance();
      spref.setString('user_id', id);

      Fluttertoast.showToast(msg: 'Succcessfully Login');
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return Chat();
        },
      ));
    } else {
      Fluttertoast.showToast(msg: 'Invalid Username or Password');
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Image.asset('assets/login.Gif',height: 150),
              Text(
                'LOGIN',
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
                      return 'Please enter your email Id';
                    }
                    return null;
                  },
                  controller: email,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color.fromRGBO(255, 5, 42, 208)),
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
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  controller: password,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color.fromARGB(255, 5, 42, 210)),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  obscureText: true,
                  keyboardType: TextInputType.number,
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
                      color: Color.fromARGB(149, 0, 136, 270),
                    ),
                    child: Center(
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Create a new account? '),
                  InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Register();
                          },
                        ));
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 3, 68, 200)),
                      )),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
