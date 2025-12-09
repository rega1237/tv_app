import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/nav/nav.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class PdfMenuPageWidget extends StatefulWidget {
  const PdfMenuPageWidget({super.key, this.pdfFiles});

  final List<FilesRecord>? pdfFiles;

  static const String routeName = 'PdfMenuPage';
  static const String routePath = '/pdfMenu';

  @override
  State<PdfMenuPageWidget> createState() => _PdfMenuPageWidgetState();
}

class _PdfMenuPageWidgetState extends State<PdfMenuPageWidget> {
  String? _localPath;
  PDFViewController? _controller;
  int _pages = 0;
  int _currentPage = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _preparePdf();
  }

  Future<void> _preparePdf() async {
    final files = widget.pdfFiles ?? [];
    if (files.isEmpty) {
      setState(() {
        _loading = false;
      });
      return;
    }
    final first = files.first;
    final url = _resolvePdfUrl(first);
    if (url.isEmpty) {
      setState(() {
        _loading = false;
      });
      return;
    }
    try {
      final file = await DefaultCacheManager().getSingleFile(url);
      if (!mounted) return;
      setState(() {
        _localPath = file.path;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  String _resolvePdfUrl(FilesRecord f) {
    if (f.fileUrlGeneric.toLowerCase().endsWith('.pdf')) return f.fileUrlGeneric;
    if (f.fileUrl.toLowerCase().endsWith('.pdf')) return f.fileUrl;
    if (f.fileType.toLowerCase().contains('pdf')) return f.fileUrlGeneric.isNotEmpty ? f.fileUrlGeneric : f.fileUrl;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      backgroundColor: Colors.black,
      body: _buildBody(),
    );
    return WillPopScope(
      onWillPop: () async {
        context.goNamedAuth(InicioWidget.routeName, mounted);
        return false;
      },
      child: scaffold,
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_localPath == null || _localPath!.isEmpty) {
      return Center(
        child: Text(
          'No hay PDF disponible.',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
                color: Colors.white,
                fontSize: 20,
              ),
        ),
      );
    }
    return Stack(
      children: [
        PDFView(
          filePath: _localPath!,
          enableSwipe: true,
          swipeHorizontal: true,
          pageSnap: true,
          pageFling: true,
          onRender: (pages) {
            setState(() {
              _pages = pages ?? _pages;
            });
          },
          onViewCreated: (controller) {
            _controller = controller;
          },
          onPageChanged: (page, total) {
            setState(() {
              _currentPage = page ?? _currentPage;
              _pages = total ?? _pages;
            });
          },
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: (_controller != null && _currentPage > 0)
                    ? () {
                        _controller!.setPage(_currentPage - 1);
                      }
                    : null,
                child: const Icon(Icons.chevron_left),
              ),
              Text(
                _pages > 0 ? '${_currentPage + 1}/$_pages' : '',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              ElevatedButton(
                onPressed: (_controller != null && _currentPage + 1 < _pages)
                    ? () {
                        _controller!.setPage(_currentPage + 1);
                      }
                    : null,
                child: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        )
      ],
    );
  }
}
