import 'dart:convert';

class UserStorageModel {
  String? username;
  String? password;
  String? urlApi;

  UserStorageModel();

  UserStorageModel.init(
    this.username,
    this.password,
    this.urlApi,
  );

  //use this forn decode
  static UserStorageModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static UserStorageModel fromDynamic(dynamic dynamicData) {
    final model = UserStorageModel();

    model.username = dynamicData['username'];
    model.password = dynamicData['password'];
    model.urlApi = dynamicData['urlApi'];

    return model;
  }

  Map<String, dynamic> userToJson(UserStorageModel data) {
    var mapData = {
      'username': data.username,
      'password': data.password,
      'urlApi': data.urlApi,
    };
    return mapData;
  }
}
