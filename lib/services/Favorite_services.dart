import 'dart:convert';
import 'dart:io';
import 'package:delivery_food/General/Api_Result.dart';
import 'package:delivery_food/General/Constants.dart';
import 'package:delivery_food/controller/Auth_controller.dart';
import 'package:delivery_food/model/DeletePutPost.dart';
import 'package:delivery_food/model/Error.dart';
import 'package:delivery_food/model/Favorite_model.dart';
import 'package:http/http.dart' as http;

class FavoriteService {
  AuthController authController = AuthController();

  Future<ApiResult> getfavoriteData(String q, String from, String to) async {
    StatusCode statusCode = StatusCode();
    ApiResult apiResult = ApiResult();
    List<FavoriteResponse> calendar = [];
    FavoriteStatus? status;
    ErrorResponse? error;
    Uri url;
    if (from == '') {
      url = Uri.http('${statusCode.url1}', '/api/private/user/favorite',
          {'q': q, 'lang': statusCode.Lang});
    } else {
      url = Uri.http('${statusCode.url1}', '/api/private/user/favorite',
          {'q': q, 'from': from, 'to': to, 'lang': statusCode.Lang});
    }

    try {
      var response = await http
          .get(url, headers: {'Authorization': 'Bearer ${statusCode.Token}'});

      var responsebode = jsonDecode(response.body);
      print(responsebode);
      if (response.statusCode == statusCode.OK ||
          response.statusCode == statusCode.CREATED) {
        status = FavoriteStatus.fromJson(responsebode['status']);
        if (responsebode['response'] != null) {
          for (var item in responsebode['response']['data']) {
            calendar.add(FavoriteResponse.fromJson(item));
          }
          apiResult.isEmpty = false;

          apiResult.errorMassage = status.msg;
          apiResult.codeError = status.code;
          apiResult.hasError = false;
          apiResult.data = calendar;
        } else {
          calendar = [];
          apiResult.hasError = false;
        }
        if (responsebode['response']['data'].isEmpty) {
          apiResult.isEmpty = true;
        }
      } else if (response.statusCode == statusCode.BAD_REQUEST) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print('A bad request Please try again');
      } else if (response.statusCode == statusCode.UNAUTHORIZED) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;
        apiResult.rfreshToken = false;
        await authController.postrefreshToken();
        print('A bad request Please try again');
      } else if (response.statusCode == statusCode.FORBIDDEN) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print('A bad request Please try again');
      } else if (response.statusCode == statusCode.NOT_FOUND) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print('Endpoint not found Please try again');
      } else if (response.statusCode == statusCode.DUPLICATED_ENTRY) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print('Input error Please try again');
      } else if (response.statusCode == statusCode.VALIDATION_ERROR) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print('Input error Please try again');
      } else if (response.statusCode == statusCode.INTERNAL_SERVER_ERROR) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print('Server error Please try again');
      } else {
        status = FavoriteStatus.fromJson(responsebode['status']);
        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print(' error Please try again');
      }
    } on SocketException {
      apiResult.errorMassage = 'Make sure you are connected to the internet';
      apiResult.codeError = statusCode.connection;
      apiResult.hasError = true;
      print('Make sure you are connected to the internet');
    } on FormatException {
      apiResult.errorMassage = 'There is a problem with the admin';
      apiResult.codeError = statusCode.parsing;
      apiResult.hasError = true;
      print('There is a problem with the admin');
    } catch (e) {
      apiResult.errorMassage = '?????? ?????? ?????? ??????????';
      apiResult.codeError = statusCode.connection;
      apiResult.hasError = true;
      print('${e}');
    }
    return apiResult;
  }

  Future<ApiResult> postfavoriteData(int id) async {
    StatusCode statusCode = StatusCode();
    ApiResult apiResult = ApiResult();
    DeletePutPostResponse? calendar;
    FavoriteStatus? status;
    ErrorResponse? error;
    Uri url = Uri.http('${statusCode.url1}', '/api/private/user/favorite/$id');

    try {
      var response = await http.post(
        url,
        headers: {'Authorization': 'Bearer ${statusCode.Token}'},
      );
      var responsebode = jsonDecode(response.body);

      if (response.statusCode == statusCode.OK ||
          response.statusCode == statusCode.CREATED) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        if (responsebode['response'] != null) {
          calendar = DeletePutPostResponse.fromJson(responsebode);

          apiResult.errorMassage = status.msg;
          apiResult.codeError = status.code;
          apiResult.hasError = false;
          apiResult.data = calendar;
        }
      } else if (response.statusCode == statusCode.BAD_REQUEST) {
        status = FavoriteStatus.fromJson(responsebode['status']);
        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print('A bad request Please try again');
      } else if (response.statusCode == statusCode.UNAUTHORIZED) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;
        apiResult.rfreshToken = false;
        await authController.postrefreshToken();
        print('A bad request Please try again');
      } else if (response.statusCode == statusCode.FORBIDDEN) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print('A bad request Please try again');
      } else if (response.statusCode == statusCode.NOT_FOUND) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print('Endpoint not found Please try again');
      } else if (response.statusCode == statusCode.DUPLICATED_ENTRY) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print('Input error Please try again');
      } else if (response.statusCode == statusCode.VALIDATION_ERROR) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print('Input error Please try again');
      } else if (response.statusCode == statusCode.INTERNAL_SERVER_ERROR) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print('Server error Please try again');
      } else {
        status = FavoriteStatus.fromJson(responsebode['status']);
        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print(' error Please try again');
      }
    } on SocketException {
      apiResult.errorMassage = 'Make sure you are connected to the internet';
      apiResult.codeError = statusCode.connection;
      apiResult.hasError = true;
      print('Make sure you are connected to the internet');
    } on FormatException {
      apiResult.errorMassage = 'There is a problem with the admin';
      apiResult.codeError = statusCode.parsing;
      apiResult.hasError = true;
      print('There is a problem with the admin');
    } catch (e) {
      apiResult.errorMassage = '?????? ?????? ?????? ??????????';
      apiResult.codeError = statusCode.connection;
      apiResult.hasError = true;
      print('${e}');
    }
    return apiResult;
  }

  Future<ApiResult> deletefavoriteData(int id) async {
    StatusCode statusCode = StatusCode();
    ApiResult apiResult = ApiResult();
    DeletePutPostResponse? calendar;
    FavoriteStatus? status;
    ErrorResponse? error;
    Uri url = Uri.http('${statusCode.url1}', '/api/private/user/favorite/$id');

    try {
      var response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer ${statusCode.Token}'},
      );
      var responsebode = jsonDecode(response.body);

      if (response.statusCode == statusCode.OK ||
          response.statusCode == statusCode.CREATED) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        if (responsebode['response'] != null) {
          calendar = DeletePutPostResponse.fromJson(responsebode);

          apiResult.errorMassage = status.msg;
          apiResult.codeError = status.code;
          apiResult.hasError = false;
          apiResult.data = calendar;
        }
      } else if (response.statusCode == statusCode.BAD_REQUEST) {
        status = FavoriteStatus.fromJson(responsebode['status']);
        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print('A bad request Please try again');
      } else if (response.statusCode == statusCode.UNAUTHORIZED) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;
        apiResult.rfreshToken = false;
        await authController.postrefreshToken();
        print('A bad request Please try again');
      } else if (response.statusCode == statusCode.FORBIDDEN) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print('A bad request Please try again');
      } else if (response.statusCode == statusCode.NOT_FOUND) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print('Endpoint not found Please try again');
      } else if (response.statusCode == statusCode.DUPLICATED_ENTRY) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print('Input error Please try again');
      } else if (response.statusCode == statusCode.VALIDATION_ERROR) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print('Input error Please try again');
      } else if (response.statusCode == statusCode.INTERNAL_SERVER_ERROR) {
        status = FavoriteStatus.fromJson(responsebode['status']);

        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print('Server error Please try again');
      } else {
        status = FavoriteStatus.fromJson(responsebode['status']);
        error = ErrorResponse.fromJson(responsebode['errors'][0]);
        apiResult.errorMassage = error.msg;
        apiResult.codeError = status.code;

        print(' error Please try again');
      }
    } on SocketException {
      apiResult.errorMassage = 'Make sure you are connected to the internet';
      apiResult.codeError = statusCode.connection;
      apiResult.hasError = true;
      print('Make sure you are connected to the internet');
    } on FormatException {
      apiResult.errorMassage = 'There is a problem with the admin';
      apiResult.codeError = statusCode.parsing;
      apiResult.hasError = true;
      print('There is a problem with the admin');
    } catch (e) {
      apiResult.errorMassage = '?????? ?????? ?????? ??????????';
      apiResult.codeError = statusCode.connection;
      apiResult.hasError = true;
      print('${e}');
    }
    return apiResult;
  }
}
