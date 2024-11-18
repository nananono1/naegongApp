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

import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import 추가

Future endStudyTime(
    String userId2, // 사용자 문서의 ID
    String plannerVariableListId2, // plannerVariableList 문서의 ID
    int indexID22, // 업데이트할 리스트 항목의 인덱스
    bool isPause // pause 또는 resume 여부
    ) async {
  // Firestore 인스턴스 생성
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // 현재 시간 가져오기
    DateTime currentTime = DateTime.now();

    // Firestore 트랜잭션 사용하여 배열의 특정 인덱스 업데이트
    await firestore.runTransaction((transaction) async {
      // 특정 사용자 문서의 plannerVariableList 문서 참조 가져오기
      DocumentReference<Map<String, dynamic>> docRef = firestore
          .collection('users') // 사용자 컬렉션
          .doc(userId2) // 특정 사용자 문서
          .collection('plannerVariableList') // 하위 컬렉션
          .doc(plannerVariableListId2); // plannerVariableList 문서

      // 문서 스냅샷 가져오기
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await transaction.get(docRef);

      // inputList를 List 타입으로 가져오기
      List<dynamic> inputList = List.from(snapshot.get('inputList'));

      // 인덱스 범위 확인 후 studyStartTimes 및 studyEndTimes 업데이트
      if (indexID22 < inputList.length) {
        // 리스트에서 해당 인덱스의 item을 수정하여 studyStartTimes 및 studyEndTimes 필드 업데이트
        Map<String, dynamic> updatedItem =
            Map<String, dynamic>.from(inputList[indexID22]);

        // studyStartTimes 및 studyEndTimes 리스트 가져오기
        List<dynamic> studyStartTimes =
            List.from(updatedItem['studyStartTimes'] ?? []);
        List<dynamic> studyEndTimes =
            List.from(updatedItem['studyEndTimes'] ?? []);

        if (isPause) {
          // pause일 경우, 현재 시간을 studyEndTimes에 추가
          studyEndTimes.add(currentTime);
          // isFinish 필드를 true로 설정
          updatedItem['isFinish'] = true;
        } else {
          // resume일 경우, 현재 시간을 studyStartTimes에 추가
          studyStartTimes.add(currentTime);
        }

        // 업데이트한 아이템을 리스트에 다시 반영
        updatedItem['studyStartTimes'] = studyStartTimes;
        updatedItem['studyEndTimes'] = studyEndTimes;
        inputList[indexID22] = updatedItem;

        // Firestore 문서 업데이트
        transaction.update(docRef, {'inputList': inputList});
      } else {
        print('Index out of bounds: $indexID22');
      }
    });

    print('study time updated successfully.');
  } catch (e) {
    // 오류 발생 시 메시지 출력
    print('Error updating study time: $e');
  }
}
