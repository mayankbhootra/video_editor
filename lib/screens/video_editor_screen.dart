import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:image_picker/image_picker.dart';
import 'package:video_editing/screens/video_preview.dart';

class VideoEditor extends StatefulWidget {
  const VideoEditor({Key? key}) : super(key: key);

  @override
  _VideoEditorState createState() => _VideoEditorState();
}

class _VideoEditorState extends State<VideoEditor> {
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: flag
          ? () {
              setState(() {
                flag = false;
              });
            }
          : null,
      child: Scaffold(
        body: Container(
          // decoration: BoxDecoration(gradient: LinearGradient(colors: [])),
          color: Colors.black87,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 200, bottom: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      child: Image.asset("assets/icon.png"),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Mr. Editor",
                        style: GoogleFonts.dancingScript(
                          fontSize: 30,
                          color: Color(0xff36ccaf),
                        )),
                  ],
                ),
              ),
              Stack(
                children: [
                  if (!flag)
                    Container(
                      child: GestureDetector(
                        child: Center(
                          child: CustomContainer("Create"),
                        ),
                        onTap: () {
                          setState(() {
                            flag = true;
                          });
                        },
                      ),
                    ),
                  if (flag)
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              XFile? selectedVideo = await ImagePicker()
                                  .pickVideo(source: ImageSource.camera);
                              if (selectedVideo != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => VideoPreview(
                                      selectedVideo: File(selectedVideo.path),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: CustomContainer("Record"),
                          ),
                          GestureDetector(
                            onTap: () async {
                              XFile? selectedVideo = await ImagePicker()
                                  .pickVideo(source: ImageSource.gallery);
                              if (selectedVideo != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => VideoPreview(
                                      selectedVideo: File(selectedVideo.path),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: CustomContainer("Select"),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  String title;

  CustomContainer(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // gradient: LinearGradient(
        //   begin: Alignment.centerLeft,
        //   end: Alignment.centerRight,
        //   colors: [Colors.purple, Colors.blue],
        // ),
        color: Color(0xff36ccaf),
        boxShadow: [
          BoxShadow(offset: Offset(3, 5), color: Colors.black45),
        ],
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: Text(title,
          style: GoogleFonts.varelaRound(
              fontWeight: FontWeight.bold, fontSize: 20)),
    );
  }
}
