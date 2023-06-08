import 'package:flutter/material.dart';
import 'pages/grades_page.dart';

class SummaryScreen extends StatefulWidget {
  final String currentPage;

  const SummaryScreen({Key? key, this.currentPage = 'personality'})
      : super(key: key);

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final LinearGradient _backgroundGradient = const LinearGradient(
    colors: [
      Color(0xff1d56ac),
      Color(0xff170a3d),
    ],
    begin: Alignment(-0.8, -1.0),
    end: Alignment(0.8, 1.0),
    stops: [-1.0, 1.0],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: _backgroundGradient),
        child: Container(
          decoration: BoxDecoration(gradient: _backgroundGradient),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 26.0 + MediaQuery.of(context).padding.top,
                bottom: 52.0,
              ),
              child: widget.currentPage == 'grades'
                  ? const GradesBody()
                  : widget.currentPage == 'lessons'
                      ? const GradesBody()
                      : widget.currentPage == 'allsum'
                          ? const GradesBody()
                          : const GradesBody(),
            ),
          ),
        ),
      ),
    );
  }
}
