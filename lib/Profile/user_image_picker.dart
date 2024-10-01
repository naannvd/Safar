import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onImagePick});

  final void Function(File pickedImage) onImagePick;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _pickImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 150,
      );

      if (pickedImage == null) {
        return;
      }

      setState(() {
        _pickedImageFile = File(pickedImage.path);
      });

      widget.onImagePick(_pickedImageFile!);
    } catch (error) {
      print('Error picking image: $error');
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to pick image'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          label: Text(
            "Add image",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          icon: const Icon(
            Icons.image,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}
