import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../peppermint_sdk.dart';
import '../loading.dart';
import 'media_controller.dart';

Color cardBg = const Color(0xff181A26);

class MediaGram extends StatelessWidget {
  final Nft? data;
  final bool mix;
  final bool audible;
  final File? file;
  final File? thumbnail;
  final bool isLeaderBoard;

  /// this fileType is from local file when create NFTGram
  final String? fileType;
  final bool grid;
  final bool play3D;
  final Color? bgColor;

  const MediaGram({
    this.file,
    this.thumbnail,
    this.data,
    this.mix = true,
    this.audible = true,
    this.fileType,
    this.grid = false,
    this.play3D = true,
    this.bgColor,
    this.isLeaderBoard = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MediaController());
    if (grid) {
      String? url =
          data?.media?.thumbnail != null && data?.media?.thumbnail != ''
              ? data?.media?.thumbnail
              : data?.render;
      return ImageGram(
        url,
        (data?.media!.fileType == '3d' || fileType == '3d'),
        isLeaderBoard3D: isLeaderBoard,
      );
    }
    if (data?.media!.fileType == 'video' || fileType == 'video') {
      return VideoGram(
        url: data?.media?.fileUrl,
        file: file,
        mix: mix,
        audible: audible,
        bgColor: bgColor ?? Colors.white12,
      );
    } else if (data?.media!.fileType == 'audio' || fileType == 'audio') {
      return AudioWidget(
        data: data,
        file: file,
        thumbnail: thumbnail,
        audible: audible,
      );
    } else if (data?.media!.fileType == '3d' || fileType == '3d') {
      String? url =
          data?.media?.thumbnail != null && data?.media?.thumbnail != ''
              ? data?.media?.thumbnail
              : data?.render;
      return !play3D
          ? ImageGram(
              url,
              true,
              isLeaderBoard3D: isLeaderBoard,
            )
          : Media3D(
              file: file,
              data: data,
            );
    } else if (data?.media!.fileType == 'image' || fileType == 'image') {
      String? url = data?.media?.fileUrl;
      return ImageGram(
        url,
        false,
        isLeaderBoard3D: isLeaderBoard,
      );
    }
    return Container();
  }
}

class ImageGram extends StatelessWidget {
  final String? url;
  final bool media3D;
  final bool isLeaderBoard3D;

