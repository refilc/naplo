// FROM: https://pub.dev/packages/flutter_colorpicker
// FROM: https://pub.dev/packages/flutter_colorpicker
// FROM: https://pub.dev/packages/flutter_colorpicker
// FROM: https://pub.dev/packages/flutter_colorpicker

/// HSV(HSB)/HSL Color Picker example
///
/// You can create your own layout by importing `picker.dart`.

library hsv_picker;

import 'package:filcnaplo/models/shared_theme.dart';
import 'package:filcnaplo_mobile_ui/common/custom_snack_bar.dart';
import 'package:filcnaplo_premium/providers/share_provider.dart';
import 'package:filcnaplo_premium/ui/mobile/flutter_colorpicker/block_picker.dart';
import 'package:filcnaplo_premium/ui/mobile/flutter_colorpicker/palette.dart';
import 'package:filcnaplo_premium/ui/mobile/flutter_colorpicker/utils.dart';
import 'package:filcnaplo_premium/ui/mobile/settings/theme.dart';
import 'package:filcnaplo_premium/ui/mobile/settings/theme.i18n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:provider/provider.dart';

class FilcColorPicker extends StatefulWidget {
  const FilcColorPicker({
    Key? key,
    required this.colorMode,
    required this.pickerColor,
    required this.onColorChanged,
    required this.onColorChangeEnd,
    this.pickerHsvColor,
    this.onHsvColorChanged,
    this.paletteType = PaletteType.hsvWithHue,
    this.enableAlpha = true,
    @Deprecated('Use empty list in [labelTypes] to disable label.')
    this.showLabel = true,
    this.labelTypes = const [
      ColorLabelType.rgb,
      ColorLabelType.hsv,
      ColorLabelType.hsl
    ],
    @Deprecated(
        'Use Theme.of(context).textTheme.bodyText1 & 2 to alter text style.')
    this.labelTextStyle,
    this.displayThumbColor = false,
    this.portraitOnly = false,
    this.colorPickerWidth = 300.0,
    this.pickerAreaHeightPercent = 1.0,
    this.pickerAreaBorderRadius = const BorderRadius.all(Radius.zero),
    this.hexInputBar = false,
    this.hexInputController,
    this.colorHistory,
    this.onHistoryChanged,
    required this.onThemeIdProvided,
  }) : super(key: key);

  final CustomColorMode colorMode;
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final void Function(Color color, {bool? adaptive}) onColorChangeEnd;
  final HSVColor? pickerHsvColor;
  final ValueChanged<HSVColor>? onHsvColorChanged;
  final PaletteType paletteType;
  final bool enableAlpha;
  final bool showLabel;
  final List<ColorLabelType> labelTypes;
  final TextStyle? labelTextStyle;
  final bool displayThumbColor;
  final bool portraitOnly;
  final double colorPickerWidth;
  final double pickerAreaHeightPercent;
  final BorderRadius pickerAreaBorderRadius;
  final bool hexInputBar;
  final TextEditingController? hexInputController;
  final List<Color>? colorHistory;
  final ValueChanged<List<Color>>? onHistoryChanged;
  final void Function(SharedTheme theme) onThemeIdProvided;

  @override
  _FilcColorPickerState createState() => _FilcColorPickerState();
}

class _FilcColorPickerState extends State<FilcColorPicker> {
  final idController = TextEditingController();

  late final ShareProvider shareProvider;

  HSVColor currentHsvColor = const HSVColor.fromAHSV(0.0, 0.0, 0.0, 0.0);
  List<Color> colorHistory = [];
  bool isAdvancedView = false;

  @override
  void initState() {
    currentHsvColor = (widget.pickerHsvColor != null)
        ? widget.pickerHsvColor as HSVColor
        : HSVColor.fromColor(widget.pickerColor);
    // If there's no initial text in `hexInputController`,
    if (widget.hexInputController?.text.isEmpty == true) {
      // set it to the current's color HEX value.
      widget.hexInputController?.text = colorToHex(
        currentHsvColor.toColor(),
        enableAlpha: widget.enableAlpha,
      );
    }
    // Listen to the text input, If there is an `hexInputController` provided.
    widget.hexInputController?.addListener(colorPickerTextInputListener);
    if (widget.colorHistory != null && widget.onHistoryChanged != null) {
      colorHistory = widget.colorHistory ?? [];
    }
    shareProvider = Provider.of<ShareProvider>(context, listen: false);
    super.initState();
  }

  @override
  void didUpdateWidget(FilcColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    currentHsvColor = (widget.pickerHsvColor != null)
        ? widget.pickerHsvColor as HSVColor
        : HSVColor.fromColor(widget.pickerColor);
  }

