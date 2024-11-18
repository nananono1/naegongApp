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
import 'package:firebase_database/firebase_database.dart';

Future<void> saveAdminFcmToken(String spot) async {
  // FCM 인스턴스 생성
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // FCM 토큰 생성
  String? fcmToken = await messaging.getToken();

  if (fcmToken != null) {
    // Firebase Database에 관리자 FCM 토큰 저장
    DatabaseReference tokenRef =
        FirebaseDatabase.instance.ref('admin_tokens/$spot');
    await tokenRef.update({fcmToken: true}); // 또는 Firestore의 문서 ID로 사용 가능
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
