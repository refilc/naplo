import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

enum LoginInputStyle { username, password, school }

class LoginInput extends StatefulWidget {
  const LoginInput({Key? key, required this.style, this.controller, this.focusNode, this.onClear}) : super(key: key);

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
      cursorColor: const Color(0xff20AC9B),
      textInputAction: TextInputAction.next,
      autofillHints: [autofill],
      obscureText: obscure,
      scrollPhysics: const BouncingScrollPhysics(),
      decoration: InputDecoration(
        fillColor: Colors.black.withOpacity(0.15),
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(width: 0, color: Colors.transparent),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(width: 0, color: Colors.transparent),
        ),
        suffixIconConstraints: const BoxConstraints(maxHeight: 42.0, maxWidth: 48.0),
        suffixIcon: widget.style == LoginInputStyle.password || widget.style == LoginInputStyle.school
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
                    icon: Icon(
                        widget.style == LoginInputStyle.password
                            ? obscure
                                ? FeatherIcons.eye
                                : FeatherIcons.eyeOff
                            : FeatherIcons.x,
                        color: Colors.white),
                  ),
                ),
              )
            : null,
      ),
      style: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }
}
