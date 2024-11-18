import '/flutter_flow/flutter_flow_util.dart';
import 'student_analytics_widget.dart' show StudentAnalyticsWidget;
import 'package:flutter/material.dart';

class StudentAnalyticsModel extends FlutterFlowModel<StudentAnalyticsWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
