import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/auth/firebase_auth/auth_util.dart';

double calculatePlannerCellHeight(
  int startTime,
  int endTime,
) {
  // 앱 상태에서 PlannerStartTime과 PlannerEndTime 값을 가져옵니다.

  double calculateHeight = (515 / (endTime - startTime + 1));
  return calculateHeight;
}

DateTime subtractminusoneday(DateTime plannerDateSelected) {
  DateTime newDate = plannerDateSelected.subtract(Duration(days: 1));

  // 새로 계산된 날짜를 반환합니다.
  return newDate;
}

int? removeLastDigit(int? insertedPin) {
  if (insertedPin == null) {
    return null;
  }

  // insertedPin이 1자리 수 이하인 경우 null 반환 (숫자가 더 없을 때)
  if (insertedPin.toString().length <= 1) {
    return null;
  }

  // insertedPin에서 마지막 자리를 제거
  String pinString = insertedPin.toString();
  String updatedPinString = pinString.substring(0, pinString.length - 1);

  // 제거한 후 다시 int로 변환하여 반환
  return int.parse(updatedPinString);
}

Color getCellColor(
  DateTime cellTime,
  List<DateTime>? startTimes,
  List<DateTime>? endTimes,
  List<Color>? pickedColors,
) {
  // Null 체크와 리스트 길이 검증을 통해 안전하게 기본 색상 반환
  if (startTimes == null || endTimes == null || pickedColors == null) {
    return Color(0xFFF5F5F5); // null 값이 있는 경우 기본 색상 반환
  }

  // 각 시간 범위 내에 셀 시간이 속하는지 확인하고 색상을 반환합니다.
  for (int i = 0; i < startTimes.length; i++) {
    if (isWithinTimeRange(cellTime, startTimes[i], endTimes[i])) {
      return pickedColors[i]; // 범위 내에 있으면 지정된 색상 반환
    }
  }

  return Color(0xFFF5F5F5); // 모든 범위 밖이면 기본 색상 반환
}

/// 시간 범위 내에 있는지 확인하는 헬퍼 함수
bool isWithinTimeRange(
    DateTime cellTime, DateTime startTime, DateTime endTime) {
  // 날짜는 배제하고 시간만을 비교하기 위해 TimeOfDay로 변환
  TimeOfDay cellTimeOfDay = TimeOfDay.fromDateTime(cellTime);
  TimeOfDay startTimeOfDay = TimeOfDay.fromDateTime(startTime);
  TimeOfDay endTimeOfDay = TimeOfDay.fromDateTime(endTime);

  // 셀 시간이 시작 시간과 같거나 이후이고, 종료 시간과 같거나 이전인 경우 true 반환
  return (isSameOrAfter(cellTimeOfDay, startTimeOfDay) &&
      isSameOrBefore(cellTimeOfDay, endTimeOfDay));
}

/// TimeOfDay 객체의 시간이 같거나 이후인지 확인하는 함수
bool isSameOrAfter(TimeOfDay t1, TimeOfDay t2) {
  return t1.hour > t2.hour || (t1.hour == t2.hour && t1.minute >= t2.minute);
}

/// TimeOfDay 객체의 시간이 같거나 이전인지 확인하는 함수
bool isSameOrBefore(TimeOfDay t1, TimeOfDay t2) {
  return t1.hour < t2.hour || (t1.hour == t2.hour && t1.minute <= t2.minute);
}

