import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';

class ImagesForm extends StatelessWidget {
  final Product product;

  ImagesForm(this.product);

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: product.images,
      builder: (state) {
        return AspectRatio(
          aspectRatio: 1,
          child: Carousel(
            images: state.value.map((image) {
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {},
                    ),
                  ),
                ],
              );
            }).toList(),
            dotSize: 4,
            dotSpacing: 15,
            dotBgColor: Colors.transparent,
            dotColor: Theme.of(context).primaryColor,
            autoplay: false,
          ),
        );
      },
    );
  }
}
