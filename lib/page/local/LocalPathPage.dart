import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class LocalPathPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocalPathPage();
  }
}

class _LocalPathPage extends State<LocalPathPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; //是否保存状态

  List<FileSystemEntity> files = [];
  List<bool> isFileChecds = [];
  String rootPath;
  String currentPath;

  @override
  void initState() {
    super.initState();
    debugPrint("_LocalPathPage:"+files.length.toString());
    _initPathList(rootPath);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Ink(
              color: Colors.white,
              height: 48,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 48,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 24),
                      child: Text(
                        "存储:",
                      ),
                    ),
                    flex: 1,
                  ),
                  InkWell(
                    onTap: () {
                      if (currentPath != rootPath) {
                        _BackPathList(currentPath);
                      }
                    },
                    child: Container(
                      height: 48,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerLeft,
                      child: currentPath == rootPath
                          ? Text(
                              "",
                            )
                          : Row(children: <Widget>[
                              Icon(Icons.keyboard_return),
                              Text(
                                "上一级",
                              ),
                            ]),
                    ),
                  ),
                ],
              ),
            ),
            flex: 0,
          ),
          Divider(
            height: 0.0,
            color: Colors.grey,
          ),
          Expanded(
            child: Ink(
                color: Colors.white,
                child: ListView.separated(
                  itemCount: files.length != 0 ? files.length : 0,
                  physics: ClampingScrollPhysics(),
                  controller: ScrollController(),

                  itemBuilder: (BuildContext context, int index) {
                    return _buildListViewItem(index);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      height: 0.0,
                      color: Colors.grey,
                    );
                  },
                )),
            flex: 1,
          ),
        ]);
  }

  void _initPathList(String path) async {
    if (path != null) {
      if (FileSystemEntity.isFileSync(path)) return;
    }
    Directory appDocDir =
        path == null ? await getExternalStorageDirectory() : Directory(path);

    if (this.rootPath == null) this.rootPath = appDocDir.path;
    currentPath = appDocDir.path;
    setState(() {
      List<FileSystemEntity> tempFiles = appDocDir.listSync();
      tempFiles.removeWhere((FileSystemEntity file) {
        return file.path
                    .substring(file.parent.path.length + 1)
                    .substring(0, 1) ==
                '.' ||
            (FileSystemEntity.isFileSync(file.path) &&
                !file.path
                    .substring(file.parent.path.length + 1)
                    .endsWith(".txt"));
      });
      tempFiles.sort((FileSystemEntity fileA, FileSystemEntity fileB) {
        bool aIsFile = FileSystemEntity.isFileSync(fileA.path);
        bool bIsFile = FileSystemEntity.isFileSync(fileB.path);
        if (aIsFile && !bIsFile) {
          return 1;
        } else if (!aIsFile && bIsFile) {
          return 0;
        } else {
          return Comparable.compare(fileA.path, fileB.path);
        }
      });
      files = tempFiles;
      isFileChecds = new List(files.length);
    });
  }

  void _BackPathList(String path) {
    Directory appDocDir = Directory(path);
    _initPathList(appDocDir.parent.path);
  }

  Widget _buildListViewItem(int index) {
    FileSystemEntity file = files[index];
    bool fileChecd = isFileChecds[index];
    bool isFile = FileSystemEntity.isFileSync(file.path);
    return ListTile(
      leading: isFile
          ? Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.padded,
              tristate: false,
              value: fileChecd == null ? false : fileChecd,
              activeColor: Color(0xffD81B60),
              onChanged: (bool checd) {
                setState(() {
                  isFileChecds[index] = checd;
                });
              },
            )
          : Icon(
              Icons.folder,
              size: 40,
            ),
      title: Text(file.path.substring(file.parent.path.length + 1)),
      subtitle: isFile
          ? Text(
              '${getFileLastModifiedTime(file)}  ${getFileSize(file)}',
              style: TextStyle(fontSize: 12.0),
            )
          : Text(
              '${removePointBegin(file)}项',
              style: TextStyle(color: Colors.grey),
            ),
      trailing: isFile ? null : Icon(Icons.chevron_right),
      onTap: () {
        if (FileSystemEntity.isFileSync(file.path)) {
          setState(() {
            isFileChecds[index] = (fileChecd == null ? true : !fileChecd);
          });
        } else {
          _initPathList(file.path);
        }
      },
    );
  }

  // 计算文件夹内 文件、文件夹的数量，以 . 开头的除外
  removePointBegin(Directory path) {
    var dir = Directory(path.path).listSync();
    int num = dir.length;

    for (int i = 0; i < dir.length; i++) {
      if (dir[i]
              .path
              .substring(dir[i].parent.path.length + 1)
              .substring(0, 1) ==
          '.') num--;
    }
    return num;
  }

  getFileSize(FileSystemEntity file) {
    int fileSize = File(file.resolveSymbolicLinksSync()).lengthSync();
    if (fileSize < 1024) {
      // b
      return '${fileSize.toStringAsFixed(2)}B';
    } else if (1024 <= fileSize && fileSize < 1048576) {
      // kb
      return '${(fileSize / 1024).toStringAsFixed(2)}KB';
    } else if (1048576 <= fileSize && fileSize < 1073741824) {
      // mb
      return '${(fileSize / 1024 / 1024).toStringAsFixed(2)}MB';
    }
  }

  getFileLastModifiedTime(FileSystemEntity file) {
    DateTime dateTime =
        File(file.resolveSymbolicLinksSync()).lastModifiedSync();

    String time =
        '${dateTime.year}-${dateTime.month < 10 ? 0 : ''}${dateTime.month}-${dateTime.day < 10 ? 0 : ''}${dateTime.day} ${dateTime.hour < 10 ? 0 : ''}${dateTime.hour}:${dateTime.minute < 10 ? 0 : ''}${dateTime.minute}';
    return time;
  }
}
