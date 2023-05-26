// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart' show kMinFlingVelocity;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

double valueFromPercentageInRange({required final double min, max, percentage}) {
  return percentage * (max - min) + min;
}

double percentageFromValueInRange({required final double min, max, value}) {
  return (value - min) / (max - min);
}

const double _kOpenScale = 1.025;

const Color _borderColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFA9A9AF),
  darkColor: Color(0xFF57585A),
);

typedef _DismissCallback = void Function(
  BuildContext context,
  double scale,
  double opacity,
);

typedef ViewablePreviewBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Widget child,
);

typedef _ViewablePreviewBuilderChildless = Widget Function(
  BuildContext context,
  Animation<double> animation,
);

Rect _getRect(GlobalKey globalKey) {
  assert(globalKey.currentContext != null);
  final RenderBox renderBoxContainer = globalKey.currentContext!.findRenderObject()! as RenderBox;
  final Offset containerOffset = renderBoxContainer.localToGlobal(
    renderBoxContainer.paintBounds.topLeft,
  );
  return containerOffset & renderBoxContainer.paintBounds.size;
}

enum _ViewableLocation {
  center,
  left,
  right,
}

class Viewable extends StatefulWidget {
  const Viewable({
    Key? key,
    required this.view,
    required this.tile,
    this.actions = const [],
    this.previewBuilder,
  }) : super(key: key);

  final Widget tile;
  final Widget view;

  final List<Widget> actions;

  final ViewablePreviewBuilder? previewBuilder;

  @override
  State<Viewable> createState() => _ViewableState();
}

class _ViewableState extends State<Viewable> with TickerProviderStateMixin {
  final GlobalKey _childGlobalKey = GlobalKey();
  bool _childHidden = false;

  late AnimationController _openController;
  Rect? _decoyChildEndRect;
  OverlayEntry? _lastOverlayEntry;
  _ViewableRoute<void>? _route;

  @override
  void initState() {
    super.initState();
    _openController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _openController.addStatusListener(_onDecoyAnimationStatusChange);
  }

  _ViewableLocation get _contextMenuLocation {
    final Rect childRect = _getRect(_childGlobalKey);
    final double screenWidth = MediaQuery.of(context).size.width;

    final double center = screenWidth / 2;
    final bool centerDividesChild = childRect.left < center && childRect.right > center;
    final double distanceFromCenter = (center - childRect.center.dx).abs();
    if (centerDividesChild && distanceFromCenter <= childRect.width / 4) {
      return _ViewableLocation.center;
    }

    if (childRect.center.dx > center) {
      return _ViewableLocation.right;
    }

    return _ViewableLocation.left;
  }

