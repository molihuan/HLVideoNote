import 'package:permission_handler/permission_handler.dart';

class PermissionTool {
  static Future<bool> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    return status.isGranted;
  }
}
