import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

import '../providers/firestore.dart' as firestore;

class QrGen extends StatefulWidget {
  const QrGen({Key? key}) : super(key: key);

  @override
  _QrGenState createState() => _QrGenState();
}

class _QrGenState extends State<QrGen> {
  final GlobalKey<FormState> _form = GlobalKey(debugLabel: '_qrform-key');
  String? _name, url;
  bool _readOnly = false;
  File? _storedImage;
  bool _saving = false;
  late Future<String> _future;

  void _submit() async {
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();

    final qrValidationResult = QrValidator.validate(
      data: _name!,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );

    if (qrValidationResult.status == QrValidationStatus.valid) {
      final qrCode = qrValidationResult.qrCode;
      final painter = QrPainter.withQr(
        qr: qrCode!,
        color: const Color(0xFF000000),
        gapless: true,
        embeddedImageStyle: null,
        embeddedImage: null,
      );

      Directory tempDir = await syspaths.getTemporaryDirectory();
      String tempPath = tempDir.path;
      final ts = DateTime.now().millisecondsSinceEpoch.toString();
      String path = '$tempPath/$ts.png';
      print(path);
      final picData =
          await painter.toImageData(2048, format: ui.ImageByteFormat.png);
      await _writeToFile(picData!, path);
      // setState(() {
      _storedImage = File(path);
      // });
      // print(_storedImage.);
    }
  }

  Future<void> _writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  void _save() async {
    setState(() {
      _saving = true;
    });
    if (_storedImage != null) await firestore.addResQr(_storedImage!);
    _readOnly = true;
    setState(() {
      _saving = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _future = firestore.getQr();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink.shade50,
          title: Text(
            'QR',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }

              Navigator.of(context).pop();
            },
          ),
        ),
        body: FutureBuilder<String>(
            future: _future,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());

              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != 'none') {
                // print()
                url = snapshot.data;
                // print('url: ' + url.toString());
                // setState(() {
                _readOnly = true;
                // });
              }
              return Center(
                child: Container(
                  height: deviceSize.height * 0.5,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: deviceSize.width * 0.1),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_readOnly)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: deviceSize.width * 0.1,
                              ),
                              child: TextFormField(
                                // readOnly: _readOnly, //? true : readOnly,
                                keyboardType: TextInputType.name,
                                // onTap: onTap,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade300,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  hintText: 'Enter Restaurant Name',
                                ),
                                validator: (validator) {
                                  if (validator!.isEmpty) {
                                    return 'required!';
                                  }
                                  return null;
                                },
                                onSaved: (onSaved) {
                                  setState(() {
                                    _name = onSaved;
                                  });
                                },
                              ),
                            ),
                          SizedBox(height: 10),
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
                                border: Border.all(
                                    width: 3.5, color: Colors.pink.shade50),
                              ),
                              child: _readOnly && url != null
                                  ? Image.network(
                                      url!,
                                      fit: BoxFit.contain,
                                      height: 200,
                                      width: 200,
                                      loadingBuilder: (ctx, child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: LinearProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                    )
                                  : _name != null
                                      ? QrImage(
                                          data: _name!,
                                          version: QrVersions.auto,
                                          size: 200.0,
                                        )
                                      : null,
                              alignment: Alignment.center,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          if (!_readOnly) ...[
                            ElevatedButton.icon(
                              icon: Icon(Icons.image),
                              label: Text('Generate'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.pink.shade50,
                                onPrimary: Colors.grey.shade500,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              onPressed: _submit, //_takePicture,
                            ),
                            _saving
                                ? Center(child: CircularProgressIndicator())
                                : TextButton.icon(
                                    label: Text('Save'),
                                    icon: Icon(Icons.check),
                                    onPressed: _save,
                                    style: TextButton.styleFrom(
                                        primary: Colors.black),
                                  ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
// class AddQR extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.pink.shade50,
//         title: Text(
//           'QR',
//           style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 onPrimary: Colors.white,
//                 padding: EdgeInsets.all(25),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(35),
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pushNamed('/qr/upload');
//               },
//               child: Text('Upload an image'),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 onPrimary: Colors.white,
//                 padding: EdgeInsets.all(25),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(35),
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pushNamed('/qr/gen');
//               },
//               child: Text('Generate an Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// class QrUpload extends StatefulWidget {
//   const QrUpload({Key? key}) : super(key: key);

//   @override
//   _QrUploadState createState() => _QrUploadState();
// }

// class _QrUploadState extends State<QrUpload> {
//   File? _storedImage;

//   Future<void> _takePicture() async {
//     final picker = ImagePicker();
//     final imageFile = await picker.pickImage(
//       source: ImageSource.gallery,
//       maxWidth: 600,
//     );
//     if (imageFile == null) return;
//     setState(() {
//       _storedImage = File(imageFile.path);
//     });

//     /// getting location where OS allows us to store files
//     final appDir = await syspaths.getApplicationDocumentsDirectory();

//     /// getting the baseName of the file where it is stored!
//     final fileName = path.basename(imageFile.path);

//     /// saving the image the in the location where OS allows
//     /// us to store files
//     ///
//     /// this is stored in memory using the function we passed to
//     /// this state's widget
//     /// also the image is stored in document but the rest of data
//     /// inclusing name we type is lost till now
//     final savedImage = await _storedImage!.copy('${appDir.path}/$fileName');
//     // widget.onSelectImage(savedImage);

//     await firestore.addResQr(_storedImage!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size deviceSize = MediaQuery.of(context).size;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.pink.shade50,
//         title: Text(
//           'QR',
//           style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Container(
//           height: deviceSize.height * 0.5,
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.1),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Flexible(
//                   child: Container(
//                     // height: 150,
//                     // width: 250,
//                     constraints: BoxConstraints(
//                       maxHeight: deviceSize.height * 0.5,
//                       maxWidth: deviceSize.width * 0.8,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       border:
//                           Border.all(width: 3.5, color: Colors.pink.shade50),
//                     ),
//                     child: _storedImage != null
//                         ? Image.file(
//                             _storedImage!,
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                           )
//                         : Image.asset(
//                             'images/qr-code.png',
//                             fit: BoxFit.contain,
//                           ),
//                     alignment: Alignment.center,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 ElevatedButton.icon(
//                   icon: Icon(Icons.image),
//                   label: Text('Add Image'),
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.pink.shade50,
//                     onPrimary: Colors.grey.shade500,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                   onPressed: _takePicture,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
