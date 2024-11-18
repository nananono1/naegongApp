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

import 'package:flutter/services.dart';

Future setLandscapeMode() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft, // 장치를 가로 모드로 설정 (왼쪽으로 회전)
    DeviceOrientation.landscapeRight, // 장치를 가로 모드로 설정 (오른쪽으로 회전)
  ]);
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