  void _openContextMenu() {
    setState(() {
      _childHidden = true;
    });

    _route = _ViewableRoute<void>(
      actions: widget.actions,
      barrierLabel: 'Dismiss',
      filter: ui.ImageFilter.blur(
        sigmaX: 5.0,
        sigmaY: 5.0,
      ),
      contextMenuLocation: _contextMenuLocation,
      previousChildRect: _decoyChildEndRect!,
      builder: (BuildContext context, Animation<double> animation) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Material(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(16.0),
            child: Stack(
              children: [
                Opacity(
                  opacity: animation.status == AnimationStatus.forward
                      ? Curves.easeOutCirc.transform(animation.value)
                      : Curves.easeInCirc.transform(animation.value),
                  child: widget.view,
                ),
                Opacity(
                  opacity: 1 -
                      (animation.status == AnimationStatus.forward
                          ? Curves.easeOutCirc.transform(animation.value)
                          : Curves.easeInCirc.transform(animation.value)),
                  child: widget.tile,
                ),
              ],
            ),
          ),
        );
      },
    );
    Navigator.of(context, rootNavigator: true).push<void>(_route!);
    _route!.animation!.addStatusListener(_routeAnimationStatusListener);
  }

  void _onDecoyAnimationStatusChange(AnimationStatus animationStatus) {
    switch (animationStatus) {
      case AnimationStatus.dismissed:
        if (_route == null) {
          setState(() {
            _childHidden = false;
          });
        }
        _lastOverlayEntry?.remove();
        _lastOverlayEntry = null;
        break;

      case AnimationStatus.completed:
        setState(() {
          _childHidden = true;
        });
        _openContextMenu();

        SchedulerBinding.instance.addPostFrameCallback((Duration _) {
          _lastOverlayEntry?.remove();
          _lastOverlayEntry = null;
          _openController.reset();
        });
        break;

      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        return;
    }
  }

  void _routeAnimationStatusListener(AnimationStatus status) {
    if (status != AnimationStatus.dismissed) {
      return;
    }
    setState(() {
      _childHidden = false;
    });
    _route!.animation!.removeStatusListener(_routeAnimationStatusListener);
    _route = null;
  }

  void _onTap() {
    _onTapDown(TapDownDetails(), anim: false);
  }

  void _onTapDown(TapDownDetails details, {anim = true}) {
    setState(() {
      _childHidden = true;
    });

    final Rect childRect = _getRect(_childGlobalKey);
    _decoyChildEndRect = Rect.fromCenter(
      center: childRect.center,
      width: childRect.width * _kOpenScale,
      height: childRect.height * _kOpenScale,
    );

    _lastOverlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return _DecoyChild(
          beginRect: childRect,
          controller: _openController,
          endRect: _decoyChildEndRect,
          child: widget.tile,
        );
      },
    );
    Overlay.of(context, rootOverlay: true).insert(_lastOverlayEntry!);
    _openController.forward(from: anim ? 0.0 : 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: TickerMode(
        enabled: !_childHidden,
        child: Opacity(
          key: _childGlobalKey,
          opacity: _childHidden ? 0.0 : 1.0,
          child: widget.tile,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _openController.dispose();
    super.dispose();
  }
}

class _DecoyChild extends StatefulWidget {
  const _DecoyChild({
    Key? key,
    this.beginRect,
    required this.controller,
    this.endRect,
    this.child,
  }) : super(key: key);

  final Rect? beginRect;
  final AnimationController controller;
  final Rect? endRect;
  final Widget? child;

  @override
  _DecoyChildState createState() => _DecoyChildState();
}

class _DecoyChildState extends State<_DecoyChild> with TickerProviderStateMixin {
  static const Color _lightModeMaskColor = Color(0xFF888888);
  static const Color _masklessColor = Color(0xFFFFFFFF);

  final GlobalKey _childGlobalKey = GlobalKey();
  late Animation<Color> _mask;
  late Animation<Rect?> _rect;

  @override
  void initState() {
    super.initState();

    _mask = _OnOffAnimation<Color>(
      controller: widget.controller,
      onValue: _lightModeMaskColor,
      offValue: _masklessColor,
      intervalOn: 0.0,
      intervalOff: 0.5,
    );

    final Rect midRect = widget.beginRect!.deflate(
      widget.beginRect!.width * (_kOpenScale - 1.0) / 2,
    );
    _rect = TweenSequence<Rect?>(<TweenSequenceItem<Rect?>>[
      TweenSequenceItem<Rect?>(
        tween: RectTween(
          begin: widget.beginRect,
          end: midRect,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 1.0,
      ),
      TweenSequenceItem<Rect?>(
        tween: RectTween(
          begin: midRect,
          end: widget.endRect,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 1.0,
      ),
    ]).animate(widget.controller);
    _rect.addListener(_rectListener);
  }

  void _rectListener() {
    if (widget.controller.value < 0.5) {
      return;
    }
    HapticFeedback.selectionClick();
    _rect.removeListener(_rectListener);
  }

  @override
  void dispose() {
    _rect.removeListener(_rectListener);
    super.dispose();
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    final Color color = widget.controller.status == AnimationStatus.reverse ? _masklessColor : _mask.value;
    return Positioned.fromRect(
      rect: _rect.value!,
      child: ShaderMask(
        key: _childGlobalKey,
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[color, color],
          ).createShader(bounds);
        },
        child: widget.child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedBuilder(
          builder: _buildAnimation,
          animation: widget.controller,
        ),
      ],
    );
  }
}

class _ViewableRoute<T> extends PopupRoute<T> {
  _ViewableRoute({
    required List<Widget> actions,
    required _ViewableLocation contextMenuLocation,
    this.barrierLabel,
    _ViewablePreviewBuilderChildless? builder,
    ui.ImageFilter? filter,
    required Rect previousChildRect,
    RouteSettings? settings,
  })  : _actions = actions,
        _builder = builder,
        _contextMenuLocation = contextMenuLocation,
        _previousChildRect = previousChildRect,
        super(
          filter: filter,
          settings: settings,
        );

  static const Color _kModalBarrierColor = Color(0x6604040F);

  static const Duration _kModalPopupTransitionDuration = Duration(milliseconds: 335);

  final List<Widget> _actions;
  final _ViewablePreviewBuilderChildless? _builder;
  final GlobalKey _childGlobalKey = GlobalKey();
  final _ViewableLocation _contextMenuLocation;
  bool _externalOffstage = false;
  bool _internalOffstage = false;
  Orientation? _lastOrientation;

  final Rect _previousChildRect;
  double? _scale = 1.0;
  final GlobalKey _sheetGlobalKey = GlobalKey();

  static final CurveTween _curve = CurveTween(
    curve: Curves.easeOutBack,
  );
  static final CurveTween _curveReverse = CurveTween(
    curve: Curves.easeInBack,
  );
  static final RectTween _rectTween = RectTween();
  static final Animatable<Rect?> _rectAnimatable = _rectTween.chain(_curve);
  static final RectTween _rectTweenReverse = RectTween();
  static final Animatable<Rect?> _rectAnimatableReverse = _rectTweenReverse.chain(
    _curveReverse,
  );
  static final RectTween _sheetRectTween = RectTween();
  final Animatable<Rect?> _sheetRectAnimatable = _sheetRectTween.chain(
    _curve,
  );
  final Animatable<Rect?> _sheetRectAnimatableReverse = _sheetRectTween.chain(
    _curveReverse,
  );
  static final Tween<double> _sheetScaleTween = Tween<double>();
  static final Animatable<double> _sheetScaleAnimatable = _sheetScaleTween.chain(
    _curve,
  );
  static final Animatable<double> _sheetScaleAnimatableReverse = _sheetScaleTween.chain(
    _curveReverse,
  );
  final Tween<double> _opacityTween = Tween<double>(begin: 0.0, end: 1.0);
  late Animation<double> _sheetOpacity;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => _kModalBarrierColor;

  @override
  bool get barrierDismissible => true;

  @override
  bool get semanticsDismissible => false;

  @override
  Duration get transitionDuration => _kModalPopupTransitionDuration;

  static Rect _getScaledRect(GlobalKey globalKey, double scale) {
    final Rect childRect = _getRect(globalKey);
    final Size sizeScaled = childRect.size * scale;
    final Offset offsetScaled = Offset(
      childRect.left + (childRect.size.width - sizeScaled.width) / 2,
      childRect.top + (childRect.size.height - sizeScaled.height) / 2,
    );
    return offsetScaled & sizeScaled;
  }

  static AlignmentDirectional getSheetAlignment(_ViewableLocation contextMenuLocation) {
    switch (contextMenuLocation) {
      case _ViewableLocation.center:
        return AlignmentDirectional.topCenter;
      case _ViewableLocation.right:
        return AlignmentDirectional.topEnd;
      case _ViewableLocation.left:
        return AlignmentDirectional.topStart;
    }
  }

  static Rect _getSheetRectBegin(Orientation? orientation, _ViewableLocation contextMenuLocation, Rect childRect, Rect sheetRect) {
    switch (contextMenuLocation) {
      case _ViewableLocation.center:
        final Offset target = orientation == Orientation.portrait ? childRect.bottomCenter : childRect.topCenter;
        final Offset centered = target - Offset(sheetRect.width / 2, 0.0);
        return centered & sheetRect.size;
      case _ViewableLocation.right:
        final Offset target = orientation == Orientation.portrait ? childRect.bottomRight : childRect.topRight;
        return (target - Offset(sheetRect.width, 0.0)) & sheetRect.size;
      case _ViewableLocation.left:
        final Offset target = orientation == Orientation.portrait ? childRect.bottomLeft : childRect.topLeft;
        return target & sheetRect.size;
    }
  }

  void _onDismiss(BuildContext context, double scale, double opacity) {
    _scale = scale;
    _opacityTween.end = opacity;
    _sheetOpacity = _opacityTween.animate(CurvedAnimation(
      parent: animation!,
      curve: const Interval(0.9, 1.0),
    ));
    Navigator.of(context).pop();
  }

  void _updateTweenRects() {
    final Rect childRect = _scale == null ? _getRect(_childGlobalKey) : _getScaledRect(_childGlobalKey, _scale!);
    _rectTween.begin = _previousChildRect;
    _rectTween.end = childRect;

    final Rect childRectOriginal = Rect.fromCenter(
      center: _previousChildRect.center,
      width: _previousChildRect.width / _kOpenScale,
      height: _previousChildRect.height / _kOpenScale,
    );

    final Rect sheetRect = _getRect(_sheetGlobalKey);
    final Rect sheetRectBegin = _getSheetRectBegin(
      _lastOrientation,
      _contextMenuLocation,
      childRectOriginal,
      sheetRect,
    );
    _sheetRectTween.begin = sheetRectBegin;
    _sheetRectTween.end = sheetRect;
    _sheetScaleTween.begin = 0.0;
    _sheetScaleTween.end = _scale;

    _rectTweenReverse.begin = childRectOriginal;
    _rectTweenReverse.end = childRect;
  }

  void _setOffstageInternally() {
    super.offstage = _externalOffstage || _internalOffstage;

    changedInternalState();
  }

  @override
  bool didPop(T? result) {
    _updateTweenRects();
    return super.didPop(result);
  }

  @override
  set offstage(bool value) {
    _externalOffstage = value;
    _setOffstageInternally();
  }

  @override
  TickerFuture didPush() {
    _internalOffstage = true;
    _setOffstageInternally();

    SchedulerBinding.instance.addPostFrameCallback((Duration _) {
      _updateTweenRects();
      _internalOffstage = false;
      _setOffstageInternally();
    });
    return super.didPush();
  }

  @override
  Animation<double> createAnimation() {
    final Animation<double> animation = super.createAnimation();
    _sheetOpacity = _opacityTween.animate(CurvedAnimation(
      parent: animation,
      curve: Curves.linear,
    ));
    return animation;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Container();
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        _lastOrientation = orientation;

        if (!animation.isCompleted) {
          final bool reverse = animation.status == AnimationStatus.reverse;
          final Rect rect = reverse ? _rectAnimatableReverse.evaluate(animation)! : _rectAnimatable.evaluate(animation)!;
          final Rect sheetRect = reverse ? _sheetRectAnimatableReverse.evaluate(animation)! : _sheetRectAnimatable.evaluate(animation)!;
          final double sheetScale = reverse ? _sheetScaleAnimatableReverse.evaluate(animation) : _sheetScaleAnimatable.evaluate(animation);
          return Stack(
            children: <Widget>[
              Positioned.fromRect(
                rect: sheetRect,
                child: FadeTransition(
                  opacity: _sheetOpacity,
                  child: Transform.scale(
                    alignment: getSheetAlignment(_contextMenuLocation),
                    scale: sheetScale,
                    child: _ViewableSheet(
                      key: _sheetGlobalKey,
                      actions: _actions,
                    ),
                  ),
                ),
              ),
              Positioned.fromRect(
                key: _childGlobalKey,
                rect: rect,
                child: _builder!(context, animation),
              ),
            ],
          );
        }

        return _ContextMenuRouteStatic(
          actions: _actions,
          childGlobalKey: _childGlobalKey,
          contextMenuLocation: _contextMenuLocation,
          onDismiss: _onDismiss,
          orientation: orientation,
          sheetGlobalKey: _sheetGlobalKey,
          child: _builder!(context, animation),
        );
      },
    );
  }
}

