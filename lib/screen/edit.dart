import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'AccountDetilsWorker.dart';
import 'Login.dart';
import '../model/server_post.dart';

class WorkerPage extends StatefulWidget {
  const WorkerPage({Key? key}) : super(key: key);

  @override
  _WorkerPageState createState() => _WorkerPageState();
}

class _WorkerPageState extends State<WorkerPage> {
  final TextEditingController _userNameTD = TextEditingController();
  final TextEditingController _nationalID = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _postTitleTD = TextEditingController();
  final TextEditingController _postTextTD = TextEditingController();
  PlatformFile? _selectedFile;

  _clearTextInput() {
    _userNameTD.text = '';
    _nationalID.text = '';
    _phoneNumber.text = '';
    _city.text = '';
    _postTitleTD.text = '';
    _postTextTD.text = '';
    _selectedFile = null;
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  _createTable() {
    Services.createTable().then((result) {
      if ('success' == result) {
        if (kDebugMode) {
          print('Success to create table');
        }
      } else {
        if (kDebugMode) {
          print('Failed to create table: $result');
        }
      }
    });
  }

  _addPost() {
    _createTable();
    if (_userNameTD.text.isEmpty ||
        _nationalID.text.isEmpty ||
        _phoneNumber.text.isEmpty ||
        _city.text.isEmpty ||
        _postTitleTD.text.isEmpty ||
        _postTextTD.text.isEmpty ||
        _selectedFile == null) {
      if (kDebugMode) {
        print('Empty Field');
      }
      return;
    } else {
      String base64Image = base64Encode(_selectedFile!.bytes!);
      Services.addPost(
        _userNameTD.text,
        _nationalID.text,
        _phoneNumber.text,
        _city.text,
        _postTitleTD.text,
        _postTextTD.text,
        base64Image,
      ).then((result) {
        if ('success' == result) {
          _clearTextInput();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.blue,
              content: Row(
                children: [
                  Icon(Icons.thumb_up, color: Colors.white),
                  Text(
                    'Post added',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        } else {
          if (kDebugMode) {
            print('Failed to add post: $result');
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home worker'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Create a post',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _userNameTD,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Username',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nationalID,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(14),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: const InputDecoration(
                      hintText: 'National ID',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _phoneNumber,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(11),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: const InputDecoration(
                      hintText: 'phone number',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _city,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'city',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _postTitleTD,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Title',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _postTextTD,
                    textAlign: TextAlign.start,
                    maxLines: 4,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Enter Post text',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Select Image'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addPost,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:http/http.dart' as http;
// import 'package:file_picker/file_picker.dart';
// import 'AccountDetilsWorker.dart';
// import 'Login.dart';
// import '../model/server_post.dart';

// class WorkerPage extends StatefulWidget {
//   const WorkerPage({Key? key}) : super(key: key);

//   @override
//   _WorkerPageState createState() => _WorkerPageState();
// }

// class _WorkerPageState extends State<WorkerPage> {
//   final TextEditingController _userNameTD = TextEditingController();
//   final TextEditingController _nationalID = TextEditingController();
//   final TextEditingController _phoneNumber = TextEditingController();
//   final TextEditingController _city = TextEditingController();
//   final TextEditingController _postTitleTD = TextEditingController();
//   final TextEditingController _postTextTD = TextEditingController();
//   PlatformFile? _selectedFile;

//   _clearTextInput() {
//     _userNameTD.text = '';
//     _nationalID.text = '';
//     _phoneNumber.text = '';
//     _city.text = '';
//     _postTitleTD.text = '';
//     _postTextTD.text = '';
//     _selectedFile = null;
//   }

//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//     );
//     if (result != null) {
//       setState(() {
//         _selectedFile = result.files.first;
//       });
//     }
//   }

//   _createTable() {
//     Services.createTable().then((result) {
//       if ('success' == result) {
//         if (kDebugMode) {
//           print('Success to create table');
//         }
//       } else {
//         if (kDebugMode) {
//           print('Failed to create table');
//         }
//       }
//     });
//   }

//   _addPost() {
//     _createTable();
//     if (_userNameTD.text.isEmpty ||
//         _nationalID.text.isEmpty ||
//         _phoneNumber.text.isEmpty ||
//         _city.text.isEmpty ||
//         _postTitleTD.text.isEmpty ||
//         _postTextTD.text.isEmpty ||
//         _selectedFile == null) {
//       if (kDebugMode) {
//         print('Empty Field');
//       }
//       return;
//     } else {
//       String base64Image = base64Encode(_selectedFile!.bytes!);
//       Services.addPost(
//         _userNameTD.text,
//         _nationalID.text,
//         _phoneNumber.text,
//         _city.text,
//         _postTitleTD.text,
//         _postTextTD.text,
//         base64Image,
//       ).then((result) {
//         if ('success' == result) {
//           _clearTextInput();
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               backgroundColor: Colors.blue,
//               content: Row(
//                 children: [
//                   Icon(Icons.thumb_up, color: Colors.white),
//                   Text(
//                     'Post added',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home worker'),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     'Create a post',
//                     style: TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _userNameTD,
//                     textAlign: TextAlign.start,
//                     style: const TextStyle(
//                       fontSize: 20,
//                     ),
//                     decoration: const InputDecoration(
//                       hintText: 'Username',
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _nationalID,
//                     textAlign: TextAlign.start,
//                     style: const TextStyle(
//                       fontSize: 20,
//                     ),
//                     keyboardType: TextInputType.number,
//                     inputFormatters: [
//                       LengthLimitingTextInputFormatter(14),
//                       FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//                     ],
//                     decoration: const InputDecoration(
//                       hintText: 'National ID',
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _phoneNumber,
//                     textAlign: TextAlign.start,
//                     style: const TextStyle(
//                       fontSize: 20,
//                     ),
//                     keyboardType: TextInputType.number,
//                     inputFormatters: [
//                       LengthLimitingTextInputFormatter(11),
//                       FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//                     ],
//                     decoration: const InputDecoration(
//                       hintText: 'phone number',
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _city,
//                     textAlign: TextAlign.start,
//                     style: const TextStyle(
//                       fontSize: 20,
//                     ),
//                     decoration: const InputDecoration(
//                       hintText: 'city',
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _postTitleTD,
//                     textAlign: TextAlign.start,
//                     style: const TextStyle(
//                       fontSize: 20,
//                     ),
//                     decoration: const InputDecoration(
//                       hintText: 'Title',
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _postTextTD,
//                     textAlign: TextAlign.start,
//                     style: const TextStyle(
//                       fontSize: 20,
//                     ),
//                     keyboardType: TextInputType.multiline,
//                     maxLines: null,
//                     decoration: const InputDecoration(
//                       hintText: 'Text post',
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _pickFile,
//                     child: const Text(
//                       'Choose Image',
//                       style: TextStyle(fontSize: 20),
//                     ),
//                   ),
//                   if (_selectedFile != null)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10),
//                       child: Text(
//                         _selectedFile!.name,
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _addPost,
//                     child: const Text(
//                       'Share Now',
//                       style: TextStyle(
//                         fontSize: 25,
//                       ),
//                     ),
//                   ),
//                   const VerticalDivider(),
//                   Container(
//                     width: 35,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             Navigator.of(context).pushReplacement(
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     AccountDetailsWorkerPage(),
//                               ),
//                             );
//                           },
//                           icon: const Icon(Icons.account_circle),
//                           tooltip: 'Account Details',
//                         ),
//                         const SizedBox(height: 20),
//                         IconButton(
//                           onPressed: () {
//                             Navigator.of(context).pushReplacement(
//                               MaterialPageRoute(
//                                 builder: (context) => LoginScreen(),
//                               ),
//                             );
//                           },
//                           icon: const Icon(Icons.logout),
//                           tooltip: 'Logout',
//                         ),
//                         const SizedBox(height: 20),
//                         IconButton(
//                           onPressed: () {
//                             // Navigate to Settings screen
//                           },
//                           icon: const Icon(Icons.settings),
//                           tooltip: 'Settings',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

