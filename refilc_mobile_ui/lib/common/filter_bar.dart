import 'dart:math';

import 'package:refilc/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class FilterBar extends StatefulWidget implements PreferredSizeWidget {
  const FilterBar({
    super.key,
    required this.items,
    required this.controller,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0),
    this.disableFading = false,
    this.scrollable = true,
    this.censored = false,
    this.tabAlignment = TabAlignment.start,
  }) : assert(items.length == controller.length);

  final List<Widget> items;
  final TabController controller;
  final EdgeInsetsGeometry padding;
  final Function(int)? onTap;
  final bool disableFading;
  final bool scrollable;
  final bool censored;
  final TabAlignment tabAlignment;

  @override
  final Size preferredSize = const Size.fromHeight(42.0);

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  List<double> censoredItemsWidth = [];
  @override
  void initState() {
    super.initState();

    censoredItemsWidth = List.generate(
            widget.items.length, (index) => 25 + Random().nextDouble() * 50)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final tabbar = TabBar(
      controller: widget.controller,
      isScrollable: widget.scrollable,
      physics: const BouncingScrollPhysics(),
      // label
      labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      labelColor: Theme.of(context).colorScheme.secondary,
      unselectedLabelColor: AppColors.of(context).text.withOpacity(0.65),
      // indicator
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: const EdgeInsets.symmetric(vertical: 8.0),
      indicator: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary.withOpacity(.2),
        borderRadius: BorderRadius.circular(45.0),
      ),
      overlayColor: WidgetStateProperty.all(const Color(0x00000000)),
      // underline (bottom border)
      dividerColor: Colors.transparent,
      // tabs
      padding: EdgeInsets.zero,
      tabs: widget.censored
          ? censoredItemsWidth
              .map(
                (e) => Tab(
                  child: Container(
                    width: e,
                    height: 15,
                    decoration: BoxDecoration(
                      color: AppColors.of(context).text.withOpacity(.45),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              )
              .toList()
          : widget.items,
      onTap: widget.onTap,
      tabAlignment: widget.tabAlignment,
    );

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 48.0,
      padding: widget.padding,
      child: widget.disableFading
          ? tabbar
          : AnimatedBuilder(
              animation: widget.controller.animation!,
              builder: (ctx, child) {
                // avoid fading over selected tab
                return ShaderMask(
                    shaderCallback: (Rect bounds) {
                      final Color bg =
                          Theme.of(context).scaffoldBackgroundColor;
                      final double index = widget.controller.animation!.value;
                      return LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            index < 0.2 ? Colors.transparent : bg,
                            Colors.transparent,
                            Colors.transparent,
                            index > widget.controller.length - 1.2
                                ? Colors.transparent
                                : bg
                          ],
                          stops: const [
                            0,
                            0.1,
                            0.9,
                            1
                          ]).createShader(bounds);
                    },
                    blendMode: BlendMode.dstOut,
                    child: child);
              },
              child: tabbar,
            ),
    );
  }
}
