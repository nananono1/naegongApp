import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'pageeee_widget.dart' show PageeeeWidget;
import 'package:flutter/material.dart';

class PageeeeModel extends FlutterFlowModel<PageeeeWidget> {
  ///  Local state fields for this page.

  double? localxStart;

  double? localxEnd;

  double? length0 = 50.0;

  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField34 widget.
  FocusNode? textField34FocusNode;
  TextEditingController? textField34TextController;
  String? Function(BuildContext, String?)? textField34TextControllerValidator;
  // Stores action output result for [Firestore Query - Query a collection] action in cellRow widget.
  PlannerVariableListRecord? loadedInfoCopy;
  // Stores action output result for [Firestore Query - Query a collection] action in cellRow widget.
  PlannerVariableListRecord? loadedInfoCopyCopy;
  DateTime? datePicked;
  // Stores action output result for [Firestore Query - Query a collection] action in Icon widget.
  PlannerVariableListRecord? loadedInfo;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for Slider widget.
  double? sliderValue;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textField34FocusNode?.dispose();
    textField34TextController?.dispose();

    textFieldFocusNode1?.dispose();
    textController2?.dispose();

    textFieldFocusNode2?.dispose();
    textController3?.dispose();
  }
}