  void colorPickerTextInputListener() {
    // It can't be null really, since it's only listening if the controller
    // is provided, but it may help to calm the Dart analyzer in the future.
    if (widget.hexInputController == null) return;
    // If a user is inserting/typing any text — try to get the color value from it,
    // and interpret its transparency, dependent on the widget's settings.
    final Color? color = colorFromHex(widget.hexInputController!.text,
        enableAlpha: widget.enableAlpha);
    // If it's the valid color:
    if (color != null) {
      // set it as the current color and
      setState(() => currentHsvColor = HSVColor.fromColor(color));
      // notify with a callback.
      widget.onColorChanged(color);
      if (widget.onHsvColorChanged != null) {
        widget.onHsvColorChanged!(currentHsvColor);
      }
    }
  }

  @override
  void dispose() {
    widget.hexInputController?.removeListener(colorPickerTextInputListener);
    super.dispose();
  }

  Widget colorPickerSlider(TrackType trackType) {
    return ColorPickerSlider(
      trackType,
      currentHsvColor,
      (HSVColor color) {
        // Update text in `hexInputController` if provided.
        widget.hexInputController?.text =
            colorToHex(color.toColor(), enableAlpha: widget.enableAlpha);
        setState(() => currentHsvColor = color);
        widget.onColorChanged(currentHsvColor.toColor());
        if (widget.onHsvColorChanged != null) {
          widget.onHsvColorChanged!(currentHsvColor);
        }
      },
      () => widget.onColorChangeEnd(currentHsvColor.toColor()),
      (p) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Move the ${p == 0 ? 'Saturation (second)' : 'Value (third)'} slider first.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.of(context).text,
                    fontWeight: FontWeight.w600)),
            backgroundColor: AppColors.of(context).background));
      },
      displayThumbColor: widget.displayThumbColor,
    );
  }

  void onColorChanging(HSVColor color) {
    // Update text in `hexInputController` if provided.
    widget.hexInputController?.text =
        colorToHex(color.toColor(), enableAlpha: widget.enableAlpha);
    setState(() => currentHsvColor = color);
    widget.onColorChanged(currentHsvColor.toColor());
    if (widget.onHsvColorChanged != null) {
      widget.onHsvColorChanged!(currentHsvColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait ||
        widget.portraitOnly) {
      return Column(
        children: [
          if (widget.colorMode != CustomColorMode.theme &&
              widget.colorMode != CustomColorMode.enterId)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: SizedBox(
                      height: 45.0,
                      width: double.infinity,
                      child: colorPickerSlider(TrackType.hue),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: SizedBox(
                      height: 45.0,
                      width: double.infinity,
                      child: colorPickerSlider(TrackType.saturation),
                    ),
                  ),
                  if (isAdvancedView)
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: SizedBox(
                        height: 45.0,
                        width: double.infinity,
                        child: colorPickerSlider(TrackType.value),
                      ),
                    ),
                ],
              ),
            ),
          if (isAdvancedView &&
              widget.colorMode != CustomColorMode.theme &&
              widget.colorMode != CustomColorMode.enterId)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: ColorPickerInput(
                currentHsvColor.toColor(),
                (Color color) {
                  setState(() => currentHsvColor = HSVColor.fromColor(color));
                  widget.onColorChanged(currentHsvColor.toColor());
                  if (widget.onHsvColorChanged != null) {
                    widget.onHsvColorChanged!(currentHsvColor);
                  }
                },
                enableAlpha: false,
                embeddedText: false,
              ),
            ),
          if (widget.colorMode == CustomColorMode.enterId)
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Column(
                children: [
                  TextField(
                    autocorrect: false,
                    autofocus: true,
                    onEditingComplete: () async {
                      SharedTheme? theme = await shareProvider.getThemeById(
                        context,
                        id: idController.text.replaceAll(' ', ''),
                      );

                      if (theme != null) {
                        widget.onThemeIdProvided(theme);
                        idController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBar(
                            content: Text("theme_not_found".i18n,
                                style: const TextStyle(color: Colors.white)),
                            backgroundColor: AppColors.of(context).red,
                            context: context,
                          ),
                        );
                      }
                    },
                    controller: idController,
                    decoration: InputDecoration(
                      hintText: 'theme_id'.i18n,
                    ),
                  ),
                  // MaterialActionButton(
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Text('check_id'.i18n),
                  //     ],
                  //   ),
                  //   backgroundColor: AppColors.of(context).filc,
                  //   onPressed: () {},
                  // ),
                ],
              ),
            ),
          if (widget.colorMode != CustomColorMode.enterId)
            SizedBox(
              height: 70 * (widget.colorMode == CustomColorMode.theme ? 2 : 1),
              child: BlockPicker(
                pickerColor: Colors.red,
                layoutBuilder: (context, colors, child) {
                  return GridView.count(
                    shrinkWrap: true,
                    crossAxisCount:
                        widget.colorMode == CustomColorMode.theme ? 2 : 1,
                    scrollDirection: Axis.horizontal,
                    crossAxisSpacing: 15,
                    physics: const BouncingScrollPhysics(),
                    mainAxisSpacing: 15,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    children: List.generate(
                        colors.toSet().length +
                            (widget.colorMode == CustomColorMode.theme ? 1 : 0),
                        (index) {
                      if (widget.colorMode == CustomColorMode.theme) {
                        if (index == 0) {
                          return GestureDetector(
                            onTap: () => widget.onColorChangeEnd(
                                Colors.transparent,
                                adaptive: true),
                            child: ColorIndicator(
                                HSVColor.fromColor(
                                    const Color.fromARGB(255, 255, 238, 177)),
                                icon: CupertinoIcons.wand_stars,
                                currentHsvColor: currentHsvColor,
                                width: 30,
                                height: 30,
                                adaptive: true),
                          );
                        }
                        index--;
                      }
                      return GestureDetector(
                        onTap: () => widget.onColorChangeEnd(colors[index]),
                        child: ColorIndicator(HSVColor.fromColor(colors[index]),
                            currentHsvColor: currentHsvColor,
                            width: 30,
                            height: 30),
                      );
                    }),
                  );
                },
                onColorChanged: (c) => {},
              ),
            ),
          if (widget.colorMode != CustomColorMode.theme &&
              widget.colorMode != CustomColorMode.enterId)
            Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onTap: () => setState(() {
                  isAdvancedView = !isAdvancedView;
                }),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        onChanged: (v) => setState(() => isAdvancedView = v),
                        value: isAdvancedView,
                      ),
                      const SizedBox(width: 12.0),
                      Text(
                        "advanced".i18n,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: AppColors.of(context)
                              .text
                              .withOpacity(isAdvancedView ? 1.0 : .5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    } else {
      return Row(
        children: [
          //SizedBox(width: widget.colorPickerWidth, height: widget.colorPickerWidth * widget.pickerAreaHeightPercent, child: colorPicker()),
          Column(
            children: [
              Row(
                children: <Widget>[
                  const SizedBox(width: 20.0),
                  GestureDetector(
                    onTap: () => setState(() {
                      if (widget.onHistoryChanged != null &&
                          !colorHistory.contains(currentHsvColor.toColor())) {
                        colorHistory.add(currentHsvColor.toColor());
                        widget.onHistoryChanged!(colorHistory);
                      }
                    }),
                    child: ColorIndicator(currentHsvColor),
                  ),
                  Column(
                    children: <Widget>[
                      //SizedBox(height: 40.0, width: 260.0, child: sliderByPaletteType()),
                      if (widget.enableAlpha)
                        SizedBox(
                            height: 40.0,
                            width: 260.0,
                            child: colorPickerSlider(TrackType.alpha)),
                    ],
                  ),
                  const SizedBox(width: 10.0),
                ],
              ),
              if (colorHistory.isNotEmpty)
                SizedBox(
                  width: widget.colorPickerWidth,
                  height: 50,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        for (Color color in colorHistory)
                          Padding(
                            key: Key(color.hashCode.toString()),
                            padding: const EdgeInsets.fromLTRB(15, 18, 0, 0),
                            child: Center(
                              child: GestureDetector(
                                onTap: () =>
                                    onColorChanging(HSVColor.fromColor(color)),
                                onLongPress: () {
                                  if (colorHistory.remove(color)) {
                                    widget.onHistoryChanged!(colorHistory);
                                    setState(() {});
                                  }
                                },
                                child: ColorIndicator(HSVColor.fromColor(color),
                                    width: 30, height: 30),
                              ),
                            ),
                          ),
                        const SizedBox(width: 15),
                      ]),
                ),
              const SizedBox(height: 20.0),
              if (widget.hexInputBar)
                ColorPickerInput(
                  currentHsvColor.toColor(),
                  (Color color) {
                    setState(() => currentHsvColor = HSVColor.fromColor(color));
                    widget.onColorChanged(currentHsvColor.toColor());
                    if (widget.onHsvColorChanged != null) {
                      widget.onHsvColorChanged!(currentHsvColor);
                    }
                  },
                  enableAlpha: widget.enableAlpha,
                  embeddedText: false,
                ),
              const SizedBox(height: 5),
            ],
          ),
        ],
      );
    }
  }
}
