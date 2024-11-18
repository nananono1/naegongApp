import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'adminplanner_page_widget.dart' show AdminplannerPageWidget;
import 'package:flutter/material.dart';

class AdminplannerPageModel extends FlutterFlowModel<AdminplannerPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - checkUserClaims] action in adminplannerPage widget.
  String? checkUserClaimAction;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // Stores action output result for [Firestore Query - Query a collection] action in Icon widget.
  List<PlannerVariableListRecord>? bb;
  DateTime? datePicked;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
