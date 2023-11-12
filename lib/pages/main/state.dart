import 'package:get/get.dart';

class MainState {
  // 页面索引
  final _pageIndex = 0.obs;

  set pageIndex(value) => _pageIndex.value = value;

  get pageIndex => _pageIndex.value;
}
