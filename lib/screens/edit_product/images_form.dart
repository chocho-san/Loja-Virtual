import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/screens/edit_product/Image_source_sheet.dart';

class ImagesForm extends StatelessWidget {
  final Product product;

  ImagesForm(this.product);

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(product.images), //編集前

      validator: (image) {
        // formKey.currentState.validate()でコールされる
        if (image.isEmpty) {
          return '画像を追加してください'; //builder以下のstate.hasErrorになる
        } else {
          return null;
        }
      },
      onSaved: (images)=>product.newImages=images, //追加した画像も含める
      builder: (state) {
        void onImageSelected(File file) {
          state.value.add(file);
          state.didChange(state.value);
          Navigator.of(context).pop();
        }

        return Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: state.value.map<Widget>((image) {
                  /*<Widget>任意のタイプ受け入れられる*/
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      if (image is String)
                        Image.network(
                          image,
                          fit: BoxFit.cover,
                        )
                      else
                        Image.file(
                          image,
                          fit: BoxFit.cover,
                        ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            state.value.remove(image);
                            state.didChange(state.value); /*このフィールドの状態を新しい値に更新*/
                          },
                        ),
                      ),
                    ],
                  );
                }).toList()
                  ..add(
                    Material(
                      /*インク効果*/
                      color: Colors.grey[100],
                      child: IconButton(
                        icon: Icon(Icons.add_a_photo),
                        color: Theme.of(context).primaryColor,
                        iconSize: 50,
                        onPressed: () {
                          if (Platform.isAndroid)
                            showModalBottomSheet(
                              context: context,
                              builder: (_) => ImageSourceSheet(
                                onImageSelected: onImageSelected,
                              ),
                            );
                          else
                            showCupertinoModalPopup(
                              context: context,
                              builder: (_) => ImageSourceSheet(
                                onImageSelected: onImageSelected,
                              ),
                            );
                        },
                      ),
                    ),
                  ),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: Theme.of(context).primaryColor,
                autoplay: false,
              ),
            ),
            if (state.hasError)
              Container(
                margin: EdgeInsets.only(top: 16, left: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
