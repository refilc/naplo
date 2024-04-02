import 'package:flutter_svg/svg.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:refilc/theme/colors/utils.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc_mobile_ui/common/round_border_icon.dart';

class HeroScrollView extends StatefulWidget {
  const HeroScrollView({
    super.key,
    required this.child,
    required this.title,
    required this.icon,
    this.italic = false,
    this.navBarItems = const [],
    this.onClose,
    this.iconSize = 64.0,
    this.scrollController,
    this.showTitleUnscroll = true,
  });

  final Widget child;
  final String title;
  final IconData? icon;
  final List<Widget> navBarItems;
  final VoidCallback? onClose;
  final double iconSize;
  final ScrollController? scrollController;
  final bool italic;
  final bool showTitleUnscroll;

  @override
  HeroScrollViewState createState() => HeroScrollViewState();
}

class HeroScrollViewState extends State<HeroScrollView> {
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
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
              duration: const Duration(milliseconds: 200),
              child: Row(
                children: [
                  Icon(widget.icon,
                      color: AppColors.of(context).text.withOpacity(.8)),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      widget.title.capital(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          color: AppColors.of(context).text,
                          fontWeight: FontWeight.w500,
                          fontStyle: widget.italic ? FontStyle.italic : null),
                    ),
                  ),
                ],
              )),
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
          expandedHeight: 165.69,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 26.0),
                      child: SvgPicture.asset(
                        "assets/svg/mesh_bg.svg",
                        // ignore: deprecated_member_use
                        color: ColorsUtils()
                            .darken(
                              Theme.of(context).colorScheme.primary,
                              amount: 0.4,
                            )
                            .withOpacity(0.4),
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).scaffoldBackgroundColor,
                            Theme.of(context)
                                .scaffoldBackgroundColor
                                .withOpacity(0.1),
                            Theme.of(context)
                                .scaffoldBackgroundColor
                                .withOpacity(0.1),
                            Theme.of(context).scaffoldBackgroundColor,
                          ],
                          stops: const [0.1, 0.5, 0.7, 0.98],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: double.infinity,
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    margin: const EdgeInsets.only(top: 30.0),
                    child: RoundBorderIcon(
                      color: ColorsUtils()
                          .darken(
                            Theme.of(context).colorScheme.primary,
                            amount: 0.4,
                          )
                          .withOpacity(0.9),
                      width: 1.5,
                      padding: 12.0,
                      icon: Icon(
                        widget.icon,
                        size: widget.iconSize / 2,
                        color: ColorsUtils()
                            .darken(
                              Theme.of(context).colorScheme.primary,
                              amount: 0.4,
                            )
                            .withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
                if (widget.showTitleUnscroll)
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 133),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      widget.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26.0,
                        color: AppColors.of(context).text.withOpacity(.8),
                        fontStyle: widget.italic ? FontStyle.italic : null,
                        fontWeight: FontWeight.bold,
                      ),
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
