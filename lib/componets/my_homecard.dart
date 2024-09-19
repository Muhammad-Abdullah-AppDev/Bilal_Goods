import 'package:bilal_goods/componets/text_widget.dart';
import 'package:flutter/material.dart';

class MyHomeCard extends StatelessWidget {
  const MyHomeCard({super.key,
    required this.text,
    required this.imagePath,
    required this.imgHeight,
    required this.imgWidth,
    required this.boxHeight,
    required this.boxWidth,
  });
  final text;
  final imagePath;
  final double imgHeight;
  final double imgWidth;
  final boxHeight;
  final boxWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 17),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(
              color: Colors.white,
              spreadRadius: 3,
              blurRadius: 10
            )],
              color: Theme.of(context).colorScheme.secondary,
              border: Border.all(),
              borderRadius: BorderRadius.circular(12)),
          width: boxWidth,
          height: boxHeight,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  height: imgHeight,
                  width: imgWidth,
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: MyTextWidget(
                    text: text,
                    size: 14.0,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
