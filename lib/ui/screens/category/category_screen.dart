import 'dart:math' as math;

import 'package:ant_icons/ant_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/constants.dart';
import '../../../constants/strings/strings.dart' as s;
import '../../../controllers/controllers.dart';
import '../../../models/models.dart';
import '../../../providers/providers.dart';
import '../../widgets/widgets.dart';
import 'widgets/widgets.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({required this.category, required this.heroId});

  final int heroId;
  final Category category;

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _fadeAnimation;

  // Index for bottom navigation
  late int _navigationIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInExpo,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentCategory = ref
        .watch(categoriesNotifierProvider)
        .firstWhere((element) => element.id == widget.category.id);
    final categoryColor = currentCategory.color;
    final activeTasksNumber =
        ref.watch(numberOfActiveTasksInCategoryProvider(currentCategory.id));
    final progress = ref.watch(completionProgressProvider(currentCategory.id));

    final description = switch (activeTasksNumber) {
      0 => '$activeTasksNumber ${s.taskPlural}',
      1 => '$activeTasksNumber ${s.taskSingular}',
      _ => '$activeTasksNumber ${s.taskPlural}',
    };

    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constrains) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF303030),
                        categoryColor,
                        categoryColor,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  width: math.min((constrains.maxWidth - 24), 600),
                  top: 12,
                  bottom: 12,
                  child: Hero(
                    tag: 'main${widget.heroId}',
                    child: Container(
                      decoration: CustomStyle.dialogDecoration,
                    ),
                  ),
                ),
                Positioned(
                  width: math.min((constrains.maxWidth - 24), 600),
                  top: 12,
                  bottom: 12,
                  child: AnimatedOpacityBuilder(
                    animation: _fadeAnimation,
                    content: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            top: 8.0,
                            right: 8.0,
                          ),
                          child: CategoryTopBar(
                            onClose: () => _animationController.reverse(),
                            category: currentCategory,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              // vertical: 12.0,
                              horizontal: 8.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 6.0,
                                    top: 16.0,
                                    right: 6.0,
                                    bottom: 12.0,
                                  ),
                                  child: CategoryElementBase(
                                    icon: currentCategory.icon,
                                    name: currentCategory.name,
                                    description: description,
                                    progress: progress,
                                    color: categoryColor,
                                    iconSize: 28,
                                    titleTextStyle:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                                NavigationBar(
                                  backgroundColor: Colors.transparent,
                                  selectedIndex: _navigationIndex,
                                  height: 64,
                                  onDestinationSelected: (index) {
                                    setState(() {
                                      _navigationIndex = index;
                                    });
                                  },
                                  destinations: [
                                    const NavigationDestination(
                                      label: s.toDo,
                                      icon: Icon(AntIcons.edit),
                                    ),
                                    const NavigationDestination(
                                      label: s.all,
                                      icon: Icon(AntIcons.profile),
                                    ),
                                    const NavigationDestination(
                                      label: s.completed,
                                      icon: Icon(AntIcons.checkCircle),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: _buildTasksList(currentCategory),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 6.0,
                                    right: 6.0,
                                    bottom: 16.0,
                                  ),
                                  child: AddTaskField(
                                    onAddTask: (value) {
                                      final task = Task(
                                        name: value,
                                        categoryId: currentCategory.id,
                                      );
                                      ref
                                          .read(tasksNotifierProvider.notifier)
                                          .add(task: task);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTasksList(Category category) {
    return switch (_navigationIndex) {
      0 => PlannedTasks(categoryId: category.id),
      1 => AllTasks(categoryId: category.id),
      2 => CompletedTasks(categoryId: category.id),
      _ => PlannedTasks(categoryId: category.id),
    };
  }
}
