import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/response_body.dart';
import '../models/student.dart';

enum HttpMethod {
  get,
  post,
}

extension ParseToString on HttpMethod {
  String toShortStringUpperCase() {
    return toString().split('.').last.toUpperCase();
  }
}

class ApiClient {
  static const apiBaseUrl = 'http://localhost:3000/api';

  Future<List<Student>> getAllStudents() async {
    var responseBody = await _makeRequest(
      HttpMethod.get,
      '/students',
    );
    List list = responseBody.data;
    return list.map((item) => Student.fromJson(item)).toList();
  }

  Future<Student?> getStudentById(String id) async {
    var responseBody = await _makeRequest(
      HttpMethod.get,
      '/students/$id',
    );
    Map<String, dynamic>? map = responseBody.data;
    return map != null ? Student.fromJson(map) : null;
  }

  Future<Student?> studentLogin(String studentId, String password) async {
    var responseBody = await _makeRequest(
      HttpMethod.get,
      '/students/$studentId/login',
      {'password': password},
    );
    Map? map = responseBody.data;
    return map != null ? Student.fromJson(map as Map<String, dynamic>) : null;
  }

  Future<bool> studentCheckIn(String studentId, int classId) async {
    var responseBody = await _makeRequest(
      HttpMethod.post,
      '/classes/$classId/attend',
      {'studentId': studentId},
    );
    bool result = responseBody.data;
    return result;
  }

  Future<ResponseBody> _makeRequest(
    HttpMethod httpMethod,
    String path, [
    Map<String, dynamic>? params,
  ]) async {
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    Uri? uri;
    http.Response? response;
    var isError = false;

    try {
      switch (httpMethod) {
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
    } catch (e) {
      // ดัก error ที่เกิดขึ้นในกรณียังไม่ได้ response กลับมาจาก API
      // เช่น ไม่มี network connection, server down เป็นต้น

      isError = true;
      _logError(httpMethod, uri, e.toString());
      throw e.toString();
    } finally {
      if (!isError && _isSuccessResponse(response)) {
        debugPrint('┌──────────────────────────────────────────────────────────────────────────────────────────');
        debugPrint('│ ✔ HTTP Method / URL:           ${httpMethod.toShortStringUpperCase()} ${uri.toString()}');
        debugPrint("│ ✔ HTTP Response's Status Code: ${response?.statusCode}");
        debugPrint('└──────────────────────────────────────────────────────────────────────────────────────────');
      }
    }

    ResponseBody? responseBody;
    String? errMessage;
    try {
      // ดักกรณี response body ไม่ได้เป็น JSON

      responseBody = ResponseBody.fromJson(jsonDecode(response.body));
    } catch (e) {
      errMessage = response.body;
    }

    if (_isSuccessResponse(response)) {
      return responseBody!;
    } else {
      // ดัก error กรณีได้ response กลับมาจาก API แล้ว
      // แต่ status code ของ response ไม่ใช่ 200, 201

      // todo: test กรณีนี้
      var msg = responseBody?.message ?? errMessage ?? 'Unknown Error';
      _logError(httpMethod, uri, responseBody?.message ?? errMessage ?? 'Unknown Error !!!', response.statusCode);
      throw msg;
    }
  }

  bool _isSuccessResponse(http.Response? response) {
    return (response?.statusCode == 200 || response?.statusCode == 201);
  }

  void _logError(HttpMethod httpMethod, Uri? uri, String errMessage, [int? statusCode]) {
    debugPrint('    ┌───────────┐');
    debugPrint('┌───┤ ⚡ ERROR ⚡ ├──────────────────────────────────────────────────────────────────────────');
    debugPrint('│   └───────────┘');
    debugPrint('│ ✏ HTTP Method / URL:           ${httpMethod.toShortStringUpperCase()} ${uri.toString()}');
    debugPrint("│ ✏ HTTP Response's Status Code: ${statusCode ?? 'N/A (ยังไม่ได้ response จาก API)'}");
    debugPrint('│ ✏ Error Message:               $errMessage');
    debugPrint('└──────────────────────────────────────────────────────────────────────────────────────────');
  }
}
