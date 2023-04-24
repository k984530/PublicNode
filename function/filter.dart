import 'package:node/function/filterWord.dart';

class Contentfilter {
  static bool filterContent(String content) {
    bool exist = false;
    List<String> s = filterSlang.SlangList();
    for (String slang in s) {
      if (slang != '') {
        exist = content.contains(slang);
      }
      if (exist) {
        break;
      }
    }
    return exist;
  }
}
