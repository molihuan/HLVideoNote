// import 'dart:io';
// import 'dart:typed_data';

// import 'package:extended_image/extended_image.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_quill_extensions/shims/dart_ui_real.dart';
// import 'package:image_editor/image_editor.dart';
// import 'package:photo_manager/photo_manager.dart';

// class ImageSaver {
//   const ImageSaver._();

//   static Future<String?> save(String name, Uint8List fileData) async {
//     final String title = '${DateTime.now().millisecondsSinceEpoch}.jpg';
//     final AssetEntity? imageEntity = await PhotoManager.editor.saveImage(
//       fileData,
//       title: title,
//     );
//     final File? file = await imageEntity?.file;
//     return file?.path;
//   }
// }

// class SimpleImageEditor extends StatefulWidget {
//   @override
//   _SimpleImageEditorState createState() => _SimpleImageEditorState();
// }

// class _SimpleImageEditorState extends State<SimpleImageEditor> {
//   final GlobalKey<ExtendedImageEditorState> editorKey =
//       GlobalKey<ExtendedImageEditorState>();
//   bool _cropping = false;

//   @override
//   Widget build(BuildContext context) {
//     return ExtendedImage.asset(
//       'assets/images/ml.png',
//       fit: BoxFit.contain,
//       mode: ExtendedImageMode.editor,
//       enableLoadState: true,
//       extendedImageEditorKey: editorKey,
//       cacheRawData: true,
//       //maxBytes: 1024 * 50,
//       initEditorConfigHandler: (ExtendedImageState? state) {
//         return EditorConfig(
//             maxScale: 4.0,
//             cropRectPadding: const EdgeInsets.all(20.0),
//             hitTestSize: 20.0,
//             initCropRectType: InitCropRectType.imageRect,
//             cropAspectRatio: CropAspectRatios.ratio4_3,
//             editActionDetailsIsChanged: (EditActionDetails? details) {
//               //print(details?.totalScale);
//             });
//       },
//     );
//     // floatingActionButton:
//     // FloatingActionButton(
//     //     child: const Icon(Icons.crop),
//     //     onPressed: () {
//     //       cropImage();
//     //     });
//   }

//   Future<void> cropImage() async {
//     if (_cropping) {
//       return;
//     }
//     _cropping = true;
//     try {
//       final Uint8List fileData = Uint8List.fromList(kIsWeb
//           ? Uint8List(1)
//           : (await cropImageDataWithNativeLibrary(
//               state: editorKey.currentState!))!);
//       final String? fileFath =
//           await ImageSaver.save('extended_image_cropped_image.jpg', fileData);
//       print('save image : $fileFath');
//     } finally {
//       _cropping = false;
//     }
//   }

//   Future<Uint8List?> cropImageDataWithNativeLibrary(
//       {required ExtendedImageEditorState state}) async {
//     print('native library start cropping');
//     Rect cropRect = state.getCropRect()!;
//     if (state.widget.extendedImageState.imageProvider is ExtendedResizeImage) {
//       final ImmutableBuffer buffer =
//           await ImmutableBuffer.fromUint8List(state.rawImageData);
//       final ImageDescriptor descriptor = await ImageDescriptor.encoded(buffer);

//       final double widthRatio = descriptor.width / state.image!.width;
//       final double heightRatio = descriptor.height / state.image!.height;
//       cropRect = Rect.fromLTRB(
//         cropRect.left * widthRatio,
//         cropRect.top * heightRatio,
//         cropRect.right * widthRatio,
//         cropRect.bottom * heightRatio,
//       );
//     }

//     final EditActionDetails action = state.editAction!;

//     final int rotateAngle = action.rotateAngle.toInt();
//     final bool flipHorizontal = action.flipY;
//     final bool flipVertical = action.flipX;
//     final Uint8List img = state.rawImageData;

//     final ImageEditorOption option = ImageEditorOption();

//     if (action.needCrop) {
//       option.addOption(ClipOption.fromRect(cropRect));
//     }

//     if (action.needFlip) {
//       option.addOption(
//           FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
//     }

//     if (action.hasRotateAngle) {
//       option.addOption(RotateOption(rotateAngle));
//     }

//     final DateTime start = DateTime.now();
//     final Uint8List? result = await ImageEditor.editImage(
//       image: img,
//       imageEditorOption: option,
//     );

//     print('${DateTime.now().difference(start)} ：total time');
//     return result;
//   }
// }
