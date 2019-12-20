import 'rxdart_use.dart';
import 'http_response.dart';
import 'package:http/http.dart' as http;
import 'package:http/src/response.dart';
import 'package:rxdart/rxdart.dart';

typedef RxHttpFutureResponse = void Function(RxHttpResponse response);
typedef RxHttpFutureError = void Function(RxHttpResponse error);

class RxHttpTools with RxUse {
  factory RxHttpTools() => _getInstance();

  static RxHttpTools get instance => _getInstance();
  static RxHttpTools _instance;
  Map<String, String> get _defaultRequestHeaders => {"key1": "value1", "key2": "value2", "key3": "value3", "key4": "value4"};

  static RxHttpTools _getInstance() {
    if (_instance == null) {
      _instance = RxHttpTools._insternal();
    }
    return _instance;
  }

  RxHttpTools._insternal() {}

  getHttp(String url,
      {Map<String, String> requestHeaders,
      RxHttpFutureResponse blockResponse,
      RxHttpFutureError blockError}) {
    http.get(url, headers: _getRequestHeaders(requestHeaders)).then((Response value) {
      if (blockResponse != null) {
        blockResponse(RxHttpResponse.success(value));
      }
    }).catchError((error) {
      if (blockError != null) {
        blockError(RxHttpResponse.failure(error));
      }
    });
  }


  postHttp(String url,
      {Map<String, String> requestHeaders,
        RxHttpFutureResponse blockResponse,
        RxHttpFutureError blockError}) {
    http.post(url, headers: _getRequestHeaders(requestHeaders)).then((Response value) {
      if (blockResponse != null) {
        blockResponse(RxHttpResponse.success(value));
      }
    }).catchError((error) {
      if (blockError != null) {
        blockError(RxHttpResponse.failure(error));
      }
    });
  }

  Map<String, String> _getRequestHeaders(Map<String, String> headers) {
    Map<String, String> getRequestHeaders = _defaultRequestHeaders;
    headers.forEach((String key, String value) {
      getRequestHeaders.update(key, (update) {
        return update;
      });
    });
    return getRequestHeaders;
  }
}
