import 'package:flutter/widgets.dart';
import 'package:test_app/src/feature/news/theme/theme.dart';

class CategoryTile extends StatelessWidget {
  final String category;
  final bool isSelected;
  final Function(int, BuildContext) onTap;
  final int index;

  const CategoryTile({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index, context),
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 11),
        decoration: BoxDecoration(
          color: isSelected
              ? NewsTheme.color.selectedFilter
              : NewsTheme.color.unselectedFilter,
          borderRadius: BorderRadius.circular(22),
        ),
        duration: const Duration(milliseconds: 200),
        child: Text(category, style: NewsTheme.text.filterTitle),
      ),
    );
  }
}
