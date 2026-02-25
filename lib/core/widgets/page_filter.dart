// lib/core/widgets/page_filter.dart
import 'package:flutter/material.dart';
import '../models/filter_config.dart';

class PageFilter extends StatefulWidget {
  final String title;
  final List<FilterConfig> filters;
  final SelectedMap selected;

  final UpdateSelected updateSelected;
  final OnSearchChanged? onSearchChanged;
  final VoidCallback? onClear;
  final VoidCallback? onApply;

  /// collapsed mặc định = false (đang MỞ)
  final bool initiallyCollapsed;

  const PageFilter({
    super.key,
    required this.title,
    required this.filters,
    required this.selected,
    required this.updateSelected,
    this.onSearchChanged,
    this.onClear,
    this.initiallyCollapsed = false, this.onApply,
  });

  @override
  State<PageFilter> createState() => _PageFilterState();
}

class _PageFilterState extends State<PageFilter> {
  late bool _collapsed;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _collapsed = widget.initiallyCollapsed;
  }

  void _toggleFilters() => setState(() => _collapsed = !_collapsed);

  @override
  Widget build(BuildContext context) {
    final icon = _collapsed ? Icons.expand_more : Icons.expand_less;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title + Toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              tooltip: _collapsed ? 'Hiện bộ lọc' : 'Ẩn bộ lọc',
              icon: Icon(icon),
              onPressed: _toggleFilters,
            ),
          ],
        ),

        // Khu vực Filter (tùy collapsed)
        if (!_collapsed) ...[
          const SizedBox(height: 8),
          _buildSearch(context),
          const SizedBox(height: 12),
          _buildDynamicFilters(context),
          if (widget.onClear != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    onPressed: widget.onApply,
                    icon: const Icon(Icons.check),
                    label: const Text('Áp dụng'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF073B3A),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    onPressed: widget.onClear,
                    icon: const Icon(Icons.clear),
                    label: const Text('Xóa'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildSearch(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Tìm kiếm',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      onChanged: (value) {
        setState(() => _search = value);
        widget.onSearchChanged?.call(value);
      },
    );
  }

  Widget _buildDynamicFilters(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: widget.filters.map((f) {
        switch (f.type) {
          case FilterType.multiSelect:
            return _MultiSelectField(
              config: f,
              value: (widget.selected[f.id] as Set?) ?? <dynamic>{},
              onChanged: (newSet) => widget.updateSelected(f.id, newSet),
            );
          case FilterType.buttonGroup:
            return _ButtonGroupField(
              config: f,
              value: widget.selected[f.id],
              onChanged: (newValue) => widget.updateSelected(f.id, newValue),
            );
        }
      }).toList(),
    );
  }
}

/// -------  MultiSelect: mở BottomSheet để chọn nhiều ----------
class _MultiSelectField extends StatelessWidget {
  final FilterConfig config;
  final Set<dynamic> value;
  final ValueChanged<Set<dynamic>> onChanged;

  const _MultiSelectField({
    required this.config,
    required this.value,
    required this.onChanged,
  });

  String _selectedText() {
    if (value.isEmpty) return 'Chọn ${config.label.toLowerCase()}';
    final labels = config.options
        .where((o) => value.contains(o.value))
        .map((o) => o.label)
        .toList();
    if (config.display == 'chip') {
      // Text rút gọn tương tự maxSelectedLabels
      final max = config.maxSelectedLabels;
      final shown = labels.take(max).toList();
      final remain = labels.length - shown.length;
      return remain > 0 ? '${shown.join(", ")} +$remain' : shown.join(", ");
    }
    // 'comma'
    return labels.join(', ');
  }

  Future<void> _openSelector(BuildContext context) async {
    final current = Set<dynamic>.from(value);

    final result = await showModalBottomSheet<Set<dynamic>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(config.label, style: Theme.of(ctx).textTheme.titleMedium),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: config.options.length,
                    itemBuilder: (context, index) {
                      final opt = config.options[index];
                      final checked = current.contains(opt.value);
                      return CheckboxListTile(
                        value: checked,
                        onChanged: (v) {
                          if (v == true) {
                            current.add(opt.value);
                          } else {
                            current.remove(opt.value);
                          }
                          // setState tại BottomSheet bằng StatefulBuilder
                          (context as Element).markNeedsBuild();
                        },
                        title: Text(opt.label),
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    if (config.showToggleAll)
                      TextButton(
                        onPressed: () {
                          if (current.length == config.options.length) {
                            current.clear();
                          } else {
                            current
                              ..clear()
                              ..addAll(config.options.map((e) => e.value));
                          }
                          (ctx as Element).markNeedsBuild();
                        },
                        child: const Text('Chọn tất cả'),
                      ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Hủy'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, current),
                      child: const Text('Áp dụng'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: GestureDetector(
        onTap: () => _openSelector(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: config.label,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          child: Text(
            _selectedText(),
            maxLines: null,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

/// -------  ButtonGroup: dùng ChoiceChip (single-choice) ----------
class _ButtonGroupField extends StatelessWidget {
  final FilterConfig config;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  const _ButtonGroupField({
    required this.config,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(config.label, style: Theme.of(context).textTheme.bodyMedium),
        ...config.options.map((opt) {
          final selected = value == opt.value;
          return ChoiceChip(
            label: Text(opt.label),
            selected: selected,
            onSelected: (_) => onChanged(opt.value),
          );
        }),
      ],
    );
  }
}
