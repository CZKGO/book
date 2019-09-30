import 'package:flutter_book/data/sql_help.dart';

const String columnName = "name"; //小说名
const String columnNoteUrl = "noteUrl"; //如果是来源网站   则小说根地址 /如果是本地  则是小说本地MD5
const String columnChapterUrl = "chapterUrl"; //章节目录地址
const String columnAuthor = "author"; //作者
const String columnIntroduce = "introduce"; //简介
const String columnOrigin = "origin"; //来源
const String columnCharset = "charset"; //编码

const String columnCurrentChapter = "curChapter"; //当前章节 （包括番外）
const String columnCurrentChapterPage = "curChapterPage"; // 当前章节位置   用页码
const String columnFinalDate = "finalDate"; //最后阅读时间
const String columnHasUpdate = "hasUpdate"; //是否有更新
const String columnNewChapters = "newChapters"; //更新章节数
const String columnType = "type"; //书籍类型
//const   String columnSerialNumber = "serialNumber"; //手动排序
const String columnFinalRefreshDate = "finalRefreshDate"; //章节最后更新时间
const String columnGroup = "columnGroup"; //书籍状态 完结，连载等
const String columnDurChapterName = "durChapterName"; //当前章节名称
const String columnLastChapterName = "lastChapterName"; //最后一章章节名称
const String columnChapterListSize = "chapterListSize"; //章节总数目
const String columnCustomCoverPath = "customCoverPath"; //封面地址
const String columnAllowUpdate = "allowUpdate"; //是否允许更新

class Book implements BaseData {
  String name = ""; //小说名
  String noteUrl = ""; //如果是来源网站   则小说根地址 /如果是本地  则是小说本地MD5
  String chapterUrl = ""; //章节目录地址
  String author = ""; //作者
  String introduce = ""; //简介
  String origin = ""; //来源
  String charset = ""; //编码

  int currentChapter = 0; //当前章节 （包括番外）
  int currentChapterPage = 0; // 当前章节位置   用页码
  int finalDate = DateTime.now().millisecondsSinceEpoch; //最后阅读时间
  bool hasUpdate = false; //是否有更新
  int newChapters = 0; //更新章节数
  int type = 0; //书籍类型 0表示本地，1表示网络
//  int serialNumber = 0; //手动排序
  int finalRefreshDate = DateTime.now().millisecondsSinceEpoch; //章节最后更新时间
  int group = 0; //书籍状态 完结，连载等
  String durChapterName = ""; //当前章节名称
  String lastChapterName = ""; //最后一章章节名称
  int chapterListSize = 0; //章节总数目
  String customCoverPath = ""; //封面地址
  bool allowUpdate = true; //是否允许更新

  Book({
    this.name = "",
    this.noteUrl = "",
    this.chapterUrl = "",
    this.author = "",
    this.introduce = "",
    this.origin = "",
    this.charset = "",
    this.currentChapter = 0, //当前章节 （包括番外）
    this.currentChapterPage = 0, // 当前章节位置   用页码
    this.finalDate = 0, //最后阅读时间
    this.hasUpdate = true, //是否有更新
    this.newChapters = 0, //更新章节数
    this.type = 0, //书籍类型
    //columnSerialNumber:serialNumber ="",//手动排序
    this.finalRefreshDate = 0, //章节最后更新时间
    this.group = 0, //书籍状态 完结，连载等
    this.durChapterName = "", //当前章节名称
    this.lastChapterName = "", //最后一章章节名称
    this.chapterListSize = 0, //章节总数目
    this.customCoverPath = "", //封面地址
    this.allowUpdate = false, //是否允许更新
  });

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnNoteUrl: noteUrl,
      columnName: name,
      columnChapterUrl: chapterUrl,
      columnAuthor: author,
      columnIntroduce: introduce,
      columnOrigin: origin,
      columnCharset: charset,
      columnCurrentChapter: currentChapter, //当前章节 （包括番外）
      columnCurrentChapterPage: currentChapterPage, // 当前章节位置   用页码
      columnFinalDate: finalDate, //最后阅读时间
      columnHasUpdate: hasUpdate, //是否有更新
      columnNewChapters: newChapters, //更新章节数
      columnType: type, //书籍类型
      //columnSerialNumber:serialNumber,//手动排序
      columnFinalRefreshDate: finalRefreshDate, //章节最后更新时间
      columnGroup: group, //书籍状态 完结，连载等
      columnDurChapterName: durChapterName, //当前章节名称
      columnLastChapterName: lastChapterName, //最后一章章节名称
      columnChapterListSize: chapterListSize, //章节总数目
      columnCustomCoverPath: customCoverPath, //封面地址
      columnAllowUpdate: allowUpdate, //是否允许更新
    };
    return map;
  }

  @override
  fromMap(Map<String, dynamic> map) {
    name = map[columnName];
    noteUrl = map[columnNoteUrl];
    chapterUrl = map[columnChapterUrl];
    author = map[columnAuthor];
    introduce = map[columnIntroduce];
    origin = map[columnOrigin];
    charset = map[columnCharset];
    currentChapter = map[columnCurrentChapter]; //当前章节 （包括番外）
    currentChapterPage = map[columnCurrentChapterPage]; // 当前章节位置   用页码
    finalDate = map[columnFinalDate]; //最后阅读时间
    hasUpdate = true.toString() == map[columnHasUpdate]; //是否有更新
    newChapters = map[columnNewChapters]; //更新章节数
    type = map[columnType]; //书籍类型
    //serialNumber = map[columnSerialNumber:,//手动排序
    finalRefreshDate = map[columnFinalRefreshDate]; //章节最后更新时间
    group = map[columnGroup]; //书籍状态 完结，连载等
    durChapterName = map[columnDurChapterName]; //当前章节名称
    lastChapterName = map[columnLastChapterName]; //最后一章章节名称
    chapterListSize = map[columnChapterListSize]; //章节总数目
    customCoverPath = map[columnCustomCoverPath]; //封面地址
    allowUpdate = true.toString() == map[columnAllowUpdate]; //是否允许更新
  }

  @override
  String getPrimayKey() {
    return columnNoteUrl;
  }

  @override
  String getTableName() {
    return this.runtimeType.toString();
  }
}