List<String> calculateStudyTimeList2(
  List<DateTime> studyStartTimes,
  List<DateTime> studyEndTimes,
) {
  List<String> studyDurations = [];

  // 종료 시간이 시작 시간보다 길면 종료 시간 리스트를 시작 시간 길이에 맞춤 (뒤에서부터 제거)
  if (studyEndTimes.length > studyStartTimes.length) {
    studyEndTimes = studyEndTimes.sublist(
        0, studyStartTimes.length); // 길이를 맞추기 위해 뒤에서부터 잘라냄
  }

  // 반대로 시작 시간이 종료 시간보다 길면, 시작 시간 리스트를 종료 시간에 맞춤 (뒤에서부터 제거)
  if (studyStartTimes.length > studyEndTimes.length) {
    studyStartTimes = studyStartTimes.sublist(
        0, studyEndTimes.length); // 길이를 맞추기 위해 뒤에서부터 잘라냄
  }

  // 각 공부 시간에 대한 계산을 수행
  for (int i = 0; i < studyStartTimes.length; i++) {
    Duration totalDuration = studyEndTimes[i].difference(studyStartTimes[i]);

    int hours = totalDuration.inHours;
    int minutes = totalDuration.inMinutes.remainder(60);
    int seconds = totalDuration.inSeconds.remainder(60);

    studyDurations.add(
      '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
    );
  }

  return studyDurations;
}

String? sumTimeValues(List<String>? timeStrings) {
  if (timeStrings == null || timeStrings.isEmpty) {
    return "00:00"; // 빈 리스트 또는 null일 경우 기본값 반환
  }

  int totalMinutes = 0;

  // 각 시간 문자열을 반복 처리
  for (String time in timeStrings) {
    // ':' 문자로 시간을 분리하여 시간과 분을 추출
    List<String> parts = time.split(':');
    if (parts.length != 2) {
      continue; // 형식이 잘못된 경우 건너뜁니다.
    }

    // 시간과 분을 정수로 변환
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    // 총 분 계산
    totalMinutes += (hours * 60) + minutes;
  }

  // 총 분을 다시 시간과 분으로 변환
  int totalHours = totalMinutes ~/ 60;
  int remainingMinutes = totalMinutes % 60;

  // 결과를 "HH:mm" 형식으로 반환
  return '${totalHours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}';
}

String? calculateTotalStudyDuration(List<PlannerInputStruct>? inputList) {
  if (inputList == null || inputList.isEmpty) {
    return '00:00';
  }

  // 총 시간을 저장할 Duration 객체를 초기화합니다.
  Duration totalDuration = Duration();

  // 각 inputList 요소를 순회하며 시간을 계산합니다.
  for (var item in inputList) {
    // 시작 시간과 종료 시간을 리스트로 가져옵니다.
    List<DateTime>? startTimes = item.studyStartTime; // 변경된 부분
    List<DateTime>? endTimes = item.studyEndTime; // 변경된 부분

    // 시작 시간과 종료 시간이 null이 아닌 경우에만 계산합니다.
    if (startTimes != null && endTimes != null) {
      for (int i = 0; i < startTimes.length; i++) {
        DateTime startTime = startTimes[i];
        DateTime endTime = (i < endTimes.length) ? endTimes[i] : DateTime.now();

        // 종료 시간에서 시작 시간을 빼서 해당 세션의 지속 시간을 계산합니다.
        Duration duration = endTime.difference(startTime);

        // 계산된 지속 시간을 총 지속 시간에 더합니다.
        totalDuration += duration;
      }
    }
  }

  // 총 지속 시간을 시간과 분으로 변환합니다.
  int hours = totalDuration.inHours;
  int minutes = totalDuration.inMinutes % 60;

  // 포맷된 문자열로 총 지속 시간을 반환합니다.
  return '${hours.toString().padLeft(2, '0')}시간 ${minutes.toString().padLeft(2, '0')}분';
}

