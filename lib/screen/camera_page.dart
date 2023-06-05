import 'package:camera/camera.dart';
import 'package:camera_sample/screen/preview_page.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;

  const CameraPage({super.key, this.cameras});

  @override
  State<StatefulWidget> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  double _cameraZoomLevel = 0.0;
  double _cameraExposure = 0.0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          (_cameraController.value.isInitialized)
              ? CameraPreview(_cameraController)
              : Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.30,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  color: Colors.black38),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: IconButton(
                    onPressed: takePhoto,
                    iconSize: 50,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.circle,
                      color: Colors.white,
                    ),
                  )),
                  const Text("Zoom Level"),
                  Slider.adaptive(
                      value: _cameraZoomLevel,
                      min: 0.0,
                      max: 10.0,
                      onChanged: (value) async {
                    setState(() {
                      _cameraZoomLevel = value;
                    });
                    _cameraController.setZoomLevel(_cameraZoomLevel);
                  }),
                  const Text("Exposure Level"),
                  Slider.adaptive(
                      value: _cameraExposure,
                      min: -5.0,
                      max: 2.0,
                      onChanged: (value) async {
                        setState(() {
                          _cameraExposure = value;
                        });
                        _cameraController.setExposureOffset(_cameraExposure);
                      })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.cameras!.isNotEmpty) {
      _cameraController =
          CameraController(widget.cameras![0], ResolutionPreset.high);

      initCamera();
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> initCamera() async {
    try {
      await _cameraController.initialize().then((value) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (error) {
      debugPrint("Camera Init Error $error");
    }
    ;
  }

  Future<void> takePhoto() async {
    if (!_cameraController.value.isInitialized) return;
    if (_cameraController.value.isTakingPicture) return;

    try {
      XFile picture = await _cameraController.takePicture();
      debugPrint("Path photo located at ${picture.path}");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  PreviewPage(path: picture.path, name: picture.name)));
    } on CameraException catch (error) {
      debugPrint("Camera take picture error $error");
    }
  }
}
