import 'package:filcnaplo_mobile_ui/screens/login/login_input.dart';
import 'package:filcnaplo_mobile_ui/screens/login/school_input/school_input_overlay.dart';
import 'package:filcnaplo_mobile_ui/screens/login/school_input/school_input_tile.dart';
import 'package:filcnaplo_mobile_ui/screens/login/school_input/school_search.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo_kreta_api/models/school.dart';

class SchoolInput extends StatefulWidget {
  const SchoolInput({Key? key, required this.controller, required this.scroll}) : super(key: key);

  final SchoolInputController controller;
  final ScrollController scroll;

  @override
  _SchoolInputState createState() => _SchoolInputState();
}

class _SchoolInputState extends State<SchoolInput> {
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();
  late SchoolInputOverlay overlay;

  @override
  void initState() {
    super.initState();

    widget.controller.update = (fn) {
      if (mounted) setState(fn);
    };

    overlay = SchoolInputOverlay(layerLink: _layerLink);

    // Show school list when focused
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) => overlay.createOverlayEntry(context));
        Future.delayed(const Duration(milliseconds: 100)).then((value) {
          if (mounted && widget.scroll.hasClients) {
            widget.scroll.animateTo(widget.scroll.offset + 500, duration: const Duration(milliseconds: 500), curve: Curves.ease);
          }
        });
      } else {
        overlay.entry?.remove();
      }
    });

    // LoginInput TextField listener
    widget.controller.textController.addListener(() {
      String text = widget.controller.textController.text;
      if (text.isEmpty) {
        overlay.children = null;
        return;
      }

      List<School> results = searchSchools(widget.controller.schools ?? [], text);
      setState(() {
        overlay.children = results
            .map((School e) => SchoolInputTile(
                  school: e,
                  onTap: () => _selectSchool(e),
                ))
            .toList();
      });
      Overlay.of(context).setState(() {});
    });
  }

  void _selectSchool(School school) {
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      widget.controller.selectedSchool = school;
      widget.controller.textController.text = school.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: widget.controller.schools == null
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Center(
                child: SizedBox(
                  height: 28.0,
                  width: 28.0,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : LoginInput(
              style: LoginInputStyle.school,
              focusNode: _focusNode,
              onClear: () {
                widget.controller.selectedSchool = null;
                FocusScope.of(context).requestFocus(_focusNode);
              },
              controller: widget.controller.textController,
            ),
    );
  }
}

class SchoolInputController {
  final textController = TextEditingController();
  School? selectedSchool;
  List<School>? schools;
  late void Function(void Function()) update;
}
