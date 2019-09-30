import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book/util/file_helper.dart';
import 'package:path_provider/path_provider.dart';

import 'ImportBookPage.dart';

class LocalPathPage extends StatefulWidget {
  var _localPathPage;
  var _rootPage;

  LocalPathPage(_importBookPage) {
    _rootPage = _importBookPage;
  }

  @override
  State<StatefulWidget> createState() {
    _localPathPage = _LocalPathPage(_rootPage);
    return _localPathPage;
  }

  void selectAll(bool isSelectAll) {
    if (_localPathPage != null) {
      _localPathPage.selectAll(isSelectAll);
    }
  }

  List<String> getSelectFilePath() {
    _localPathPage.getSelectFilePath();
  }
}

class _LocalPathPage extends State<LocalPathPage>
    with AutomaticKeepAliveClientMixin {
  @override
  var _rootPage;

  _LocalPathPage(rootPage) {
    _rootPage = rootPage;
  }

  bool get wantKeepAlive => true; //是否保存状态

  List<FileSystemEntity> files = [];
  MyFiles myFiles;
  String rootPath;
  String currentPath;
  String pathText;

  @override
  void initState() {
    super.initState();
    _initPathList(rootPath);
  }

  @override
  Widget build(BuildContext context) {
    pathText = "存储:" +
        (currentPath == null
            ? ""
            : currentPath.substring(rootPath == null ? 0 : rootPath.length));
    var listView = ListView.separated(
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
    );
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
                        pathText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    flex: 1,
                  ),
                  InkWell(
                    onTap: () {
                      if (currentPath != rootPath) {
                        this._rootPage.select(false);
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
            child: Ink(color: Colors.white, child: listView),
            flex: 1,
          ),
        ]);
  }

  void selectAll(bool isSelectAll) async {
    for (int i = 0; i < myFiles.length; i++) {
      myFiles.checkItem(i, isSelectAll);
    }
    setState(() {});
  }

  List<String> getSelectFilePath() {
    List<String> paths = [];
    for (int i = 0; i < myFiles.length; i++) {
      if (myFiles.isCheck(i) != null || myFiles.isCheck(i)) {
        paths.add(myFiles.getFile(i).path);
      }
    }
    return paths;
  }

  void onCheckItem(int index, bool check) {
    myFiles.checkItem(index, check);
    if (!check) {
      this._rootPage.select(false);
    } else {
      for (int i = 0; i < myFiles.length; i++) {
        if (myFiles.isCheck(i) == null || !myFiles.isCheck(i)) {
          this._rootPage.select(false);
          break;
        } else if (i == myFiles.length - 1) {
          this._rootPage.select(true);
        }
      }
    }
    setState(() {});
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
      int fileNum = 0; //该目录下text数目
      List<FileSystemEntity> tempFiles = appDocDir.listSync();
      tempFiles.removeWhere((FileSystemEntity file) {
        var isHiddenFile =
            file.path.substring(file.parent.path.length + 1).substring(0, 1) ==
                '.';
        var isFile = FileSystemEntity.isFileSync(file.path);
        var isNotTxtFile = isFile &&
            !file.path.substring(file.parent.path.length + 1).endsWith(".txt");
        bool result = isHiddenFile || isNotTxtFile;
        if (isFile && !isNotTxtFile && !isHiddenFile) {
          fileNum++;
        }
        return result;
      });
      tempFiles.sort((FileSystemEntity fileA, FileSystemEntity fileB) {
        bool aIsFile = FileSystemEntity.isFileSync(fileA.path);
        bool bIsFile = FileSystemEntity.isFileSync(fileB.path);
        if (aIsFile && !bIsFile) {
          return -1;
        } else if (!aIsFile && bIsFile) {
          return 1;
        } else {
          return Comparable.compare(fileA.path, fileB.path);
        }
      });
      files = tempFiles;
      myFiles = MyFiles(files.sublist(0, fileNum));
    });
  }

  void _BackPathList(String path) {
    Directory appDocDir = Directory(path);
    _initPathList(appDocDir.parent.path);
  }

  Widget _buildListViewItem(int index) {
    FileSystemEntity file = files[index];
    bool isFile = FileSystemEntity.isFileSync(file.path);
    bool fileChecd;
    if (isFile) {
      fileChecd = myFiles.isCheck(index);
    }
    return ListTile(
      leading: isFile
          ? Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.padded,
              tristate: false,
              value: fileChecd == null ? false : fileChecd,
              activeColor: Color(0xffD81B60),
              onChanged: (bool checd) {
                onCheckItem(index, checd);
              },
            )
          : Icon(
              Icons.folder,
              size: 40,
            ),
      title: Text(file.path.substring(file.parent.path.length + 1)),
      subtitle: isFile
          ? Text(
              '${getFileLastModifiedTimeString(file)}  ${getFileSize(file)}',
              style: TextStyle(fontSize: 12.0),
            )
          : Text(
              '${removePointBegin(file)}项',
              style: TextStyle(color: Colors.grey),
            ),
      trailing: isFile ? null : Icon(Icons.chevron_right),
      onTap: () {
        if (FileSystemEntity.isFileSync(file.path)) {
          onCheckItem(index, fileChecd == null ? true : !fileChecd);
        } else {
          this._rootPage.select(false);
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




}
