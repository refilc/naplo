import 'package:refilc/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

enum LoginInputStyle { username, password, school }

class LoginInput extends StatefulWidget {
  const LoginInput(
      {super.key,
      required this.style,
      this.controller,
      this.focusNode,
      this.onClear});

  final Function()? onClear;
  final LoginInputStyle style;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  late bool obscure;

  @override
  void initState() {
    super.initState();
    obscure = widget.style == LoginInputStyle.password;
  }

  @override
  Widget build(BuildContext context) {
    String autofill;

    switch (widget.style) {
      case LoginInputStyle.username:
        autofill = AutofillHints.username;
        break;
      case LoginInputStyle.password:
        autofill = AutofillHints.password;
        break;
      case LoginInputStyle.school:
        autofill = AutofillHints.organizationName;
        break;
    }

    return TextField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      cursorColor: AppColors.of(context).filc,
      textInputAction: TextInputAction.next,
      autofillHints: [autofill],
      obscureText: obscure,
      scrollPhysics: const BouncingScrollPhysics(),
      decoration: InputDecoration(
        // fillColor: Colors.black.withOpacity(0.15),
        filled: false,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            width: 1,
            color: AppColors.of(context).inputBorder,
          ),
        ),
        // focusedBorder: UnderlineInputBorder(
        //   borderRadius: BorderRadius.circular(12.0),
        //   borderSide: const BorderSide(width: 0, color: Colors.transparent),
        // ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            width: 1,
            color: AppColors.of(context).filc,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            width: 1,
            color: Color(0xFFFF0000),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        suffixIconConstraints:
            const BoxConstraints(maxHeight: 42.0, maxWidth: 48.0),
        suffixIcon: widget.style == LoginInputStyle.password ||
                widget.style == LoginInputStyle.school
            ? ClipOval(
                child: Material(
                  type: MaterialType.transparency,
                  child: IconButton(
                    splashRadius: 20.0,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (widget.style == LoginInputStyle.password) {
                        setState(() => obscure = !obscure);
                      } else {
                        widget.controller?.clear();
                        if (widget.onClear != null) widget.onClear!();
                      }
                    },
                    icon: widget.style == LoginInputStyle.password
                        ? Icon(
                            obscure ? FeatherIcons.eye : FeatherIcons.eyeOff,
                            color: AppColors.of(context).text.withOpacity(0.8),
                            weight: 0.1,
                            size: 18.0,
                          )
                        : Icon(
                            FeatherIcons.x,
                            color: AppColors.of(context).text.withOpacity(0.8),
                            weight: 0.1,
                            size: 20.0,
                          ),
                  ),
                ),
              )
            : null,
      ),
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: AppColors.of(context).text.withOpacity(0.8),
      ),
    );
  }
}
