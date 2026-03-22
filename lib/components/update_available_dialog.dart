import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAvailableDialog extends StatefulWidget {
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
  State<UpdateAvailableDialog> createState() => _UpdateAvailableDialogState();
}

class _UpdateAvailableDialogState extends State<UpdateAvailableDialog> {
  bool _isUpdateFocused = false;
  bool _isLaterFocused = false;

  @override
  Widget build(BuildContext context) {
    debugPrint(
        'UpdateAvailableDialog: Build ejecutado. Focus: Update($_isUpdateFocused), Later($_isLaterFocused)');
    return AlertDialog(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      title: Text(
        'New Update Available!',
        style: FlutterFlowTheme.of(context).headlineSmall,
      ),
      content: Text(
        'A new version (${widget.latestVersion}) is available. Please update now to enjoy the latest improvements and fixes.',
        style: FlutterFlowTheme.of(context).bodyMedium,
      ),
      actions: [
        if (!widget.forceUpdate)
          Focus(
            canRequestFocus: false,
            onFocusChange: (hasFocus) =>
                setState(() => _isLaterFocused = hasFocus),
            child: FFButtonWidget(
              onPressed: () => Navigator.pop(context),
              text: 'Later',
              options: FFButtonOptions(
                width: 130.0,
                height: 40.0,
                color: _isLaterFocused
                    ? const Color(0xFFE2E8F0)
                    : FlutterFlowTheme.of(context).alternate,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Inter Tight',
                      color: FlutterFlowTheme.of(context).primaryText,
                      useGoogleFonts: false,
                    ),
                elevation: _isLaterFocused ? 8.0 : 2.0,
                borderSide: BorderSide(
                  color: _isLaterFocused
                      ? FlutterFlowTheme.of(context).primary
                      : Colors.transparent,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        Focus(
          canRequestFocus: false,
          onFocusChange: (hasFocus) =>
              setState(() => _isUpdateFocused = hasFocus),
          child: FFButtonWidget(
            onPressed: () async {
              final Uri url = Uri.parse(widget.storeUrl);
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
              height: 45.0,
              color: _isUpdateFocused
                  ? const Color(0xFF6F61EF) // Morado claro (Foco)
                  : const Color(0xFF3A2DBE), // Morado oscuro (Normal)
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Inter Tight',
                    color: Colors.white,
                    useGoogleFonts: false,
                  ),
              elevation: _isUpdateFocused ? 12.0 : 4.0,
              borderSide: BorderSide(
                color: _isUpdateFocused ? Colors.white : Colors.transparent,
                width: 3.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }
}
