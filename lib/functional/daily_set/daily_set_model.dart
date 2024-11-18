import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'daily_set_widget.dart' show DailySetWidget;
import 'package:flutter/material.dart';

class DailySetModel extends FlutterFlowModel<DailySetWidget> {
  ///  Local state fields for this component.

  PageStateSchemaStruct? addingPlannerInfo;
  void updateAddingPlannerInfoStruct(Function(PageStateSchemaStruct) updateFn) {
    updateFn(addingPlannerInfo ??= PageStateSchemaStruct());
  }

  Color? colorToSet = const Color(0xff7fb3d5);

  ///  State fields for stateful widgets in this component.

  DateTime? datePicked1;
  DateTime? datePicked2;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
