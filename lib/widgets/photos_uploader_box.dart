import 'package:flutter/material.dart';

import 'dart:io';

// import 'package:BI_Fahes_Flutter/data/data.dart';
// import 'package:BI_Fahes_Flutter/viwes/widgets/text_input.dart';

// colors
// import 'package:BI_Fahes_Flutter/viwes/constants/constants.dart';

// file picker
import 'package:lost/widgets/choose_file.dart';

// colors
const Color backGroundColorImage = Color(0xffe1e7f0);
const Color textColorgray2 = Color(0xff8798ad);
const Color textColorDarkBlack = Color(0xff2e384d);

class PhotosUploaderBox extends StatefulWidget {
  void Function(BuildContext, List<NewImage> photos) onChange;
  List<String> onlinePhotos;

  // on delete online images
  void Function(BuildContext, int deletedIndex) onDeleteOnlineImage;

  // on delete local images
  void Function(BuildContext, int deletedIndex) onDeleteLocalImage;

  // if there any (file) images to show
  List<File> oldFilePhotos;

  int newImageQuality;
  PhotosUploaderBox({
    this.onChange,
    this.onlinePhotos,
    this.oldFilePhotos,
    this.newImageQuality = 60,
    this.onDeleteOnlineImage,
    this.onDeleteLocalImage,
  });

  @override
  _PhotosUploaderBoxState createState() => _PhotosUploaderBoxState();
}

class _PhotosUploaderBoxState extends State<PhotosUploaderBox> {
  // the photos
  List<NewImage> photos = [];

  void appendPhoto(BuildContext context, List<File> photosList) async {
    for (int i = 0; i < photosList.length; i++) {
      File image = photosList[i];
      photos.add(NewImage(image: image));
    }
    // refresh the page
    setState(() {});

    // if the parent provided a callback fun
    if (widget.onChange != null) widget.onChange(context, photos);
  }

  void onDeletePhoto(BuildContext context, int photoIndex) {
    // delete the photo
    setState(() {
      photos.removeAt(photoIndex);
    });

    // tell the parent
    if (widget.onDeleteLocalImage != null)
      widget.onDeleteLocalImage(context, photoIndex);
  }

  @override
  void initState() {
    // load the old file photos
    if (widget.oldFilePhotos != null) {
      photos = widget.oldFilePhotos.map((ph) => NewImage(image: ph)).toList();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // new photo
            ImageBox(
              newImage: true,
              onAddPhoto: appendPhoto,
              imageQuality: widget.newImageQuality,
            ),

            // the uploaded images
            Container(
              height: 100,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                reverse: true,
                itemCount: photos.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ImageBox(
                          image: photos[index],
                          onAddPhoto: appendPhoto,
                          onDelete: (c) => onDeletePhoto(c, index),
                          height: 100,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // the online images
            Container(
              height: 100,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                reverse: true,
                itemCount: widget.onlinePhotos?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return ImageBox(
                    onlineImageLink: widget.onlinePhotos[index],
                    onlineImage: true,
                    onAddPhoto: (c, l) {},
                    onDelete: (c) {
                      // delete from online list
                      setState(() {
                        widget.onlinePhotos.removeAt(index);
                        if (widget.onDeleteOnlineImage != null)
                          widget.onDeleteOnlineImage(c, index);
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageBox extends StatelessWidget {
  final bool newImage;
  final bool onlineImage;
  NewImage image;
  String onlineImageLink;

  final Function(BuildContext, List<File>) onAddPhoto;
  final Function(BuildContext) onDelete;

  int imageQuality;
  double height;
  ImageBox({
    this.newImage = false,
    this.onlineImage = false,
    this.image,
    this.onlineImageLink,
    @required this.onAddPhoto,
    this.onDelete,
    this.imageQuality = 60,
    this.height = 100,
  });

  Widget onErrorImage() => Center(
      child: Text('x',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 40,
          )));

  Future<File> addFile(BuildContext context) async {
    // add file

    var pickedFile = await showDialog(
      context: context,
      builder: (context) => ChooseFile(
        allowFiles: false,
        imageQuality: imageQuality,
      ),
    );

    if (pickedFile is File) {
      File file = pickedFile;
      return file;
    } else {
      // User canceled the picker
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 100,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: textColorgray2),
        color: newImage ? backGroundColorImage : Colors.transparent,
      ),
      clipBehavior: Clip.hardEdge,
      child: newImage
          ?
          // new image design
          InkWell(
              onTap: () async {
                // add image
                List<File> photos = [];
                File f = await addFile(context);
                if (f != null) {
                  photos.add(f);
                }
                onAddPhoto(context, photos);
              },
              child: Container(
                width: 100,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // the circle
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                          child: Text(
                        '+',
                        style: TextStyle(
                          color: textColorDarkBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),

                    // the add photo text
                    Text(
                      'أضف صورة',
                      style: TextStyle(
                        color: textColorDarkBlack,
                      ),
                    ),
                  ],
                ),
              ),
            )
          :
          // the image
          Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  child: onlineImage
                      ? Image.network(
                          onlineImageLink,
                          fit: BoxFit.fill,
                          errorBuilder: (context, obj, _) => onErrorImage(),
                        )
                      : Image.file(
                          image.image,
                          fit: BoxFit.fill,
                          errorBuilder: (context, obj, _) => onErrorImage(),
                        ),
                ),

                // the delete button
                Positioned(
                  right: 0,
                  child: InkWell(
                    onTap: () => onDelete(context),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // color: Colors.red,
                          border: Border.all(
                            color: Colors.red,
                          )),
                      child: Center(
                        child: Text(
                          'x',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class NewImage {
  // the image file
  File image;

  // String name
  String name;
  NewImage({
    @required this.image,
    this.name = '',
  });
}
