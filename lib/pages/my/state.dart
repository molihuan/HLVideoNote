import 'package:get/get.dart';

class MyState {
  // title
  final _title = true.obs;
  set title(value) => _title.value = value;
  get title => _title.value;
}