String? calculateStudyTimeForSingleInput(
  DocumentReference userDocRef,
  DocumentReference plannerVariableListDocRef,
  int index,
) {
  // Firestore에서 문서 데이터 가져오기
  plannerVariableListDocRef.get().then((snapshot) {
    if (snapshot.exists) {
      // inputList 필드 가져오기
      List<dynamic> inputListData = snapshot.get('inputList');

      // 인덱스 범위 확인 후 특정 PlannerInputStruct 데이터 가져오기
      if (index < inputListData.length) {
        Map<String, dynamic> data = inputListData[index];

        // PlannerInputStruct로 데이터 변환
        PlannerInputStruct item = PlannerInputStruct(
          studyStartTime: (data['studyStartTime'] as List<dynamic>?)
              ?.map((timestamp) => (timestamp as Timestamp).toDate())
              .toList(),
          studyEndTime: (data['studyEndTime'] as List<dynamic>?)
              ?.map((timestamp) => (timestamp as Timestamp).toDate())
              .toList(),
          isFinish: data['isFinish'] as bool? ?? false,
        );

        // 총 학습 시간을 저장할 Duration 객체 초기화
        Duration totalDuration = Duration();

        // studyStartTime과 studyEndTime 리스트에서 개별 학습 시간 계산
        if (item.studyStartTime != null && item.studyEndTime != null) {
          for (int i = 0; i < item.studyStartTime!.length; i++) {
            DateTime startTime = item.studyStartTime![i];
            DateTime endTime = (i < item.studyEndTime!.length)
                ? item.studyEndTime![i]
                : DateTime.now();

            // 종료 시간에서 시작 시간을 빼서 해당 세션의 지속 시간을 계산
            Duration duration = endTime.difference(startTime);

            // 계산된 지속 시간을 총 지속 시간에 더합니다.
            totalDuration += duration;
          }

          // 총 지속 시간을 시간과 분으로 변환하여 문자열로 반환
          int hours = totalDuration.inHours;
          int minutes = totalDuration.inMinutes % 60;
          return '${hours.toString().padLeft(2, '0')}시간 ${minutes.toString().padLeft(2, '0')}분';
        } else {
          return '00시간 00분';
        }
      } else {
        print('Index out of bounds: $index');
        return 'Invalid Index';
      }
    } else {
      print('Document does not exist');
      return 'Document does not exist';
    }
  }).catchError((e) {
    print('Error fetching study time: $e');
    return null;
  });
}

String calculateTotalStudyTime(
    List<PlannerInputStruct>? inputListStateForTotal) {
  int totalMinutes = 0;

  // Null 체크 및 오류 처리
  if (inputListStateForTotal == null) {
    return "00시간 00분";
  }

  try {
    // 각 공부 세션의 시간을 순회하며 계산
    for (var item in inputListStateForTotal) {
      if (item.studyStartTime != null && item.studyEndTime != null) {
        for (int i = 0; i < item.studyStartTime!.length; i++) {
          totalMinutes += item.studyEndTime![i]
              .difference(item.studyStartTime![i])
              .inMinutes;
        }
      }
    }
  } catch (e) {
    // 오류 발생 시 00시간 00분 반환
    return "00시간 00분";
  }

  // 시간과 분으로 변환
  int hours = totalMinutes ~/ 60;
  int minutes = totalMinutes % 60;

  // "hh시간 mm분" 형식의 문자열로 반환
  return "${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m";
}

