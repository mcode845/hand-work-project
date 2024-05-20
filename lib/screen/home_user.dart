import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/posts.dart';
import 'package:flutter_application_1/model/server_post.dart';
import 'package:flutter_application_1/screen/AccountDetilsUsers.dart';
import 'package:flutter_application_1/screen/Login.dart';
import 'dart:convert';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Posts> _posts = [];

  @override
  void initState() {
    _getPosts();
    super.initState();
  }

  Future<void> _getPosts() async {
    try {
      List<Posts> posts = await Services.getAllPosts();
      setState(() {
        _posts = posts;
      });
      if (kDebugMode) {
        print('Length: ${_posts.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching posts: $e');
      }
    }
  }

  // void _deletePost(String selectPostId) async {
  //   try {
  //     String result = await Services.deletePost(selectPostId);
  //     if (result == 'success') {
  //       _getPosts();
  //       if (kDebugMode) {
  //         print('Delete done');
  //       }
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error deleting post: $e');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home user'),
        automaticallyImplyLeading: false,
      ),
      body: Row(
        children: [
          Expanded(
            child: _posts.isEmpty
                ? const Center(
                    child: Text(
                      'There is no post',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _getPosts,
                    backgroundColor: Colors.blue,
                    color: Colors.white,
                    child: ListView.builder(
                      itemCount: _posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffEBEBEB),
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: Colors.blue, width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              size: 20,
                                            ),
                                            color: Colors.red,
                                            onPressed: () {
                                              // _deletePost(_posts[index].id);
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${_posts[index].username}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.person,
                                            size: 35,
                                            color: Colors.blue,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${_posts[index].phonenumber}',
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${_posts[index].city}',
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${_posts[index].postTitle}',
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SelectableText(
                                    '${_posts[index].postText}',
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _posts[index].image.isNotEmpty
                                      ? Image.memory(
                                          base64Decode(_posts[index].image),
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
          const VerticalDivider(),
          Container(
            width: 35,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _getPosts,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh',
                ),
                const SizedBox(height: 20),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => AccountDetailsPage()));
                  },
                  icon: const Icon(Icons.account_circle),
                  tooltip: 'Account Details',
                ),
                const SizedBox(height: 20),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                ),
                const SizedBox(height: 20),
                IconButton(
                  onPressed: () {
                    // Navigator.of(context).pushReplacement(
                    //     MaterialPageRoute(builder: (context) => Feedback()));
                  },
                  icon: const Icon(Icons.star),
                  tooltip: 'Feedback',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
