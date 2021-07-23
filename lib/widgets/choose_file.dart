import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

// colors
// import 'package:BI_Fahes_Flutter/viwes/constants/constants.dart';

// image picker
import 'package:image_picker/image_picker.dart';

// compresser
import 'package:flutter_image_compress/flutter_image_compress.dart';

// file picker
import 'package:file_picker/file_picker.dart';

// Future<File> compressAndGetFile(File file, String targetPath) async {
Future<File> compressAndGetFile(BuildContext context, File file) async {
  final filePath = file.absolute.path;
  final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
  final splitted = filePath.substring(0, (lastIndex));
  final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

  // get the quality from provider
  int quality = 50;
  int minHeight = 1080;
  int minWidth = 1920;

  File result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    outPath,
    quality: quality,
    minHeight: minHeight,
    minWidth: minWidth,
  );

  return result;
}

class ChooseFile extends StatelessWidget {
  bool allowFiles;

  List<String> allowedFilesExtensions;
  List<String> allowedImagesExtensions;

  int imageQuality;

  ChooseFile({
    this.allowFiles = false,
    this.allowedFilesExtensions = const ['pdf'],
    this.allowedImagesExtensions = const ['jpg', 'png'],
    this.imageQuality = 50,
  });

  Future<File> getImage(
      {@required BuildContext context,
      ImageSource source = ImageSource.camera}) async {
    final picker = ImagePicker();

    PickedFile pickedFile = await picker.getImage(
      source: source,
      // imageQuality: imageQuality,
    );

    if (pickedFile != null) {
      // image as a file
      File file = File(pickedFile.path);

      try {
        // compress the image
        File newFile = await compressAndGetFile(context, file);

        if (newFile != null) return newFile;
      } catch (e) {}

      // the main image before compress
      return File(pickedFile.path);
    } else {
      return null;
    }
  }

  Future<File> getFile(BuildContext context) async {
    List<String> allowed =
        allowedImagesExtensions + (allowFiles ? allowedFilesExtensions : []);

    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowCompression: true,
      type: FileType.custom,
      allowedExtensions: allowed,
    );

    if (result != null) {
      File file = File(result.files.single.path);

      // compress the images
      if (allowedImagesExtensions.contains(file.path.split('.').last)) {
        try {
          File newFile = await compressAndGetFile(context, file);
          if (newFile != null) return newFile;
        } catch (e) {}
      }

      if (!allowed.contains(file.path.split('.').last)) return null;
      return file;
    }
    return null;
  }

  // return the selected file
  void returnFile(BuildContext context, File file) {
    Navigator.of(context).pop(file);
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding =
        EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10);

    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        height: 180,
        padding: EdgeInsets.only(top: 25, bottom: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // camera
            Expanded(
              child: InkWell(
                onTap: () async {
                  returnFile(context, await getImage(context: context));
                },
                child: Container(
                  padding: padding,
                  // color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // icon
                      Icon(Icons.camera_alt_outlined),

                      SizedBox(width: 10),

                      // the text
                      Text(
                        'Camera',
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // gallery
            Expanded(
              child: InkWell(
                onTap: () async {
                  // just images
                  returnFile(
                      context,
                      await getImage(
                          context: context, source: ImageSource.gallery));
                },
                child: Container(
                  padding: padding,
                  // color: Colors.blue,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // icon
                      Icon(Icons.image),

                      SizedBox(width: 10),

                      // the text
                      Text(
                        'Gallery',
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // files
            allowFiles
                ? Expanded(
                    child: InkWell(
                      onTap: () async {
                        // files & images
                        returnFile(
                          context,
                          await getFile(context),
                        );
                      },
                      child: Container(
                        padding: padding,
                        // color: Colors.red,

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // icon
                            Icon(Icons.file_present),

                            SizedBox(width: 10),

                            // the text
                            Text(
                              'Files',
                              style: textStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
