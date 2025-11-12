// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math' as math;

class VerticalFocusGrid extends StatefulWidget {
  const VerticalFocusGrid({
    Key? key,
    this.width,
    this.height,
    this.iconName = 'live_tv',
    this.iconSize = 30.0,
    this.fontSize = 14.0,
    this.normalColor,
    this.focusColor,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.focusIconTextColor,
    this.crossAxisCount = 3,
    this.crossAxisSpacing = 10.0,
    this.mainAxisSpacing = 10.0,
    this.childAspectRatio = 1.0,
    this.items = const [],
    this.onItemTap,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String iconName;
  final double iconSize;
  final double fontSize;
  final Color? normalColor;
  final Color? focusColor;
  final Color textColor;
  final Color iconColor;
  final Color? focusIconTextColor;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final List<dynamic> items;
  final Future<dynamic> Function(dynamic itemData)? onItemTap;

  @override
  State<VerticalFocusGrid> createState() => _VerticalFocusGridState();
}

class _VerticalFocusGridState extends State<VerticalFocusGrid> {
  List<FocusNode> _focusNodes = [];
  int _currentFocusIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeFocusNodes();
  }

  @override
  void didUpdateWidget(VerticalFocusGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items.length != _focusNodes.length) {
      _initializeFocusNodes();
    }
  }

