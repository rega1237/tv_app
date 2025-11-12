// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/services.dart';

import 'dart:math' as math;

class FocusableHighlightBox extends StatefulWidget {
  const FocusableHighlightBox({
    Key? key,
    this.width,
    this.height,
    this.iconName,
    this.iconSize = 30.0,
    this.textLabel,
    this.fontSize = 14.0,
    this.normalColor,
    this.focusColor,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.focusIconTextColor,
    this.onTapAction,
    this.autofocus = false,
    this.rotate = false,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? iconName;
  final double iconSize;
  final String? textLabel;
  final double fontSize;
  final Color? normalColor;
  final Color? focusColor;
  final Color textColor;
  final Color iconColor;
  final Color? focusIconTextColor;
  final Future<dynamic> Function()? onTapAction;
  final bool autofocus;
  final bool rotate;

  @override
  _FocusableHighlightBoxState createState() => _FocusableHighlightBoxState();
}

class _FocusableHighlightBoxState extends State<FocusableHighlightBox> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isFocused = _focusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(() {});
    _focusNode.dispose();
    super.dispose();
  }

  IconData _getIconData(String? iconName) {
    if (iconName == null) return Icons.help;
    switch (iconName.toLowerCase()) {
      case 'play_arrow':
        return Icons.play_arrow;
      case 'pause':
        return Icons.pause;
      case 'stop':
        return Icons.stop;
      case 'home':
        return Icons.home;
      case 'search':
        return Icons.search;
      case 'settings':
        return Icons.settings;
      case 'favorite':
        return Icons.favorite;
      case 'info':
        return Icons.info;
      case 'live_tv':
        return Icons.live_tv;
      default:
        return Icons.help;
    }
  }

  void _handleTap() {
    if (widget.onTapAction != null) {
      widget.onTapAction!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color currentBackgroundColor = _isFocused
        ? (widget.focusColor ?? Theme.of(context).focusColor)
        : (widget.normalColor ?? Theme.of(context).cardColor);

    final IconData currentIconData = _getIconData(widget.iconName);

    final Color currentIconColor = _isFocused
        ? (widget.focusIconTextColor ?? widget.iconColor)
        : widget.iconColor;

    final Color currentTextColor = _isFocused
        ? (widget.focusIconTextColor ?? widget.textColor)
        : widget.textColor;

    final double rotationAngle = widget.rotate ? (math.pi / 2) : 0;

    return FocusableActionDetector(
      autofocus: widget.autofocus,
      focusNode: _focusNode,
      onFocusChange: (bool hasFocus) {
        if (mounted) {
          setState(() {
            _isFocused = hasFocus;
          });
        }
      },
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (ActivateIntent intent) => _handleTap(),
        ),
      },
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(color: currentBackgroundColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.rotate(
                angle: rotationAngle,
                child: Icon(
                  currentIconData,
                  size: widget.iconSize,
                  color: currentIconColor,
                ),
              ),
              if (widget.textLabel != null) SizedBox(height: 8),
              if (widget.textLabel != null)
                Text(
                  widget.textLabel!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: currentTextColor,
                    fontSize: widget.fontSize,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
