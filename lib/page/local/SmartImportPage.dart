import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'ImportBookPage.dart';

class SmartImportPage extends StatefulWidget {
  var _smartImportPage;
  var _rootPage;

  SmartImportPage(_importBookPage) {
    this._rootPage = _importBookPage;
  }

  @override
  State<StatefulWidget> createState() {
    _smartImportPage = _SmartImportPage(this._rootPage);
    return _smartImportPage;
  }

  void selectAll(bool isSelectAll) {
    if (_smartImportPage != null) {
      _smartImportPage.selectAll(isSelectAll);
    }
  }

  List<String> getSelectFilePath() {
    return _smartImportPage.getSelectFilePath();
  }
}

class _SmartImportPage extends State<SmartImportPage>
    with AutomaticKeepAliveClientMixin {
  var _rootPage;

  _SmartImportPage(_importBookPage) {
    this._rootPage = _importBookPage;
  }

  @override
  bool get wantKeepAlive => true; //是否保存状态

  MyFiles myFiles;

  @override
  void initState() {
    super.initState();
    _initPathList();
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
        color: Colors.white,
        child: ListView.separated(
          itemCount: myFiles != null ? myFiles.length : 0,
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
        ));
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
      if (myFiles.isCheck(i) != null && myFiles.isCheck(i)) {
        paths.add(myFiles.getFile(i).path);
      }
    }
    return paths;
  }

  void _initPathList() async {
    Directory appDocDir = await getExternalStorageDirectory();
    List<FileSystemEntity> allTextFiles = await _getAllTxt(appDocDir);
    allTextFiles.sort((FileSystemEntity fileA, FileSystemEntity fileB) {
      return Comparable.compare(fileA.path, fileB.path);
    });
    setState(() {
      myFiles = MyFiles(allTextFiles);
    });
  }

  Future<List<FileSystemEntity>> _getAllTxt(Directory directoty) async {
    List<FileSystemEntity> list = [];
    var tempFiles = directoty.listSync();
    for (int i = 0; i < tempFiles.length; i++) {
      var tempFile = tempFiles[i];
      if (tempFile.path
              .substring(tempFile.parent.path.length + 1)
              .substring(0, 1) !=
          '.') {
        if (!FileSystemEntity.isFileSync(tempFile.path)) {
          list.addAll(await _getAllTxt(Directory(tempFile.path)));
        } else if (tempFile.path.endsWith(".txt")) {
          list.add(tempFile);
        }
      }
    }
    return list;
  }

  Widget _buildListViewItem(int index) {
    FileSystemEntity file = myFiles.getFile(index);
    bool fileChecd = myFiles.isCheck(index);
    return ListTile(
      leading: Checkbox(
        materialTapTargetSize: MaterialTapTargetSize.padded,
        tristate: false,
        value: fileChecd == null ? false : fileChecd,
        activeColor: Color(0xffD81B60),
        onChanged: (bool checd) {
          onCheckItem(index, checd);
        },
      ),
      title: Text(file.path.substring(file.parent.path.length + 1)),
      subtitle: Text(
        '${getFileLastModifiedTime(file)}  ${getFileSize(file)}',
        style: TextStyle(fontSize: 12.0),
      ),
      onTap: () {
        setState(() {
          onCheckItem(index, fileChecd == null ? true : !fileChecd);
        });
      },
    );
  }

  void onCheckItem(int index, bool check) {
    setState(() {
      myFiles.checkItem(index, check);
    });
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
