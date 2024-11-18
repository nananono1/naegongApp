import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/temporary_lock_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/functional/daily_set/daily_set_widget.dart';
import '/functional/planner_fix/planner_fix_widget.dart';
import '/functional/planner_inut_set_copy/planner_inut_set_copy_widget.dart';
import '/functional/planner_time_option_bottom_sheet/planner_time_option_bottom_sheet_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pageeee_model.dart';
export 'pageeee_model.dart';

class PageeeeWidget extends StatefulWidget {
  const PageeeeWidget({
    super.key,
    int? startTime,
    int? endTime,
    this.dataForPassSub,
    this.dataForPassPlan,
    this.dataForPassColor,
    this.timeToSum,
    this.passToAddSchema,
    bool? dbExist,
  })  : startTime = startTime ?? 9,
        endTime = endTime ?? 23,
        dbExist = dbExist ?? false;

  final int startTime;
  final int endTime;
  final String? dataForPassSub;
  final String? dataForPassPlan;
  final Color? dataForPassColor;
  final List<String>? timeToSum;
  final PageStateSchemaStruct? passToAddSchema;
  final bool dbExist;

  @override
  State<PageeeeWidget> createState() => _PageeeeWidgetState();
}

class _PageeeeWidgetState extends State<PageeeeWidget> {
  late PageeeeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageeeeModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (currentUserReference == null) {
        context.pushNamed('auth_WelcomeScreen');

        FFAppState().deleteInsideDBStudent();
        FFAppState().insideDBStudent = [];

        FFAppState().deletePageStateSchemaVariable();
        FFAppState().pageStateSchemaVariable = PageStateSchemaStruct();

        FFAppState().deleteChangeChecker();
        FFAppState().changeChecker = PageStateSchemaStruct();

        FFAppState().currentIndexIDParameter = 0;
        FFAppState().deleteDDayAppState();
        FFAppState().dDayAppState = [];

        FFAppState().update(() {});
      } else {
        if (valueOrDefault(currentUserDocument?.seatNo, 0) >= 1) {
          if (FFAppState().plannerDateSelected == null) {
            FFAppState().plannerDateSelected =
                functions.getDateAtMidnight(getCurrentTimestamp);
            safeSetState(() {});
          }
          await actions.checkAndUpdateStartTimes();
        } else {
          if (valueOrDefault<bool>(currentUserDocument?.seatRequest, false) ==
              true) {
            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: const Text('승인 대기'),
                  content: const Text('관리자 승인을 대기해주세요'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(alertDialogContext),
                      child: const Text('Ok'),
                    ),
                  ],
                );
              },
            );
          } else {
            var confirmDialogResponse = await showDialog<bool>(
                  context: context,
                  builder: (alertDialogContext) {
                    return AlertDialog(
                      title: const Text('승인대기'),
                      content: const Text('관리자에게 좌석승인을 요청하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(alertDialogContext, false),
                          child: const Text('아니오'),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(alertDialogContext, true),
                          child: const Text('예'),
                        ),
                      ],
                    );
                  },
                ) ??
                false;
            if (confirmDialogResponse) {
              await currentUserReference!.update(createUsersRecordData(
                seatRequest: true,
              ));
              await showDialog(
                context: context,
                builder: (alertDialogContext) {
                  return AlertDialog(
                    content: const Text('승인 요청되었습니다!'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(alertDialogContext),
                        child: const Text('Ok'),
                      ),
                    ],
                  );
                },
              );
            }
          }

          context.pushNamed('HomePage');
        }
      }
    });

    _model.textField34TextController ??= TextEditingController();
    _model.textField34FocusNode ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return StreamBuilder<List<PlannerVariableListRecord>>(
      stream: queryPlannerVariableListRecord(
        parent: currentUserReference,
        queryBuilder: (plannerVariableListRecord) =>
            plannerVariableListRecord.where(
          'submittedDate',
          isEqualTo: FFAppState().plannerDateSelected,
        ),
        singleRecord: true,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        List<PlannerVariableListRecord> pageeeePlannerVariableListRecordList =
            snapshot.data!;
        final pageeeePlannerVariableListRecord =
            pageeeePlannerVariableListRecordList.isNotEmpty
                ? pageeeePlannerVariableListRecordList.first
                : null;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            floatingActionButton: Visibility(
              visible: !valueOrDefault<bool>(
                pageeeePlannerVariableListRecord?.plannerSubmitted,
                false,
              ),
              child: Align(
                alignment: const AlignmentDirectional(1.0, 1.0),
                child: Builder(
                  builder: (context) => FloatingActionButton(
                    onPressed: () async {
                      if ((FFAppState()
                                  .pageStateSchemaVariable
                                  .dailyStartPara
                                  .sleepTime ==
                              null) &&
                          ((FFAppState()
                                      .pageStateSchemaVariable
                                      .dailyStartPara
                                      .getupTime ==
                                  null) &&
                              (FFAppState()
                                          .pageStateSchemaVariable
                                          .dailyStartPara
                                          .goalTime ==
                                      ''))) {
                        await showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return Dialog(
                              elevation: 0,
                              insetPadding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              alignment: const AlignmentDirectional(0.0, 0.0)
                                  .resolve(Directionality.of(context)),
                              child: GestureDetector(
                                onTap: () =>
                                    FocusScope.of(dialogContext).unfocus(),
                                child: const SizedBox(
                                  height: 500.0,
                                  width: 500.0,
                                  child: DailySetWidget(),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        await showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return Dialog(
                              elevation: 0,
                              insetPadding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              alignment: const AlignmentDirectional(0.0, 0.0)
                                  .resolve(Directionality.of(context)),
                              child: GestureDetector(
                                onTap: () =>
                                    FocusScope.of(dialogContext).unfocus(),
                                child: SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.5,
                                  width: MediaQuery.sizeOf(context).width * 0.5,
                                  child: const PlannerInutSetCopyWidget(),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                    backgroundColor: const Color(0xFF2100FF),
                    elevation: 5.0,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 24.0,
                    ),
                  ),
                ),
              ),
            ),
            drawer: SizedBox(
              width: 500.0,
              child: Drawer(
                elevation: 16.0,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: 500.0,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F4F8),
                          borderRadius: BorderRadius.circular(0.0),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/JPG.jpg',
                                        width: 100.0,
                                        height: 100.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          30.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        FFLocalizations.of(context).getText(
                                          '5qnipkbt' /* 내공에듀센터 */,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .override(
                                              fontFamily: 'Ubuntu',
                                              color: const Color(0xFF15161E),
                                              fontSize: 24.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w800,
                                              useGoogleFonts:
                                                  GoogleFonts.asMap()
                                                      .containsKey('Ubuntu'),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 12.0,
                                thickness: 2.0,
                                color: Color(0xFFE5E7EB),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          16.0, 12.0, 0.0, 0.0),
                                      child: Text(
                                        FFLocalizations.of(context).getText(
                                          '4t3g5d59' /* Platform Navigation */,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Plus Jakarta Sans',
                                              color: const Color(0xFF606A85),
                                              fontSize: 20.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              useGoogleFonts:
                                                  GoogleFonts.asMap()
                                                      .containsKey(
                                                          'Plus Jakarta Sans'),
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed('HomePage');
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          curve: Curves.easeInOut,
                                          width: double.infinity,
                                          height: 60.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF1F4F8),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    8.0, 0.0, 6.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Icon(
                                                    Icons.home,
                                                    color: Color(0xFF15161E),
                                                    size: 50.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.0, 0.0, 0.0, 0.0),
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'xo08j24a' /* 메인메뉴 */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Plus Jakarta Sans',
                                                          color:
                                                              const Color(0xFF15161E),
                                                          fontSize: 30.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          useGoogleFonts:
                                                              GoogleFonts
                                                                      .asMap()
                                                                  .containsKey(
                                                                      'Plus Jakarta Sans'),
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed('pageeee');
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          curve: Curves.easeInOut,
                                          width: double.infinity,
                                          height: 60.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEDDABB),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    8.0, 0.0, 6.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    const Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Icon(
                                                        Icons.menu_book,
                                                        color:
                                                            Color(0xFF15161E),
                                                        size: 55.0,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        FFLocalizations.of(
                                                                context)
                                                            .getText(
                                                          '1dl3o6ls' /* 플래너확인 */,
                                                        ),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Plus Jakarta Sans',
                                                              color: const Color(
                                                                  0xFF15161E),
                                                              fontSize: 30.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              useGoogleFonts: GoogleFonts
                                                                      .asMap()
                                                                  .containsKey(
                                                                      'Plus Jakarta Sans'),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        curve: Curves.easeInOut,
                                        width: double.infinity,
                                        height: 60.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F4F8),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 0.0, 6.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              const Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Icon(
                                                  Icons.space_dashboard_rounded,
                                                  color: Color(0xFF15161E),
                                                  size: 50.0,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        12.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    'wcgnbbjx' /* 시간표 관리 */,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Plus Jakarta Sans',
                                                        color:
                                                            const Color(0xFF15161E),
                                                        fontSize: 30.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                'Plus Jakarta Sans'),
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed('studentAnalytics');
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          curve: Curves.easeInOut,
                                          width: double.infinity,
                                          height: 60.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF1F4F8),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    8.0, 0.0, 6.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Icon(
                                                    Icons.pie_chart_rounded,
                                                    color: Color(0xFF15161E),
                                                    size: 50.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.0, 0.0, 0.0, 0.0),
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'xkumutni' /* 공부시간분석 */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Plus Jakarta Sans',
                                                          color:
                                                              const Color(0xFF15161E),
                                                          fontSize: 30.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          useGoogleFonts:
                                                              GoogleFonts
                                                                      .asMap()
                                                                  .containsKey(
                                                                      'Plus Jakarta Sans'),
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          16.0, 20.0, 0.0, 0.0),
                                      child: Text(
                                        FFLocalizations.of(context).getText(
                                          'pmetb3iw' /* Settings */,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Plus Jakarta Sans',
                                              color: const Color(0xFF606A85),
                                              fontSize: 20.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              useGoogleFonts:
                                                  GoogleFonts.asMap()
                                                      .containsKey(
                                                          'Plus Jakarta Sans'),
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed('userPage');
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          curve: Curves.easeInOut,
                                          width: double.infinity,
                                          height: 60.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF1F4F8),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    8.0, 0.0, 6.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Icon(
                                                  Icons.person,
                                                  color: Color(0xFF15161E),
                                                  size: 50.0,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.0, 0.0, 0.0, 0.0),
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'zgmkf3a2' /* 개인설정 */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Plus Jakarta Sans',
                                                          color:
                                                              const Color(0xFF15161E),
                                                          fontSize: 30.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          useGoogleFonts:
                                                              GoogleFonts
                                                                      .asMap()
                                                                  .containsKey(
                                                                      'Plus Jakarta Sans'),
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ].divide(const SizedBox(height: 18.0)),
                                ),
                              ),
                              const Divider(
                                height: 12.0,
                                thickness: 2.0,
                                color: Color(0xFFE5E7EB),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 12.0, 16.0, 12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AuthUserStreamWidget(
                                              builder: (context) => Text(
                                                currentUserDisplayName,
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyLarge
                                                    .override(
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      color: const Color(0xFF15161E),
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      useGoogleFonts: GoogleFonts
                                                              .asMap()
                                                          .containsKey(
                                                              'Plus Jakarta Sans'),
                                                    ),
                                              ),
                                            ),
                                            AuthUserStreamWidget(
                                              builder: (context) => Text(
                                                valueOrDefault(
                                                    currentUserDocument?.spot,
                                                    ''),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      color: const Color(0xFF606A85),
                                                      fontSize: 14.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      useGoogleFonts: GoogleFonts
                                                              .asMap()
                                                          .containsKey(
                                                              'Plus Jakarta Sans'),
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 10.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Align(
                                      alignment: const AlignmentDirectional(0.0, 0.0),
                                      child: Builder(
                                        builder: (context) => Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 10.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (dialogContext) {
                                                  return Dialog(
                                                    elevation: 0,
                                                    insetPadding:
                                                        EdgeInsets.zero,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    alignment:
                                                        const AlignmentDirectional(
                                                                0.0, 0.0)
                                                            .resolve(
                                                                Directionality.of(
                                                                    context)),
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          FocusScope.of(
                                                                  dialogContext)
                                                              .unfocus(),
                                                      child: const SizedBox(
                                                        height: double.infinity,
                                                        width: double.infinity,
                                                        child:
                                                            TemporaryLockWidget(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: FaIcon(
                                              FontAwesomeIcons.lock,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 40.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: SafeArea(
              top: true,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 20.0),
                      child: GestureDetector(
                        onVerticalDragEnd: (details) async {
                          scaffoldKey.currentState!.openDrawer();
                        },
                        child: Container(
                          width: 100.0,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment: const AlignmentDirectional(-1.0, 0.0),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          15.0, 15.0, 0.0, 0.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          scaffoldKey.currentState!
                                              .openDrawer();
                                        },
                                        child: Icon(
                                          Icons.menu,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 50.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(flex: 2),
                              Expanded(
                                flex: 45,
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10.0, 0.0, 0.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 5.0, 0.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 209.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 4.0,
                                                  color: Color(0x33000000),
                                                  offset: Offset(
                                                    0.0,
                                                    2.0,
                                                  ),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                width: 2.0,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          1.0, -1.0),
                                                  child: Builder(
                                                    builder: (context) =>
                                                        Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  10.0,
                                                                  10.0,
                                                                  0.0),
                                                      child: InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          await showDialog(
                                                            context: context,
                                                            builder:
                                                                (dialogContext) {
                                                              return Dialog(
                                                                elevation: 0,
                                                                insetPadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                alignment: const AlignmentDirectional(
                                                                        0.0,
                                                                        0.0)
                                                                    .resolve(
                                                                        Directionality.of(
                                                                            context)),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () =>
                                                                      FocusScope.of(
                                                                              dialogContext)
                                                                          .unfocus(),
                                                                  child:
                                                                      const SizedBox(
                                                                    height:
                                                                        500.0,
                                                                    width:
                                                                        500.0,
                                                                    child:
                                                                        DailySetWidget(),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Icon(
                                                          Icons.settings_sharp,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          size: 22.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          20.0, 0.0, 20.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          RichText(
                                                            textScaler:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .textScaler,
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: FFLocalizations.of(
                                                                          context)
                                                                      .getText(
                                                                    '7mbntnn0' /* 수면시간 :  */,
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                      ),
                                                                ),
                                                                TextSpan(
                                                                  text: valueOrDefault<
                                                                      String>(
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .dailyStartPara
                                                                        .sleepTime
                                                                        ?.toString(),
                                                                    '23:30',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        useGoogleFonts:
                                                                            GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                      ),
                                                                )
                                                              ],
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          RichText(
                                                            textScaler:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .textScaler,
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: FFLocalizations.of(
                                                                          context)
                                                                      .getText(
                                                                    'tngtwzm4' /* 기상시간 :  */,
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                      ),
                                                                ),
                                                                TextSpan(
                                                                  text: valueOrDefault<
                                                                      String>(
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .dailyStartPara
                                                                        .getupTime
                                                                        ?.toString(),
                                                                    '08:30',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        useGoogleFonts:
                                                                            GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                      ),
                                                                )
                                                              ],
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          RichText(
                                                            textScaler:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .textScaler,
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: FFLocalizations.of(
                                                                          context)
                                                                      .getText(
                                                                    '074bs2m3' /* 목표공부시간 :  */,
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                      ),
                                                                ),
                                                                TextSpan(
                                                                  text: valueOrDefault<
                                                                      String>(
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .dailyStartPara
                                                                        .goalTime,
                                                                    '10시간 30분',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        useGoogleFonts:
                                                                            GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                      ),
                                                                )
                                                              ],
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          RichText(
                                                            textScaler:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .textScaler,
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: FFLocalizations.of(
                                                                          context)
                                                                      .getText(
                                                                    't4167kpj' /* 현재공부시간 :  */,
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                      ),
                                                                ),
                                                                TextSpan(
                                                                  text: valueOrDefault<
                                                                      String>(
                                                                    functions.calculateTotalStudyTime(FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                    '0h 0m',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        useGoogleFonts:
                                                                            GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                      ),
                                                                )
                                                              ],
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Align(
                                                        alignment:
                                                            const AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            RichText(
                                                              textScaler:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .textScaler,
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: FFLocalizations.of(
                                                                            context)
                                                                        .getText(
                                                                      'dpz3fo5y' /* 오늘의 한마디 : */,
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                        ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: FFLocalizations.of(
                                                                            context)
                                                                        .getText(
                                                                      'nvya9jrv' /*  */,
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          useGoogleFonts:
                                                                              GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                        ),
                                                                  )
                                                                ],
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts: GoogleFonts
                                                                              .asMap()
                                                                          .containsKey(
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                    ),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  const AlignmentDirectional(
                                                                      -1.0,
                                                                      0.0),
                                                              child: SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                child:
                                                                    TextFormField(
                                                                  controller: _model
                                                                      .textField34TextController,
                                                                  focusNode: _model
                                                                      .textField34FocusNode,
                                                                  autofocus:
                                                                      false,
                                                                  obscureText:
                                                                      false,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    isDense:
                                                                        true,
                                                                    labelStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).labelMediumFamily,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                                                                        ),
                                                                    hintText: FFLocalizations.of(
                                                                            context)
                                                                        .getText(
                                                                      '02xp35km' /* 오늘의 다짐, 고민거리, 건의사항등
하고싶은 말을 자유... */
                                                                      ,
                                                                    ),
                                                                    hintStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).labelMediumFamily,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                                                                        ),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Color(
                                                                            0x00000000),
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Color(
                                                                            0x00000000),
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    errorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    focusedErrorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                    filled:
                                                                        true,
                                                                    fillColor: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryBackground,
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        useGoogleFonts:
                                                                            GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                      ),
                                                                  maxLines: 4,
                                                                  cursorColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                  validator: _model
                                                                      .textField34TextControllerValidator
                                                                      .asValidator(
                                                                          context),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ].divide(
                                                        const SizedBox(height: 10.0)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 5.0, 0.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 260.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 4.0,
                                                  color: Color(0x33000000),
                                                  offset: Offset(
                                                    0.0,
                                                    2.0,
                                                  ),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                width: 2.0,
                                              ),
                                            ),
                                            alignment:
                                                const AlignmentDirectional(0.0, 0.0),
                                            child: Align(
                                              alignment: const AlignmentDirectional(
                                                  -1.0, 0.0),
                                              child: Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 5.0, 10.0, 5.0),
                                                child: Container(
                                                  decoration: const BoxDecoration(),
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    child: custom_widgets
                                                        .DailyPieChart(
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      pageStateSchema: FFAppState()
                                                          .pageStateSchemaVariable,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 5.0, 0.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 260.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 4.0,
                                                  color: Color(0x33000000),
                                                  offset: Offset(
                                                    0.0,
                                                    2.0,
                                                  ),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                width: 2.0,
                                              ),
                                            ),
                                            child: Align(
                                              alignment: const AlignmentDirectional(
                                                  -1.0, 0.0),
                                              child: Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 5.0, 10.0, 5.0),
                                                child: Container(
                                                  decoration: const BoxDecoration(),
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    child: custom_widgets
                                                        .StudyGaugeChart(
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      targetStudyTime:
                                                          valueOrDefault<
                                                              String>(
                                                        FFAppState()
                                                            .pageStateSchemaVariable
                                                            .dailyStartPara
                                                            .goalTime,
                                                        '12h 00m',
                                                      ),
                                                      pageStateSchema: FFAppState()
                                                          .pageStateSchemaVariable,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ].divide(const SizedBox(height: 15.0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      width: 100.0,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      child: Align(
                        alignment: const AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              15.0, 0.0, 30.0, 0.0),
                          child: SingleChildScrollView(
                            primary: false,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 10.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: 100.0,
                                          height: 65.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            boxShadow: const [
                                              BoxShadow(
                                                blurRadius: 4.0,
                                                color: Color(0x33000000),
                                                offset: Offset(
                                                  0.0,
                                                  2.0,
                                                ),
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                            ),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    20.0, 0.0, 20.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AuthUserStreamWidget(
                                                  builder: (context) => Text(
                                                    currentUserDisplayName,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          fontSize: 20.0,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily),
                                                        ),
                                                  ),
                                                ),
                                                Text(
                                                  valueOrDefault<String>(
                                                    dateTimeFormat(
                                                      "yyyy\'년 \'M\'월 \'d\'일\'",
                                                      FFAppState()
                                                          .plannerDateSelected,
                                                      locale:
                                                          FFLocalizations.of(
                                                                  context)
                                                              .languageCode,
                                                    ),
                                                    '오늘의 날짜를 선택하세요',
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        fontSize: 30.0,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily),
                                                      ),
                                                ),
                                                Text(
                                                  functions.calculateTotalStudyTime(
                                                      FFAppState()
                                                          .pageStateSchemaVariable
                                                          .inputListState
                                                          .toList()),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        fontSize: 20.0,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily),
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 15.0, 0.0, 20.0),
                                  child: GestureDetector(
                                    onVerticalDragEnd: (details) async {
                                      _model.localxEnd =
                                          details.localPosition.dx;
                                      safeSetState(() {});
                                      if ((FFAppConstants.C200 <=
                                              ((_model.localxStart!) -
                                                  (_model.localxEnd!))) ||
                                          (FFAppConstants.C200 <=
                                              ((_model.localxEnd!) -
                                                  (_model.localxStart!)))) {
                                        if (_model.length0! <
                                            ((_model.localxStart!) -
                                                (_model.localxEnd!))) {
                                          FFAppState()
                                              .updatePageStateSchemaVariableStruct(
                                            (e) => e
                                              ..goodThingsPlanner =
                                                  _model.textController2.text
                                              ..imporovementState =
                                                  _model.textController3.text
                                              ..archivePercentState =
                                                  _model.sliderValue
                                              ..submittedDatePlanner =
                                                  FFAppState()
                                                      .plannerDateSelected
                                              ..dailyStartPara =
                                                  DailyStartingStruct(
                                                commentOfDay: _model
                                                    .textField34TextController
                                                    .text,
                                                sleepTime: FFAppState()
                                                    .pageStateSchemaVariable
                                                    .dailyStartPara
                                                    .sleepTime,
                                                getupTime: FFAppState()
                                                    .pageStateSchemaVariable
                                                    .dailyStartPara
                                                    .getupTime,
                                                goalTime: FFAppState()
                                                    .pageStateSchemaVariable
                                                    .dailyStartPara
                                                    .goalTime,
                                              ),
                                          );
                                          FFAppState().update(() {});
                                          if ((FFAppState()
                                                      .insideDBStudent
                                                      .where((e) =>
                                                          e.submittedDatePlanner ==
                                                          FFAppState()
                                                              .plannerDateSelected)
                                                      .toList().isNotEmpty) &&
                                              (valueOrDefault<bool>(
                                                    FFAppState()
                                                            .pageStateSchemaVariable
                                                            .inputListState.isNotEmpty,
                                                    false,
                                                  ) ||
                                                  valueOrDefault<bool>(
                                                    FFAppState()
                                                                .pageStateSchemaVariable
                                                                .goodThingsPlanner !=
                                                            '',
                                                    false,
                                                  ) ||
                                                  valueOrDefault<bool>(
                                                    FFAppState()
                                                                .pageStateSchemaVariable
                                                                .imporovementState !=
                                                            '',
                                                    false,
                                                  ))) {
                                            FFAppState()
                                                .updateInsideDBStudentAtIndex(
                                              functions.getIndexFunction(
                                                  FFAppState()
                                                      .insideDBStudent
                                                      .toList(),
                                                  FFAppState()
                                                      .plannerDateSelected!),
                                              (_) => FFAppState()
                                                  .pageStateSchemaVariable,
                                            );
                                            FFAppState().update(() {});
                                          } else {
                                            if (valueOrDefault<bool>(
                                                  FFAppState()
                                                          .pageStateSchemaVariable
                                                          .inputListState.isNotEmpty,
                                                  false,
                                                ) ||
                                                valueOrDefault<bool>(
                                                  FFAppState()
                                                              .pageStateSchemaVariable
                                                              .goodThingsPlanner !=
                                                          '',
                                                  false,
                                                ) ||
                                                valueOrDefault<bool>(
                                                  FFAppState()
                                                              .pageStateSchemaVariable
                                                              .imporovementState !=
                                                          '',
                                                  false,
                                                )) {
                                              FFAppState().addToInsideDBStudent(
                                                  FFAppState()
                                                      .pageStateSchemaVariable);
                                              FFAppState().update(() {});
                                            }
                                          }

                                          if (valueOrDefault<bool>(
                                                FFAppState()
                                                        .pageStateSchemaVariable
                                                        .inputListState.isNotEmpty,
                                                false,
                                              ) ||
                                              valueOrDefault<bool>(
                                                FFAppState()
                                                            .pageStateSchemaVariable
                                                            .goodThingsPlanner !=
                                                        '',
                                                false,
                                              ) ||
                                              valueOrDefault<bool>(
                                                FFAppState()
                                                            .pageStateSchemaVariable
                                                            .imporovementState !=
                                                        '',
                                                false,
                                              )) {
                                            if (_model.loadedInfo != null) {
                                              await _model.loadedInfo!.reference
                                                  .update({
                                                ...createPlannerVariableListRecordData(
                                                  goodThings: FFAppState()
                                                      .pageStateSchemaVariable
                                                      .goodThingsPlanner,
                                                  improvement: FFAppState()
                                                      .pageStateSchemaVariable
                                                      .imporovementState,
                                                  achivementPercentage:
                                                      FFAppState()
                                                          .pageStateSchemaVariable
                                                          .archivePercentState,
                                                  dailyStarting:
                                                      updateDailyStartingStruct(
                                                    FFAppState()
                                                        .pageStateSchemaVariable
                                                        .dailyStartPara,
                                                    clearUnsetFields: false,
                                                  ),
                                                ),
                                                ...mapToFirestore(
                                                  {
                                                    'inputList':
                                                        getPlannerInputListFirestoreData(
                                                      FFAppState()
                                                          .pageStateSchemaVariable
                                                          .inputListState,
                                                    ),
                                                  },
                                                ),
                                              });
                                            } else {
                                              await PlannerVariableListRecord
                                                      .createDoc(
                                                          currentUserReference!)
                                                  .set({
                                                ...createPlannerVariableListRecordData(
                                                  adminChecked: false,
                                                  goodThings: FFAppState()
                                                      .pageStateSchemaVariable
                                                      .goodThingsPlanner,
                                                  improvement: FFAppState()
                                                      .pageStateSchemaVariable
                                                      .imporovementState,
                                                  achivementPercentage:
                                                      valueOrDefault<double>(
                                                    FFAppState()
                                                        .pageStateSchemaVariable
                                                        .archivePercentState,
                                                    0.0,
                                                  ),
                                                  submittedDate: FFAppState()
                                                      .plannerDateSelected,
                                                  plannerSubmitted: false,
                                                  basicInfo:
                                                      updateBasicUserInfoStruct(
                                                    BasicUserInfoStruct(
                                                      uid: currentUserReference
                                                          ?.id,
                                                      userName:
                                                          currentUserDisplayName,
                                                      userSeatNo: valueOrDefault(
                                                          currentUserDocument
                                                              ?.seatNo,
                                                          0),
                                                    ),
                                                    clearUnsetFields: false,
                                                    create: true,
                                                  ),
                                                  dailyStarting:
                                                      updateDailyStartingStruct(
                                                    FFAppState()
                                                        .pageStateSchemaVariable
                                                        .dailyStartPara,
                                                    clearUnsetFields: false,
                                                    create: true,
                                                  ),
                                                ),
                                                ...mapToFirestore(
                                                  {
                                                    'inputList':
                                                        getPlannerInputListFirestoreData(
                                                      FFAppState()
                                                          .pageStateSchemaVariable
                                                          .inputListState,
                                                    ),
                                                  },
                                                ),
                                              });
                                            }
                                          }
                                          FFAppState().plannerDateSelected =
                                              functions.addoneday(FFAppState()
                                                  .plannerDateSelected!);
                                          FFAppState().update(() {});
                                          _model.loadedInfoCopy =
                                              await queryPlannerVariableListRecordOnce(
                                            parent: currentUserReference,
                                            queryBuilder:
                                                (plannerVariableListRecord) =>
                                                    plannerVariableListRecord
                                                        .where(
                                              'submittedDate',
                                              isEqualTo: FFAppState()
                                                  .plannerDateSelected,
                                            ),
                                            singleRecord: true,
                                          ).then((s) => s.firstOrNull);
                                          if (_model.loadedInfoCopy != null) {
                                            FFAppState()
                                                    .pageStateSchemaVariable =
                                                PageStateSchemaStruct(
                                              inputListState: _model
                                                  .loadedInfoCopy?.inputList,
                                              submittedDatePlanner: _model
                                                  .loadedInfoCopy
                                                  ?.submittedDate,
                                              goodThingsPlanner: _model
                                                  .loadedInfoCopy?.goodThings,
                                              imporovementState: _model
                                                  .loadedInfoCopy?.improvement,
                                              archivePercentState: _model
                                                  .loadedInfoCopy
                                                  ?.achivementPercentage,
                                              teacherquoteState: _model
                                                  .loadedInfoCopy
                                                  ?.teachersQuote,
                                              isSubmittedPara: _model
                                                  .loadedInfoCopy
                                                  ?.plannerSubmitted,
                                              adminCheckedPara: _model
                                                  .loadedInfoCopy?.adminChecked,
                                              dailyStartPara: _model
                                                  .loadedInfoCopy
                                                  ?.dailyStarting,
                                            );
                                            FFAppState().update(() {});
                                            safeSetState(() {
                                              _model.textField34TextController
                                                  ?.clear();
                                              _model.textController3?.clear();
                                              _model.textController2?.clear();
                                            });
                                            await Future.wait([
                                              Future(() async {
                                                safeSetState(() {
                                                  _model.textController2?.text =
                                                      FFAppState()
                                                          .pageStateSchemaVariable
                                                          .goodThingsPlanner;
                                                  _model.textFieldFocusNode1
                                                      ?.requestFocus();
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    _model.textController2
                                                            ?.selection =
                                                        TextSelection.collapsed(
                                                      offset: _model
                                                          .textController2!
                                                          .text
                                                          .length,
                                                    );
                                                  });
                                                });
                                              }),
                                              Future(() async {
                                                safeSetState(() {
                                                  _model.textController3?.text =
                                                      FFAppState()
                                                          .pageStateSchemaVariable
                                                          .imporovementState;
                                                  _model.textFieldFocusNode2
                                                      ?.requestFocus();
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    _model.textController3
                                                            ?.selection =
                                                        TextSelection.collapsed(
                                                      offset: _model
                                                          .textController3!
                                                          .text
                                                          .length,
                                                    );
                                                  });
                                                });
                                              }),
                                              Future(() async {
                                                safeSetState(() {
                                                  _model.sliderValue =
                                                      FFAppState()
                                                          .pageStateSchemaVariable
                                                          .archivePercentState;
                                                });
                                              }),
                                              Future(() async {
                                                safeSetState(() {
                                                  _model.textField34TextController
                                                          ?.text =
                                                      FFAppState()
                                                          .pageStateSchemaVariable
                                                          .dailyStartPara
                                                          .commentOfDay;
                                                  _model.textField34FocusNode
                                                      ?.requestFocus();
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    _model.textField34TextController
                                                            ?.selection =
                                                        TextSelection.collapsed(
                                                      offset: _model
                                                          .textField34TextController!
                                                          .text
                                                          .length,
                                                    );
                                                  });
                                                });
                                              }),
                                            ]);
                                          } else {
                                            FFAppState()
                                                .deletePageStateSchemaVariable();
                                            FFAppState()
                                                    .pageStateSchemaVariable =
                                                PageStateSchemaStruct();

                                            FFAppState().update(() {});
                                            safeSetState(() {
                                              _model.textField34TextController
                                                  ?.clear();
                                              _model.textController3?.clear();
                                              _model.textController2?.clear();
                                            });
                                            safeSetState(() {
                                              _model.sliderValue = 0.0;
                                            });
                                          }

                                          FFAppState().changeChecker =
                                              FFAppState()
                                                  .pageStateSchemaVariable;
                                          FFAppState().update(() {});
                                        } else {
                                          FFAppState()
                                              .updatePageStateSchemaVariableStruct(
                                            (e) => e
                                              ..goodThingsPlanner =
                                                  _model.textController2.text
                                              ..imporovementState =
                                                  _model.textController3.text
                                              ..archivePercentState =
                                                  _model.sliderValue
                                              ..submittedDatePlanner =
                                                  FFAppState()
                                                      .plannerDateSelected
                                              ..dailyStartPara =
                                                  DailyStartingStruct(
                                                commentOfDay: _model
                                                    .textField34TextController
                                                    .text,
                                                sleepTime: FFAppState()
                                                    .pageStateSchemaVariable
                                                    .dailyStartPara
                                                    .sleepTime,
                                                getupTime: FFAppState()
                                                    .pageStateSchemaVariable
                                                    .dailyStartPara
                                                    .getupTime,
                                                goalTime: FFAppState()
                                                    .pageStateSchemaVariable
                                                    .dailyStartPara
                                                    .goalTime,
                                              ),
                                          );
                                          FFAppState().update(() {});
                                          if ((FFAppState()
                                                      .insideDBStudent
                                                      .where((e) =>
                                                          e.submittedDatePlanner ==
                                                          FFAppState()
                                                              .plannerDateSelected)
                                                      .toList().isNotEmpty) &&
                                              (valueOrDefault<bool>(
                                                    FFAppState()
                                                            .pageStateSchemaVariable
                                                            .inputListState.isNotEmpty,
                                                    false,
                                                  ) ||
                                                  valueOrDefault<bool>(
                                                    FFAppState()
                                                                .pageStateSchemaVariable
                                                                .goodThingsPlanner !=
                                                            '',
                                                    false,
                                                  ) ||
                                                  valueOrDefault<bool>(
                                                    FFAppState()
                                                                .pageStateSchemaVariable
                                                                .imporovementState !=
                                                            '',
                                                    false,
                                                  ))) {
                                            FFAppState()
                                                .updateInsideDBStudentAtIndex(
                                              functions.getIndexFunction(
                                                  FFAppState()
                                                      .insideDBStudent
                                                      .toList(),
                                                  FFAppState()
                                                      .plannerDateSelected!),
                                              (_) => FFAppState()
                                                  .pageStateSchemaVariable,
                                            );
                                            FFAppState().update(() {});
                                          } else {
                                            if (valueOrDefault<bool>(
                                                  FFAppState()
                                                          .pageStateSchemaVariable
                                                          .inputListState.isNotEmpty,
                                                  false,
                                                ) ||
                                                valueOrDefault<bool>(
                                                  FFAppState()
                                                              .pageStateSchemaVariable
                                                              .goodThingsPlanner !=
                                                          '',
                                                  false,
                                                ) ||
                                                valueOrDefault<bool>(
                                                  FFAppState()
                                                              .pageStateSchemaVariable
                                                              .imporovementState !=
                                                          '',
                                                  false,
                                                )) {
                                              FFAppState().addToInsideDBStudent(
                                                  FFAppState()
                                                      .pageStateSchemaVariable);
                                              FFAppState().update(() {});
                                            }
                                          }

                                          if (valueOrDefault<bool>(
                                                FFAppState()
                                                        .pageStateSchemaVariable
                                                        .inputListState.isNotEmpty,
                                                false,
                                              ) ||
                                              valueOrDefault<bool>(
                                                FFAppState()
                                                            .pageStateSchemaVariable
                                                            .goodThingsPlanner !=
                                                        '',
                                                false,
                                              ) ||
                                              valueOrDefault<bool>(
                                                FFAppState()
                                                            .pageStateSchemaVariable
                                                            .imporovementState !=
                                                        '',
                                                false,
                                              )) {
                                            if (_model.loadedInfo != null) {
                                              await _model.loadedInfo!.reference
                                                  .update({
                                                ...createPlannerVariableListRecordData(
                                                  goodThings: FFAppState()
                                                      .pageStateSchemaVariable
                                                      .goodThingsPlanner,
                                                  improvement: FFAppState()
                                                      .pageStateSchemaVariable
                                                      .imporovementState,
                                                  achivementPercentage:
                                                      FFAppState()
                                                          .pageStateSchemaVariable
                                                          .archivePercentState,
                                                  dailyStarting:
                                                      updateDailyStartingStruct(
                                                    FFAppState()
                                                        .pageStateSchemaVariable
                                                        .dailyStartPara,
                                                    clearUnsetFields: false,
                                                  ),
                                                ),
                                                ...mapToFirestore(
                                                  {
                                                    'inputList':
                                                        getPlannerInputListFirestoreData(
                                                      FFAppState()
                                                          .pageStateSchemaVariable
                                                          .inputListState,
                                                    ),
                                                  },
                                                ),
                                              });
                                            } else {
                                              await PlannerVariableListRecord
                                                      .createDoc(
                                                          currentUserReference!)
                                                  .set({
                                                ...createPlannerVariableListRecordData(
                                                  adminChecked: false,
                                                  goodThings: FFAppState()
                                                      .pageStateSchemaVariable
                                                      .goodThingsPlanner,
                                                  improvement: FFAppState()
                                                      .pageStateSchemaVariable
                                                      .imporovementState,
                                                  achivementPercentage:
                                                      valueOrDefault<double>(
                                                    FFAppState()
                                                        .pageStateSchemaVariable
                                                        .archivePercentState,
                                                    0.0,
                                                  ),
                                                  submittedDate: FFAppState()
                                                      .plannerDateSelected,
                                                  plannerSubmitted: false,
                                                  basicInfo:
                                                      updateBasicUserInfoStruct(
                                                    BasicUserInfoStruct(
                                                      uid: currentUserReference
                                                          ?.id,
                                                      userName:
                                                          currentUserDisplayName,
                                                      userSeatNo: valueOrDefault(
                                                          currentUserDocument
                                                              ?.seatNo,
                                                          0),
                                                    ),
                                                    clearUnsetFields: false,
                                                    create: true,
                                                  ),
                                                  dailyStarting:
                                                      updateDailyStartingStruct(
                                                    FFAppState()
                                                        .pageStateSchemaVariable
                                                        .dailyStartPara,
                                                    clearUnsetFields: false,
                                                    create: true,
                                                  ),
                                                ),
                                                ...mapToFirestore(
                                                  {
                                                    'inputList':
                                                        getPlannerInputListFirestoreData(
                                                      FFAppState()
                                                          .pageStateSchemaVariable
                                                          .inputListState,
                                                    ),
                                                  },
                                                ),
                                              });
                                            }
                                          }
                                          FFAppState().plannerDateSelected =
                                              functions.subtractminusoneday(
                                                  FFAppState()
                                                      .plannerDateSelected!);
                                          FFAppState().update(() {});
                                          _model.loadedInfoCopyCopy =
                                              await queryPlannerVariableListRecordOnce(
                                            parent: currentUserReference,
                                            queryBuilder:
                                                (plannerVariableListRecord) =>
                                                    plannerVariableListRecord
                                                        .where(
                                              'submittedDate',
                                              isEqualTo: FFAppState()
                                                  .plannerDateSelected,
                                            ),
                                            singleRecord: true,
                                          ).then((s) => s.firstOrNull);
                                          if (_model.loadedInfoCopyCopy !=
                                              null) {
                                            FFAppState()
                                                    .pageStateSchemaVariable =
                                                PageStateSchemaStruct(
                                              inputListState: _model
                                                  .loadedInfoCopyCopy
                                                  ?.inputList,
                                              submittedDatePlanner: _model
                                                  .loadedInfoCopyCopy
                                                  ?.submittedDate,
                                              goodThingsPlanner: _model
                                                  .loadedInfoCopyCopy
                                                  ?.goodThings,
                                              imporovementState: _model
                                                  .loadedInfoCopyCopy
                                                  ?.improvement,
                                              archivePercentState: _model
                                                  .loadedInfoCopyCopy
                                                  ?.achivementPercentage,
                                              teacherquoteState: _model
                                                  .loadedInfoCopyCopy
                                                  ?.teachersQuote,
                                              isSubmittedPara: _model
                                                  .loadedInfoCopyCopy
                                                  ?.plannerSubmitted,
                                              adminCheckedPara: _model
                                                  .loadedInfoCopyCopy
                                                  ?.adminChecked,
                                              dailyStartPara: _model
                                                  .loadedInfoCopyCopy
                                                  ?.dailyStarting,
                                            );
                                            FFAppState().update(() {});
                                            safeSetState(() {
                                              _model.textField34TextController
                                                  ?.clear();
                                              _model.textController3?.clear();
                                              _model.textController2?.clear();
                                            });
                                            await Future.wait([
                                              Future(() async {
                                                safeSetState(() {
                                                  _model.textController2?.text =
                                                      _model.loadedInfoCopyCopy!
                                                          .goodThings;
                                                  _model.textFieldFocusNode1
                                                      ?.requestFocus();
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    _model.textController2
                                                            ?.selection =
                                                        TextSelection.collapsed(
                                                      offset: _model
                                                          .textController2!
                                                          .text
                                                          .length,
                                                    );
                                                  });
                                                });
                                              }),
                                              Future(() async {
                                                safeSetState(() {
                                                  _model.textController3?.text =
                                                      _model.loadedInfoCopyCopy!
                                                          .improvement;
                                                  _model.textFieldFocusNode2
                                                      ?.requestFocus();
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    _model.textController3
                                                            ?.selection =
                                                        TextSelection.collapsed(
                                                      offset: _model
                                                          .textController3!
                                                          .text
                                                          .length,
                                                    );
                                                  });
                                                });
                                              }),
                                              Future(() async {
                                                safeSetState(() {
                                                  _model.sliderValue =
                                                      FFAppState()
                                                          .pageStateSchemaVariable
                                                          .archivePercentState;
                                                });
                                              }),
                                              Future(() async {
                                                safeSetState(() {
                                                  _model.textField34TextController
                                                          ?.text =
                                                      FFAppState()
                                                          .pageStateSchemaVariable
                                                          .dailyStartPara
                                                          .commentOfDay;
                                                  _model.textField34FocusNode
                                                      ?.requestFocus();
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    _model.textField34TextController
                                                            ?.selection =
                                                        TextSelection.collapsed(
                                                      offset: _model
                                                          .textField34TextController!
                                                          .text
                                                          .length,
                                                    );
                                                  });
                                                });
                                              }),
                                            ]);
                                          } else {
                                            FFAppState()
                                                .deletePageStateSchemaVariable();
                                            FFAppState()
                                                    .pageStateSchemaVariable =
                                                PageStateSchemaStruct();

                                            FFAppState().update(() {});
                                            safeSetState(() {
                                              _model.textField34TextController
                                                  ?.clear();
                                              _model.textController3?.clear();
                                              _model.textController2?.clear();
                                            });
                                            safeSetState(() {
                                              _model.sliderValue = 0.0;
                                            });
                                          }

                                          FFAppState().changeChecker =
                                              FFAppState()
                                                  .pageStateSchemaVariable;
                                          FFAppState().update(() {});
                                        }
                                      }

                                      safeSetState(() {});
                                    },
                                    onVerticalDragStart: (details) async {
                                      _model.localxStart =
                                          details.localPosition.dx;
                                      safeSetState(() {});
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 15,
                                          child: Container(
                                            width: 100.0,
                                            height: 552.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 4.0,
                                                  color: Color(0x33000000),
                                                  offset: Offset(
                                                    0.0,
                                                    2.0,
                                                  ),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              border: Border.all(
                                                color: const Color(0xFFE5E7EB),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: 35.0,
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xFFE8BA95),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(0.0),
                                                      bottomRight:
                                                          Radius.circular(0.0),
                                                      topLeft:
                                                          Radius.circular(15.0),
                                                      topRight:
                                                          Radius.circular(15.0),
                                                    ),
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'rnhw2tjz' /* TO DO LIST */,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                color: Colors
                                                                    .white,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily),
                                                              ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  height: 35.0,
                                                  decoration: const BoxDecoration(
                                                    color: Color(0x98E8BA95),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            const AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Text(
                                                          FFLocalizations.of(
                                                                  context)
                                                              .getText(
                                                            'v23o1msf' /* STUDY PLAN */,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily),
                                                              ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            const AlignmentDirectional(
                                                                -0.95, 0.0),
                                                        child: Text(
                                                          FFLocalizations.of(
                                                                  context)
                                                              .getText(
                                                            '0l4ewjpy' /* SUB */,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily),
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    SizedBox(
                                                      height: 480.0,
                                                      child: Stack(
                                                        alignment:
                                                            const AlignmentDirectional(
                                                                0.0, -1.0),
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 5,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 50,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 5,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 50,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 5,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 50,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 5,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 50,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 5,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 50,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 5,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 50,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 5,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 50,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 5,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 50,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 5,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 50,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 5,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 50,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 5,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 50,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 5,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        borderRadius:
                                                                            const BorderRadius.only(
                                                                          bottomLeft:
                                                                              Radius.circular(20.0),
                                                                          bottomRight:
                                                                              Radius.circular(0.0),
                                                                          topLeft:
                                                                              Radius.circular(0.0),
                                                                          topRight:
                                                                              Radius.circular(0.0),
                                                                        ),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 50,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        borderRadius:
                                                                            const BorderRadius.only(
                                                                          bottomLeft:
                                                                              Radius.circular(0.0),
                                                                          bottomRight:
                                                                              Radius.circular(20.0),
                                                                          topLeft:
                                                                              Radius.circular(0.0),
                                                                          topRight:
                                                                              Radius.circular(0.0),
                                                                        ),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Builder(
                                                            builder: (context) {
                                                              final plannerinputchildLoad =
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()
                                                                      .take(20)
                                                                      .toList();

                                                              return ListView
                                                                  .builder(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                primary: false,
                                                                shrinkWrap:
                                                                    true,
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                itemCount:
                                                                    plannerinputchildLoad
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        plannerinputchildLoadIndex) {
                                                                  final plannerinputchildLoadItem =
                                                                      plannerinputchildLoad[
                                                                          plannerinputchildLoadIndex];
                                                                  return Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 5,
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              40.0,
                                                                          constraints:
                                                                              const BoxConstraints(
                                                                            minWidth:
                                                                                30.0,
                                                                            minHeight:
                                                                                20.0,
                                                                          ),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryBackground,
                                                                            border:
                                                                                Border.all(
                                                                              color: FlutterFlowTheme.of(context).primaryBackground,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                const AlignmentDirectional(0.0, 0.0),
                                                                            child:
                                                                                AutoSizeText(
                                                                              plannerinputchildLoadItem.subjectNamePlanner.maybeHandleOverflow(
                                                                                maxChars: 5,
                                                                              ),
                                                                              textAlign: TextAlign.center,
                                                                              minFontSize: 8.0,
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    fontSize: 14.0,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex:
                                                                            50,
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              40.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryBackground,
                                                                            border:
                                                                                Border.all(
                                                                              color: FlutterFlowTheme.of(context).primaryBackground,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              Align(
                                                                                alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                                                  child: Text(
                                                                                    plannerinputchildLoadItem.whatIDid,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          letterSpacing: 0.0,
                                                                                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Align(
                                                                                  alignment: const AlignmentDirectional(-1.0, 0.0),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                                                    child: Icon(
                                                                                      Icons.circle_rounded,
                                                                                      color: plannerinputchildLoadItem.pickedColor,
                                                                                      size: 24.0,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              if (plannerinputchildLoadItem.hasStudyEndTime())
                                                                                Align(
                                                                                  alignment: const AlignmentDirectional(1.0, 0.0),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 0.0),
                                                                                    child: Text(
                                                                                      functions.calculateStudyTime(plannerinputchildLoadItem.studyStartTime.toList(), plannerinputchildLoadItem.studyEndTime.toList()),
                                                                                      textAlign: TextAlign.center,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                            letterSpacing: 0.0,
                                                                                            useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              if (!valueOrDefault<bool>(
                                                                                pageeeePlannerVariableListRecord?.plannerSubmitted,
                                                                                false,
                                                                              ))
                                                                                Align(
                                                                                  alignment: const AlignmentDirectional(1.0, 0.0),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                                                                                    child: InkWell(
                                                                                      splashColor: Colors.transparent,
                                                                                      focusColor: Colors.transparent,
                                                                                      hoverColor: Colors.transparent,
                                                                                      highlightColor: Colors.transparent,
                                                                                      onTap: () async {
                                                                                        context.goNamed(
                                                                                          'timerPage',
                                                                                          queryParameters: {
                                                                                            'subNameParameter': serializeParam(
                                                                                              plannerinputchildLoadItem.subjectNamePlanner,
                                                                                              ParamType.String,
                                                                                            ),
                                                                                            'studiedDetailsParameter': serializeParam(
                                                                                              plannerinputchildLoadItem.whatIDid,
                                                                                              ParamType.String,
                                                                                            ),
                                                                                            'indexIDParameter': serializeParam(
                                                                                              plannerinputchildLoadIndex,
                                                                                              ParamType.int,
                                                                                            ),
                                                                                          }.withoutNulls,
                                                                                        );
                                                                                      },
                                                                                      child: Icon(
                                                                                        Icons.play_circle,
                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                        size: 24.0,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              if (!valueOrDefault<bool>(
                                                                                pageeeePlannerVariableListRecord?.plannerSubmitted,
                                                                                false,
                                                                              ))
                                                                                Builder(
                                                                                  builder: (context) => Padding(
                                                                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                                                                                    child: InkWell(
                                                                                      splashColor: Colors.transparent,
                                                                                      focusColor: Colors.transparent,
                                                                                      hoverColor: Colors.transparent,
                                                                                      highlightColor: Colors.transparent,
                                                                                      onTap: () async {
                                                                                        await showDialog(
                                                                                          context: context,
                                                                                          builder: (dialogContext) {
                                                                                            return Dialog(
                                                                                              elevation: 0,
                                                                                              insetPadding: EdgeInsets.zero,
                                                                                              backgroundColor: Colors.transparent,
                                                                                              alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                                              child: GestureDetector(
                                                                                                onTap: () => FocusScope.of(dialogContext).unfocus(),
                                                                                                child: PlannerFixWidget(
                                                                                                  listNo: valueOrDefault<int>(
                                                                                                    plannerinputchildLoadIndex,
                                                                                                    0,
                                                                                                  ),
                                                                                                  subNamePassToFix: valueOrDefault<String>(
                                                                                                    plannerinputchildLoadItem.subjectNamePlanner,
                                                                                                    'null',
                                                                                                  ),
                                                                                                  objectPassToFix: valueOrDefault<String>(
                                                                                                    plannerinputchildLoadItem.whatIDid,
                                                                                                    'null',
                                                                                                  ),
                                                                                                  colorToFix: valueOrDefault<Color>(
                                                                                                    plannerinputchildLoadItem.pickedColor,
                                                                                                    Colors.black,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                        );
                                                                                      },
                                                                                      child: Icon(
                                                                                        Icons.settings_sharp,
                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                        size: 24.0,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 3,
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            if (plannerinputchildLoadItem.isdone ==
                                                                                'done') {
                                                                              FFAppState().updatePageStateSchemaVariableStruct(
                                                                                (e) => e
                                                                                  ..updateInputListState(
                                                                                    (e) => e[plannerinputchildLoadIndex]..isdone = 'notyet',
                                                                                  ),
                                                                              );
                                                                              safeSetState(() {});
                                                                            } else if (plannerinputchildLoadItem.isdone ==
                                                                                'notyet') {
                                                                              FFAppState().updatePageStateSchemaVariableStruct(
                                                                                (e) => e
                                                                                  ..updateInputListState(
                                                                                    (e) => e[plannerinputchildLoadIndex]..isdone = 'unfinish',
                                                                                  ),
                                                                              );
                                                                              safeSetState(() {});
                                                                            } else {
                                                                              FFAppState().updatePageStateSchemaVariableStruct(
                                                                                (e) => e
                                                                                  ..updateInputListState(
                                                                                    (e) => e[plannerinputchildLoadIndex]..isdone = 'done',
                                                                                  ),
                                                                              );
                                                                              safeSetState(() {});
                                                                            }
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                40.0,
                                                                            constraints:
                                                                                const BoxConstraints(
                                                                              minWidth: 20.0,
                                                                              minHeight: 20.0,
                                                                            ),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              border: Border.all(
                                                                                color: FlutterFlowTheme.of(context).primaryBackground,
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Align(
                                                                              alignment: const AlignmentDirectional(0.0, 0.0),
                                                                              child: Builder(
                                                                                builder: (context) {
                                                                                  if (plannerinputchildLoadItem.isdone == 'done') {
                                                                                    return Align(
                                                                                      alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                      child: Icon(
                                                                                        Icons.circle_outlined,
                                                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                                                        size: 24.0,
                                                                                      ),
                                                                                    );
                                                                                  } else if (plannerinputchildLoadItem.isdone == 'notyet') {
                                                                                    return Align(
                                                                                      alignment: const AlignmentDirectional(0.0, 0.0),
                                                                                      child: Icon(
                                                                                        Icons.change_history,
                                                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                                                        size: 24.0,
                                                                                      ),
                                                                                    );
                                                                                  } else {
                                                                                    return FaIcon(
                                                                                      FontAwesomeIcons.times,
                                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                                      size: 24.0,
                                                                                    );
                                                                                  }
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const VerticalDivider(
                                          thickness: 3.0,
                                          color: Colors.white,
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                            width: 100.0,
                                            height: 550.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 4.0,
                                                  color: Color(0x33000000),
                                                  offset: Offset(
                                                    0.0,
                                                    2.0,
                                                  ),
                                                )
                                              ],
                                              borderRadius: const BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(10.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                                topLeft: Radius.circular(20.0),
                                                topRight: Radius.circular(20.0),
                                              ),
                                            ),
                                            child: SingleChildScrollView(
                                              primary: false,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    height: 35.0,
                                                    decoration: const BoxDecoration(
                                                      color: Color(0xFFE8BA95),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                                0.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                0.0),
                                                        topLeft:
                                                            Radius.circular(
                                                                10.0),
                                                        topRight:
                                                            Radius.circular(
                                                                10.0),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, -0.5),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          5.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  FFAppState()
                                                                      .updatePageStateSchemaVariableStruct(
                                                                    (e) => e
                                                                      ..goodThingsPlanner = _model
                                                                          .textController2
                                                                          .text
                                                                      ..imporovementState = _model
                                                                          .textController3
                                                                          .text
                                                                      ..archivePercentState =
                                                                          _model
                                                                              .sliderValue
                                                                      ..submittedDatePlanner =
                                                                          FFAppState()
                                                                              .plannerDateSelected,
                                                                  );
                                                                  FFAppState()
                                                                      .update(
                                                                          () {});
                                                                  if (FFAppState()
                                                                          .insideDBStudent
                                                                          .where((e) =>
                                                                              e.submittedDatePlanner ==
                                                                              FFAppState().plannerDateSelected)
                                                                          .toList().isNotEmpty) {
                                                                    FFAppState()
                                                                        .updateInsideDBStudentAtIndex(
                                                                      functions.getIndexFunction(
                                                                          FFAppState()
                                                                              .insideDBStudent
                                                                              .toList(),
                                                                          FFAppState()
                                                                              .plannerDateSelected!),
                                                                      (_) => FFAppState()
                                                                          .pageStateSchemaVariable,
                                                                    );
                                                                    FFAppState()
                                                                        .update(
                                                                            () {});
                                                                  } else {
                                                                    FFAppState()
                                                                        .addToInsideDBStudent(
                                                                            FFAppState().pageStateSchemaVariable);
                                                                    FFAppState()
                                                                        .update(
                                                                            () {});
                                                                  }

                                                                  if (valueOrDefault<
                                                                          bool>(
                                                                        FFAppState().pageStateSchemaVariable.inputListState.isNotEmpty,
                                                                        false,
                                                                      ) ||
                                                                      valueOrDefault<
                                                                          bool>(
                                                                        FFAppState().pageStateSchemaVariable.goodThingsPlanner !=
                                                                                '',
                                                                        false,
                                                                      ) ||
                                                                      valueOrDefault<
                                                                          bool>(
                                                                        FFAppState().pageStateSchemaVariable.imporovementState !=
                                                                                '',
                                                                        false,
                                                                      ) ||
                                                                      (FFAppState()
                                                                              .pageStateSchemaVariable
                                                                              .dailyStartPara
                                                                              .sleepTime !=
                                                                          null) ||
                                                                      (FFAppState().pageStateSchemaVariable.dailyStartPara.goalTime !=
                                                                              '') ||
                                                                      (FFAppState()
                                                                              .pageStateSchemaVariable
                                                                              .dailyStartPara
                                                                              .getupTime !=
                                                                          null)) {
                                                                    if (pageeeePlannerVariableListRecord !=
                                                                        null) {
                                                                      await pageeeePlannerVariableListRecord
                                                                          .reference
                                                                          .update({
                                                                        ...createPlannerVariableListRecordData(
                                                                          goodThings: FFAppState()
                                                                              .pageStateSchemaVariable
                                                                              .goodThingsPlanner,
                                                                          improvement: FFAppState()
                                                                              .pageStateSchemaVariable
                                                                              .imporovementState,
                                                                          achivementPercentage: FFAppState()
                                                                              .pageStateSchemaVariable
                                                                              .archivePercentState,
                                                                          dailyStarting:
                                                                              updateDailyStartingStruct(
                                                                            FFAppState().pageStateSchemaVariable.dailyStartPara,
                                                                            clearUnsetFields:
                                                                                false,
                                                                          ),
                                                                        ),
                                                                        ...mapToFirestore(
                                                                          {
                                                                            'inputList':
                                                                                getPlannerInputListFirestoreData(
                                                                              FFAppState().pageStateSchemaVariable.inputListState,
                                                                            ),
                                                                          },
                                                                        ),
                                                                      });
                                                                    } else {
                                                                      await PlannerVariableListRecord.createDoc(
                                                                              currentUserReference!)
                                                                          .set({
                                                                        ...createPlannerVariableListRecordData(
                                                                          adminChecked:
                                                                              false,
                                                                          goodThings: FFAppState()
                                                                              .pageStateSchemaVariable
                                                                              .goodThingsPlanner,
                                                                          improvement: FFAppState()
                                                                              .pageStateSchemaVariable
                                                                              .imporovementState,
                                                                          achivementPercentage:
                                                                              valueOrDefault<double>(
                                                                            FFAppState().pageStateSchemaVariable.archivePercentState,
                                                                            0.0,
                                                                          ),
                                                                          submittedDate:
                                                                              FFAppState().plannerDateSelected,
                                                                          plannerSubmitted:
                                                                              false,
                                                                          basicInfo:
                                                                              updateBasicUserInfoStruct(
                                                                            BasicUserInfoStruct(
                                                                              uid: currentUserReference?.id,
                                                                              userName: currentUserDisplayName,
                                                                              userSeatNo: valueOrDefault(currentUserDocument?.seatNo, 0),
                                                                              userSpot: valueOrDefault(currentUserDocument?.spot, ''),
                                                                            ),
                                                                            clearUnsetFields:
                                                                                false,
                                                                            create:
                                                                                true,
                                                                          ),
                                                                          dailyStarting:
                                                                              updateDailyStartingStruct(
                                                                            FFAppState().pageStateSchemaVariable.dailyStartPara,
                                                                            clearUnsetFields:
                                                                                false,
                                                                            create:
                                                                                true,
                                                                          ),
                                                                        ),
                                                                        ...mapToFirestore(
                                                                          {
                                                                            'inputList':
                                                                                getPlannerInputListFirestoreData(
                                                                              FFAppState().pageStateSchemaVariable.inputListState,
                                                                            ),
                                                                          },
                                                                        ),
                                                                      });
                                                                    }
                                                                  }
                                                                  final datePickedDate =
                                                                      await showDatePicker(
                                                                    context:
                                                                        context,
                                                                    initialDate:
                                                                        getCurrentTimestamp,
                                                                    firstDate:
                                                                        DateTime(
                                                                            1900),
                                                                    lastDate:
                                                                        DateTime(
                                                                            2050),
                                                                    builder:
                                                                        (context,
                                                                            child) {
                                                                      return wrapInMaterialDatePickerTheme(
                                                                        context,
                                                                        child!,
                                                                        headerBackgroundColor:
                                                                            FlutterFlowTheme.of(context).primary,
                                                                        headerForegroundColor:
                                                                            FlutterFlowTheme.of(context).info,
                                                                        headerTextStyle: FlutterFlowTheme.of(context)
                                                                            .headlineLarge
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).headlineLargeFamily,
                                                                              fontSize: 32.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).headlineLargeFamily),
                                                                            ),
                                                                        pickerBackgroundColor:
                                                                            FlutterFlowTheme.of(context).secondaryBackground,
                                                                        pickerForegroundColor:
                                                                            FlutterFlowTheme.of(context).primaryText,
                                                                        selectedDateTimeBackgroundColor:
                                                                            FlutterFlowTheme.of(context).primary,
                                                                        selectedDateTimeForegroundColor:
                                                                            FlutterFlowTheme.of(context).info,
                                                                        actionButtonForegroundColor:
                                                                            FlutterFlowTheme.of(context).primaryText,
                                                                        iconSize:
                                                                            24.0,
                                                                      );
                                                                    },
                                                                  );

                                                                  if (datePickedDate !=
                                                                      null) {
                                                                    safeSetState(
                                                                        () {
                                                                      _model.datePicked =
                                                                          DateTime(
                                                                        datePickedDate
                                                                            .year,
                                                                        datePickedDate
                                                                            .month,
                                                                        datePickedDate
                                                                            .day,
                                                                      );
                                                                    });
                                                                  }
                                                                  if (_model
                                                                          .datePicked ==
                                                                      null) {
                                                                    FFAppState()
                                                                            .plannerDateSelected =
                                                                        FFAppState()
                                                                            .dateselectSafety;
                                                                    FFAppState()
                                                                        .update(
                                                                            () {});
                                                                  } else {
                                                                    FFAppState()
                                                                            .plannerDateSelected =
                                                                        _model
                                                                            .datePicked;
                                                                    FFAppState()
                                                                        .update(
                                                                            () {});
                                                                  }

                                                                  FFAppState()
                                                                          .dateselectSafety =
                                                                      FFAppState()
                                                                          .plannerDateSelected;
                                                                  FFAppState()
                                                                      .update(
                                                                          () {});
                                                                  if (FFAppState()
                                                                          .insideDBStudent
                                                                          .where((e) =>
                                                                              e.submittedDatePlanner ==
                                                                              FFAppState().plannerDateSelected)
                                                                          .toList()
                                                                          .length >
                                                                      999999) {
                                                                    FFAppState().pageStateSchemaVariable = FFAppState().insideDBStudent[functions.getIndexFunction(
                                                                        FFAppState()
                                                                            .insideDBStudent
                                                                            .toList(),
                                                                        FFAppState()
                                                                            .plannerDateSelected!)];
                                                                    safeSetState(
                                                                        () {});
                                                                    await Future
                                                                        .wait([
                                                                      Future(
                                                                          () async {
                                                                        safeSetState(
                                                                            () {
                                                                          _model
                                                                              .textController2
                                                                              ?.text = FFAppState().pageStateSchemaVariable.goodThingsPlanner;
                                                                          _model
                                                                              .textFieldFocusNode1
                                                                              ?.requestFocus();
                                                                          WidgetsBinding
                                                                              .instance
                                                                              .addPostFrameCallback((_) {
                                                                            _model.textController2?.selection =
                                                                                TextSelection.collapsed(
                                                                              offset: _model.textController2!.text.length,
                                                                            );
                                                                          });
                                                                        });
                                                                      }),
                                                                      Future(
                                                                          () async {
                                                                        safeSetState(
                                                                            () {
                                                                          _model
                                                                              .textController3
                                                                              ?.text = FFAppState().pageStateSchemaVariable.imporovementState;
                                                                          _model
                                                                              .textFieldFocusNode2
                                                                              ?.requestFocus();
                                                                          WidgetsBinding
                                                                              .instance
                                                                              .addPostFrameCallback((_) {
                                                                            _model.textController3?.selection =
                                                                                TextSelection.collapsed(
                                                                              offset: _model.textController3!.text.length,
                                                                            );
                                                                          });
                                                                        });
                                                                      }),
                                                                      Future(
                                                                          () async {
                                                                        safeSetState(
                                                                            () {
                                                                          _model.sliderValue = FFAppState()
                                                                              .pageStateSchemaVariable
                                                                              .archivePercentState;
                                                                        });
                                                                      }),
                                                                    ]);
                                                                  } else {
                                                                    _model.loadedInfo =
                                                                        await queryPlannerVariableListRecordOnce(
                                                                      parent:
                                                                          currentUserReference,
                                                                      queryBuilder:
                                                                          (plannerVariableListRecord) =>
                                                                              plannerVariableListRecord.where(
                                                                        'submittedDate',
                                                                        isEqualTo:
                                                                            FFAppState().plannerDateSelected,
                                                                      ),
                                                                      singleRecord:
                                                                          true,
                                                                    ).then((s) =>
                                                                            s.firstOrNull);
                                                                    if (_model
                                                                            .loadedInfo !=
                                                                        null) {
                                                                      FFAppState()
                                                                              .pageStateSchemaVariable =
                                                                          PageStateSchemaStruct(
                                                                        inputListState: _model
                                                                            .loadedInfo
                                                                            ?.inputList,
                                                                        submittedDatePlanner: _model
                                                                            .loadedInfo
                                                                            ?.submittedDate,
                                                                        goodThingsPlanner: _model
                                                                            .loadedInfo
                                                                            ?.goodThings,
                                                                        imporovementState: _model
                                                                            .loadedInfo
                                                                            ?.improvement,
                                                                        archivePercentState: _model
                                                                            .loadedInfo
                                                                            ?.achivementPercentage,
                                                                        teacherquoteState: _model
                                                                            .loadedInfo
                                                                            ?.teachersQuote,
                                                                        isSubmittedPara: _model
                                                                            .loadedInfo
                                                                            ?.plannerSubmitted,
                                                                        adminCheckedPara: _model
                                                                            .loadedInfo
                                                                            ?.adminChecked,
                                                                        dailyStartPara: _model
                                                                            .loadedInfo
                                                                            ?.dailyStarting,
                                                                      );
                                                                      FFAppState()
                                                                          .update(
                                                                              () {});
                                                                      safeSetState(
                                                                          () {
                                                                        _model
                                                                            .textController2
                                                                            ?.clear();
                                                                        _model
                                                                            .textController3
                                                                            ?.clear();
                                                                      });
                                                                      await Future
                                                                          .wait([
                                                                        Future(
                                                                            () async {
                                                                          safeSetState(
                                                                              () {
                                                                            _model.textController2?.text =
                                                                                FFAppState().pageStateSchemaVariable.goodThingsPlanner;
                                                                            _model.textFieldFocusNode1?.requestFocus();
                                                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                              _model.textController2?.selection = TextSelection.collapsed(
                                                                                offset: _model.textController2!.text.length,
                                                                              );
                                                                            });
                                                                          });
                                                                        }),
                                                                        Future(
                                                                            () async {
                                                                          safeSetState(
                                                                              () {
                                                                            _model.textController3?.text =
                                                                                FFAppState().pageStateSchemaVariable.imporovementState;
                                                                            _model.textFieldFocusNode2?.requestFocus();
                                                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                              _model.textController3?.selection = TextSelection.collapsed(
                                                                                offset: _model.textController3!.text.length,
                                                                              );
                                                                            });
                                                                          });
                                                                        }),
                                                                        Future(
                                                                            () async {
                                                                          safeSetState(
                                                                              () {
                                                                            _model.sliderValue =
                                                                                FFAppState().pageStateSchemaVariable.archivePercentState;
                                                                          });
                                                                        }),
                                                                        Future(
                                                                            () async {
                                                                          safeSetState(
                                                                              () {
                                                                            _model.textField34TextController?.text =
                                                                                _model.loadedInfo!.dailyStarting.commentOfDay;
                                                                            _model.textField34FocusNode?.requestFocus();
                                                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                              _model.textField34TextController?.selection = TextSelection.collapsed(
                                                                                offset: _model.textField34TextController!.text.length,
                                                                              );
                                                                            });
                                                                          });
                                                                        }),
                                                                      ]);
                                                                    } else {
                                                                      FFAppState()
                                                                          .deletePageStateSchemaVariable();
                                                                      FFAppState()
                                                                              .pageStateSchemaVariable =
                                                                          PageStateSchemaStruct();

                                                                      FFAppState()
                                                                          .update(
                                                                              () {});
                                                                      safeSetState(
                                                                          () {
                                                                        _model
                                                                            .textController2
                                                                            ?.clear();
                                                                        _model
                                                                            .textController3
                                                                            ?.clear();
                                                                      });
                                                                      safeSetState(
                                                                          () {
                                                                        _model.sliderValue =
                                                                            0.0;
                                                                      });
                                                                    }
                                                                  }

                                                                  FFAppState()
                                                                          .changeChecker =
                                                                      FFAppState()
                                                                          .pageStateSchemaVariable;
                                                                  FFAppState()
                                                                      .update(
                                                                          () {});

                                                                  safeSetState(
                                                                      () {});
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .calendar_today,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                  size: 20.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Text(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                'p8qs7y62' /* TimeTable */,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    color: Colors
                                                                        .white,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: Builder(
                                                              builder:
                                                                  (context) =>
                                                                      InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  await showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (dialogContext) {
                                                                      return Dialog(
                                                                        elevation:
                                                                            0,
                                                                        insetPadding:
                                                                            EdgeInsets.zero,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        alignment:
                                                                            const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap: () =>
                                                                              FocusScope.of(dialogContext).unfocus(),
                                                                          child:
                                                                              SizedBox(
                                                                            height:
                                                                                350.0,
                                                                            width:
                                                                                500.0,
                                                                            child:
                                                                                PlannerTimeOptionBottomSheetWidget(
                                                                              starttime: FFAppState().PlannerStartTime,
                                                                              endtime: FFAppState().PlannerEndTime,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: const Icon(
                                                                  Icons
                                                                      .settings_sharp,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 20.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (FFAppState()
                                                          .PlannerStartTime <=
                                                      5)
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            child: Align(
                                                              alignment:
                                                                  const AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              child:
                                                                  AutoSizeText(
                                                                FFLocalizations.of(
                                                                        context)
                                                                    .getText(
                                                                  '7lv7ybg6' /* 5 */,
                                                                ),
                                                                minFontSize:
                                                                    10.0,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      fontSize:
                                                                          20.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts: GoogleFonts
                                                                              .asMap()
                                                                          .containsKey(
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell051',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell052',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell053',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell054',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell055',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell056',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (FFAppState()
                                                          .PlannerStartTime <=
                                                      6)
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            child: Align(
                                                              alignment:
                                                                  const AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              child:
                                                                  AutoSizeText(
                                                                FFLocalizations.of(
                                                                        context)
                                                                    .getText(
                                                                  '09esbp58' /* 6 */,
                                                                ),
                                                                minFontSize:
                                                                    10.0,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      fontSize:
                                                                          20.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts: GoogleFonts
                                                                              .asMap()
                                                                          .containsKey(
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell061',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell062',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell063',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell064',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell065',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell066',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (FFAppState()
                                                          .PlannerStartTime <=
                                                      7)
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            child: Align(
                                                              alignment:
                                                                  const AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              child:
                                                                  AutoSizeText(
                                                                FFLocalizations.of(
                                                                        context)
                                                                    .getText(
                                                                  'wvut6nhm' /* 7 */,
                                                                ),
                                                                minFontSize:
                                                                    10.0,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      fontSize:
                                                                          20.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts: GoogleFonts
                                                                              .asMap()
                                                                          .containsKey(
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell071',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell072',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell073',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell074',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell075',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell076',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (FFAppState()
                                                          .PlannerStartTime <=
                                                      8)
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            child: Align(
                                                              alignment:
                                                                  const AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              child:
                                                                  AutoSizeText(
                                                                FFLocalizations.of(
                                                                        context)
                                                                    .getText(
                                                                  '1kc8ga7d' /* 8 */,
                                                                ),
                                                                minFontSize:
                                                                    10.0,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      fontSize:
                                                                          20.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts: GoogleFonts
                                                                              .asMap()
                                                                          .containsKey(
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell081',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell082',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell083',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell084',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell085',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell086',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: AutoSizeText(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                'qaj4uocp' /* 9 */,
                                                              ),
                                                              minFontSize: 10.0,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        20.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell091',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell092',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell093',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell094',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell095',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell096',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: AutoSizeText(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                'm437mwys' /* 10 */,
                                                              ),
                                                              minFontSize: 10.0,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        20.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell101',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell102',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell103',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell104',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell105',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell106',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: AutoSizeText(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                'i0f3j9x7' /* 11 */,
                                                              ),
                                                              minFontSize: 10.0,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        20.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell111',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell112',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell113',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell114',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell115',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell116',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: AutoSizeText(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                '9oxtcuoz' /* 12 */,
                                                              ),
                                                              minFontSize: 10.0,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        20.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell121',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell122',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell123',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell124',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell125',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell126',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: AutoSizeText(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                'b0udfzo8' /* 13 */,
                                                              ),
                                                              minFontSize: 10.0,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        20.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell131',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell132',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell133',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell134',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell135',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell136',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: AutoSizeText(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                'bvsoktuz' /* 14 */,
                                                              ),
                                                              minFontSize: 10.0,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        20.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell141',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell142',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell143',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell144',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell145',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell146',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: AutoSizeText(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                'vbanbl5d' /* 15 */,
                                                              ),
                                                              minFontSize: 10.0,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        20.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell151',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell102',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell103',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell104',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell105',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell106',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: AutoSizeText(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                'fjrw3dgd' /* 16 */,
                                                              ),
                                                              minFontSize: 10.0,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        20.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell101',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell102',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell103',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell104',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell105',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell106',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: AutoSizeText(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                'y5z9alkb' /* 17 */,
                                                              ),
                                                              minFontSize: 10.0,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        20.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell101',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell102',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell103',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell104',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell105',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell106',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: AutoSizeText(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                '056dfs2h' /* 18 */,
                                                              ),
                                                              minFontSize: 10.0,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        20.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell101',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell102',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell103',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell104',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell105',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell106',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: AutoSizeText(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                '6yjwdhib' /* 19 */,
                                                              ),
                                                              minFontSize: 10.0,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        20.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell101',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell102',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell103',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell104',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell105',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell106',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: AutoSizeText(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                'r76pvops' /* 20 */,
                                                              ),
                                                              minFontSize: 10.0,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        20.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell101',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell102',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell103',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell104',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell105',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell106',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: AutoSizeText(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                'v8go3tpw' /* 21 */,
                                                              ),
                                                              minFontSize: 10.0,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        20.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell101',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell102',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell103',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell104',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell105',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell106',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      valueOrDefault<
                                                                          double>(
                                                                FFAppState().PlannerEndTime ==
                                                                        22
                                                                    ? 10.0
                                                                    : 0.0,
                                                                0.0,
                                                              )),
                                                              bottomRight:
                                                                  const Radius
                                                                      .circular(
                                                                          0.0),
                                                              topLeft: const Radius
                                                                  .circular(
                                                                      0.0),
                                                              topRight: const Radius
                                                                  .circular(
                                                                      0.0),
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            child: AutoSizeText(
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .getText(
                                                                'esm3izmk' /* 22 */,
                                                              ),
                                                              minFontSize: 10.0,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        20.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell221',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell222',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell223',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell224',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell225',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          width: 100.0,
                                                          height: functions
                                                              .calculatePlannerCellHeight(
                                                                  FFAppState()
                                                                      .PlannerStartTime,
                                                                  FFAppState()
                                                                      .PlannerEndTime),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                valueOrDefault<
                                                                    Color>(
                                                              functions.getCellColorFromInputListState(
                                                                  'cell226',
                                                                  FFAppState()
                                                                      .pageStateSchemaVariable
                                                                      .inputListState
                                                                      .toList()),
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: const Radius
                                                                  .circular(
                                                                      0.0),
                                                              bottomRight: Radius
                                                                  .circular(
                                                                      valueOrDefault<
                                                                          double>(
                                                                FFAppState().PlannerEndTime ==
                                                                        22
                                                                    ? 10.0
                                                                    : 0.0,
                                                                0.0,
                                                              )),
                                                              topLeft: const Radius
                                                                  .circular(
                                                                      0.0),
                                                              topRight: const Radius
                                                                  .circular(
                                                                      0.0),
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  if (FFAppState()
                                                          .PlannerEndTime >=
                                                      23)
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        valueOrDefault<
                                                                            double>(
                                                                  FFAppState().PlannerEndTime ==
                                                                          23
                                                                      ? 10.0
                                                                      : 0.0,
                                                                  0.0,
                                                                )),
                                                                bottomRight: const Radius
                                                                    .circular(
                                                                        0.0),
                                                                topLeft: const Radius
                                                                    .circular(
                                                                        0.0),
                                                                topRight: const Radius
                                                                    .circular(
                                                                        0.0),
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            child: Align(
                                                              alignment:
                                                                  const AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              child:
                                                                  AutoSizeText(
                                                                FFLocalizations.of(
                                                                        context)
                                                                    .getText(
                                                                  'ygmi6gxp' /* 23 */,
                                                                ),
                                                                minFontSize:
                                                                    10.0,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily,
                                                                      fontSize:
                                                                          20.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      useGoogleFonts: GoogleFonts
                                                                              .asMap()
                                                                          .containsKey(
                                                                              FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell231',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell232',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell233',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell234',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell235',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 100.0,
                                                            height: functions
                                                                .calculatePlannerCellHeight(
                                                                    FFAppState()
                                                                        .PlannerStartTime,
                                                                    FFAppState()
                                                                        .PlannerEndTime),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  valueOrDefault<
                                                                      Color>(
                                                                functions.getCellColorFromInputListState(
                                                                    'cell236',
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .inputListState
                                                                        .toList()),
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: const Radius
                                                                    .circular(
                                                                        0.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        valueOrDefault<
                                                                            double>(
                                                                  FFAppState().PlannerEndTime ==
                                                                          23
                                                                      ? 10.0
                                                                      : 0.0,
                                                                  0.0,
                                                                )),
                                                                topLeft: const Radius
                                                                    .circular(
                                                                        0.0),
                                                                topRight: const Radius
                                                                    .circular(
                                                                        0.0),
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 10.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            flex: 50,
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 5.0, 0.0),
                                              child: Container(
                                                width: 100.0,
                                                height: 120.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      blurRadius: 4.0,
                                                      color: Color(0x33000000),
                                                      offset: Offset(
                                                        0.0,
                                                        2.0,
                                                      ),
                                                    )
                                                  ],
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(20.0),
                                                    bottomRight:
                                                        Radius.circular(20.0),
                                                    topLeft:
                                                        Radius.circular(20.0),
                                                    topRight:
                                                        Radius.circular(20.0),
                                                  ),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(18.0, 0.0,
                                                                18.0, 0.0),
                                                    child: TextFormField(
                                                      controller: _model
                                                          .textController2,
                                                      focusNode: _model
                                                          .textFieldFocusNode1,
                                                      autofocus: false,
                                                      obscureText: false,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                          'ioc3p4ch' /* Good Things */,
                                                        ),
                                                        labelStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily),
                                                                ),
                                                        hintStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily),
                                                                ),
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        focusedErrorBorder:
                                                            InputBorder.none,
                                                      ),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily),
                                                              ),
                                                      maxLines: 5,
                                                      minLines: 1,
                                                      validator: _model
                                                          .textController2Validator
                                                          .asValidator(context),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 50,
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(5.0, 0.0, 0.0, 0.0),
                                              child: Container(
                                                width: 100.0,
                                                height: 120.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      blurRadius: 4.0,
                                                      color: Color(0x33000000),
                                                      offset: Offset(
                                                        0.0,
                                                        2.0,
                                                      ),
                                                    )
                                                  ],
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(20.0),
                                                    bottomRight:
                                                        Radius.circular(20.0),
                                                    topLeft:
                                                        Radius.circular(20.0),
                                                    topRight:
                                                        Radius.circular(20.0),
                                                  ),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                  ),
                                                ),
                                                child: Slider(
                                                  activeColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                  inactiveColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .alternate,
                                                  min: 0.0,
                                                  max: 100.0,
                                                  value: _model.sliderValue ??=
                                                      0.0,
                                                  label: _model.sliderValue
                                                      ?.toStringAsFixed(0),
                                                  divisions: 20,
                                                  onChanged: (newValue) {
                                                    newValue = double.parse(
                                                        newValue
                                                            .toStringAsFixed(
                                                                0));
                                                    safeSetState(() =>
                                                        _model.sliderValue =
                                                            newValue);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 10.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            flex: 50,
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 10.0, 5.0, 0.0),
                                              child: Container(
                                                width: 100.0,
                                                height: 120.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      blurRadius: 4.0,
                                                      color: Color(0x33000000),
                                                      offset: Offset(
                                                        0.0,
                                                        2.0,
                                                      ),
                                                    )
                                                  ],
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(20.0),
                                                    bottomRight:
                                                        Radius.circular(20.0),
                                                    topLeft:
                                                        Radius.circular(20.0),
                                                    topRight:
                                                        Radius.circular(20.0),
                                                  ),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                alignment: const AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(18.0, 0.0,
                                                                18.0, 0.0),
                                                    child: TextFormField(
                                                      controller: _model
                                                          .textController3,
                                                      focusNode: _model
                                                          .textFieldFocusNode2,
                                                      autofocus: false,
                                                      obscureText: false,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            FFLocalizations.of(
                                                                    context)
                                                                .getText(
                                                          'vhvd54o9' /* Improvement */,
                                                        ),
                                                        labelStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .labelMediumFamily),
                                                                ),
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        focusedErrorBorder:
                                                            InputBorder.none,
                                                      ),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily),
                                                              ),
                                                      maxLines: 5,
                                                      minLines: 1,
                                                      validator: _model
                                                          .textController3Validator
                                                          .asValidator(context),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 50,
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      5.0, 10.0, 0.0, 0.0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  if (FFAppState()
                                                          .pageStateSchemaVariable
                                                          .isSubmittedPara ==
                                                      true) {
                                                    await showDialog(
                                                      context: context,
                                                      builder:
                                                          (alertDialogContext) {
                                                        return AlertDialog(
                                                          content: const Text(
                                                              '플래너가 이미 제출되었습니다.'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      alertDialogContext),
                                                              child: const Text('Ok'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    var confirmDialogResponse =
                                                        await showDialog<bool>(
                                                              context: context,
                                                              builder:
                                                                  (alertDialogContext) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      '플래너 제출하기'),
                                                                  content: const Text(
                                                                      '플래너를 제출하시겠습니까? 제출된 플래너는 추가 기록 및 수정이 불가합니다'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed: () => Navigator.pop(
                                                                          alertDialogContext,
                                                                          false),
                                                                      child: const Text(
                                                                          '취소'),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed: () => Navigator.pop(
                                                                          alertDialogContext,
                                                                          true),
                                                                      child: const Text(
                                                                          '제출하기'),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            ) ??
                                                            false;
                                                    if (confirmDialogResponse) {
                                                      FFAppState()
                                                          .updatePageStateSchemaVariableStruct(
                                                        (e) => e
                                                          ..goodThingsPlanner =
                                                              _model
                                                                  .textController2
                                                                  .text
                                                          ..imporovementState =
                                                              _model
                                                                  .textController3
                                                                  .text
                                                          ..archivePercentState =
                                                              _model.sliderValue
                                                          ..isSubmittedPara =
                                                              true,
                                                      );
                                                      FFAppState()
                                                          .update(() {});
                                                      if (pageeeePlannerVariableListRecord !=
                                                          null) {
                                                        await pageeeePlannerVariableListRecord
                                                            .reference
                                                            .update({
                                                          ...createPlannerVariableListRecordData(
                                                            goodThings: FFAppState()
                                                                .pageStateSchemaVariable
                                                                .goodThingsPlanner,
                                                            improvement: FFAppState()
                                                                .pageStateSchemaVariable
                                                                .imporovementState,
                                                            achivementPercentage:
                                                                FFAppState()
                                                                    .pageStateSchemaVariable
                                                                    .archivePercentState,
                                                            plannerSubmitted:
                                                                true,
                                                          ),
                                                          ...mapToFirestore(
                                                            {
                                                              'inputList':
                                                                  getPlannerInputListFirestoreData(
                                                                FFAppState()
                                                                    .pageStateSchemaVariable
                                                                    .inputListState,
                                                              ),
                                                            },
                                                          ),
                                                        });
                                                      } else {
                                                        await PlannerVariableListRecord
                                                                .createDoc(
                                                                    currentUserReference!)
                                                            .set({
                                                          ...createPlannerVariableListRecordData(
                                                            adminChecked: false,
                                                            goodThings: FFAppState()
                                                                .pageStateSchemaVariable
                                                                .goodThingsPlanner,
                                                            improvement: FFAppState()
                                                                .pageStateSchemaVariable
                                                                .imporovementState,
                                                            achivementPercentage:
                                                                valueOrDefault<
                                                                    double>(
                                                              FFAppState()
                                                                  .pageStateSchemaVariable
                                                                  .archivePercentState,
                                                              0.0,
                                                            ),
                                                            submittedDate:
                                                                FFAppState()
                                                                    .plannerDateSelected,
                                                            plannerSubmitted:
                                                                true,
                                                            basicInfo:
                                                                updateBasicUserInfoStruct(
                                                              BasicUserInfoStruct(
                                                                uid:
                                                                    currentUserReference
                                                                        ?.id,
                                                                userName:
                                                                    currentUserDisplayName,
                                                                userSeatNo: valueOrDefault(
                                                                    currentUserDocument
                                                                        ?.seatNo,
                                                                    0),
                                                                userSpot: valueOrDefault(
                                                                    currentUserDocument
                                                                        ?.spot,
                                                                    ''),
                                                              ),
                                                              clearUnsetFields:
                                                                  false,
                                                              create: true,
                                                            ),
                                                          ),
                                                          ...mapToFirestore(
                                                            {
                                                              'inputList':
                                                                  getPlannerInputListFirestoreData(
                                                                FFAppState()
                                                                    .pageStateSchemaVariable
                                                                    .inputListState,
                                                              ),
                                                            },
                                                          ),
                                                        });
                                                      }

                                                      if (FFAppState()
                                                              .insideDBStudent
                                                              .where((e) =>
                                                                  e.submittedDatePlanner ==
                                                                  FFAppState()
                                                                      .plannerDateSelected)
                                                              .toList().isNotEmpty) {
                                                        FFAppState()
                                                            .updateInsideDBStudentAtIndex(
                                                          functions.getIndexFunction(
                                                              FFAppState()
                                                                  .insideDBStudent
                                                                  .toList(),
                                                              FFAppState()
                                                                  .plannerDateSelected!),
                                                          (_) => FFAppState()
                                                              .pageStateSchemaVariable,
                                                        );
                                                        FFAppState()
                                                            .update(() {});
                                                      } else {
                                                        FFAppState()
                                                            .addToInsideDBStudent(
                                                                FFAppState()
                                                                    .pageStateSchemaVariable);
                                                        FFAppState()
                                                            .update(() {});
                                                      }

                                                      await showDialog(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title: const Text('제출완료'),
                                                            content: const Text(
                                                                '플래너가 제출되었습니다!'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext),
                                                                child:
                                                                    const Text('Ok'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  width: 100.0,
                                                  height: 120.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        blurRadius: 4.0,
                                                        color:
                                                            Color(0x33000000),
                                                        offset: Offset(
                                                          0.0,
                                                          2.0,
                                                        ),
                                                      )
                                                    ],
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(20.0),
                                                      bottomRight:
                                                          Radius.circular(20.0),
                                                      topLeft:
                                                          Radius.circular(20.0),
                                                      topRight:
                                                          Radius.circular(20.0),
                                                    ),
                                                    border: Border.all(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primaryBackground,
                                                    ),
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            valueOrDefault<
                                                                double>(
                                                              () {
                                                                if (valueOrDefault<
                                                                        bool>(
                                                                      FFAppState()
                                                                          .pageStateSchemaVariable
                                                                          .isSubmittedPara,
                                                                      false,
                                                                    ) &&
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .adminCheckedPara) {
                                                                  return -1.0;
                                                                } else if (valueOrDefault<
                                                                        bool>(
                                                                      FFAppState()
                                                                          .pageStateSchemaVariable
                                                                          .isSubmittedPara,
                                                                      false,
                                                                    ) &&
                                                                    !FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .adminCheckedPara) {
                                                                  return -1.0;
                                                                } else {
                                                                  return 0.0;
                                                                }
                                                              }(),
                                                              0.0,
                                                            ),
                                                            0.0),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  valueOrDefault<
                                                                      double>(
                                                                    () {
                                                                      if (valueOrDefault<
                                                                              bool>(
                                                                            FFAppState().pageStateSchemaVariable.isSubmittedPara,
                                                                            false,
                                                                          ) &&
                                                                          FFAppState()
                                                                              .pageStateSchemaVariable
                                                                              .adminCheckedPara) {
                                                                        return 20.0;
                                                                      } else if (valueOrDefault<
                                                                              bool>(
                                                                            FFAppState().pageStateSchemaVariable.isSubmittedPara,
                                                                            false,
                                                                          ) &&
                                                                          !FFAppState()
                                                                              .pageStateSchemaVariable
                                                                              .adminCheckedPara) {
                                                                        return 20.0;
                                                                      } else {
                                                                        return 0.0;
                                                                      }
                                                                    }(),
                                                                    0.0,
                                                                  ),
                                                                  0.0,
                                                                  valueOrDefault<
                                                                      double>(
                                                                    () {
                                                                      if (valueOrDefault<
                                                                              bool>(
                                                                            FFAppState().pageStateSchemaVariable.isSubmittedPara,
                                                                            false,
                                                                          ) &&
                                                                          FFAppState()
                                                                              .pageStateSchemaVariable
                                                                              .adminCheckedPara) {
                                                                        return 20.0;
                                                                      } else if (valueOrDefault<
                                                                              bool>(
                                                                            FFAppState().pageStateSchemaVariable.isSubmittedPara,
                                                                            false,
                                                                          ) &&
                                                                          !FFAppState()
                                                                              .pageStateSchemaVariable
                                                                              .adminCheckedPara) {
                                                                        return 20.0;
                                                                      } else {
                                                                        return 0.0;
                                                                      }
                                                                    }(),
                                                                    0.0,
                                                                  ),
                                                                  0.0),
                                                      child: Text(
                                                        () {
                                                          if ((valueOrDefault<
                                                                      bool>(
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .isSubmittedPara,
                                                                    false,
                                                                  ) ==
                                                                  true) &&
                                                              (valueOrDefault<
                                                                      bool>(
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .adminCheckedPara,
                                                                    false,
                                                                  ) ==
                                                                  true)) {
                                                            return valueOrDefault<
                                                                String>(
                                                              FFAppState()
                                                                  .pageStateSchemaVariable
                                                                  .teacherquoteState,
                                                              '고생하셨습니다!',
                                                            );
                                                          } else if ((valueOrDefault<
                                                                      bool>(
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .isSubmittedPara,
                                                                    false,
                                                                  ) ==
                                                                  true) &&
                                                              (valueOrDefault<
                                                                      bool>(
                                                                    FFAppState()
                                                                        .pageStateSchemaVariable
                                                                        .adminCheckedPara,
                                                                    false,
                                                                  ) ==
                                                                  false)) {
                                                            return '플래너가 제출되었습니다!';
                                                          } else {
                                                            return '플래너 제출하기';
                                                          }
                                                        }(),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMediumFamily),
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
