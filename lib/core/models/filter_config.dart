
/// Kiểu filter tương ứng Angular: 'multi-select' | 'button-group'
enum FilterType { multiSelect, buttonGroup }

/// Option cho cả hai loại filter
class FilterOption<T> {
  final String label;
  final T value;
  const FilterOption({required this.label, required this.value});
}

/// Cấu hình filter động
class FilterConfig<T> {
  final String id;
  final String label;
  final FilterType type;
  final List<FilterOption<T>> options;

  /// Angular có: showToggleAll, maxSelectedLabels, display
  /// Ở Flutter mình để tùy chọn để bạn map theo nhu cầu UI
  final bool showToggleAll;
  final int maxSelectedLabels; // dùng để rút gọn text hiển thị
  final String display; // 'comma' | 'chip' (tự định nghĩa trong Flutter)

  const FilterConfig({
    required this.id,
    required this.label,
    required this.type,
    required this.options,
    this.showToggleAll = true,
    this.maxSelectedLabels = 3,
    this.display = 'comma',
  });
}

/// Map selected giống bên Angular:
/// - với multiSelect: selected[filterId] = Set<T>
/// - với buttonGroup: selected[filterId] = T
typedef SelectedMap = Map<String, dynamic>;

/// Callback cập nhật selected giống updateSelected(filterId, value)
typedef UpdateSelected = void Function(String filterId, dynamic value);

/// Callback thay đổi Search box
typedef OnSearchChanged = void Function(String keyword);
