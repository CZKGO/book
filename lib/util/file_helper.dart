import 'dart:io';

DateTime getFileLastModifiedTime(FileSystemEntity file) {
  DateTime dateTime = File(file.resolveSymbolicLinksSync()).lastModifiedSync();
  return dateTime;
}

getFileLastModifiedTimeString(FileSystemEntity file) {
  DateTime dateTime = File(file.resolveSymbolicLinksSync()).lastModifiedSync();

  String time =
      '${dateTime.year}-${dateTime.month < 10 ? 0 : ''}${dateTime.month}-${dateTime.day < 10 ? 0 : ''}${dateTime.day} ${dateTime.hour < 10 ? 0 : ''}${dateTime.hour}:${dateTime.minute < 10 ? 0 : ''}${dateTime.minute}';
  return time;
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