class _ContextMenuRouteStatic extends StatefulWidget {
  const _ContextMenuRouteStatic({
    Key? key,
    this.actions,
    required this.child,
    this.childGlobalKey,
    required this.contextMenuLocation,
    this.onDismiss,
    required this.orientation,
    this.sheetGlobalKey,
  }) : super(key: key);

  final List<Widget>? actions;
  final Widget child;
  final GlobalKey? childGlobalKey;
  final _ViewableLocation contextMenuLocation;
  final _DismissCallback? onDismiss;
  final Orientation orientation;
  final GlobalKey? sheetGlobalKey;

  @override
  _ContextMenuRouteStaticState createState() => _ContextMenuRouteStaticState();
}

class _ContextMenuRouteStaticState extends State<_ContextMenuRouteStatic> with TickerProviderStateMixin {
  static const double _kMinScale = 0.8;

  static const double _kSheetScaleThreshold = 0.9;
  static const double _kPadding = 20.0;
  static const double _kDamping = 400.0;
  static const Duration _kMoveControllerDuration = Duration(milliseconds: 600);

  late Offset _dragOffset;
  double _lastScale = 1.0;
  late AnimationController _moveController;
  late AnimationController _sheetController;
  late Animation<Offset> _moveAnimation;
  late Animation<double> _sheetScaleAnimation;
  late Animation<double> _sheetOpacityAnimation;

