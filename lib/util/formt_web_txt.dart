class FormatWebText {

  static String getContent(String str) {
    if (str == null) {
      return null;
    }
    return str
        .replaceFirst("\r", "")
        .replaceFirst("\n", "")
        .replaceFirst("\t", "")
        .replaceFirst("&nbsp;", "")
        .replaceAll("\\s", " ")
        .trim();
  }

  static String getBookName(String str) {
    if (str.isEmpty) {
      return "";
    }

    return trim(str.replaceFirst("&nbsp;", "")
        .replaceFirst(":", "：")
        .replaceFirst(",", "，")
        .replaceAll("[\\u3000 ]+", "")
        .replaceAll("\\s", " ")
        .replaceAll("[?？!！。~《》【】]", "")
        .replaceAll("([(（].*[）)])", ""));
  }

  static String getAuthor(String str) {
    if (str.isEmpty) {
      return "";
    }

    return trim(str.replaceFirst("&nbsp;", "")
        .replaceAll("[：:()【】\\[\\]（）\\u3000 ]+", "")
        .replaceAll("\\s", " ")
        .replaceAll("作.*?者", ""));
  }

  static String trim(String s) {
    String result = "";
    if (null != s && !("" == s)) {
      result = s.replaceAll("^[　*| *| *|//s*]*", "").replaceAll(
          "[　*| *| *|//s*]*\$", "");
    }
    return result;
  }
}
