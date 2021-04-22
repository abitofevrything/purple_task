import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../globals/globals.dart';
import '../../bloc/category_cubit.dart';
import '../../bloc/new_category_cubit.dart';

class IconSelector extends StatelessWidget {
  const IconSelector({
    required this.selectedIcon,
    this.isInCreator = true,
  });

  final int selectedIcon;
  final bool isInCreator;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryIcons.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIcon == categoryIcons[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 300),
            child: SlideAnimation(
              horizontalOffset: 100,
              child: FadeInAnimation(
                child: Padding(
                  padding: isSelected
                      ? const EdgeInsets.symmetric(vertical: 10, horizontal: 4)
                      : const EdgeInsets.symmetric(vertical: 20, horizontal: 4),
                  child: SizedBox(
                    width: 70,
                    child: Card(
                      color: Colors.grey.shade300,
                      elevation: isSelected ? 6 : 1,
                      child: InkWell(
                        onFocusChange: isInCreator
                            ? (v) => context
                                .read<NewCategoryCubit>()
                                .changeTempIcon(categoryIcons[index])
                            : (v) => context
                                .read<CategoryCubit>()
                                .updateIcon(icon: categoryIcons[index]),
                        onTap: isInCreator
                            ? () => context
                                .read<NewCategoryCubit>()
                                .changeTempIcon(categoryIcons[index])
                            : () => context
                                .read<CategoryCubit>()
                                .updateIcon(icon: categoryIcons[index]),
                        child: Icon(
                          IconData(
                            categoryIcons[index],
                            fontFamily: 'AntIcons',
                            fontPackage: 'ant_icons',
                          ),
                          color: Colors.grey.shade800,
                          size: isSelected ? 30 : 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
