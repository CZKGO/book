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
    with SingleTickerProviderStateMixin {
  List<FileSystemEntity> files = [];

  @override
  void initState() {
    super.initState();
    _initPathList(null);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: files.length != 0 ? files.length : 0,
      physics: ClampingScrollPhysics(),
      controller: ScrollController(),
      itemBuilder: (BuildContext context, int index) {
        return _buildListViewItem(files[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 0.0,
          color: Colors.grey,
        );
      },
    );
  }

  void _initPathList(String path) async {
    Directory appDocDir =
        path == null ? await getExternalStorageDirectory() : Directory(path);
    setState(() {
      files = appDocDir.listSync();
      files.removeWhere((FileSystemEntity file) {
        return file.path
                .substring(file.parent.path.length + 1)
                .substring(0, 1) ==
            '.';
      });
      files.sort((FileSystemEntity fileA, FileSystemEntity fileB) {
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
    });
  }

  Widget _buildListViewItem(FileSystemEntity file) {
    bool isFile = FileSystemEntity.isFileSync(file.path);
    return ListTile(
      leading: isFile
          ? Checkbox(
              value: false,
              onChanged: (bool checd) {},
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
        _initPathList(file.path);
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
