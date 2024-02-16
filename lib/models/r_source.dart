///资源类型
enum SourceType {
  ///本地
  LOCAL,

  ///包括http和https
  HTTP,
  WEB_SOCKET;

  static const String flag = "SourceType";
}

typedef bool BoolFuncRsource(Rsource rsource);
typedef int IntFuncRsource(Rsource rsource);
typedef String StrFuncRsource(Rsource rsource);
typedef Object ObjFuncRsource(Rsource rsource);
typedef dynamic DynamicFuncRsource(Rsource rsource);

///资源为本地还是远程的封装类
///[T]为值的类型
class Rsource<T> {
  Rsource({required this.sourceType, required this.v});

  static const String flag = "Rsource";

  ///资源类型:本地、网络
  SourceType sourceType;

  ///值
  static const String vkey = "v";
  T v;

  ///[R]返回值
  ///[F]回调方法类型,且其返回值必须为 [R]
  ///[T]值的类型
  R callSwitch<R, F extends R Function(Rsource<T> rsource)>(
      {required F localCallback,
      required F httpCallback,
      required F webSocketCallback}) {
    switch (sourceType) {
      case SourceType.LOCAL:
        return localCallback(this);
      case SourceType.HTTP:
        return httpCallback(this);
      case SourceType.WEB_SOCKET:
        return webSocketCallback(this);
    }
  }
}
