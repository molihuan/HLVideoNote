import 'package:flutter/material.dart';
import 'package:note/common/utils/common_tool.dart';

/**
 * --noteProjectName1
 *   --data
 *   --noteProjectName1.cfg
 *   --resource
 *     --img(存放图片、截图)
 *     --video(存放视频)
 *     --audio(音频)
 *     --pdf(存放pdf)
 *     --markdown
 *     --txt
 *     --doc
 */

class BaseNote {
  ///标识用于json传输转换
  static const String flag = "BaseNote";

  /// 笔记依赖媒体来源: 本地、http、websocket
  SourceType noteDependMediaSourceType;
  /// 笔记依赖媒体类型:video、audio、pdf、markdown、txt、doc
  MediaType noteDependMediaType;
  /// 笔记依赖媒体的位置
  String noteDependMediaPos;


  /// 笔记来源: 本地、http、websocket
  SourceType noteSourceType;
  /// 配置位置,
  String noteCfgPos;
  /// 项目位置,由noteCfgPos确定
  late String noteProjectPos;
  /// 笔记内容数据位置,由noteCfgPos确定
  late String noteDataPos;
  /// 资源位置,由noteCfgPos确定
  late String noteResourcePos;
  /// 图片资源位置,由noteResourcePos确定
  late String noteImgPos;
  /// 视频资源位置,由noteResourcePos确定
  late String noteVideoPos;
  /// 音频资源位置,由noteResourcePos确定
  late String noteAudioPos;
  /// pdf资源位置,由noteResourcePos确定
  late String notePdfPos;
  /// markdown资源位置,由noteResourcePos确定
  late String noteMarkdownPos;
  /// txt资源位置,由noteResourcePos确定
  late String noteTxtPos;


  /// 笔记标题
  String noteTitle;
  /// 笔记描述
  String noteDescription;
  /// 笔记创建时间
  DateTime? noteCreateTime;
  /// 笔记更新时间
  DateTime? noteUpdateTime;
  /// 笔记封面
  String? noteCover;

  BaseNote({
    this.noteDependMediaSourceType = SourceType.LOCAL,
    this.noteDependMediaType = MediaType.VIDEO,
    required this.noteDependMediaPos,
    this.noteSourceType = SourceType.LOCAL,
    required this.noteCfgPos,
    required this.noteTitle,
    this.noteDescription = "",
    this.noteCreateTime,
    this.noteUpdateTime,
    this.noteCover,
  }){
    noteUpdateTime = DateTime.now();
    noteProjectPos = CommonTool.getParentPos(noteCfgPos);
    noteDataPos = "$noteProjectPos/data";
    noteResourcePos = "$noteProjectPos/resource";
    noteImgPos = "$noteResourcePos/img";
    noteVideoPos = "$noteResourcePos/video";
    noteAudioPos = "$noteResourcePos/audio";
    notePdfPos = "$noteResourcePos/pdf";
    noteMarkdownPos = "$noteResourcePos/markdown";
    noteTxtPos = "$noteResourcePos/txt";


  }


  Map<String, dynamic> toJson() {
    return {
      'noteDependMediaSourceType': noteDependMediaSourceType.toString().split('.').last,
      'noteDependMediaType': noteDependMediaType.toString().split('.').last,
      'noteDependMediaPos': noteDependMediaPos,
      'noteSourceType': noteSourceType.toString().split('.').last,
      'noteCfgPos': noteCfgPos,
      'noteTitle': noteTitle,
      'noteDescription': noteDescription,
      'noteCreateTime': noteCreateTime?.toIso8601String(),
      'noteUpdateTime': noteUpdateTime?.toIso8601String(),
      'noteCover': noteCover,
      'noteProjectPos': noteProjectPos,
      'noteDataPos': noteDataPos,
      'noteResourcePos': noteResourcePos,
      'noteImgPos': noteImgPos,
      'noteVideoPos': noteVideoPos,
      'noteAudioPos': noteAudioPos,
      'notePdfPos': notePdfPos,
      'noteMarkdownPos': noteMarkdownPos,
      'noteTxtPos': noteTxtPos,
    };
  }

  static BaseNote fromJson(Map<String, dynamic> json) {
    return BaseNote(
      noteDependMediaSourceType: SourceType.parseSourceType(json['noteDependMediaSourceType']),
      noteDependMediaType: MediaType.parseMediaType(json['noteDependMediaType']),
      noteDependMediaPos: json['noteDependMediaPos'],
      noteSourceType: SourceType.parseSourceType(json['noteSourceType']),
      noteCfgPos: json['noteCfgPos'],
      noteTitle: json['noteTitle'],
      noteDescription: json['noteDescription'],
      noteCreateTime: json['noteCreateTime'] != null ? DateTime.parse(json['noteCreateTime']) : null,
      noteUpdateTime: DateTime.parse(json['noteUpdateTime']),
      noteCover: json['noteCover'],
    );
  }




}
///媒体类型
enum MediaType {
  VIDEO,
  AUDIO,
  PDF,
  MARKDOWN,
  TXT;

  static MediaType parseMediaType(String mediaTypeString) {
    switch (mediaTypeString) {
      case 'VIDEO':
        return MediaType.VIDEO;
      case 'AUDIO':
        return MediaType.AUDIO;
      case 'PDF':
        return MediaType.PDF;
      case 'MARKDOWN':
        return MediaType.MARKDOWN;
      case 'TXT':
        return MediaType.TXT;
      default:
        throw ArgumentError('Invalid media type: $mediaTypeString');
    }
  }
}
///来源类型
enum SourceType {
  ///本地
  LOCAL,
  ///包括http和https
  HTTP,
  WEBSOCKET;

  static SourceType parseSourceType(String sourceTypeString) {
    switch (sourceTypeString) {
      case 'LOCAL':
        return SourceType.LOCAL;
      case 'HTTP':
        return SourceType.HTTP;
      case 'WEBSOCKET':
        return SourceType.WEBSOCKET;
      default:
        throw ArgumentError('Invalid source type: $sourceTypeString');
    }
  }

}