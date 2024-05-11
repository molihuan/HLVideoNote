import 'dart:convert';
import 'dart:io';

///flutter pub run flutter_launcher_icons
///图标脚本
void main() async {
  // 获取当前路径
  String currentPath = Directory.current.parent.path;

  if (Platform.isWindows) {
    // 执行命令
    Process.start('cmd', ['flutter', 'pub', 'run', 'flutter_launcher_icons'],
            workingDirectory: currentPath)
        .then((process) {
      process.stdout.listen((data) {
        print(data); // 输出命令执行结果
      });

      process.stderr.transform(utf8.decoder).listen((data) {
        print(data); // 输出命令执行错误
      });

      process.exitCode.then((exitCode) {
        print('命令执行完毕，退出码：$exitCode');
      });
    });
  }
  if (Platform.isLinux) {}
  if (Platform.isMacOS) {}
}
