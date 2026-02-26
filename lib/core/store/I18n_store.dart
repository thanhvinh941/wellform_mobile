class I18NStore {
  I18NStore._();
  static final I18NStore instance = I18NStore._();

  Map<String, Map<String, String>> _data = {};
  String currentLang = 'en';

  void setData(Map<String, Map<String, String>> data) {
    _data = data;
  }

  String translate(String key) {
    return _data[currentLang]?[key] ?? key;
  }
}