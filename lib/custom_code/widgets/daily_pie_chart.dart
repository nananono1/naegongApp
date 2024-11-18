// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:syncfusion_flutter_charts/charts.dart'; // Syncfusion 파이 차트 패키지
import '/flutter_flow/flutter_flow_theme.dart'; // FlutterFlow 테마

class DailyPieChart extends StatefulWidget {
  const DailyPieChart({
    super.key,
    this.width,
    this.height,
    required this.pageStateSchema,
  });

  final double? width;
  final double? height;
  final PageStateSchemaStruct pageStateSchema;

  @override
  State<DailyPieChart> createState() => _DailyPieChartState();
}

class _DailyPieChartState extends State<DailyPieChart> {
  @override
  Widget build(BuildContext context) {
    // 각 과목별로 총 공부 시간을 계산하고 퍼센티지로 변환
    final studyData = _calculateStudyPercentages(widget.pageStateSchema);

    return Align(
      alignment: Alignment(0.0, -0.9), // Y축 기준 위쪽으로 배치
      child: Container(
        width: widget.width ?? 260, // 차트 너비 설정
        height: widget.height ?? 260, // 차트 높이 설정
        decoration: BoxDecoration(
          color: Colors.transparent, // 상위 컨테이너 배경을 투명으로 설정
          borderRadius: BorderRadius.circular(30), // 모서리를 둥글게 설정
        ),
        child: SfCircularChart(
          legend: Legend(isVisible: true), // 범례 표시 유지
          backgroundColor: Colors.transparent, // 차트 배경 투명하게 설정
          series: <CircularSeries>[
            // 파이 차트 데이터 설정
            PieSeries<Map<String, dynamic>, String>(
              dataSource: studyData,
              xValueMapper: (data, _) => data['subjectName'], // 과목 이름
              yValueMapper: (data, _) => data['percentage'], // 퍼센티지로 변환된 공부 시간
              pointColorMapper: (data, _) => data['pickedColor'], // 각 과목별 색상 설정
              radius: '90%', // 차트의 비율 설정
              dataLabelSettings: DataLabelSettings(
                isVisible: true, // 데이터 라벨 표시
                labelPosition: ChartDataLabelPosition.inside, // 라벨을 차트 바깥으로 설정
                textStyle: TextStyle(
                  color: Colors.black, // 라벨 텍스트 색상을 흰색으로 설정
                  fontSize: 12, // 라벨 텍스트 크기
                ),
              ),
              enableTooltip: true, // 툴팁 유지
              dataLabelMapper: (data, _) => data['subjectName'], // 과목명만 표시
            ),
          ],
        ),
      ),
    );
  }

  // 각 과목의 총 공부 시간을 퍼센티지로 변환하는 함수
  List<Map<String, dynamic>> _calculateStudyPercentages(
      PageStateSchemaStruct pageStateSchema) {
    Map<String, double> subjectTimeMap = {};
    Map<String, Color> subjectColorMap = {}; // 각 과목의 색상 저장
    double totalStudyTime = 0.0;

    // plannerInput 리스트를 처리하는 부분
    for (var plannerInput in pageStateSchema.inputListState) {
      String subjectName =
          plannerInput.subjectNamePlanner ?? "Unknown"; // 과목 이름
      List<DateTime>? startTimeList =
          plannerInput.studyStartTime ?? []; // 시작 시간 리스트
      List<DateTime>? endTimeList =
          plannerInput.studyEndTime ?? []; // 종료 시간 리스트

      // 과목의 색상은 처음 등장한 plannerInput의 pickedColor로 설정
      if (!subjectColorMap.containsKey(subjectName)) {
        subjectColorMap[subjectName] = plannerInput.pickedColor ?? Colors.grey;
      }

      // 시작 시간과 종료 시간이 제대로 있는 경우에만 계산
      if (startTimeList.isNotEmpty && endTimeList.isNotEmpty) {
        for (int i = 0; i < startTimeList.length; i++) {
          DateTime startTime = startTimeList[i];
          DateTime endTime = endTimeList[i];

          // inSeconds로 차이를 계산 (초 단위로)
          double studySeconds =
              endTime.difference(startTime).inSeconds.toDouble(); // 공부 시간 계산

          // 과목별로 공부 시간을 누적 (동일한 과목이 여러 번 나올 수 있음)
          if (subjectTimeMap.containsKey(subjectName)) {
            subjectTimeMap[subjectName] =
                subjectTimeMap[subjectName]! + studySeconds;
          } else {
            subjectTimeMap[subjectName] = studySeconds;
          }

          totalStudyTime += studySeconds; // 전체 공부 시간 누적
        }
      }
    }

    // 과목별 공부 시간을 퍼센티지로 변환하여 리스트로 반환
    return subjectTimeMap.entries.map((entry) {
      double percentage = (entry.value / totalStudyTime) * 100;

      return {
        'subjectName': entry.key,
        'percentage': percentage, // 퍼센티지 값
        'pickedColor': subjectColorMap[entry.key], // 과목의 색상
      };
    }).toList();
  }
}
