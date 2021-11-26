import 'dart:io';

import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class AddQR extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade50,
        title: Text(
          'QR',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                padding: EdgeInsets.all(25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/qr/upload');
              },
              child: Text('Upload an image'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                padding: EdgeInsets.all(25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/qr/gen');
              },
              child: Text('Generate an Image'),
            ),
          ],
        ),
      ),
    );
  }
}

class QrGen extends StatefulWidget {
  const QrGen({Key? key}) : super(key: key);

  @override
  _QrGenState createState() => _QrGenState();
}

class _QrGenState extends State<QrGen> {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade50,
        title: Text(
          'QR',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          height: deviceSize.height * 0.5,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TODO check res name to gen qr
                // TextField(),
                Flexible(
                  child: Container(
                    // height: 150,
                    // width: 250,
                    constraints: BoxConstraints(
                      maxHeight: deviceSize.height * 0.5,
                      maxWidth: deviceSize.width * 0.8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border:
                          Border.all(width: 3.5, color: Colors.pink.shade50),
                    ),
                    child: QrImage(
                      data: "1234567890",
                      version: QrVersions.auto,
                      size: 200.0,
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
                  onPressed: null, //_takePicture,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QrUpload extends StatefulWidget {
  const QrUpload({Key? key}) : super(key: key);

  @override
  _QrUploadState createState() => _QrUploadState();
}

class _QrUploadState extends State<QrUpload> {
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
    // widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade50,
        title: Text(
          'QR',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          height: deviceSize.height * 0.5,
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
                      maxHeight: deviceSize.height * 0.5,
                      maxWidth: deviceSize.width * 0.8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border:
                          Border.all(width: 3.5, color: Colors.pink.shade50),
                    ),
                    child: _storedImage != null
                        ? Image.file(
                            _storedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Image.asset(
                            'images/qr-code.png',
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
        ),
      ),
    );
  }
}
