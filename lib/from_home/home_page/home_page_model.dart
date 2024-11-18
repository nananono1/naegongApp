import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  String? left = 'dd';

  String right = 'adf';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - fetchNotificationRemoteConfig] action in HomePage widget.
  List<NotificationRemoteConfigEachStruct>? notificationload;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Stores action output result for [Custom Action - checkUserClaims] action in Button widget.
  String? userClaims;
  // Stores action output result for [Backend Call - API (callWriteByStudent)] action in Image widget.
  ApiCallResponse? apiResultrxr;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