String calculateStudyTime(
  List<DateTime> studyStartTimes,
  List<DateTime> studyEndTimes,
) {
  Duration totalDuration = Duration();

  for (int i = 0; i < studyStartTimes.length; i++) {
    totalDuration += studyEndTimes[i].difference(studyStartTimes[i]);
  }

  int hours = totalDuration.inHours;
  int minutes = totalDuration.inMinutes.remainder(60);
  int seconds = totalDuration.inSeconds.remainder(60);

  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

Color getCellColorFromInputListState(
  String cellName,
  List<PlannerInputStruct>? inputListState,
) {
  // 기본 색상 설정
  Color defaultColor = Color(0xFFFFFFFF);
  ;

  // Null 체크
  if (inputListState == null) {
    return defaultColor;
  }

  // 셀 이름에서 rowHour와 cellIndex 추출
  int rowHour = int.parse(cellName.substring(4, 6));
  int cellIndex = int.parse(cellName.substring(6, 7)) - 1;

  // 셀의 시작 시간과 종료 시간 계산
  DateTime cellStartTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    rowHour,
    cellIndex * 10,
  );
  DateTime cellEndTime = cellStartTime.add(Duration(minutes: 10));

  // 각 10분 셀의 전체 시간 범위에 대해 최소 5분 이상이 공부 시간에 포함되는지 확인
  Color cellColor = defaultColor;

  for (var item in inputListState) {
    if (item.studyStartTime != null && item.studyEndTime != null) {
      for (int j = 0; j < item.studyStartTime!.length; j++) {
        DateTime startTime = item.studyStartTime![j];
        DateTime endTime = item.studyEndTime![j];

        // 겹치는 시간 계산
        DateTime overlapStart =
            startTime.isAfter(cellStartTime) ? startTime : cellStartTime;
        DateTime overlapEnd =
            endTime.isBefore(cellEndTime) ? endTime : cellEndTime;

        // 겹치는 시간이 5분 이상인지 확인
        if (overlapEnd.difference(overlapStart).inMinutes >= 5) {
          cellColor = item.pickedColor ?? defaultColor;
          break;
        }
      }
    }
  }

  return cellColor;
}

List<String> getStudySessionsForSubject(
  int? index,
  List<PlannerInputStruct>? inputListState,
) {
  // 결과를 저장할 리스트 초기화
  List<String> studySessions = [];

  // Null 체크 및 인덱스 범위 체크
  if (inputListState == null ||
      index == null ||
      index < 0 ||
      index >= inputListState.length) {
    return ["공부를 시작합시다!"];
  }

  // 선택된 과목의 공부 시간 리스트 가져오기
  PlannerInputStruct selectedSubject = inputListState[index];
  List<DateTime>? startTimes = selectedSubject.studyStartTime;
  List<DateTime>? endTimes = selectedSubject.studyEndTime;

  // Null 체크
  if (startTimes == null ||
      endTimes == null ||
      startTimes.isEmpty ||
      endTimes.isEmpty) {
    return ["공부를 시작합시다!"];
  }

  try {
    for (int i = 0; i < startTimes.length; i++) {
      DateTime startTime = startTimes[i];
      DateTime endTime = endTimes[i];

      // 공부 시간 계산
      int sessionMinutes = endTime.difference(startTime).inMinutes;
      int hours = sessionMinutes ~/ 60;
      int minutes = sessionMinutes % 60;

      // "시작시간 ~ 종료시간, hh시간 mm분" 형식으로 결과 리스트에 추가
      String formattedSession =
          "${startTime.hour.toString().padLeft(2, '0')}시 ${startTime.minute.toString().padLeft(2, '0')}분 ~ "
          "${endTime.hour.toString().padLeft(2, '0')}시 ${endTime.minute.toString().padLeft(2, '0')}분, "
          "${hours.toString().padLeft(2, '0')}시간 ${minutes.toString().padLeft(2, '0')}분";
      studySessions.add(formattedSession);
    }
  } catch (e) {
    return ["공부를 시작합시다!"];
  }

  return studySessions;
}

DateTime addoneday(DateTime plannerDateSelected) {
  DateTime newDate = plannerDateSelected.add(Duration(days: 1));

  // 새로 계산된 날짜를 반환합니다.
  return newDate;
}

int getIndexFunction(
  List<PageStateSchemaStruct> dBList,
  DateTime plannerDateSelected,
) {
  // 조건을 만족하는 첫 번째 항목의 인덱스를 찾습니다.
  int index = dBList.indexWhere(
      (element) => element.submittedDatePlanner == plannerDateSelected);

  return index; // 일치하는 항목이 없으면 -1이 반환됩니다.
}

