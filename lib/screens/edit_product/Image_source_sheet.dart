import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final Function(File) onImageSelected;

  ImageSourceSheet({this.onImageSelected});

  final ImagePicker picker = ImagePicker();

  Future<void> editImage(String path,BuildContext context) async{
    final File croppedFile =await ImageCropper.cropImage(
      sourcePath: path, //編集したい画像
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: '画像編集',
        toolbarColor: Theme.of(context).primaryColor,
        toolbarWidgetColor: Colors.white,
      ),
      iosUiSettings: IOSUiSettings(
        title: '画像編集',
        cancelButtonTitle: 'キャンセル',
        doneButtonTitle: '完了',
      ),
    );
    if(croppedFile!=null){
      onImageSelected(croppedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid)
      return BottomSheet(
        onClosing: () {},
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          /*押す範囲広がる*/
          children: [
            FlatButton(
              onPressed: () async {
                final PickedFile file = await picker.getImage(
                    source: ImageSource.camera); // カメラから読み込み
                editImage(file.path,context); //画像編集
              },
              child: Text('カメラ'),
            ),
            FlatButton(
              onPressed: () async {
                final PickedFile file = await picker.getImage(
                    source: ImageSource.gallery); // アルバムから読み込み
                editImage(file.path,context);
              },
              child: Text('画像ファイル'),
            ),
          ],
        ),
      );
    else
      return CupertinoActionSheet(
        title: Text('イメージの追加'),
        message: Text('画像を選択してください'),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('キャンセル'),
        ),
        actions: [
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () async {
              final PickedFile file = await picker.getImage(
                  source: ImageSource.camera); // カメラから読み込み
              editImage(file.path,context);
            },
            child: Text('カメラ'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              final PickedFile file = await picker.getImage(
                  source: ImageSource.camera); // カメラから読み込み
              editImage(file.path,context);
            },
            child: Text('画像ファイル'),
          ),
        ],
      );
  }
}
