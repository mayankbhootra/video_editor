import 'package:flutter/material.dart';

import 'package:helpers/helpers.dart';
import 'package:video_editor/video_editor.dart';

class CropScreen extends StatelessWidget {
  CropScreen({Key? key, required this.controller}) : super(key: key);

  final VideoEditorController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: Margin.all(30),
          child: Container(
            color: Colors.black87,
            child: Column(children: [
              Expanded(
                child: AnimatedInteractiveViewer(
                  maxScale: 2.4,
                  child: CropGridViewer(controller: controller),
                ),
              ),
              SizedBox(height: 15),
              Row(children: [
                Expanded(
                  child: SplashTap(
                    onTap: context.navigator.pop,
                    child: Center(
                      child: Text(
                        "CANCEL",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff36ccaf),
                        ),
                      ),
                    ),
                  ),
                ),
                buildSplashTap("16:9", 16 / 9, padding: Margin.horizontal(10)),
                buildSplashTap("1:1", 1 / 1),
                buildSplashTap("4:5", 4 / 5, padding: Margin.horizontal(10)),
                buildSplashTap("NO", null, padding: Margin.right(10)),
                Expanded(
                  child: SplashTap(
                    onTap: () {
                      //2 WAYS TO UPDATE CROP
                      //WAY 1:
                      controller.updateCrop();
                      /*WAY 2:
                      controller.minCrop = controller.cacheMinCrop;
                      controller.maxCrop = controller.cacheMaxCrop;
                      */
                      context.navigator.pop();
                    },
                    child: Center(
                      child: Text(
                        "OK",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff36ccaf),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  Widget buildSplashTap(
    String title,
    double? aspectRatio, {
    EdgeInsetsGeometry? padding,
  }) {
    return SplashTap(
      onTap: () => controller.preferredCropAspectRatio = aspectRatio,
      child: Padding(
        padding: padding ?? Margin.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.aspect_ratio, color: Colors.white),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff36ccaf),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
