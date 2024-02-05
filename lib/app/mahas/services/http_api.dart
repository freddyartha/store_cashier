import 'dart:convert';
import 'dart:developer';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:store_cashier/app/mahas/mahas_service.dart';
import 'package:store_cashier/app/mahas/services/helper.dart';

import '../models/api_result_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class HttpApi {
  static String? _apiToken;
  static DateTime _apiTokenExpired = DateTime.now();

  static void clearToken() {
    _apiToken = null;
  }

  static Future<String?> _token() async {
    var now = DateTime.now();
    if (_apiToken == null || _apiTokenExpired.isBefore(now)) {
      _apiTokenExpired = DateTime(
          now.year, now.month, now.day, now.hour, now.minute + 59, now.second);
      _apiToken = await auth.currentUser?.getIdToken(true);
    }
    return _apiToken;
  }

  static String getUrl(String url) {
    if (url.toUpperCase().contains('HTTPS://') ||
        url.toUpperCase().contains('HTTP://')) {
      return url;
    } else {
      // return MahasConfig.urlApi + url;
      return url;
    }
  }

  static ApiResultModel _getResult(http.Response r) {
    // print(r.body);
    // print(r.statusCode);
    // print(r.request!.url);
    // print(r.request!.method);
    return ApiResultModel(r.statusCode, r.body);
  }

  static ApiResultModel _getErrorResult(dynamic ex) {
    _apiToken = null;
    return ApiResultModel.error("$ex");
  }

  static Future<ApiResultModel> get(String url) async {
    try {
      final token = await _token();
      log(token!);
      final urlX = Uri.parse(getUrl(url));
      final r = await httpLog().get(
        urlX,
        headers: {
          'Authorization': token != null ? 'Bearer $token' : '',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          return http.Response(
            'Error Request Timeout\nCek koneksi internet Anda dan coba beberapa saat lagi',
            408,
          );
        },
      );
      return _getResult(r);
    } catch (ex) {
      return _getErrorResult(ex);
    }
  }

  static Future<ApiResultModel> post(
    String url, {
    Object? body,
    String contentType = 'application/json',
  }) async {
    try {
      final token = await _token();
      final urlX = Uri.parse(getUrl(url));
      http.Response r;
      if (contentType == 'application/json') {
        r = await httpLog()
            .post(
          urlX,
          headers: {
            'Content-type': contentType,
            'Authorization': token != null ? 'Bearer $token' : '',
          },
          body: json.encode(body),
        )
            .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            return http.Response(
              'Error Request Timeout\nCek koneksi internet Anda dan coba beberapa saat lagi',
              408,
            );
          },
        );
      } else {
        var request = http.MultipartRequest('POST', urlX);
        if (body is Map<String, dynamic>) {
          body.forEach((key, value) {
            if (key == 'Foto' && value is List) {
              for (var i = 0; i < value.length; i++) {
                var file = value[i];
                request.files.add(
                  http.MultipartFile.fromBytes(key, file,
                      filename: 'file${i + 1}.jpg'),
                );
              }
            } else {
              request.fields[key] = value.toString();
            }
          });
        }
        request.headers['Content-type'] = contentType;
        request.headers['Authorization'] = token != null ? 'Bearer $token' : '';

        var response = await request.send();
        r = await http.Response.fromStream(response);
      }
      return _getResult(r);
    } catch (ex) {
      return _getErrorResult(ex);
    }
  }

  static Future<ApiResultModel> put(String url, {Object? body}) async {
    try {
      final token = await _token();
      final urlX = Uri.parse(getUrl(url));
      var r = await httpLog()
          .put(
        urlX,
        headers: {
          'Content-type': 'application/json',
          'Authorization': token != null ? 'Bearer $token' : '',
        },
        body: json.encode(body),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          return http.Response(
            'Error Request Timeout\nCek koneksi internet Anda dan coba beberapa saat lagi',
            408,
          );
        },
      );
      return _getResult(r);
    } catch (ex) {
      return _getErrorResult(ex);
    }
  }

  static Future<ApiResultModel> delete(String url, {Object? body}) async {
    try {
      final token = await _token();
      final urlX = Uri.parse(getUrl(url));
      var r = await httpLog()
          .delete(
        urlX,
        headers: {
          'Content-type': 'application/json',
          'Authorization': token != null ? 'Bearer $token' : '',
        },
        body: json.encode(body),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          return http.Response(
            'Error Request Timeout\nCek koneksi internet Anda dan coba beberapa saat lagi',
            408,
          );
        },
      );
      return _getResult(r);
    } catch (ex) {
      return _getErrorResult(ex);
    }
  }

  static bool httpErrorCheck(ApiResultModel err) {
    //if data is empty return true else false
    if (EasyLoading.isShow) EasyLoading.dismiss();
    bool noInternet =
        MahasService.isInternetCausedError(err.message.toString());
    if (!noInternet) {
      String errorMessage;
      if (err.message.toString().startsWith("{")) {
        var errorBody = jsonDecode(err.message!);
        errorMessage = errorBody["errorMessages"][0];
      } else {
        errorMessage = err.message ?? "";
      }
      if (errorMessage.contains(RegExp(
              "Item that you try to find can not be found",
              caseSensitive: false)) ||
          err.statusCode == 400 ||
          err.statusCode == 404) {
        return true;
      } else {
        Helper.errorToast(message: errorMessage);
        return false;
      }
    } else {
      Helper.errorToast();
      return false;
    }
  }

  static HttpWithMiddleware httpLog() {
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    return http;
  }
}
