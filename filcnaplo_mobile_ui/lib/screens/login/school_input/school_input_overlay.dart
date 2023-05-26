import 'package:flutter/material.dart';
import 'school_input_overlay.i18n.dart';

class SchoolInputOverlay {
  OverlayEntry? entry;
  final LayerLink layerLink;
  List<Widget>? children;

  SchoolInputOverlay({required this.layerLink});

  void createOverlayEntry(BuildContext context) {
    entry = OverlayEntry(builder: (_) => buildOverlayEntry(context));
    Overlay.of(context).insert(entry!);
  }

  Widget buildOverlayEntry(BuildContext context) {
    RenderBox renderBox = context.findRenderObject()! as RenderBox;
    var size = renderBox.size;
    return SchoolInputOverlayWidget(
      children: children,
      size: size,
      layerLink: layerLink,
    );
  }
}

class SchoolInputOverlayWidget extends StatelessWidget {
  const SchoolInputOverlayWidget({
    Key? key,
    required this.children,
    required this.size,
    required this.layerLink,
  }) : super(key: key);

  final Size size;
  final List<Widget>? children;
  final LayerLink layerLink;

  @override
  Widget build(BuildContext context) {
    return children != null
        ? Positioned(
            width: size.width,
            height: (children?.length ?? 0) > 0 ? 150.0 : 50.0,
            child: CompositedTransformFollower(
              link: layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, size.height + 5.0),
              child: Material(
                color: Theme.of(context).colorScheme.background,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                elevation: 4.0,
                shadowColor: Colors.black,
                child: (children?.length ?? 0) > 0
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: children?.length ?? 0,
                        itemBuilder: (context, index) {
                          return children?[index] ?? Container();
                        },
                      )
                    : Center(
                        child: Text("noresults".i18n),
                      ),
              ),
            ),
          )
        : Container();
  }
}