  void _initializeFocusNodes() {
    // Dispose old focus nodes
    for (final node in _focusNodes) {
      node.dispose();
    }

    // Create new focus nodes
    final itemsCount = widget.items.isNotEmpty ? widget.items.length : 6;
    _focusNodes = List.generate(
      itemsCount,
      (index) => FocusNode(
        debugLabel: 'Item $index',
                            onKey: (node, event) {
                              if (event is! RawKeyDownEvent) return KeyEventResult.ignored;
                  
                              final itemsCount =
                                  widget.items.isNotEmpty ? widget.items.length : 6;
                              int newIndex = index;
                  
                              // Linear navigation: Up/Left for previous, Down/Right for next.
                              if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
                                  event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                                newIndex = _getPreviousIndex(index);
                              } else if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
                                  event.logicalKey == LogicalKeyboardKey.arrowRight) {
                                newIndex = _getNextIndex(index, itemsCount);
                              } else if (event.logicalKey == LogicalKeyboardKey.enter ||
                                  event.logicalKey == LogicalKeyboardKey.select) {
                                _handleItemTap(index);
                                return KeyEventResult.handled;
                              }
                  
                              if (newIndex != index) {
                                _focusNodes[newIndex].requestFocus();
                                _currentFocusIndex = newIndex;
                                return KeyEventResult.handled;
                              }
                  
                              return KeyEventResult.ignored;
                            },
                          ));
                  
                      if (_focusNodes.isNotEmpty) {
                        // Request focus in a post-frame callback to ensure the widget is built.
                        WidgetsBinding.instance
                            .addPostFrameCallback((_) => _focusNodes[0].requestFocus());
                      }
                    }
                  
                    int _getNextIndex(int currentIndex, int itemsCount) {
                      final newIndex = currentIndex + 1;
                      return newIndex < itemsCount ? newIndex : currentIndex;
                    }
                  
                    int _getPreviousIndex(int currentIndex) {
                      final newIndex = currentIndex - 1;
                      return newIndex >= 0 ? newIndex : currentIndex;
                    }
  void _handleItemTap(int index) {
    if (widget.onItemTap != null) {
      final item = widget.items.isNotEmpty
          ? widget.items[index]
          : {'name': 'Item ${index + 1}', 'vertical': false};
      widget.onItemTap!(item);
    }
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _buildGrid(),
    );
  }

  Widget _buildGrid() {
    final itemsToUse = widget.items.isNotEmpty
        ? widget.items
        : [
            {'name': 'Deportes', 'vertical': false},
            {'name': 'Noticias', 'vertical': true},
            {'name': 'Cine', 'vertical': false},
            {'name': 'Música', 'vertical': true},
            {'name': 'Kids', 'vertical': false},
            {'name': 'Docs', 'vertical': true},
          ];

    if (itemsToUse.isEmpty) {
      return Center(
        child: Text(
          'No hay canales disponibles',
          style: TextStyle(color: widget.textColor),
        ),
      );
    }

    return GridView.builder(
      itemCount: itemsToUse.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: widget.crossAxisSpacing,
        mainAxisSpacing: widget.mainAxisSpacing,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemBuilder: (context, index) {
        final item = itemsToUse[index];

        // Extraer datos del item
        final String? label = _extractLabel(item);
        final bool shouldRotateIcon = _extractVertical(item);

        return _FocusableItem(
          focusNode: _focusNodes[index],
          autofocus: index == 0,
          iconName: widget.iconName,
          textLabel: label,
          onTapAction: () => _handleItemTap(index),
          iconSize: widget.iconSize,
          fontSize: widget.fontSize,
          normalColor: widget.normalColor,
          focusColor: widget.focusColor,
          textColor: widget.textColor,
          iconColor: widget.iconColor,
          focusIconTextColor: widget.focusIconTextColor,
          rotate: shouldRotateIcon,
        );
      },
    );
  }

  // Función para extraer el label de diferentes tipos de datos
  String? _extractLabel(dynamic item) {
    if (item is Map<String, dynamic>) {
      return item['name']?.toString();
    }
    // Si es un ChannelsRecord de FlutterFlow
    else if (item != null && item is! String && item is! num && item is! bool) {
      try {
        // Intentar acceder a la propiedad 'name'
        final dynamic nameValue = _getProperty(item, 'name');
        return nameValue?.toString();
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Función para extraer el valor vertical
  bool _extractVertical(dynamic item) {
    if (item is Map<String, dynamic>) {
      return item['vertical'] == true;
    }
    // Si es un ChannelsRecord de FlutterFlow
    else if (item != null && item is! String && item is! num && item is! bool) {
      try {
        // Intentar acceder a la propiedad 'vertical'
        final dynamic verticalValue = _getProperty(item, 'vertical');
        if (verticalValue is bool) return verticalValue;
        if (verticalValue is String)
          return verticalValue.toLowerCase() == 'true';
        if (verticalValue is num) return verticalValue == 1;
        return false;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  // Función genérica para obtener propiedades de objetos
  dynamic _getProperty(dynamic obj, String propertyName) {
    try {
      // Para objetos que tienen el método .toMap()
      if (obj != null) {
        try {
          if (obj is Map) {
            return obj[propertyName];
          }
        } catch (e) {
          // Ignorar error
        }

        // Intentar acceso directo mediante reflection
        try {
          return (obj as dynamic).get(propertyName);
        } catch (e) {
          // Ignorar error
        }

        // Intentar acceso como propiedad
        try {
          switch (propertyName) {
            case 'name':
              return (obj as dynamic).name;
            case 'vertical':
              return (obj as dynamic).vertical;
            default:
              return null;
          }
        } catch (e) {
          return null;
        }
      }
    } catch (e) {
      print('Error getting property $propertyName: $e');
    }
    return null;
  }
}

class _FocusableItem extends StatefulWidget {
  const _FocusableItem({
    Key? key,
    required this.focusNode,
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

  final FocusNode focusNode;
  final String? iconName;
  final double iconSize;
  final String? textLabel;
  final double fontSize;
  final Color? normalColor;
  final Color? focusColor;
  final Color textColor;
  final Color iconColor;
  final Color? focusIconTextColor;
  final VoidCallback? onTapAction;
  final bool autofocus;
  final bool rotate;

  @override
  State<_FocusableItem> createState() => __FocusableItemState();
}

class __FocusableItemState extends State<_FocusableItem> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isFocused = widget.focusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(() {});
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
      case 'music_note':
        return Icons.music_note;
      case 'movie':
        return Icons.movie;
      case 'sports':
        return Icons.sports_baseball;
      case 'news':
        return Icons.article;
      case 'tv':
        return Icons.tv;
      case 'theaters':
        return Icons.theaters;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'child_care':
        return Icons.child_care;
      case 'school':
        return Icons.school;
      default:
        return Icons.help;
    }
  }

  void _handleTap() {
    widget.onTapAction?.call();
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

    return Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: currentBackgroundColor,
            borderRadius: BorderRadius.circular(8.0),
            border: _isFocused
                ? Border.all(color: currentTextColor, width: 2)
                : null,
          ),
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
                    fontWeight:
                        _isFocused ? FontWeight.bold : FontWeight.normal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
