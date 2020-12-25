import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:ungfunny/models/ebook_model.dart';

class ReadPdf extends StatefulWidget {
  final EbookModel ebookModel;
  ReadPdf({Key key, this.ebookModel}) : super(key: key);
  @override
  _ReadPdfState createState() => _ReadPdfState();
}

class _ReadPdfState extends State<ReadPdf> {
  EbookModel model;
  PDFDocument pdfDocument;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    model = widget.ebookModel;
    print('Ebook on Read => ${model.name}');

    if (model != null) {
      loadPDF();
    }
  }

  Future<Null> loadPDF() async {
    try {
      var result = await PDFDocument.fromURL(model.pdf);
      setState(() {
        pdfDocument = result;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read Ebook'),
      ),
      body: pdfDocument == null
          ? Center(child: CircularProgressIndicator())
          : PDFViewer(document: pdfDocument),
    );
  }
}
