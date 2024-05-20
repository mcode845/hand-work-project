import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/server_user.dart';
import 'package:flutter_application_1/screen/Login.dart';
import 'package:http/http.dart' as http;

class user extends StatefulWidget {
  const user({Key? key}) : super(key: key);

  @override
  _userState createState() => _userState();
}

class _userState extends State<user> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _secureText = true;
  bool _secureTextConfirm = true;
  bool _nationalIdExists = false;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String _countryController = 'Egypt';
  final _cityController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _userType = 'User';
  final _jobController = TextEditingController();

  _clearTextInput() {
    _firstNameController.text = '';
    _lastNameController.text = '';
    _cityController.text = '';
    _idNumberController.text = '';
    _nationalIdController.text = '';
    _passwordController.text = '';
    _confirmPasswordController.text = '';
    _jobController.text = '';
  }

  @override
  void initState() {
    super.initState();
    _createUserTable();
  }

  void _createUserTable() {
    http.post(Uri.parse(ServerUserAPI.API_URL),
        body: {'action': 'CREATE_TABLE'}).then((response) {
      if (response.statusCode == 200) {
        print('User table created successfully');
      } else {
        print('Failed to create user table: ${response.reasonPhrase}');
      }
    }).catchError((error) {
      print('Error creating user table: $error');
    });
  }

  void _insertUser() {
    if (_formKey.currentState!.validate()) {
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String country = _countryController;
      String city = _cityController.text;
      String idNumber = _idNumberController.text;
      String nationalId = _nationalIdController.text;
      String password = _passwordController.text;
      String userType = _userType;
      String job = _jobController.text;

      _checkNationalIdExistence(nationalId).then((exists) {
        setState(() {
          _nationalIdExists = exists;
        });

        if (!exists) {
          ServerUserAPI.insertUser(
            firstName,
            lastName,
            country,
            city,
            idNumber,
            nationalId,
            password,
            userType,
            job,
          ).then((result) {
            if (result == 'User inserted successfully') {
              _clearTextInput();
              print('User inserted successfully');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.blue,
                  content: Row(
                    children: [
                      Icon(Icons.thumb_up, color: Colors.white),
                      Text(
                        'User registered successfully',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            } else {
              print('Failed to insert user: $result');
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('This national ID already exists.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<bool> _checkNationalIdExistence(String nationalId) async {
    bool exists = false;
    await ServerUserAPI.checkUser(nationalId, _passwordController.text)
        .then((result) {
      exists = result['authenticated'];
    }).catchError((error) {
      print('Error checking national id existence: $error');
    });
    return exists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF3A50C2),
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(15.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 26),
                    Text(
                      "Sign up to continue",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _firstNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelText: "First Name",
                          labelStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _lastNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelText: "Last Name",
                          labelStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: DropdownButtonFormField<String>(
                        value: _countryController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelText: "Country",
                          labelStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                        items: <String>[
                          'Egypt',
                          'Saudi Arabia',
                          'United Arab Emirates',
                          'Iraq',
                          'Jordan',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _countryController = newValue!;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _cityController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          suffixIcon: Icon(Icons.home_filled),
                          labelText: "City",
                          labelStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your city';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _idNumberController,
                        keyboardType: TextInputType.number,
                        maxLength: 11,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          suffixIcon: Icon(Icons.perm_identity_rounded),
                          labelText: "Phone Number",
                          labelStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _nationalIdController,
                        keyboardType: TextInputType.number,
                        maxLength: 14,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          suffixIcon: Icon(Icons.perm_identity_rounded),
                          labelText: "National ID",
                          labelStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your national ID';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _secureText,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_secureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _secureText = !_secureText;
                              });
                            },
                          ),
                          labelText: "Password",
                          labelStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          } else if (!RegExp(
                                  r'^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$')
                              .hasMatch(value)) {
                            return 'Password must contain at least one letter, one number, and one special character';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _secureTextConfirm,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_secureTextConfirm
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _secureTextConfirm = !_secureTextConfirm;
                              });
                            },
                          ),
                          labelText: "Confirm Password",
                          labelStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: DropdownButtonFormField<String>(
                        value: _userType,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelText: "User Type",
                          labelStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                        items: <String>[
                          'User',
                          'Worker',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _userType = newValue!;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _jobController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          suffixIcon: Icon(Icons.work),
                          labelText: "Job",
                          labelStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                        validator: (value) {
                          if (_userType == 'Worker' && value!.isEmpty) {
                            return 'Please enter your job title';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _insertUser();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text('Register'),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        "Already have an account? Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
