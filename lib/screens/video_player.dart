import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  const FullScreenVideoPlayer({super.key});

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

//List<String> videoAssetPaths = ['assets/A.mp4', 'assets/C.mp4', 'assets/B.mp4'];
List<String> videoAssetPaths = ['assets/F.mp4', 'assets/D.mp4', 'assets/E.mp4'];

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;
  int nextVideoIndex = 1;
  int selectedTileIndex = -1;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration) {
        print("Video ended");
        print("Actual 1st Video length${_controller.value.duration}");
        print("1st Video ended at ${_controller.value.position}");
        switchVideo(nextVideoIndex);
        Navigator.of(context).pop();
      }
    });
  }

  void _initializeVideoController() {
    _controller = VideoPlayerController.asset(
      videoAssetPaths[0],
    )..initialize().then((_) {
        setState(() {});
      });
  }

  void switchVideo(int videoIndex) {
    _controller.pause().then((_) => _controller.dispose()).then((_) {
      _controller = VideoPlayerController.asset(
        videoAssetPaths[videoIndex],
      )..initialize().then((_) {
          _controller.play();
          setState(() {});
        });
    });
  }

  void clearSelection() {
    setState(() {
      selectedTileIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.play();
          Future.delayed(const Duration(seconds: 15), () {
            showBottomOptions();
          });
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }

  void showBottomOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white.withOpacity(0.5),
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: 180,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Which option are you interested in seeing next?",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 2,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 100, right: 100),
                          child: Container(
                            color: (index == selectedTileIndex)
                                ? Colors.green
                                : null,
                            child: ListTile(
                              selected: index == selectedTileIndex,
                              title: Text(
                                index != 0 ? 'Mountains' : 'Skyscraper',
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                              onTap: () {
                                if (selectedTileIndex == index) {
                                  clearSelection();
                                } else {
                                  setState(() {
                                    nextVideoIndex = index + 1;
                                    selectedTileIndex = index;
                                  });
                                }
                                print("selected option ${index + 1}");
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
