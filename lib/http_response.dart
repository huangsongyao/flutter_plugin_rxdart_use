import 'dart:convert';
import 'package:http/src/response.dart';

const int RxHttpResponseFailureDefaultHashCode = -991;

class RxHttpResponse {

  Response response;
  Error error;
  int get httpStatus => _statusCode();

  RxHttpResponse({this.response, this.error});
  factory RxHttpResponse.success(Response response) => RxHttpResponse(response: response);
  factory RxHttpResponse.failure(Error error) => RxHttpResponse(error: error);

  String toFailureString() {
    if (this.error == null) {
      return "this.error is null";
    }
    return this.error.toString();
  }

  int toFailureCode() {
    if (this.error == null) {
      return RxHttpResponseFailureDefaultHashCode;
    }
    return this.error.hashCode;
  }

  int _statusCode() {
    if (this.response == null) {
      return RxHttpResponseFailureDefaultHashCode;
    }
    return this.response.statusCode;
  }

  Map<String, String> toRequestHeaders() {
    if (this.response == null) {
      return {};
    }
    return this.response.headers;
  }

  Map<String, dynamic> toResponseJsonDecode() {
    if (this.response == null) {
      return {};
    }
    Map<String, dynamic> json = JsonDecoder().convert(this.response.body);
    return json;
  }

}