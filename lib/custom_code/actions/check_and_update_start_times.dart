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

import '/backend/schema/index.dart'; // PlannerInputStruct와 PageStateSchemaStruct를 가져옵니다.
import 'dart:async'; // 시간 관련 함수 사용
import '/flutter_flow/flutter_flow_util.dart'; // FFAppState를 사용하기 위한 import

Future<void> checkAndUpdateStartTimes() async {
  // FFAppState의 pageStateSchemaVariable을 가져옵니다.
  PageStateSchemaStruct? pageStateSchemaVariable =
      FFAppState().pageStateSchemaVariable;

  // pageStateSchemaVariable이 null일 경우 함수 종료
  if (pageStateSchemaVariable == null) {
    return;
  }

  // inputListState가 설정되지 않았을 경우 처리하지 않고 넘어갑니다.
  if (pageStateSchemaVariable.inputListState == null ||
      pageStateSchemaVariable.inputListState.isEmpty) {
    return;
  }

  // inputListState를 가져옵니다.
  List<PlannerInputStruct> inputListState =
      pageStateSchemaVariable.inputListState;

  // 모든 PlannerInputStruct를 순회합니다.
  for (int i = 0; i < inputListState.length; i++) {
    PlannerInputStruct plannerInput = inputListState[i];

    // studyStartTime과 studyEndTime의 배열을 가져옵니다.
    List<DateTime>? studyStartTime = plannerInput.studyStartTime;
    List<DateTime>? studyEndTime = plannerInput.studyEndTime;

    // studyStartTime 또는 studyEndTime이 null이거나 둘 다 비어있는 경우는 문제 없는 상태로 처리하지 않고 넘어감
    if ((studyStartTime == null && studyEndTime == null) ||
        (studyStartTime?.isEmpty == true && studyEndTime?.isEmpty == true)) {
      continue;
    }

    // studyStartTime이 studyEndTime보다 한 개 더 많으면 추가
    if (studyStartTime != null &&
        studyEndTime != null &&
        studyStartTime.length == studyEndTime.length + 1) {
      DateTime lastStartTime = studyStartTime.last;
      // 1초를 더한 값을 studyEndTime에 추가합니다.
      studyEndTime.add(lastStartTime.add(Duration(seconds: 1)));

      // 업데이트된 PlannerInputStruct를 다시 할당
      plannerInput.studyEndTime = studyEndTime;
    }
  }

  // 변경된 inputListState를 pageStateSchemaVariable에 다시 저장
  pageStateSchemaVariable.inputListState = inputListState;

  // FFAppState를 사용하여 업데이트된 pageStateSchemaVariable을 저장
  FFAppState().pageStateSchemaVariable = pageStateSchemaVariable;
}
