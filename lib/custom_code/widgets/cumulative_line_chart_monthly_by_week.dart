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

import 'package:syncfusion_flutter_charts/charts.dart'; // Syncfusion 차트 패키지
import 'package:intl/intl.dart'; // 날짜 형식 포맷을 위한 패키지

class CumulativeLineChartMonthlyByWeek extends StatefulWidget {
  const CumulativeLineChartMonthlyByWeek({
    super.key,
    this.width,
    this.height,
    required this.insideDBStudent,
  });

  final double? width;
  final double? height;
  final List<PageStateSchemaStruct> insideDBStudent;

  @override
  State<CumulativeLineChartMonthlyByWeek> createState() =>
      _CumulativeLineChartMonthlyByWeekState();
}

class _CumulativeLineChartMonthlyByWeekState
    extends State<CumulativeLineChartMonthlyByWeek> {
  @override
  Widget build(BuildContext context) {
    // 기준일로부터 35일간의 데이터를 필터링
    final DateTime endDate = DateTime.now();
    final DateTime startDate = endDate.subtract(Duration(days: 35));

    // 35일간의 공부 데이터를 필터링
    final filteredData = widget.insideDBStudent.where((pageState) {
      final submittedDate = pageState.submittedDatePlanner;
      return submittedDate != null &&
          submittedDate.isAfter(startDate.subtract(Duration(days: 1))) &&
          submittedDate.isBefore(endDate.add(Duration(days: 1)));
    }).toList();

    // 각 주별로 공부 시간을 누적
    final cumulativeData =
        _calculateCumulativeStudyHoursByWeek(startDate, endDate, filteredData);

    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 400.0,
      child: SfCartesianChart(
        backgroundColor: FlutterFlowTheme.of(context)
            .primaryBackground, // primaryBackground로 수정
        title: ChartTitle(text: 'Cumulative Study Hours (Last 5 Weeks)'),
        legend: Legend(isVisible: true),
        primaryXAxis: CategoryAxis(), // CategoryAxis로 수정
        primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Study Hours')), // y축: 공부 시간 (시간 단위)
        tooltipBehavior: TooltipBehavior(enable: true), // 툴팁 사용 설정
        series: _buildLineSeries(cumulativeData),
      ),
    );
  }

  // 공부 데이터를 처리하여 주별 누적 시간을 계산하는 함수
  List<LineSeries<Map<String, dynamic>, String>> _buildLineSeries(
      Map<String, List<Map<String, dynamic>>> cumulativeData) {
    return cumulativeData.entries.map((entry) {
      return LineSeries<Map<String, dynamic>, String>(
        name: entry.key, // 과목 이름
        dataSource: entry.value, // 주별 누적 데이터
        xValueMapper: (data, _) => data['week'], // x축: 주차
        yValueMapper: (data, _) => data['cumulativeHours'], // y축: 누적 공부 시간
        markerSettings: MarkerSettings(isVisible: true), // 마커 표시
        dataLabelSettings: DataLabelSettings(isVisible: true), // 데이터 라벨 표시
      );
    }).toList();
  }

  // 각 과목별로 주별 공부 시간을 누적하는 함수
  Map<String, List<Map<String, dynamic>>> _calculateCumulativeStudyHoursByWeek(
      DateTime startDate,
      DateTime endDate,
      List<PageStateSchemaStruct> filteredData) {
    Map<String, List<Map<String, dynamic>>> cumulativeData = {};
    Map<String, double> subjectTotalHours = {};

    // 35일을 7일 단위로 나누어 각 주의 시작과 끝을 계산
    final weekRanges = List.generate(5, (i) {
      final startOfWeek = startDate.add(Duration(days: i * 7));
      final endOfWeek = startOfWeek.add(Duration(days: 6));
      return {
        'week': 'Week ${i + 1}',
        'start': startOfWeek,
        'end': endOfWeek,
      };
    });

    // 각 주별로 과목별 공부 시간을 초기화
    for (var weekRange in weekRanges) {
      for (var subjectName in filteredData
          .expand((page) =>
              page.inputListState
                  ?.map((input) => input.subjectNamePlanner)
                  .toSet() ??
              {})
          .toSet()) {
        cumulativeData.putIfAbsent(subjectName ?? "Unknown", () => []);
        cumulativeData[subjectName]!.add({
          'week': weekRange['week'],
          'cumulativeHours': subjectTotalHours[subjectName] ?? 0.0, // 초기값 0
        });
      }
    }

    // 필터된 데이터 기반으로 실제 공부 시간을 누적
    for (var pageState in filteredData) {
      DateTime? submittedDate = pageState.submittedDatePlanner;
      List<PlannerInputStruct> inputList = pageState.inputListState ?? [];

      // 어떤 주에 속하는지 확인하고 해당 주에 공부 시간을 추가
      for (var weekRange in weekRanges) {
        if (submittedDate != null &&
            submittedDate.isAfter(weekRange['start'] as DateTime) &&
            submittedDate.isBefore(weekRange['end'] as DateTime)) {
          String week = weekRange['week'] as String;

          for (var plannerInput in inputList) {
            String subjectName = plannerInput.subjectNamePlanner ?? "Unknown";
            List<DateTime>? startTimes = plannerInput.studyStartTime;
            List<DateTime>? endTimes = plannerInput.studyEndTime;

            if (startTimes != null &&
                endTimes != null &&
                startTimes.isNotEmpty &&
                endTimes.isNotEmpty) {
              double weeklyStudyHours = 0;

              for (int i = 0; i < startTimes.length; i++) {
                final studyStart = startTimes[i];
                final studyEnd = endTimes[i];
                final duration = studyEnd.difference(studyStart).inMinutes /
                    60.0; // 시간을 시간 단위로 계산
                weeklyStudyHours += duration;
              }

              subjectTotalHours[subjectName] =
                  (subjectTotalHours[subjectName] ?? 0) + weeklyStudyHours;

              // 누적 데이터를 저장
              cumulativeData[subjectName]!
                  .removeWhere((data) => data['week'] == week);
              cumulativeData[subjectName]!.add({
                'week': week,
                'cumulativeHours': subjectTotalHours[subjectName],
              });
            }
          }
        }
      }
    }

    return cumulativeData;
  }
}
