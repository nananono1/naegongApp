// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> setupFirebaseMessagingListener() async {
  // FirebaseMessaging.onMessage.listen을 통해 푸시 알림을 수신 대기
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    try {
      // 알림 데이터 확인 및 처리
      if (message.data.containsKey('latestTeachersQuote') &&
          message.data.containsKey('latestSubmittedDate')) {
        final String? latestTeachersQuote = message.data['latestTeachersQuote'];
        final String? submittedDateStr = message.data['latestSubmittedDate'];

        // 날짜 변환을 시도하고 실패할 경우를 대비해 예외 처리
        if (latestTeachersQuote != null && submittedDateStr != null) {
          try {
            final DateTime latestSubmittedDate =
                DateTime.parse(submittedDateStr);

            // updateAppStateWithLatestData 함수 호출
            await updateAppStateWithLatestData(
                latestTeachersQuote, latestSubmittedDate);
          } catch (e) {
            print('Error parsing submitted date: $e');
          }
        } else {
          print('Missing required notification data.');
        }
      }
    } catch (e) {
      // 알림 수신 또는 처리 중 오류 발생 시 로그 출력
      print('Error handling push notification: $e');
    }
  });
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