String convertToImagePath(String? imageUrl) {
  // 이미지 URL이 비어있지 않다면 해당 경로 반환
  if (imageUrl != null && imageUrl.isNotEmpty) {
    return imageUrl; // 네트워크 경로를 반환
  } else {
    // 기본 이미지 경로 반환 (경로가 없을 경우 대비)
    return 'https://default-image-url.com/default.jpg'; // 기본 이미지 경로
  }
}

DateTime getDateAtMidnight(DateTime currentTime) {
// 입력받은 시간에서 시간을 없애고 해당 날짜의 자정(12:00 AM)으로 설정
  return DateTime(
      currentTime.year, currentTime.month, currentTime.day, 0, 0, 0);
}

bool isSubjectInList(
  String? inputText,
  List<FixSubjectColorStruct>? subjectColorList,
) {
  if (inputText == null || subjectColorList == null) {
    return false;
  }

  // subjectColorList에서 subjectToFix 필드를 가진 항목을 순회하며 inputText와 비교
  for (var item in subjectColorList) {
    if (item.subjectToFix == inputText) {
      return true; // 입력값과 일치하는 값이 있으면 true 반환
    }
  }

  return false; // 일치하는 값이 없으면 false 반환
}

int? getSubjectIndex(
  String inputText,
  List<FixSubjectColorStruct> subjectColorList,
) {
  for (int i = 0; i < subjectColorList.length; i++) {
    if (subjectColorList[i].subjectToFix == inputText) {
      return i; // 입력값과 일치하는 값이 있으면 해당 index 반환
    }
  }

  return -1; // 일치하는 값이 없으면 -1 반환
}

List<DailyInfoEachStruct>? makeDailyList(
    PageStateSchemaStruct? todayStudyInfo) {
  // 먼저 null 체크를 통해 입력된 값이 유효한지 확인합니다.
  if (todayStudyInfo == null || todayStudyInfo.inputListState == null) {
    return null;
  }

  // 결과를 저장할 리스트를 생성합니다.
  List<DailyInfoEachStruct> dailyList = [];

  // 모든 PlannerInputStruct 항목을 순회합니다.
  for (PlannerInputStruct input in todayStudyInfo.inputListState!) {
    if (input.studyStartTime == null ||
        input.studyEndTime == null ||
        input.studyStartTime!.length != input.studyEndTime!.length) {
      continue; // 시작 시간과 종료 시간이 없거나 일치하지 않으면 건너뜁니다.
    }

    // 각 PlannerInputStruct에서 start와 end를 순회하며 DailyInfoEachStruct를 생성합니다.
    for (int i = 0; i < input.studyStartTime!.length; i++) {
      DateTime? startTime = input.studyStartTime![i];
      DateTime? endTime = input.studyEndTime![i];

      // DailyInfoEachStruct를 생성하여 리스트에 추가합니다.
      dailyList.add(DailyInfoEachStruct(
        starttime: startTime,
        endtime: endTime,
        colorPicked: input.pickedColor,
        subject: input.subjectNamePlanner,
        details: input.whatIDid, // whatIDid 필드를 details로 매핑
      ));
    }
  }

  // starttime을 기준으로 오름차순 정렬합니다.
  dailyList.sort((a, b) => a.starttime!.compareTo(b.starttime!));

  return dailyList;
}

String calculateDday(DateTime targetDate) {
  DateTime now = DateTime.now(); // 현재 날짜를 가져옵니다.
  Duration difference = targetDate.difference(now);

  // 차이를 일(day) 단위로 변환합니다.
  int dayDifference = difference.inDays;

  // D-day 형식으로 반환합니다.
  if (dayDifference > 0) {
    return 'D-${dayDifference}'; // 목표일이 미래일 때
  } else if (dayDifference == 0) {
    return 'D-Day'; // 목표일이 오늘일 때
  } else {
    return 'D+${-dayDifference}'; // 목표일이 과거일 때
  }
}

