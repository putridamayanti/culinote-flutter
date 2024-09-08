import 'package:flutter/material.dart';

class ImagePicker extends StatelessWidget {
  const ImagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white70,
        )
      ),
      child: Center(
        child: Icon(Icons.image_outlined),
      )
    );
  }
}
