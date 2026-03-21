import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAvailableDialog extends StatelessWidget {
  const UpdateAvailableDialog({
    super.key,
    required this.latestVersion,
    required this.storeUrl,
    required this.forceUpdate,
  });

  final String latestVersion;
  final String storeUrl;
  final bool forceUpdate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      title: Text(
        'New Update Available!',
        style: FlutterFlowTheme.of(context).headlineSmall,
      ),
      content: Text(
        'A new version ($latestVersion) is available. Please update now to enjoy the latest improvements and fixes.',
        style: FlutterFlowTheme.of(context).bodyMedium,
      ),
      actions: [
        if (!forceUpdate)
          FFButtonWidget(
            onPressed: () => Navigator.pop(context),
            text: 'Later',
            options: FFButtonOptions(
              width: 130.0,
              height: 40.0,
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              iconPadding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: FlutterFlowTheme.of(context).alternate,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Inter Tight',
                    color: FlutterFlowTheme.of(context).primaryText,
                    useGoogleFonts: false,
                  ),
              elevation: 3.0,
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        FFButtonWidget(
          onPressed: () async {
            final Uri url = Uri.parse(storeUrl);
            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
              // Fallback if URL cannot be launched
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not open the store.')),
                );
              }
            }
          },
          text: 'Update now',
          options: FFButtonOptions(
            width: 150.0,
            height: 40.0,
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            iconPadding:
                const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            color: FlutterFlowTheme.of(context).primary,
            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                  fontFamily: 'Inter Tight',
                  color: Colors.white,
                  useGoogleFonts: false,
                ),
            elevation: 3.0,
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ],
    );
  }
}
