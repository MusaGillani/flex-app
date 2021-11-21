import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  final String imgPath;
  const ImageInput(this.onSelectImage, this.imgPath, {Key? key})
      : super(key: key);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    if (imageFile == null) return;
    setState(() {
      _storedImage = File(imageFile.path);
    });

    /// getting location where OS allows us to store files
    final appDir = await syspaths.getApplicationDocumentsDirectory();

    /// getting the baseName of the file where it is stored!
    final fileName = path.basename(imageFile.path);

    /// saving the image the in the location where OS allows
    /// us to store files
    ///
    /// this is stored in memory using the function we passed to
    /// this state's widget
    /// also the image is stored in document but the rest of data
    /// inclusing name we type is lost till now
    final savedImage = await _storedImage!.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Flexible(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Container(
                // height: 150,
                // width: 250,
                constraints: BoxConstraints(
                  maxHeight: deviceSize.height * 0.2,
                  maxWidth: deviceSize.width * 0.8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 3.5, color: Colors.pink.shade50),
                ),
                child: _storedImage != null
                    ? Image.file(
                        _storedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : Image.asset(
                        widget.imgPath,
                        fit: BoxFit.contain,
                      ),
                alignment: Alignment.center,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.image),
              label: Text('Add Image'),
              style: ElevatedButton.styleFrom(
                primary: Colors.pink.shade50,
                onPrimary: Colors.grey.shade500,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: _takePicture,
            ),
          ],
        ),
      ),
    );
  }
}
