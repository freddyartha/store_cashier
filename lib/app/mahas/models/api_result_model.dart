import 'dart:convert';

class ApiResultModel {
  bool success = true;
  dynamic body;
  String? message;
  int? statusCode;
  dynamic errorMessages;

  ApiResultModel(this.statusCode, this.body) {
    if (statusCode == 200 || statusCode == 201) {
      success = true;
    } else {
      success = false;
      if (statusCode == 500) {
        message = "Internal Server Error";
      } else if (statusCode == 401) {
        if (body.toString().startsWith("{")) {
          var r = json.decode(body);
          message = r['errorMessages'][0];
        } else {
          message = "Token is invalid";
        }
      } else if (statusCode == 400 || statusCode == 404) {
        var r = json.decode(body);
        message = r['errorMessages'][0];
      } else if (body is String) {
        message = body;
        if (message!.indexOf('<!DOCTYPE html>') == 0) {
          var start = message!.indexOf('<title>') + '<title>'.length;
          var end = message!.indexOf('</title>');
          message = message!.substring(start, end);
        } else {}
      } else {
        message = body.toString();
      }
    }
  }

  ApiResultModel.error(this.message, {this.success = false});
}
