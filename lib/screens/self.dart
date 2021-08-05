//
//
//import 'package:flutter/material.dart';
//import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
//
//class Selffie extends StatefulWidget {
//  @override
//  _SelffieState createState() => _SelffieState();
//}
//
//class _SelffieState extends State<Selffie> {
//  int _cameraFace = FlutterMobileVision.CAMERA_FRONT;
//  bool _autoFocusFace = true;
//  bool _torchFace = false;
//  bool _multipleFace = true;
//  bool _showTextFace = true;
//  Size _previewFace;
//  List<Face> _faces = [];
//
//
//
//
//  @override
//  void initState() {
//    super.initState();
//    FlutterMobileVision.start().then((previewSizes) => setState(() {
//      _previewFace = previewSizes[_cameraFace].first;
//    }));
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//    body: Column(
//
//      children: [
//
//
//        _getFaceScreen(context),
//      ],
//    ),
//
//    );
//  }
//
//
//  List<DropdownMenuItem<int>> _getCameras() {
//    List<DropdownMenuItem<int>> cameraItems = [];
//
//    cameraItems.add(DropdownMenuItem(
//      child: Text('BACK'),
//      value: FlutterMobileVision.CAMERA_BACK,
//    ));
//
//    cameraItems.add(DropdownMenuItem(
//      child: Text('FRONT'),
//      value: FlutterMobileVision.CAMERA_FRONT,
//    ));
//
//    return cameraItems;
//  }
//
//
//
//  Widget _getFaceScreen(BuildContext context) {
//    List<Widget> items = [];
//
//    items.add(Padding(
//      padding: const EdgeInsets.only(
//        top: 8.0,
//        left: 18.0,
//        right: 18.0,
//      ),
//      child: const Text('Camera:'),
//    ));
//
//    items.add(Padding(
//      padding: const EdgeInsets.only(
//        left: 18.0,
//        right: 18.0,
//      ),
//      child: DropdownButton(
//        items: _getCameras(),
//        onChanged: (value) {
//          _previewFace = null;
//          setState(() => _cameraFace = value);
//        },
//        value: _cameraFace,
//      ),
//    ));
//
//    items.add(Padding(
//      padding: const EdgeInsets.only(
//        top: 8.0,
//        left: 18.0,
//        right: 18.0,
//      ),
//      child: const Text('Preview size:'),
//    ));
//
////    items.add(Padding(
////      padding: const EdgeInsets.only(
////        left: 18.0,
////        right: 18.0,
////      ),
////      child: DropdownButton(
////        items: _getPreviewSizes(_cameraFace),
////        onChanged: (value) {
////          setState(() => _previewFace = value);
////        },
////        value: _previewFace,
////      ),
////    ));
//
//    items.add(SwitchListTile(
//      title: const Text('Auto focus:'),
//      value: _autoFocusFace,
//      onChanged: (value) => setState(() => _autoFocusFace = value),
//    ));
//
//    items.add(SwitchListTile(
//      title: const Text('Torch:'),
//      value: _torchFace,
//      onChanged: (value) => setState(() => _torchFace = value),
//    ));
//
//    items.add(SwitchListTile(
//      title: const Text('Multiple:'),
//      value: _multipleFace,
//      onChanged: (value) => setState(() => _multipleFace = value),
//    ));
//
//    items.add(SwitchListTile(
//      title: const Text('Show text:'),
//      value: _showTextFace,
//      onChanged: (value) => setState(() => _showTextFace = value),
//    ));
//
//    items.add(
//      Padding(
//        padding: const EdgeInsets.only(
//          left: 18.0,
//          right: 18.0,
//          bottom: 12.0,
//        ),
//        child: RaisedButton(
//          onPressed: _face,
//          child: Text('DETECT!'),
//        ),
//      ),
//    );
//
//    items.addAll(
//      ListTile.divideTiles(
//        context: context,
//        tiles: _faces.map((face) => FaceWidget(face)).toList(),
//      ),
//    );
//
//    return ListView(
//      padding: const EdgeInsets.only(top: 12.0),
//      children: items,
//    );
//  }
//
//  ///
//  /// Face Method
//  ///
//  Future<Null> _face() async {
//    List<Face> faces = [];
//    try {
//      faces = await FlutterMobileVision.face(
//        flash: _torchFace,
//        autoFocus: _autoFocusFace,
//        multiple: _multipleFace,
//        showText: _showTextFace,
//        preview: _previewFace,
//        camera: _cameraFace,
//        fps: 15.0,
//      );
//    } on Exception {
//      faces.add(Face(-1));
//    }
//
//    if (!mounted) return;
//
//    setState(() => _faces = faces);
//  }
//}
//
//
//class FaceWidget extends StatelessWidget {
//final Face face;
//
//FaceWidget(this.face);
//
//@override
//Widget build(BuildContext context) {
//  return ListTile(
//    leading: const Icon(Icons.face),
//    title: Text(face.id.toString()),
//    trailing: const Icon(Icons.arrow_forward),
////    onTap: () => Navigator.of(context).push(
////      MaterialPageRoute(
////        builder: (context) => FaceDetail(face),
////      ),
////    ),
//  );
//}
//}