  static double _getScale(Orientation orientation, double maxDragDistance, double dy) {
    final double dyDirectional = dy <= 0.0 ? dy : -dy;
    return math.max(
      _kMinScale,
      (maxDragDistance + dyDirectional) / maxDragDistance,
    );
  }

  void _onPanStart(DragStartDetails details) {
    _moveController.value = 1.0;
    _setDragOffset(Offset.zero);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _setDragOffset(_dragOffset + details.delta);
  }

  void _onPanEnd(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dy.abs() >= kMinFlingVelocity) {
      final bool flingIsAway = details.velocity.pixelsPerSecond.dy > 0;
      final double finalPosition = flingIsAway ? _moveAnimation.value.dy + 100.0 : 0.0;

      if (flingIsAway && _sheetController.status != AnimationStatus.forward) {
        _sheetController.forward();
      } else if (!flingIsAway && _sheetController.status != AnimationStatus.reverse) {
        _sheetController.reverse();
      }

      _moveAnimation = Tween<Offset>(
        begin: Offset(0.0, _moveAnimation.value.dy),
        end: Offset(0.0, finalPosition),
      ).animate(_moveController);
      _moveController.reset();
      _moveController.duration = const Duration(
        milliseconds: 64,
      );
      _moveController.forward();
      _moveController.addStatusListener(_flingStatusListener);
      return;
    }

