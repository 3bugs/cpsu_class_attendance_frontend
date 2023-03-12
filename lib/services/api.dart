import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/response_body.dart';
import '../models/student.dart';

enum HttpMethod {
  get,
  post,
}

class ApiClient {
  static const apiBaseUrl = 'http://localhost:3000/api';

  Future<List<Student>> getAllStudents() async {
    try {
      var responseBody = await _makeRequest(
        HttpMethod.get,
        '/students',
      );
      List list = responseBody.data;
      return list.map((item) => Student.fromJson(item)).toList();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<Student?> getStudentById(String id) async {
    try {
      var responseBody = await _makeRequest(
        HttpMethod.get,
        '/students/$id',
      );
      Map<String, dynamic>? map = responseBody.data;
      return map != null ? Student.fromJson(map) : null;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<Student?> studentLogin(String studentId, String password) async {
    try {
      var responseBody = await _makeRequest(
        HttpMethod.get,
        '/students/$studentId/login',
        {'password': password},
      );
      Map<String, dynamic>? map = responseBody.data;
      return map != null ? Student.fromJson(map) : null;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<bool> studentCheckIn(String studentId, int classId) async {
    try {
      var responseBody = await _makeRequest(
        HttpMethod.post,
        '/classes/$classId/attend',
        {'studentId': studentId},
      );
      bool result = responseBody.data;
      return result;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<ResponseBody> _makeRequest(
    HttpMethod method,
    String path, [
    Map<String, dynamic>? params,
  ]) async {
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    Uri uri;
    http.Response response;

    try {
      switch (method) {
        // GET method
        case HttpMethod.get:
          String queryString = Uri(queryParameters: params).query;
          uri = Uri.parse('$apiBaseUrl$path?$queryString');

          response = await http.get(
            uri,
            headers: headers,
          );
          break;

        // POST method
        case HttpMethod.post:
          uri = Uri.parse('$apiBaseUrl$path');

          response = await http.post(
            uri,
            headers: headers,
            body: json.encode(params),
          );
          break;
      }

      debugPrint('URL: ${uri.toString()}');
      debugPrint('Response Status Code: ${response.statusCode.toString()}');
    } on SocketException {
      throw 'No Internet connection';
    } on TimeoutException catch (e) {
      throw 'Connection timeout';
    } on Error catch (e) {
      debugPrint('Error: $e');
      throw '$e';
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ResponseBody.fromJson(jsonDecode(response.body));
    } else {
      throw 'Error ${response.statusCode}: ${response.body}';
    }
  }

/*static Future<ResponseBody> _fetch(String path, [Map<String, dynamic>? queryParams]) async {
    http.Response response;

    try {
      String queryString = Uri(queryParameters: queryParams).query;
      var url = Uri.parse('$apiBaseUrl$path?$queryString');

      response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );

      debugPrint('URL: ${url.toString()}');
      debugPrint('Response Status Code: ${response.statusCode.toString()}');
    } on SocketException {
      throw 'No Internet connection';
    } on TimeoutException catch (e) {
      throw 'Connection timeout';
    } on Error catch (e) {
      debugPrint('Error: $e');
      throw '$e';
    }

    if (response.statusCode == 200) {
      return ResponseBody.fromJson(jsonDecode(response.body));
    } else {
      throw 'Error ${response.statusCode}: ${response.body}';
    }
  }

  Future<ResponseBody> _submit(String path, Map<String, dynamic> bodyParams) async {
    http.Response response;

    try {
      var url = Uri.parse('$apiBaseUrl$path');

      response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(bodyParams),
      );

      debugPrint('URL: ${url.toString()}');
      debugPrint('Response Status Code: ${response.statusCode.toString()}');
    } on SocketException {
      throw 'No Internet connection';
    } on TimeoutException catch (e) {
      throw 'Connection timeout';
    } on Error catch (e) {
      debugPrint('Error: $e');
      throw '$e';
    }

    if (response.statusCode == 200) {
      return ResponseBody.fromJson(jsonDecode(response.body));
    } else {
      throw 'Error ${response.statusCode}: ${response.body}';
    }
  }*/
}
