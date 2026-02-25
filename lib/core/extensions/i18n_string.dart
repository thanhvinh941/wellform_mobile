/// ===== I18N support (thay cho pipe Angular) =====
typedef I18nMap = Map<String, Map<String, String>>;

extension I18nStringX on String {
  String tr(
      I18nMap? i18n, {
        String lang = 'en',
        String? fallbackLang,
      }) {
    if (i18n == null || i18n.isEmpty) return this;
    final s1 = i18n[lang]?[this];
    if (s1 != null && s1.isNotEmpty) return s1;
    if (fallbackLang != null) {
      final s2 = i18n[fallbackLang]?[this];
      if (s2 != null && s2.isNotEmpty) return s2;
    }
    for (final e in i18n.entries) {
      final s = e.value[this];
      if (s != null && s.isNotEmpty) return s;
    }
    return this; // fallback về keyCode nếu không có i18n
  }
}