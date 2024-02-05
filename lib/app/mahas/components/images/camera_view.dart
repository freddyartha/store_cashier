// ignore_for_file: library_private_types_in_public_api, unnecessary_new

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_utilities/flutter_image_utilities.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_svg/flutter_svg.dart';
// ignore: library_prefixes
import 'package:image/image.dart' as PackagedImage;
import 'package:dotted_border/dotted_border.dart';

import '../../mahas_colors.dart';
import '../../mahas_font_size.dart';
import '../../services/helper.dart';
import '../inputs/unordered_list_component.dart';
import '../texts/text_component.dart';
import 'photo_type.dart';

class CameraView extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final PhotoType? type;

  const CameraView({super.key, this.cameras, this.type});

  @override
  _CameraViewState createState() => new _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  CameraController? controller;
  String? imagePath;
  final double bottomWidgetHeight = 120;
  Size? frameSize;
  bool frontCamera = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final cameraPreviewWidgetGlobalKey = GlobalKey();
  List? cameras;
  int? selectedCameraIdx;
  bool _autoFlashMode = false;

  @override
  void initState() {
    super.initState();
    didChangeAppLifecycleState(AppLifecycleState.detached);
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(Duration.zero).then((_) {
        _initFrame();
        availableCameras().then((availableCameras) {
          cameras = availableCameras;
          if (cameras!.isNotEmpty) {
            setState(() {
              if (widget.type == PhotoType.selfie) {
                selectedCameraIdx = 1;
              } else {
                selectedCameraIdx = 0;
              }
            });
            _initCameraController(cameras![selectedCameraIdx!]);
          } else {
            Helper.debugLogger("No camera available");
          }
        }).catchError((err) {
          // 3
          Helper.debugLogger('Error: $err.code\nError Message: $err.message');
        });
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller!.dispose();
    controller = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        _initCameraController(controller!.description);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Center(
            child: _cameraPreviewWidget(),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: MahasColors.primary,
            height: widget.type == PhotoType.kwitasi ? 90 : 110,
            child: TextComponent(
              padding: const EdgeInsets.only(top: 70, left: 20),
              value: widget.type!.descTitle,
              fontColor: MahasColors.light,
              fontSize: MahasFontSize.h3,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 30, 0, 0),
              child: IconButton(
                icon: const Icon(Icons.close),
                iconSize: 20,
                color: Colors.white,
                onPressed: _closeCameraView,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _initFrame() {
    final deviceSize = MediaQuery.of(context).size;
    if (widget.type == PhotoType.ktp) {
      double size = deviceSize.width - 40;
      frameSize = Size(size, size * 0.6);
    } else if (widget.type == PhotoType.kwitasi) {
      frameSize = Size(
          deviceSize.width - 40, deviceSize.height - bottomWidgetHeight - 300);
    } else if (widget.type == PhotoType.familyCard) {
      frameSize = Size(
          deviceSize.width - 40, deviceSize.height - bottomWidgetHeight - 180);
    } else {
      frameSize = null;
    }
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    } else {
      return imagePath != null ? _photoPreview() : _cameraPreview();
    }
  }

  Widget _photoPreview() {
    return Stack(
      children: <Widget>[
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.5,
            child: Align(
              alignment: Alignment.center,
              child: Image.file(
                File(imagePath!),
                fit:
                    widget.type == PhotoType.ktp ? BoxFit.fill : BoxFit.contain,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _captureIconWidget(),
        )
      ],
    );
  }

  bool _isCroppingCamera() {
    return widget.type == PhotoType.kwitasi || widget.type == PhotoType.ktp;
  }

  Widget _cameraPreview() {
    if (_isCroppingCamera()) {
      return Portal(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Transform.scale(
                scale: 1 /
                    (controller!.value.aspectRatio *
                        MediaQuery.of(context).size.aspectRatio),
                key: cameraPreviewWidgetGlobalKey,
                child: CameraPreview(controller!),
              ),
            ),
            const ClipOval(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: 0.5,
              ),
            ),
            ClipPath(
              clipper: InvertedRectangleClipper(frameSize!),
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, 0.8),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: PortalTarget(
                  anchor: const Aligned(
                      follower: Alignment.topCenter,
                      target: Alignment.topCenter),
                  portalFollower: const SizedBox(),
                  child: DottedBorder(
                    color: Colors.white,
                    strokeWidth: 2,
                    dashPattern: const [8, 8],
                    strokeCap: StrokeCap.round,
                    child: SizedBox(
                      width: frameSize!.width,
                      height: frameSize!.height,
                    ),
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _captureIconWidget(),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  margin: EdgeInsets.only(
                      top: widget.type == PhotoType.kwitasi ? 90 : 150),
                  child: _cameraMessage()),
            ),
          ],
        ),
      );
    } else if (widget.type == PhotoType.selfie) {
      return Stack(children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Transform.scale(
            scale: 1 /
                (controller!.value.aspectRatio *
                    MediaQuery.of(context).size.aspectRatio),
            key: cameraPreviewWidgetGlobalKey,
            child: CameraPreview(controller!),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 110),
          child: const Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Image(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/frame_face.png'),
                  ),
                  SizedBox(height: 30),
                  Image(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/frame_ktp.png'),
                  ),
                ],
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _captureIconWidget(),
        ),
      ]);
    } else if (widget.type == PhotoType.familyCard) {
      return Portal(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Transform.scale(
                scale: 1 /
                    (controller!.value.aspectRatio *
                        MediaQuery.of(context).size.aspectRatio),
                key: cameraPreviewWidgetGlobalKey,
                child: CameraPreview(controller!),
              ),
            ),
            const ClipOval(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: 0.5,
              ),
            ),
            ClipPath(
              clipper: InvertedRectangleClipper(frameSize!),
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, 0.8),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: PortalTarget(
                  // portalAnchor: Alignment.bottomCenter,
                  anchor: Aligned.center,
                  portalFollower: _cameraMessage(),
                  child: DottedBorder(
                    color: Colors.white,
                    strokeWidth: 2,
                    dashPattern: const [8, 8],
                    strokeCap: StrokeCap.round,
                    child: SizedBox(
                      width: frameSize!.width,
                      height: frameSize!.height,
                    ),
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _captureIconWidget(),
            ),
          ],
        ),
      );
    } else {
      return Stack(children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Transform.scale(
            scale: 1 /
                (controller!.value.aspectRatio *
                    MediaQuery.of(context).size.aspectRatio),
            key: cameraPreviewWidgetGlobalKey,
            child: CameraPreview(controller!),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _captureIconWidget(),
        ),
      ]);
    }
  }

  Widget _cameraMessage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: frameSize!.width,
        height: 100,
        child: Center(
          child: UnorderedListComponent(widget.type!.content,
              const TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _captureIconWidget() {
    return Container(
      color: Colors.black.withOpacity(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        child: SizedBox(
          height: bottomWidgetHeight,
          width: double.infinity,
          child: Stack(
            children: _bottomWidgets(),
          ),
        ),
      ),
    );
  }

  List<Widget> _bottomWidgets() {
    if (imagePath != null) {
      return [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.delete),
                iconSize: 40,
                color: Colors.white,
                onPressed: _removeImage,
              ),
              IconButton(
                icon: const Icon(Icons.check),
                iconSize: 40,
                color: Colors.white,
                onPressed: () {
                  _closeCameraViewWithFilePath(imagePath!);
                },
              ),
            ],
          ),
        ),
      ];
    } else {
      return [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: MahasColors.light,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: IconButton(
                icon: SvgPicture.asset('assets/svg/camera_btn.svg'),
                iconSize: 64,
                color: Colors.white,
                onPressed: controller != null && controller!.value.isInitialized
                    ? onTakePictureButtonPressed
                    : null,
              ),
            ),
          ),
        ),
        widget.type == PhotoType.ktp
            ? Positioned(
                top: 30,
                right: 25,
                child: IconButton(
                    icon: Icon(
                      _autoFlashMode ? Icons.flash_auto : Icons.flash_off,
                      color: MahasColors.primary,
                      size: 30,
                    ),
                    iconSize: 64,
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        _autoFlashMode = !_autoFlashMode;
                      });
                    }),
              )
            : Positioned(
                top: 30,
                right: 25,
                child: IconButton(
                    icon: SvgPicture.asset('assets/svg/switch_cam.svg'),
                    iconSize: 64,
                    color: Colors.white,
                    onPressed: _onSwitchCamera),
              ),
      ];
    }
  }

  void _removeImage() {
    setState(() {
      imagePath = null;
    });
  }

  void _closeCameraView() {
    setState(() {
      _autoFlashMode = false;
    });
    Navigator.pop(context);
  }

  void _closeCameraViewWithFilePath(String filePath) {
    setState(() {
      _autoFlashMode = false;
    });
    Navigator.pop(context, filePath);
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }

    // 3
    setState(() {
      controller = CameraController(cameraDescription, ResolutionPreset.medium,
          enableAudio: false);
    });

    // If the controller is updated then update the UI.
    // 4
    if (controller != null) {
      Helper.debugLogger("Controller is not null");
      try {
        await controller!.initialize();
        Helper.debugLogger("Controller initialized successfully");
        setState(() {});
        Helper.debugLogger(
            "Controller initialized: ${controller!.value.isInitialized}");
      } catch (e) {
        Helper.debugLogger("Error initializing controller: $e");
      }
    } else {
      Helper.debugLogger("Controller is null");
    }

    controller!.addListener(() {
      // 5
      if (mounted) {
        setState(() {});
      }

      if (controller!.value.hasError) {
        Helper.debugLogger(
            'Camera error ${controller!.value.errorDescription}');
      }
    });

    // 6
    try {} on CameraException catch (e) {
      // ignore: avoid_print
      print("Error : $e");
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onSwitchCamera() {
    selectedCameraIdx =
        selectedCameraIdx! < cameras!.length - 1 ? selectedCameraIdx! + 1 : 0;
    CameraDescription selectedCamera = cameras![selectedCameraIdx!];
    _initCameraController(selectedCamera);
  }

  void onTakePictureButtonPressed() {
    controller!.setFlashMode(_autoFlashMode ? FlashMode.auto : FlashMode.off);
    takePicture().then((String? filePath) async {
      if (_isCroppingCamera()) {
        await _fixExifRotation(filePath!);
        final croppedImage = await _cropImage(filePath);
        if (mounted) {
          setState(() {
            imagePath = croppedImage;
          });
        }
      } else {
        if (mounted) {
          if (selectedCameraIdx == 1) {
            var a = await _flipImage(filePath!);
            setState(() {
              imagePath = a;
            });
          } else {
            setState(() {
              imagePath = filePath;
            });
          }
        }
      }
    });
  }

  Future<String> _cropImage(String filePath) async {
    RenderBox? cameraPreviewWidget =
        _scaffoldKey.currentContext!.findRenderObject() as RenderBox;
    final imageFile = File(filePath);
    ImageProperties imageProperties =
        await FlutterImageUtilities.getImageProperties(imageFile);

    final imageWidth = imageProperties.width! > imageProperties.height!
        ? imageProperties.height
        : imageProperties.width;
    final scaleRatioWidth = cameraPreviewWidget.size.width / imageWidth!;
    final originX = (cameraPreviewWidget.size.width - frameSize!.width) /
        2 /
        scaleRatioWidth;
    final originY = (cameraPreviewWidget.size.height - frameSize!.height) /
        3.5 /
        scaleRatioWidth;
    final width = frameSize!.width / scaleRatioWidth;
    final height = frameSize!.height / scaleRatioWidth;

    final image = PackagedImage.decodeImage(File(filePath).readAsBytesSync());
    PackagedImage.Image fixedRotationImage = image!;
    if (fixedRotationImage.width > fixedRotationImage.height) {
      fixedRotationImage = PackagedImage.copyRotate(fixedRotationImage,
          angle: _getFixAngle(imageProperties.orientation));
    }
    PackagedImage.Image croppedImage = PackagedImage.copyCrop(
        fixedRotationImage,
        x: originX.toInt(),
        y: originY.toInt(),
        width: width.toInt(),
        height: height.toInt());
    final file = File(filePath)
      ..writeAsBytesSync(PackagedImage.encodeJpg(croppedImage));
    return file.path;
  }

  Future<String> _flipImage(String filePath) async {
    final image = PackagedImage.decodeImage(File(filePath).readAsBytesSync());
    PackagedImage.Image fixedRotationImage = image!;
    PackagedImage.Image fixedImage =
        PackagedImage.bakeOrientation(fixedRotationImage);
    PackagedImage.Image croppedImage = PackagedImage.flipHorizontal(fixedImage);

    final file = File(filePath)
      ..writeAsBytesSync(PackagedImage.encodeJpg(croppedImage));
    return file.path;
  }

  Future<File> _fixExifRotation(String imagePath) async {
    final originalFile = File(imagePath);
    final originalImage =
        PackagedImage.decodeImage(originalFile.readAsBytesSync());

    PackagedImage.Image fixedImage =
        PackagedImage.bakeOrientation(originalImage!);
    final fixedFile =
        await originalFile.writeAsBytes(PackagedImage.encodeJpg(fixedImage));

    return fixedFile;
  }

  num _getFixAngle(ImageOrientation orientation) {
    switch (orientation) {
      case ImageOrientation.normal:
        return 90;
      case ImageOrientation.rotate90:
        return -90;
      case ImageOrientation.rotate180:
        return -180;
      case ImageOrientation.rotate270:
        return -270;
      case ImageOrientation.undefined:
        return 90;
      default:
        return -90;
    }
  }

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  Future<String?> takePicture() async {
    if (!controller!.value.isInitialized) {
      return null;
    }
    String filePath = "";

    if (controller!.value.isTakingPicture) {
      return null;
    }

    try {
      var xfile = await controller!.takePicture();
      filePath = xfile.path;
      // await controller.takePicture();
    } on CameraException catch (e) {
      Helper.debugLogger(e);
      return null;
    }
    return filePath;
  }
}

class InvertedRectangleClipper extends CustomClipper<Path> {
  final Size frameSize;

  InvertedRectangleClipper(this.frameSize);

  @override
  Path getClip(Size size) {
    return Path()
      ..addRect(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: frameSize.width,
          height: frameSize.height,
        ),
      )
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
