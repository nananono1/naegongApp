import '/flutter_flow/flutter_flow_util.dart';
import 'rest_info_fix_widget.dart' show RestInfoFixWidget;
import 'package:flutter/material.dart';

class RestInfoFixModel extends FlutterFlowModel<RestInfoFixWidget> {
  ///  State fields for stateful widgets in this component.

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
