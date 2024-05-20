import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/model/posts.dart';
import 'dart:convert';

class Services {
  static var url = Uri.parse(
      'https://handworke.000webhostapp.com/API_POST/Post_api.php');

  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _ADD_POST_ACTION = 'ADD_POST';
  static const _GET_ALL_POSTS_ACTION = 'GET_ALL';
  static const _DELETE_POST_ACTION = 'DELETE_POST';

  // Method to create table
  static Future<String> createTable() async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _CREATE_TABLE_ACTION;
      final response = await http.post(url, body: map);
      if (kDebugMode) {
        print('Create table response: ${response.body}');
      }
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }

  // Method to add Post
  static Future<String> addPost(
      String userName,
      String nationalid,
      String phonenumber,
      String city,
      String postTitle,
      String postText,
      String image,
  ) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _ADD_POST_ACTION;
      map['user_name'] = userName;
      map['national_id'] = nationalid;
      map['phone_number'] = phonenumber;
      map['city'] = city;
      map['post_title'] = postTitle;
      map['post_text'] = postText;
      map['image'] = image;
      final response = await http.post(url, body: map);
      if (kDebugMode) {
        print('ADD Post Response: ${response.body}');
      }
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }

  // Method to get all Posts
  static Future<List<Posts>> getAllPosts() async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _GET_ALL_POSTS_ACTION;
      final response = await http.post(url, body: map);
      if (kDebugMode) {
        print('Get All Posts: ${response.body}');
      }
      if (200 == response.statusCode) {
        List<Posts> list = parseResponse(response.body);
        return list;
      } else {
        return <Posts>[];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception: $e');
      }
      return <Posts>[];
    }
  }

  static List<Posts> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Posts>((json) => Posts.fromJson(json)).toList();
  }

  static Future<String> deletePost(String postId) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _DELETE_POST_ACTION;
      map['POST_ID'] = postId;
      final response = await http.post(url, body: map);
      if (kDebugMode) {
        print('delete post response: ${response.body}');
      }
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }


}
