import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'settings1_notifications_model.dart';
export 'settings1_notifications_model.dart';

class Settings1NotificationsWidget extends StatefulWidget {
  const Settings1NotificationsWidget({super.key});

  @override
  State<Settings1NotificationsWidget> createState() =>
      _Settings1NotificationsWidgetState();
}

class _Settings1NotificationsWidgetState
    extends State<Settings1NotificationsWidget> {
  late Settings1NotificationsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Settings1NotificationsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: responsiveVisibility(
        context: context,
        phone: false,
        tablet: false,
      )
          ? AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              leading: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                buttonSize: 46.0,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF14181B),
                  size: 25.0,
                ),
                onPressed: () async {
                  context.pop();
                },
              ),
              title: Text(
                FFLocalizations.of(context).getText(
                  '6s11dqjv' /* Settings Page */,
                ),
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: 'Outfit',
                      color: const Color(0xFF14181B),
                      fontSize: 24.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                      useGoogleFonts: GoogleFonts.asMap().containsKey('Outfit'),
                    ),
              ),
              actions: const [],
              centerTitle: false,
              elevation: 0.0,
            )
          : null,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(
                    FFLocalizations.of(context).getText(
                      '8zzszftr' /* Choose what notifcations you w... */,
                    ),
                    style: FlutterFlowTheme.of(context).labelMedium.override(
                          fontFamily: 'Plus Jakarta Sans',
                          color: const Color(0xFF57636C),
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.normal,
                          useGoogleFonts: GoogleFonts.asMap()
                              .containsKey('Plus Jakarta Sans'),
                        ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
            child: Material(
              color: Colors.transparent,
              child: SwitchListTile.adaptive(
                value: _model.switchListTileValue1 ??= true,
                onChanged: (newValue) async {
                  safeSetState(() => _model.switchListTileValue1 = newValue);
                },
                title: Text(
                  FFLocalizations.of(context).getText(
                    'o3p16zui' /* Push Notifications */,
                  ),
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: const Color(0xFF14181B),
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.normal,
                        useGoogleFonts: GoogleFonts.asMap()
                            .containsKey('Plus Jakarta Sans'),
                        lineHeight: 2.0,
                      ),
                ),
                subtitle: Text(
                  FFLocalizations.of(context).getText(
                    'g67aklao' /* Receive Push notifications fro... */,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: const Color(0xFF8B97A2),
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.normal,
                        useGoogleFonts: GoogleFonts.asMap()
                            .containsKey('Plus Jakarta Sans'),
                      ),
                ),
                tileColor: Colors.white,
                activeColor: const Color(0xFF4B39EF),
                activeTrackColor: const Color(0x4C4B39EF),
                dense: false,
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 12.0),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: SwitchListTile.adaptive(
              value: _model.switchListTileValue2 ??= true,
              onChanged: (newValue) async {
                safeSetState(() => _model.switchListTileValue2 = newValue);
              },
              title: Text(
                FFLocalizations.of(context).getText(
                  'lo96ey9k' /* Email Notifications */,
                ),
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Plus Jakarta Sans',
                      color: const Color(0xFF14181B),
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.normal,
                      useGoogleFonts:
                          GoogleFonts.asMap().containsKey('Plus Jakarta Sans'),
                      lineHeight: 2.0,
                    ),
              ),
              subtitle: Text(
                FFLocalizations.of(context).getText(
                  'xnvktf2s' /* Receive email notifications fr... */,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Plus Jakarta Sans',
                      color: const Color(0xFF8B97A2),
                      fontSize: 14.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.normal,
                      useGoogleFonts:
                          GoogleFonts.asMap().containsKey('Plus Jakarta Sans'),
                    ),
              ),
              tileColor: Colors.white,
              activeColor: const Color(0xFF4B39EF),
              activeTrackColor: const Color(0x4C4B39EF),
              dense: false,
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding:
                  const EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 12.0),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: SwitchListTile.adaptive(
              value: _model.switchListTileValue3 ??= true,
              onChanged: (newValue) async {
                safeSetState(() => _model.switchListTileValue3 = newValue);
              },
              title: Text(
                FFLocalizations.of(context).getText(
                  'vgcm1uoc' /* Location Services */,
                ),
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Plus Jakarta Sans',
                      color: const Color(0xFF14181B),
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.normal,
                      useGoogleFonts:
                          GoogleFonts.asMap().containsKey('Plus Jakarta Sans'),
                      lineHeight: 2.0,
                    ),
              ),
              subtitle: Text(
                FFLocalizations.of(context).getText(
                  'wswdulbv' /* Allow us to track your locatio... */,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Plus Jakarta Sans',
                      color: const Color(0xFF8B97A2),
                      fontSize: 14.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.normal,
                      useGoogleFonts:
                          GoogleFonts.asMap().containsKey('Plus Jakarta Sans'),
                    ),
              ),
              tileColor: Colors.white,
              activeColor: const Color(0xFF4B39EF),
              activeTrackColor: const Color(0x4C4B39EF),
              dense: false,
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding:
                  const EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 12.0),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
            child: FFButtonWidget(
              onPressed: () async {
                context.pop();
              },
              text: FFLocalizations.of(context).getText(
                'wltnhq1t' /* Change Changes */,
              ),
              options: FFButtonOptions(
                width: 190.0,
                height: 50.0,
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: const Color(0xFF4B39EF),
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Colors.white,
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                      useGoogleFonts:
                          GoogleFonts.asMap().containsKey('Plus Jakarta Sans'),
                    ),
                elevation: 3.0,
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
