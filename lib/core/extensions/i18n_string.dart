import '../store/I18n_store.dart';

/// ===== I18N support (thay cho pipe Angular) =====
typedef I18nMap = Map<String, Map<String, String>>;

extension I18nStringX on String {
  String get tr => I18NStore.instance.translate(this);
}