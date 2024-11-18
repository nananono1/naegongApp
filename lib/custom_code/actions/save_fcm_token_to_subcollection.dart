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

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info_plus/device_info_plus.dart';

// 로그인 후에 호출되는 함수
Future<void> saveFcmTokenToSubcollection() async {
  try {
    // Firebase 초기화
    await Firebase.initializeApp();

    // 로그인된 사용자 가져오기
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not logged in');
      return;
    }

    // FCM 토큰 발급
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null) {
      print('FCM 토큰이 생성되지 않았습니다.');
      return;
    }

    // 기기 정보 가져오기
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String platform;

    if (await deviceInfo.androidInfo != null) {
      platform = "Android";
    } else if (await deviceInfo.iosInfo != null) {
      platform = "iOS";
    } else if (await deviceInfo.webBrowserInfo != null) {
      platform = "Web";
    } else {
      print('Unsupported platform');
      return;
    }

    // Firestore의 서브컬렉션에 FCM 토큰을 중복 없이 저장
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('fcm_tokens')
        .doc(fcmToken) // FCM 토큰을 문서 ID로 사용하여 중복 방지
        .set({
      'device_type': platform,
      'created_at': FieldValue.serverTimestamp(),
    });

    print('FCM 토큰 저장 성공: $fcmToken');
  } catch (e) {
    print('FCM 토큰을 저장하는 중 오류 발생: $e');
  }
}
