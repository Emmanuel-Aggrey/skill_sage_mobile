library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:skill_sage_app/models/_index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'user.dart';
part 'settings.dart';
part "http.dart";
part 'recommendation.dart';
part 'courses.dart';
part 'job.dart';
part 'skills_recommender.dart';
part 'youtube.dart';
part 'web_socket_channel.dart';

FutureOr<Resp<dynamic>> cather(Future<Response> Function() func) async {
  try {
    final res = await func.call();

    // Handle different response formats
    dynamic result;
    bool success = false;

    // Check if response data exists
    if (res.data != null && res.data is Map<String, dynamic>) {
      final responseData = res.data as Map<String, dynamic>;

      // Extract success field
      success = responseData["success"] ?? false;

      // Extract result/data field - check both common patterns
      if (responseData.containsKey("result")) {
        result = responseData["result"];
      } else if (responseData.containsKey("data")) {
        result = responseData["data"];
      } else {
        // Fallback: if no 'result' or 'data' field, return the whole response minus success
        result = responseData;
        result.remove("success"); // Remove success to avoid duplication
      }
    } else {
      // Handle cases where response is not a map or is null
      success = false;
      result = res.data;
    }

    return Resp(success: success, result: result);
  } catch (e) {
    if (e is DioException) {
      if (e.response != null) {
        print('err: ${e.response!.data}');
        final res = e.response!;

        // Handle null response data
        if (res.data == null) {
          return Resp(
              success: false,
              error: "Network error: ${res.statusMessage ?? 'Unknown error'}");
        }

        // Handle different error response formats
        final responseData = res.data;

        // Check if it's a simple string error
        if (responseData is String) {
          return Resp(success: false, error: responseData);
        }

        // Check if it's a map with detail field
        if (responseData is Map<String, dynamic>) {
          final detail = responseData["detail"];

          if (detail is String) {
            return Resp(success: false, error: detail);
          }

          // Handle nested error structure
          if (detail is Map<String, dynamic> && detail["result"] != null) {
            final result = detail["result"];
            if (result is List && result.length > 1 && result[1] is Map) {
              final errorResult = result[1]["result"];
              return Resp(
                  success: detail["success"] ?? false,
                  error: errorResult?.toString() ?? "Unknown error");
            }
          }

          // Handle direct error message
          final message = responseData["message"] ??
              responseData["error"] ??
              "Unknown error";
          return Resp(success: false, error: message.toString());
        }

        return Resp(success: false, error: "Unexpected error format");
      }
    }
    rethrow;
  }
}

class Resp<T> {
  bool success;
  T? result;
  String? error;
  Resp({required this.success, this.result, this.error});

  Resp<U?> parse<U>(U Function(dynamic) parser) {
    U? parsed;
    if (result != null) {
      if (result is List) {
        throw Exception("Data is a list, use parseList method instead.");
      } else {
        parsed = parser(result);
      }
      return Resp(success: success, error: error, result: parsed);
    }

    return Resp(success: success, error: error, result: null);
  }

  Resp<List<U?>> parseList<U>(U Function(Map<String, dynamic>) parser) {
    List<U?> parsedList;
    if (result != null) {
      if (result is List) {
        final mapData = result as List;
        parsedList = mapData.map((e) => parser(e)).toList();
      } else {
        throw Exception("Data is not a list, use parse method instead.");
      }
      return Resp(success: success, error: error, result: parsedList);
    }
    return Resp(success: false, error: error, result: null);
  }

  Resp<Null> toNull() {
    return Resp(success: success, error: error, result: null);
  }
}
