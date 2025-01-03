// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:refilc/api/providers/database_provider.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/models/user.dart';
import 'package:refilc_mobile_ui/common/bottom_sheet_menu/bottom_sheet_menu_item.dart';
// import 'package:refilc_plus/models/premium_scopes.dart';
// import 'package:refilc_plus/providers/plus_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:refilc_mobile_ui/screens/settings/settings_screen.i18n.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_crop_plus/image_crop_plus.dart';

// ignore: must_be_immutable
class UserMenuProfilePic extends StatelessWidget {
  late User u;

  UserMenuProfilePic(this.u, {super.key});

  @override
  Widget build(BuildContext context) {
    // if (!Provider.of<PlusProvider>(context)
    //     .hasScope(PremiumScopes.nickname)) {
    //   return const SizedBox();
    // }

    return BottomSheetMenuItem(
      onPressed: () {
        showDialog(
            context: context, builder: (context) => UserProfilePicEditor(u));
      },
      icon: const Icon(FeatherIcons.camera),
      title: Text("edit_profile_picture".i18n),
    );
  }
}

// ignore: must_be_immutable
class UserProfilePicEditor extends StatefulWidget {
  late User u;

  UserProfilePicEditor(this.u, {super.key});

  @override
  State<UserProfilePicEditor> createState() => _UserProfilePicEditorState();
}

class _UserProfilePicEditorState extends State<UserProfilePicEditor> {
  late final UserProvider user;

  final cropKey = GlobalKey<CropState>();
  File? _file;
  File? _sample;
  File? _lastCropped;

  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      File imageFile = File(image.path);

      final sample = await ImageCrop.sampleImage(
        file: imageFile,
        preferredSize: context.size!.longestSide.ceil(),
      );

      _sample?.delete();
      _file?.delete();

      setState(() {
        _sample = sample;
        _file = imageFile;
      });
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
  }

  Widget cropImageWidget() {
    return SizedBox(
      height: 300,
      child: Crop.file(
        _sample!,
        key: cropKey,
        aspectRatio: 1.0,
      ),
    );
  }

  Widget openImageWidget() {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      onTap: () => pickImage(),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(14.0),
        ),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 8.0),
        child: Column(
          children: [
            Text(
              "click_here".i18n,
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "select_profile_picture".i18n,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _cropImage() async {
    final scale = cropKey.currentState!.scale;
    final area = cropKey.currentState!.area;
    if (area == null || _file == null) {
      return;
    }

    final sample = await ImageCrop.sampleImage(
      file: _file!,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    sample.delete();

    _lastCropped?.delete();
    _lastCropped = file;

    List<int> imageBytes = await _lastCropped!.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    widget.u.picture = base64Image;
    Provider.of<DatabaseProvider>(context, listen: false)
        .store
        .storeUser(widget.u);
    Provider.of<UserProvider>(context, listen: false).refresh();

    debugPrint('$file');
  }

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    _file?.delete();
    _sample?.delete();
    _lastCropped?.delete();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14.0))),
      contentPadding: const EdgeInsets.only(top: 10.0),
      title: Text("edit_profile_picture".i18n),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            child: _sample == null ? openImageWidget() : cropImageWidget(),
          ),
          if (widget.u.picture != "")
            TextButton(
              child: Text(
                "remove_profile_picture".i18n,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.red),
              ),
              onPressed: () {
                widget.u.picture = "";
                Provider.of<DatabaseProvider>(context, listen: false)
                    .store
                    .storeUser(widget.u);
                Provider.of<UserProvider>(context, listen: false).refresh();
                Navigator.of(context).pop(true);
              },
            ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            "cancel".i18n,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
        TextButton(
          child: Text(
            "done".i18n,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          onPressed: () async {
            await _cropImage();
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
