import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/format.dart';

class HeroScrollView extends StatefulWidget {
  const HeroScrollView(
      {Key? key,
      required this.child,
      required this.title,
      required this.icon,
      this.italic = false,
      this.navBarItems = const [],
      this.onClose,
      this.iconSize = 64.0,
      this.scrollController})
      : super(key: key);

  final Widget child;
  final String title;
  final IconData? icon;
  final List<Widget> navBarItems;
  final VoidCallback? onClose;
  final double iconSize;
  final ScrollController? scrollController;
  final bool italic;

  @override
  _HeroScrollViewState createState() => _HeroScrollViewState();
}

class _HeroScrollViewState extends State<HeroScrollView> {
  late ScrollController _scrollController;

  bool showBarTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset > 42.0) {
        if (showBarTitle == false) setState(() => showBarTitle = true);
      } else {
        if (showBarTitle == true) setState(() => showBarTitle = false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      headerSliverBuilder: (context, _) => [
        SliverAppBar(
          pinned: true,
          floating: false,
          snap: false,
          centerTitle: false,
          titleSpacing: 0,
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
          title: AnimatedOpacity(
              opacity: showBarTitle ? 1.0 : 0.0,
              child: Row(
                children: [
                  Icon(widget.icon, color: AppColors.of(context).text.withOpacity(.8)),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      widget.title.capital(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          color: AppColors.of(context).text, fontWeight: FontWeight.w500, fontStyle: widget.italic ? FontStyle.italic : null),
                    ),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 200)),
          leading: BackButton(
              color: AppColors.of(context).text,
              onPressed: () {
                if (widget.onClose != null) {
                  widget.onClose!();
                } else {
                  Navigator.of(context).pop();
                }
              }),
          actions: widget.navBarItems,
          expandedHeight: 124.0,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              children: [
                Center(
                  child: Icon(
                    widget.icon,
                    size: widget.iconSize,
                    color: AppColors.of(context).text.withOpacity(.15),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 82),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    widget.title.capital(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 36.0,
                        color: AppColors.of(context).text.withOpacity(.9),
                        fontStyle: widget.italic ? FontStyle.italic : null,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      body: widget.child,
    );
  }
}