    if (_lastScale == _kMinScale) {
      widget.onDismiss!(context, _lastScale, _sheetOpacityAnimation.value);
      return;
    }

    _moveController.addListener(_moveListener);
    _moveController.reverse();
  }

  void _moveListener() {
    if (_lastScale > _kSheetScaleThreshold) {
      _moveController.removeListener(_moveListener);
      if (_sheetController.status != AnimationStatus.dismissed) {
        _sheetController.reverse();
      }
    }
  }

  void _flingStatusListener(AnimationStatus status) {
    if (status != AnimationStatus.completed) {
      return;
    }

    _moveController.duration = _kMoveControllerDuration;

    _moveController.removeStatusListener(_flingStatusListener);

    if (_moveAnimation.value.dy == 0.0) {
      return;
    }
    widget.onDismiss!(context, _lastScale, _sheetOpacityAnimation.value);
  }

  Alignment _getChildAlignment(Orientation orientation, _ViewableLocation contextMenuLocation) {
    switch (contextMenuLocation) {
      case _ViewableLocation.center:
        return orientation == Orientation.portrait ? Alignment.bottomCenter : Alignment.topRight;
      case _ViewableLocation.right:
        return orientation == Orientation.portrait ? Alignment.bottomCenter : Alignment.topLeft;
      case _ViewableLocation.left:
        return orientation == Orientation.portrait ? Alignment.bottomCenter : Alignment.topRight;
    }
  }

  void _setDragOffset(Offset dragOffset) {
    final double endX = _kPadding * dragOffset.dx / _kDamping;
    final double endY = dragOffset.dy >= 0.0 ? dragOffset.dy : _kPadding * dragOffset.dy / _kDamping;
    setState(() {
      _dragOffset = dragOffset;
      _moveAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(
          endX.clamp(-_kPadding, _kPadding),
          endY,
        ),
      ).animate(
        CurvedAnimation(
          parent: _moveController,
          curve: Curves.elasticIn,
        ),
      );

      if (_lastScale <= _kSheetScaleThreshold && _sheetController.status != AnimationStatus.forward && _sheetScaleAnimation.value != 0.0) {
        _sheetController.forward();
      } else if (_lastScale > _kSheetScaleThreshold && _sheetController.status != AnimationStatus.reverse && _sheetScaleAnimation.value != 1.0) {
        _sheetController.reverse();
      }
    });
  }

  List<Widget> _getChildren(Orientation orientation, _ViewableLocation contextMenuLocation) {
    final Expanded child = Expanded(
      child: Align(
        alignment: _getChildAlignment(
          widget.orientation,
          widget.contextMenuLocation,
        ),
        child: AnimatedBuilder(
          animation: _moveController,
          builder: _buildChildAnimation,
          child: widget.child,
        ),
      ),
    );
    const SizedBox spacer = SizedBox(
      width: _kPadding,
      height: _kPadding,
    );
    final sheet = AnimatedBuilder(
      animation: _sheetController,
      builder: _buildSheetAnimation,
      child: _ViewableSheet(
        key: widget.sheetGlobalKey,
        actions: widget.actions!,
      ),
    );

    switch (contextMenuLocation) {
      case _ViewableLocation.center:
        return <Widget>[child, spacer, sheet];
      case _ViewableLocation.right:
        return orientation == Orientation.portrait ? <Widget>[child, spacer, sheet] : <Widget>[sheet, spacer, child];
      case _ViewableLocation.left:
        return <Widget>[child, spacer, sheet];
    }
  }

  Widget _buildSheetAnimation(BuildContext context, Widget? child) {
    return Transform.scale(
      alignment: _ViewableRoute.getSheetAlignment(widget.contextMenuLocation),
      scale: _sheetScaleAnimation.value,
      child: FadeTransition(
        opacity: _sheetOpacityAnimation,
        child: child,
      ),
    );
  }

  Widget _buildChildAnimation(BuildContext context, Widget? child) {
    _lastScale = _getScale(
      widget.orientation,
      MediaQuery.of(context).size.height,
      _moveAnimation.value.dy,
    );
    return Transform.scale(
      key: widget.childGlobalKey,
      scale: _lastScale,
      child: child,
    );
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Transform.translate(
      offset: _moveAnimation.value,
      child: child,
    );
  }

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(
      duration: _kMoveControllerDuration,
      value: 1.0,
      vsync: this,
    );
    _sheetController = AnimationController(
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _sheetScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _sheetController,
        curve: Curves.linear,
        reverseCurve: Curves.easeInBack,
      ),
    );
    _sheetOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_sheetController);
    _setDragOffset(Offset.zero);
  }

  @override
  void dispose() {
    _moveController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = _getChildren(
      widget.orientation,
      widget.contextMenuLocation,
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(_kPadding),
        child: Align(
          alignment: Alignment.topLeft,
          child: GestureDetector(
            onPanEnd: _onPanEnd,
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            child: AnimatedBuilder(
              animation: _moveController,
              builder: _buildAnimation,
              child: widget.orientation == Orientation.portrait
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children,
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewableSheet extends StatelessWidget {
  const _ViewableSheet({
    Key? key,
    required this.actions,
  }) : super(key: key);

  final List<Widget> actions;

  List<Widget> getChildren(BuildContext context) {
    if (actions.isEmpty) return [];

    final Widget menu = Expanded(
      child: IntrinsicHeight(
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(13.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              actions.first,
              for (Widget action in actions.skip(1))
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                      color: CupertinoDynamicColor.resolve(_borderColor, context),
                      width: 0.5,
                    )),
                  ),
                  position: DecorationPosition.foreground,
                  child: action,
                ),
            ],
          ),
        ),
      ),
    );

    return [menu];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: getChildren(context),
    );
  }
}

class _OnOffAnimation<T> extends CompoundAnimation<T> {
  _OnOffAnimation({
    required AnimationController controller,
    required T onValue,
    required T offValue,
    required double intervalOn,
    required double intervalOff,
  })  : _offValue = offValue,
        assert(intervalOn >= 0.0 && intervalOn <= 1.0),
        assert(intervalOff >= 0.0 && intervalOff <= 1.0),
        assert(intervalOn <= intervalOff),
        super(
          first: Tween<T>(begin: offValue, end: onValue).animate(
            CurvedAnimation(
              parent: controller,
              curve: Interval(intervalOn, intervalOn),
            ),
          ),
          next: Tween<T>(begin: onValue, end: offValue).animate(
            CurvedAnimation(
              parent: controller,
              curve: Interval(intervalOff, intervalOff),
            ),
          ),
        );

  final T _offValue;

  @override
  T get value => next.value == _offValue ? next.value : first.value;
}
