import 'dart:async';

import 'serialization_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


final _handledMessageIds = <String?>{};

class PushNotificationsHandler extends StatefulWidget {
  const PushNotificationsHandler({super.key, required this.child});

  final Widget child;

  @override
  _PushNotificationsHandlerState createState() =>
      _PushNotificationsHandlerState();
}

class _PushNotificationsHandlerState extends State<PushNotificationsHandler> {
  bool _loading = false;

  Future handleOpenedPushNotification() async {
    if (isWeb) {
      return;
    }

    final notification = await FirebaseMessaging.instance.getInitialMessage();
    if (notification != null) {
      await _handlePushNotification(notification);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handlePushNotification);
  }

  Future _handlePushNotification(RemoteMessage message) async {
    if (_handledMessageIds.contains(message.messageId)) {
      return;
    }
    _handledMessageIds.add(message.messageId);

    safeSetState(() => _loading = true);
    try {
      final initialPageName = message.data['initialPageName'] as String;
      final initialParameterData = getInitialParameterData(message.data);
      final parametersBuilder = parametersBuilderMap[initialPageName];
      if (parametersBuilder != null) {
        final parameterData = await parametersBuilder(initialParameterData);
        context.pushNamed(
          initialPageName,
          pathParameters: parameterData.pathParameters,
          extra: parameterData.extra,
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      safeSetState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      handleOpenedPushNotification();
    });
  }

  @override
  Widget build(BuildContext context) => _loading
      ? Center(
          child: SizedBox(
            width: 50.0,
            height: 50.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
        )
      : widget.child;
}

class ParameterData {
  const ParameterData(
      {this.requiredParams = const {}, this.allParams = const {}});
  final Map<String, String?> requiredParams;
  final Map<String, dynamic> allParams;

  Map<String, String> get pathParameters => Map.fromEntries(
        requiredParams.entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
  Map<String, dynamic> get extra => Map.fromEntries(
        allParams.entries.where((e) => e.value != null),
      );

  static Future<ParameterData> Function(Map<String, dynamic>) none() =>
      (data) async => const ParameterData();
}

final parametersBuilderMap =
    <String, Future<ParameterData> Function(Map<String, dynamic>)>{
  'HomePage': (data) async => ParameterData(
        allParams: {
          'right': getParameter<String>(data, 'right'),
          'left': getParameter<String>(data, 'left'),
        },
      ),
  'auth_WelcomeScreen': ParameterData.none(),
  'auth_Create': ParameterData.none(),
  'auth_Login': ParameterData.none(),
  'auth_ForgotPassword': ParameterData.none(),
  'timerPage': (data) async => ParameterData(
        allParams: {
          'subNameParameter': getParameter<String>(data, 'subNameParameter'),
          'studiedDetailsParameter':
              getParameter<String>(data, 'studiedDetailsParameter'),
          'indexIDParameter': getParameter<int>(data, 'indexIDParameter'),
        },
      ),
  'backup': ParameterData.none(),
  'userPage': ParameterData.none(),
  'Settings1Notifications': ParameterData.none(),
  'analyticsPage': ParameterData.none(),
  'adminSeatConfigure': ParameterData.none(),
  'adminplannerPage': (data) async => ParameterData(
        allParams: {
          'mmm': getParameter<int>(data, 'mmm'),
        },
      ),
  'adminSeatChange': ParameterData.none(),
  'adminPointConfigurePage': ParameterData.none(),
  'studentAnalytics': ParameterData.none(),
  'setBestColorPage': ParameterData.none(),
  'pageeee': (data) async => ParameterData(
        allParams: {
          'startTime': getParameter<int>(data, 'startTime'),
          'endTime': getParameter<int>(data, 'endTime'),
          'dataForPassSub': getParameter<String>(data, 'dataForPassSub'),
          'dataForPassPlan': getParameter<String>(data, 'dataForPassPlan'),
          'dataForPassColor': getParameter<Color>(data, 'dataForPassColor'),
          'dbExist': getParameter<bool>(data, 'dbExist'),
        },
      ),
  'timerPageCopy': (data) async => ParameterData(
        allParams: {
          'subNameParameter': getParameter<String>(data, 'subNameParameter'),
          'studiedDetailsParameter':
              getParameter<String>(data, 'studiedDetailsParameter'),
          'indexIDParameter': getParameter<int>(data, 'indexIDParameter'),
        },
      ),
  'alertAdmin': (data) async => ParameterData(
        allParams: {
          'num': getParameter<String>(data, 'num'),
          'reason': getParameter<String>(data, 'reason'),
        },
      ),
};

Map<String, dynamic> getInitialParameterData(Map<String, dynamic> data) {
  try {
    final parameterDataStr = data['parameterData'];
    if (parameterDataStr == null ||
        parameterDataStr is! String ||
        parameterDataStr.isEmpty) {
      return {};
    }
    return jsonDecode(parameterDataStr) as Map<String, dynamic>;
  } catch (e) {
    print('Error parsing parameter data: $e');
    return {};
  }
}
