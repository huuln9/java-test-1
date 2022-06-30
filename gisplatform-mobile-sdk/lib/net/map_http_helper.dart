import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter_vnpt_map/m_config.dart';
import 'package:flutter_vnpt_map/model/base_resp.dart';
import 'package:flutter_vnpt_map/net/map_error_code.dart';
import 'package:flutter_vnpt_map/net/simple_uri.dart';
import 'package:http/http.dart' as http;

class MapHttpHelper {
  /// errorCode
  static const String k_error = 'error';

  /// message
  static const String k_msg = 'msg';

  /// data
  static const String k_result = 'result';

  static const String k_code = 'code';
  static const String k_message = 'message';
  static const String k_data = 'data';

  static BaseResp retSystemError = BaseResp(
    ErrorCode.UNKNOWN,
    null,
    null,
  );

  static Map<String, String> getDefHeaders({
    String accessToken = '',
  }) {
    return {
      'Authorization': accessToken,
      'Content-Type': 'application/json',
      'type': '1',
    };
  }

  /// Invokes an `http` request given.
  /// [url] can either be a `string` or a `Uri`.
  /// The [type] can be any of the [RequestType]s.
  /// [body] and [encoding] only apply to [RequestType.post] and [RequestType.put] requests. Otherwise,
  /// they have no effect.
  /// This is optimized for requests that anticipate a response body of type `BaseResp`, as in a json file-type response.
  static Future<BaseResp> invokeHttp(
    String url,
    RequestType type, {
    Map<String, String>? headers,
    dynamic body,
    Encoding? encoding,
  }) async {
    if (MConfig.showLog) {
      print('URL:: $type - ' + url);
    }
    http.Response response;
    try {
      response = await _invoke(
        Uri.parse(url),
        type,
        headers: headers ?? getDefHeaders(),
        body: body,
        encoding: encoding,
      );
    } catch (error) {
      rethrow;
    }
    return await _handleResponse(
      response,
    );
  }

  /// Invoke the `http` request, returning the [http.Response] unparsed.
  static Future<http.Response> _invoke(
    Uri url,
    RequestType type, {
    Map<String, String>? headers,
    dynamic body,
    Encoding? encoding,
  }) async {
    http.Response response;
    if (MConfig.showLog) {
      print('BODY:: ' + body.toString());
    }
    try {
      switch (type) {
        case RequestType.get:
          response = await http.get(
            url,
            headers: headers,
          );
          break;
        case RequestType.post:
          response = await http.post(
            url,
            headers: headers,
            body: json.encode(body),
            encoding: encoding,
          );

          break;
        case RequestType.put:
          response = await http.put(
            url,
            headers: headers,
            body: json.encode(body),
            encoding: encoding,
          );

          break;
        case RequestType.delete:
          response = await http.delete(
            url,
            headers: headers,
          );
          break;
      }

      return response;
    } on http.ClientException {
      // handle any 404's
      rethrow;

      // handle no internet connection
    } on SocketException catch (e) {
      throw Exception(e.osError?.message);
    } catch (error) {
      rethrow;
    }
  }

  static Future<BaseResp> onGetWithBody(
    String endpoint,
    Map<String, dynamic>? body, {
    Map<String, String>? headers,
  }) async {
    if (MConfig.showLog) {
      print('=== GetWithBody:: $endpoint');
      print('=== Data:: $body');
    }

    final Uri uri = SimplifiedUri.uri(
      endpoint,
      body,
    );

    var response = await http.get(
      uri,
      headers: headers ?? getDefHeaders(),
    );
    String output = response.body;

    if (output.isEmpty) {
      return retSystemError;
    }
    return _retBaseResp(
      json.decode(
        output.toString(),
      ),
    );
  }

  static Future<BaseResp> _handleResponse(
    http.Response response,
  ) async {
    try {
      return _retBaseResp(
        _decodeData(response),
      );
    } catch (e) {
      return retSystemError;
    }
  }

  static BaseResp _retBaseResp(
    Map<String, dynamic> _dataMap,
  ) {
    int error;
    String msg;
    dynamic result;
    error = _dataMap.containsKey(
      k_error,
    )
        ? _dataMap[k_error]
        : _dataMap[k_code];
    msg = _dataMap.containsKey(
      k_msg,
    )
        ? _dataMap[k_msg]
        : _dataMap[k_message];
    result = _dataMap.containsKey(
      k_result,
    )
        ? _dataMap[k_result]
        : _dataMap[k_data];

    if (MConfig.showLog) {
      // print('=== Response::');
      print('=== Result:: $result');
      // print('=== Raw:: $_dataMap');
    }
    return BaseResp(
      error,
      msg,
      result,
    );
  }

  static Map<String, dynamic> _decodeData(http.Response? response) {
    if (response == null || response.body.toString().isEmpty) {
      return Map();
    }
    if (MConfig.showLog) {
      // print(
      //   'RAW_DATA:: ' + response.body.toString(),
      // );
    }
    try {
      return json.decode(
        utf8convert(
          response.body.toString(),
        ),
      );
    } catch (_) {
      return json.decode(
        response.body.toString(),
      );
    }
  }

  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }
}

enum RequestType {
  get,
  post,
  put,
  delete,
}
