import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'camera_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Camera Sample"),),
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              await availableCameras().then((value) =>
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
            }, child: Text("Open Camera"),
          ),
        ),
      ),
    );
  }

}