int? appendPin(
  int? insertedPin,
  int? numbertopush,
) {
  if (insertedPin == null) {
    return numbertopush;
  }

  // insertedPin에 numbertopush를 뒤에 추가한 값을 만듦
  int combinedPin = int.parse(insertedPin.toString() + numbertopush.toString());

  // 반환되는 값의 자릿수가 최대 6자리를 넘지 않도록 처리
  if (combinedPin.toString().length > 6) {
    return int.parse(combinedPin.toString().substring(0, 6));
  }

  // 6자리 이하일 경우 그대로 반환
  return combinedPin;
}

String formatDateString(String dateString) {
  // 주어진 문자열에서 날짜 부분만 추출 (첫 번째 '.' 기준으로 나눈 후 처리)
  List<String> dateParts = dateString.split(' ');

  // 연, 월, 일을 추출 (연월일 부분은 첫 번째와 두 번째, 세 번째 요소에 있음)
  String year = dateParts[0].replaceAll('.', '').trim(); // 2024
  String month = dateParts[1].replaceAll('.', '').trim(); // 10
  String day = dateParts[2].replaceAll('.', '').trim(); // 14

  // 새로운 포맷으로 반환 (2024/10/14)
  return "$year/$month/$day";
}

String formatDateTimeWithDay(DateTime dateTime) {
  // List of days in Korean
  List<String> daysOfWeek = ['일', '월', '화', '수', '목', '금', '토'];

  // Get the day of the week (0 for Sunday, 1 for Monday, etc.)
  String dayOfWeek = daysOfWeek[dateTime.weekday % 7];

  // Format the date as MM/dd and append the day of the week
  String formattedDate = '${dateTime.month}/${dateTime.day}($dayOfWeek)';

  return formattedDate;
}

List<PageStateSchemaStruct>? fromFirebaseToSchema(
    List<PlannerVariableListRecord>? inputList) {
  if (inputList == null) {
    return null;
  }

  return inputList.map((plannerRecord) {
    // `PageStateSchemaStruct`를 생성하여 `PlannerVariableListRecord`의 필드 값을 매핑합니다.
    return PageStateSchemaStruct(
      inputListState: plannerRecord.inputList, // PlannerInput 타입 리스트로 매핑
      submittedDatePlanner: plannerRecord.submittedDate,
      goodThingsPlanner: plannerRecord.goodThings,
      imporovementState: plannerRecord.improvement,
      archivePercentState: plannerRecord.achivementPercentage,
      teacherquoteState: plannerRecord.teachersQuote,
      isSubmittedPara: plannerRecord.plannerSubmitted,
      userName: "", // userName은 별도로 추가 데이터가 필요할 수 있습니다.
      adminCheckedPara: plannerRecord.adminChecked,
      dailyStartPara: plannerRecord.dailyStarting,
      basicInfoState: plannerRecord.basicInfo,
    );
  }).toList();
}

double returnDistanceBetweenTwoPoints(
  LatLng? positionOne,
  LatLng? positionTwo,
) {
  // null 체크
  if (positionOne == null || positionTwo == null) {
    return 0.0;
  }

  // 두 지점 사이의 거리를 계산하는 함수 (하버사인 공식 사용)
  var p = 0.017453292519943295; // π / 180
  var a = 0.5 -
      math.cos((positionTwo.latitude - positionOne.latitude) * p) / 2 +
      math.cos(positionOne.latitude * p) *
          math.cos(positionTwo.latitude * p) *
          (1 - math.cos((positionTwo.longitude - positionOne.longitude) * p)) /
          2;
  double result = 12742 * math.asin(math.sqrt(a)); // 지구 반지름 * 계산된 각도

  // 결과 반환
  return result;
}

DocumentReference convertStringToUserReference(String userId) {
  // 'users'는 Firestore 컬렉션 이름
  return FirebaseFirestore.instance.collection('users').doc(userId);
}
