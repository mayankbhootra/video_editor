import 'dart:io';

import 'package:flutter/material.dart';
import 'package:helpers/helpers.dart';
import 'package:video_editing/screens/crop_screen.dart';
import 'package:video_editor/video_editor.dart';

class VideoPreview extends StatefulWidget {
  File selectedVideo;

  VideoPreview({required this.selectedVideo});

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;

  bool _exported = false;
  String _exportText = "";
  late VideoEditorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoEditorController.file(widget.selectedVideo,
        maxDuration: Duration(seconds: 30))
      ..initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _exportingProgress.dispose();
    _isExporting.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _openCropScreen() => Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CropScreen(controller: _controller)));

  void _exportVideo() async {
    Misc.delayed(1000, () => _isExporting.value = true);
    final File? file = await _controller.exportVideo(
      preset: VideoExportPreset.medium,
      customInstruction: "-crf 17",
      onProgress: (statics) {
        _exportingProgress.value =
            statics.time / _controller.video.value.duration.inMilliseconds;
      },
    );
    _isExporting.value = false;

    if (file != null)
      _exportText = "Video success export!";
    else
      _exportText = "Error on export video :(";

    setState(() => _exported = true);
    Misc.delayed(2000, () => setState(() => _exported = false));
  }

  void _exportCover() async {
    setState(() => _exported = false);
    final File? cover = await _controller.extractCover();

    if (cover != null)
      _exportText = "Cover exported! ${cover.path}";
    else
      _exportText = "Error on cover exportation :(";

    setState(() => _exported = true);
    Misc.delayed(2000, () => setState(() => _exported = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black12,
      body: _controller.initialized
          ? SafeArea(
              child: Container(
              color: Colors.black87,
              child: Stack(
                children: [
                  Column(
                    children: [
                      _topNavBar(),
                      Expanded(
                        child: DefaultTabController(
                          length: 2,
                          child: Column(
                            children: [
                              Expanded(
                                child: TabBarView(
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CropGridViewer(
                                          controller: _controller,
                                          showGrid: false,
                                        ),
                                        AnimatedBuilder(
                                          animation: _controller.video,
                                          builder: (_, __) => OpacityTransition(
                                              visible: !_controller.isPlaying,
                                              child: GestureDetector(
                                                onTap: _controller.video.play,
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle),
                                                  child: Icon(
                                                    Icons.play_arrow,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                    CoverViewer(controller: _controller)
                                  ],
                                ),
                              ),
                              Container(
                                height: 200,
                                margin: Margin.top(10),
                                child: Column(
                                  children: [
                                    TabBar(
                                      indicatorColor: Colors.white,
                                      tabs: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: Margin.all(5),
                                              child: Icon(Icons.content_cut),
                                            ),
                                            Text(
                                              "Trim",
                                              style: TextStyle(
                                                color: Color(0xff36ccaf),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                  padding: Margin.all(5),
                                                  child:
                                                      Icon(Icons.video_label)),
                                              Text(
                                                'Cover',
                                                style: TextStyle(
                                                  color: Color(0xff36ccaf),
                                                ),
                                              )
                                            ]),
                                      ],
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        children: [
                                          Container(
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: _trimSlider())),
                                          Container(
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [_coverSelection()]),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              _customSnackBar(),
                              ValueListenableBuilder(
                                  valueListenable: _isExporting,
                                  builder: (_, bool export, __) =>
                                      OpacityTransition(
                                          visible: export,
                                          child: AlertDialog(
                                            backgroundColor: Colors.white,
                                            title: ValueListenableBuilder(
                                              valueListenable:
                                                  _exportingProgress,
                                              builder: (_, double value, __) =>
                                                  Text(
                                                "Exporting video ${(value * 100).ceil()}%",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff36ccaf),
                                                ),
                                              ),
                                            ),
                                          )))
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ))
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _topNavBar() {
    return SafeArea(
        child: Container(
      height: height,
      // color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _controller.rotate90Degrees(RotateDirection.left),
              child: Icon(
                Icons.rotate_left,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _controller.rotate90Degrees(RotateDirection.right),
              child: Icon(Icons.rotate_right, color: Colors.white),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: _openCropScreen,
              child: Icon(Icons.crop, color: Colors.white),
            ),
          ),
          // Expanded(
          //   child: GestureDetector(
          //     onTap: _exportCover,
          //     child: Icon(Icons.save_alt, color: Colors.white),
          //   ),
          // ),
          Expanded(
            child: GestureDetector(
              onTap: _exportVideo,
              child: Icon(Icons.save, color: Colors.white),
            ),
          ),
        ],
      ),
    ));
  }

  String formatter(Duration duration) => [
        duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
        duration.inSeconds.remainder(60).toString().padLeft(2, '0')
      ].join(":");

  List<Widget> _trimSlider() {
    return [
      AnimatedBuilder(
        animation: _controller.video,
        builder: (_, __) {
          final duration = _controller.video.value.duration.inSeconds;
          final pos = _controller.trimPosition * duration;
          final start = _controller.minTrim * duration;
          final end = _controller.maxTrim * duration;

          return Padding(
            padding: Margin.horizontal(height / 4),
            child: Row(children: [
              Text(
                formatter(Duration(seconds: pos.toInt())),
                style: TextStyle(
                  color: Color(0xff36ccaf),
                ),
              ),
              Expanded(child: SizedBox()),
              OpacityTransition(
                visible: _controller.isTrimming,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    formatter(Duration(seconds: start.toInt())),
                    style: TextStyle(
                      color: Color(0xff36ccaf),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    formatter(Duration(seconds: end.toInt())),
                    style: TextStyle(
                      color: Color(0xff36ccaf),
                    ),
                  ),
                ]),
              )
            ]),
          );
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: Margin.vertical(height / 4),
        child: TrimSlider(
            child: TrimTimeline(
                controller: _controller, margin: EdgeInsets.only(top: 10)),
            controller: _controller,
            height: height,
            horizontalMargin: height / 4),
      )
    ];
  }

  Widget _coverSelection() {
    return Container(
        margin: Margin.horizontal(height / 4),
        child: CoverSelection(
          controller: _controller,
          height: height,
          nbSelection: 8,
        ));
  }

  Widget _customSnackBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SwipeTransition(
        visible: _exported,
        axis: Axis.vertical,
        // direction: SwipeDirection.fromBottom,
        child: Container(
          height: height,
          width: double.infinity,
          color: Color(0xff36ccaf),
          child: Center(
            child: Text(
              _exportText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff36ccaf),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
