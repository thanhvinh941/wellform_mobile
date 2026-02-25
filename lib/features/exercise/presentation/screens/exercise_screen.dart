// lib/features/exercise/presentation/screens/exercise_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wellform_mobile/features/exercise/presentation/providers/exercise_providers.dart';
import 'package:wellform_mobile/features/exercise/presentation/providers/static_providers.dart';
import '../../../../core/models/exercise_models.dart';
import '../../../../core/models/filter_config.dart';
import '../../../../core/widgets/page_filter.dart';
import '../widgets/exercise_card.dart';
import 'exercise_detail_screen.dart';

class ExerciseScreen extends ConsumerStatefulWidget {
  const ExerciseScreen({super.key});

  @override
  ConsumerState<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends ConsumerState<ExerciseScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() async {
      await ref.read(staticProvider.notifier).load();
      await ref.read(exerciseProvider.notifier).load();
    });

  }

  final List<Exercise> exercises = [
    Exercise(
      id: 'ex_001',
      name: 'Push Up',
      levelCode: 'Beginner',
      imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=1200&auto=format&fit=crop',
      duration: 45, // giây
      focusAreas: const [
        FocusArea(id: 'fa_chest', keyCode: 'Chest'),
        FocusArea(id: 'fa_triceps', keyCode: 'Triceps'),
        FocusArea(id: 'fa_core', keyCode: 'Core'),
      ],
      equipments: const [
        Equipment(id: 'eq_body', keyCode: 'Bodyweight'),
      ],
    ),
    Exercise(
      id: 'ex_002',
      name: 'Plank',
      levelCode: 'Beginner',
      imageUrl: 'https://images.unsplash.com/photo-1599050751790-26b3ffcc4d07?q=80&w=1200&auto=format&fit=crop',
      duration: 60,
      focusAreas: const [
        FocusArea(id: 'fa_core', keyCode: 'Core'),
        FocusArea(id: 'fa_shoulders', keyCode: 'Shoulders'),
      ],
      equipments: const [
        Equipment(id: 'eq_mat', keyCode: 'Yoga Mat'),
      ],
    ),
    Exercise(
      id: 'ex_003',
      name: 'Dumbbell Row',
      levelCode: 'Intermediate',
      imageUrl: 'https://images.unsplash.com/photo-1517963879433-6ad2b056d712?q=80&w=1200&auto=format&fit=crop',
      duration: 40,
      focusAreas: const [
        FocusArea(id: 'fa_back', keyCode: 'Back'),
        FocusArea(id: 'fa_biceps', keyCode: 'Biceps'),
      ],
      equipments: const [
        Equipment(id: 'eq_dumbbell', keyCode: 'Dumbbell'),
        Equipment(id: 'eq_bench', keyCode: 'Bench'),
      ],
    ),
    Exercise(
      id: 'ex_004',
      name: 'Squat',
      levelCode: 'Intermediate',
      imageUrl: 'https://images.unsplash.com/photo-1599058917212-d750089bc07c?q=80&w=1200&auto=format&fit=crop',
      duration: 50,
      focusAreas: const [
        FocusArea(id: 'fa_legs', keyCode: 'Legs'),
        FocusArea(id: 'fa_glutes', keyCode: 'Glutes'),
        FocusArea(id: 'fa_core', keyCode: 'Core'),
      ],
      equipments: const [
        Equipment(id: 'eq_body', keyCode: 'Bodyweight'),
      ],
    ),
    Exercise(
      id: 'ex_005',
      name: 'Shoulder Press',
      levelCode: 'Advanced',
      imageUrl: 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=1200&auto=format&fit=crop',
      duration: 45,
      focusAreas: const [
        FocusArea(id: 'fa_shoulders', keyCode: 'Shoulders'),
        FocusArea(id: 'fa_triceps', keyCode: 'Triceps'),
      ],
      equipments: const [
        Equipment(id: 'eq_dumbbell', keyCode: 'Dumbbell'),
      ],
    ),
    Exercise(
      id: 'ex_006',
      name: 'Deadlift',
      levelCode: 'Advanced',
      imageUrl: 'https://images.unsplash.com/photo-1546484959-f9a53db89f19?q=80&w=1200&auto=format&fit=crop',
      duration: 55,
      focusAreas: const [
        FocusArea(id: 'fa_back', keyCode: 'Back'),
        FocusArea(id: 'fa_hamstrings', keyCode: 'Hamstrings'),
        FocusArea(id: 'fa_glutes', keyCode: 'Glutes'),
      ],
      equipments: const [
        Equipment(id: 'eq_barbell', keyCode: 'Barbell'),
        Equipment(id: 'eq_plates', keyCode: 'Plates'),
      ],
    ),
  ];

  final SelectedMap _selected = {
    // id -> value (Set cho multi, single cho button-group)
    'muscles': <String>{}, // multi-select
    'difficulty': 'all', // button-group
  };

  late final List<FilterConfig> _filters = [
    FilterConfig<String>(
      id: 'muscles',
      label: 'Nhóm cơ',
      type: FilterType.multiSelect,
      options: const [
        FilterOption(label: 'Ngực', value: 'chest'),
        FilterOption(label: 'Lưng', value: 'back'),
        FilterOption(label: 'Chân', value: 'leg'),
        FilterOption(label: 'Vai', value: 'shoulder'),
        FilterOption(label: 'Tay', value: 'arm'),
        FilterOption(label: 'Ngực1', value: 'chest1'),
        FilterOption(label: 'Lưng1', value: 'back1'),
        FilterOption(label: 'Chân1', value: 'leg1'),
        FilterOption(label: 'Vai1', value: 'shoulder1'),
        FilterOption(label: 'Tay1', value: 'arm1'),
        FilterOption(label: 'Ngực2', value: 'chest2'),
        FilterOption(label: 'Lưng2', value: 'back2'),
        FilterOption(label: 'Chân2', value: 'leg2'),
        FilterOption(label: 'Vai2', value: 'shoulder2'),
        FilterOption(label: 'Tay2', value: 'arm2'),
      ],
      showToggleAll: true,
      maxSelectedLabels: 3,
      display: 'comma',
    ),
    FilterConfig<String>(
      id: 'difficulty',
      label: 'Độ khó',
      type: FilterType.buttonGroup,
      options: const [
        FilterOption(label: 'Tất cả', value: 'all'),
        FilterOption(label: 'Dễ', value: 'easy'),
        FilterOption(label: 'Trung Bình', value: 'medium'),
        FilterOption(label: 'Khó', value: 'hard'),
      ],
    ),
  ];

  String _keyword = '';

  void _updateSelected(String id, dynamic value) {
    setState(() {
      _selected[id] = value;
    });
    // TODO: trigger lọc danh sách bài tập theo _selected + _keyword
  }

  void _clearFilters() {
    setState(() {
      _selected['muscles'] = <String>{};
      _selected['difficulty'] = 'all';
      _keyword = '';
    });
  }

  void _applyFilters() {
    print(_selected);
    print(_keyword);
  }

  void goToDetail(dynamic id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ExerciseDetailScreen(exerciseId: id.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Giả sử bạn có danh sách exercises gốc:
    // final List<Exercise> exercises = ...

    // Nếu bạn có lọc theo keyword + selected, hãy tạo filtered trước khi build:
    final List<Exercise> filtered = exercises; // TODO: áp dụng filter thật

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1) Khu vực Filter + Debug text dùng BoxAdapter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageFilter(
                    title: 'Bộ lọc bài tập',
                    filters: _filters,
                    selected: _selected,
                    updateSelected: _updateSelected,
                    onSearchChanged: (kw) => _keyword = kw,
                    onClear: _clearFilters,
                    onApply: _applyFilters,
                    initiallyCollapsed: false,
                  ),

                  // Debug text (có thể bỏ)
                  // Text('Từ khóa: $_keyword'),
                  // Text('Nhóm cơ: ${(_selected['muscles'] as Set).join(", ")}'),
                  // Text('Độ khó: ${_selected['difficulty']}'),
                ],
              ),
            ),
          ),

          // 2) Trạng thái rỗng (nếu không có item)
          if (filtered.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48.0),
                child: Center(
                  child: Text(
                    'Không có bài tập nào',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            )
          else ...[
            // 3) Lưới card bằng SliverGrid
            SliverPadding(
              padding: const EdgeInsets.all(12.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,      // số cột
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 3 / 4, // tỉ lệ card
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final ex = filtered[index];
                    // Đảm bảo mỗi item có size chặt chẽ trong cell
                    return SizedBox.expand(
                      child: ExerciseCard(
                        name: ex.name,
                        levelCode: ex.levelCode,
                        imageUrl: ex.imageUrl,
                        duration: ex.duration,
                        focusAreas:
                        ex.focusAreas.map((a) => a.keyCode).toList(),
                        equipments:
                        ex.equipments.map((e) => e.keyCode).toList(),
                        onTap: () => goToDetail(ex.id),
                      ),
                    );

                        // return Text("data");
                  },
                  childCount: filtered.length,
                ),
              ),
            ),
            // 4) (Tuỳ chọn) Thêm khoảng trống cuối danh sách
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ],
      ),
    );
  }
}
