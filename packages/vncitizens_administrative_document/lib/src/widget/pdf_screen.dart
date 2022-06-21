import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:developer' as dev;

import 'package:vncitizens_common/vncitizens_common.dart' show CommonUtil;

class PDFScreen extends StatefulWidget {
  const PDFScreen({Key? key, required this.url, required this.filename}) : super(key: key);

  final String url;
  final String filename;

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool loaded = false;
  bool failed = false;
  String? error;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dev.log("Loading PDF from url: ${widget.url}", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filename, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: Stack(
        children: [
          SfPdfViewer.network(
            widget.url,
            key: _pdfViewerKey,
            onDocumentLoaded: (PdfDocumentLoadedDetails detail) {
              setState(() {
                loaded = true;
              });
            },
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails detail) {
              dev.log("Load PDF failed", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
              setState(() {
                loaded = true;
                failed = true;
                error = detail.description;
              });
            },
          ),
          loaded ? const SizedBox() : const Positioned.fill(child: Center(child: CircularProgressIndicator())),
          failed == false ? const SizedBox(): Positioned.fill(child: Center(child: Text(error ?? "da xay ra loi"),))
        ],
      ),
    );
  }
}
