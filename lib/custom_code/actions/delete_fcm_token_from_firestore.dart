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

// 로그아웃 시 FCM 토큰 삭제
Future<void> deleteFcmTokenFromFirestore() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not logged in');
      return;
    }

    // 현재 기기의 FCM 토큰 가져오기
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null) {
      print('FCM 토큰이 없습니다.');
      return;
    }

    // Firestore의 `fcm_tokens` 하위 컬렉션에서 해당 토큰 문서 삭제
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('fcm_tokens')
        .doc(fcmToken)
        .delete();

    print('FCM 토큰 삭제 성공: $fcmToken');
  } catch (e) {
    print('FCM 토큰을 삭제하는 중 오류 발생: $e');
  }
}