  const ImageGram(this.url, this.media3D,
      {required this.isLeaderBoard3D, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Stack(
        children: [
          Hero(
            tag: '$url',
            child: VImageLoader(
              url: url,
              width: double.infinity,
              height: double.infinity,
              boxFit: BoxFit.cover,
              errorText: 'The image will be available soon!',
            ),
          ),
          if (media3D)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cardBg,
                ),
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/icons/cube.svg',
                  color: Colors.white,
                  width: isLeaderBoard3D ? 7.0 : 24.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class VideoGram extends StatefulWidget {
  final String? url;
  final File? file;
  final bool audible;
  final bool mix;
  final Color bgColor;

  const VideoGram({
    Key? key,
    this.url,
    this.file,
    this.audible = true,
    this.mix = true,
    this.bgColor = Colors.white12,
  }) : super(key: key);

  @override
  _VideoGramState createState() => _VideoGramState();
}

class _VideoGramState extends State<VideoGram> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  MediaController mediaController = Get.find<MediaController>();
  File? file;

  @override
  void initState() {
    super.initState();
    file = widget.file;
    initPlayer();
  }

  initPlayer() {
    try {
      _controller = file != null
          ? VideoPlayerController.file(file!,
              videoPlayerOptions: VideoPlayerOptions(mixWithOthers: widget.mix))
          : VideoPlayerController.network(widget.url!);
      _controller.setLooping(true);
      _initializeVideoPlayerFuture = _controller.initialize().then((_) async {
        await _controller.setVolume(mediaController.mute.value ? 0.0 : 100.0);
        if (!widget.audible) await _controller.setVolume(0.0);
        setState(() {});
      }).onError((error, stackTrace) {
        Sentry.captureEvent(SentryEvent(
            culprit: 'Can not load video file',
            message: SentryMessage('$error\n$stackTrace')));
        return;
      });
    } catch (e) {
      Get.log('catch e');
      Get.log('$e');
    }
  }

  muteUnmute() async {
    await _controller.setVolume(mediaController.mute.value ? 0.0 : 100.0);
    if (!widget.audible) await _controller.setVolume(0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        double ratio =
            _controller.value.size.width / _controller.value.size.height;
        if (snapshot.connectionState == ConnectionState.done) {
          return VisibilityDetector(
            key: ObjectKey(_controller),
            onVisibilityChanged: (visiblityInfo) {
              if (visiblityInfo.visibleFraction >= 0.85) {
                _controller.play();
              }
              if (visiblityInfo.visibleFraction < 0.85 && mounted) {
                _controller.pause();
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              color: widget.bgColor,
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Center(
                    child: ratio.isNaN
                        ? AspectRatio(
                            aspectRatio: 1.0,
                            child: Lottie.asset('assets/lottie/music.json'),
                          )
                        : AspectRatio(
                            aspectRatio: ratio,
                            child: VideoPlayer(_controller),
                          ),
                  ),
                  if (widget.audible)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () async {
                          mediaController.toggleMute(callback: () async {
                            await _controller.setVolume(
                                mediaController.mute.value ? 0.0 : 100.0);
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: cardBg),
                          child: Obx(() {
                            muteUnmute();
                            return Icon(
                              mediaController.mute.value
                                  ? Icons.volume_off
                                  : Icons.volume_up,
                              color: Colors.white,
                              size: 16.0,
                            );
                          }),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        } else {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: const PeppermintLoading(),
          );
        }
      },
    );
  }
}

class AudioWidget extends StatefulWidget {
  final Nft? data;
  final bool audible;
  final File? file;
  final File? thumbnail;

  const AudioWidget({
    this.data,
    this.file,
    this.thumbnail,
    this.audible = true,
    Key? key,
  }) : super(key: key);

  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  late AudioPlayer _controller;
  Duration _seek = Duration.zero;
  MediaController controller = Get.find<MediaController>();
  bool mute = false;

  @override
  void initState() {
    super.initState();
    mute = controller.mute.value;
    _controller = AudioPlayer();
    if (widget.audible) {
      widget.file != null
          ? _controller.setSourceDeviceFile(widget.file!.path)
          : _controller.setSourceUrl(widget.data!.media!.fileUrl!);
      _controller.setVolume(controller.mute.value ? 0.0 : 1.0);
    }
    _controller.setReleaseMode(ReleaseMode.loop);
    _controller.onPositionChanged.listen((event) {
      setState(() {
        _seek = event;
      });
    });
    _controller.onDurationChanged.listen((event) {
      setState(() {
        _seek = event;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  muteUnmute() async {
    _controller.setVolume(controller.mute.value ? 0.0 : 1.0);
    mute = controller.mute.value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(_controller),
      onVisibilityChanged: (visiblityInfo) {
        if (visiblityInfo.visibleFraction >= 0.85) {
          if (widget.audible) {
            _controller.resume();
          }
        }
        if (visiblityInfo.visibleFraction < 0.85 && mounted) {
          _controller.pause();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        color: Colors.white12,
        child: Stack(
          children: [
            if (widget.data?.media?.thumbnail != null)
              VImageLoader(
                url: widget.data?.media?.thumbnail,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
              )
            else if (widget.thumbnail != null)
              VImageLoader(
                file: widget.thumbnail,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
              )
            else
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: Lottie.asset(
                  'assets/lottie/music.json',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(formatTime(_seek)),
            ),
            if (widget.audible)
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () async {
                    controller.toggleMute(callback: () {
                      _controller.setVolume(controller.mute.value ? 0.0 : 1.0);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(4.0),
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: cardBg),
                    child: Obx(() {
                      if (mute != controller.mute.value) {
                        muteUnmute();
                      }
                      return Icon(
                        controller.mute.value
                            ? Icons.volume_off
                            : Icons.volume_up,
                        color: Colors.white,
                        size: 16.0,
                      );
                    }),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }
}

class Media3D extends StatelessWidget {
  final Nft? data;
  final File? file;

  const Media3D({this.data, this.file, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width,
      color: Colors.white12,
      child: ModelViewer(
        src: file != null ? 'file://${file!.path}' : data!.media!.fileUrl!,
        cameraControls: true,
        touchAction: TouchAction.none,
      ),
    );
  }
}
