import 'dart:convert';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class GetFromSheetCall {
  static Future<ApiCallResponse> call({
    String? userDisplayName = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getFromSheet',
      apiUrl:
          'https://script.google.com/macros/s/AKfycbz53cCWvgjHBuu-gXXnHiLBYIrri5TLf4LTozyrXPuPen7IucWeeWCgFBOKlqgDL9H8kQ/exec',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'displayName': userDisplayName,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AdasdCall {
  static Future<ApiCallResponse> call({
    String? userDisplayName = '',
    List<String>? monList,
    List<String>? tueList,
    List<String>? wedList,
    List<String>? thuList,
    List<String>? friList,
    List<String>? satList,
    String? updatedDate = '',
  }) async {
    final mon = _serializeList(monList);
    final tue = _serializeList(tueList);
    final wed = _serializeList(wedList);
    final thu = _serializeList(thuList);
    final fri = _serializeList(friList);
    final sat = _serializeList(satList);

    const ffApiRequestBody = '''
{
  "callreason": "<callreason>",
  "calltime": "<calltime>",
  "checked": false,
  "seatno": "<seatno>"
}
''';
    return ApiManager.instance.makeApiCall(
      callName: 'adasd',
      apiUrl:
          'https://naegong-student-qgbwcp-default-rtdb.asia-southeast1.firebasedatabase.app/calls/{spotname}.json',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CallWriteByStudentCall {
  static Future<ApiCallResponse> call({
    String? callreason = '',
    String? calltime = '',
    bool? checked,
    String? seatno = '',
    String? spotname = '',
  }) async {
    final ffApiRequestBody = '''
{
  "callreason": "$callreason",
  "calltime": "$calltime",
  "checked": false,
  "seatno": "$seatno"
}
''';
    return ApiManager.instance.makeApiCall(
      callName: 'callWriteByStudent',
      apiUrl:
          'https://naegong-student-qgbwcp-default-rtdb.asia-southeast1.firebasedatabase.app/calls/$spotname.json',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetmasterReferenceCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'getmasterReference',
      apiUrl:
          'https://naegong-student-qgbwcp-default-rtdb.asia-southeast1.firebasedatabase.app/calls/',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
