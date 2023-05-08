import 'package:flutter/material.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/utils/size_config.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFviewer extends StatelessWidget {
  const PDFviewer({Key? key, required this.pdfURL, required this.title})
      : super(key: key);
  final String pdfURL, title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor:kPrimaryColor,
          elevation: 0,
          title: Text(
            title,
            style: TextStyle(
                fontSize: SizeConfig.textMultiplier * 2.2,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
        ),
        body: SfPdfViewer.network(pdfURL));
  }
}
