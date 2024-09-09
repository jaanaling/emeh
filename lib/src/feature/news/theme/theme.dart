import 'package:test_app/src/core/theme/a_colors.dart';
import 'package:test_app/src/core/theme/a_text_styles.dart';

final class NewsThemeText {
  final cardTitle = ATextStyles.title1;
  final cardSubtitle = ATextStyles.subtitle2;
  final cardDate = ATextStyles.subtitle;
  final filterTitle = ATextStyles.buttonText;
  final detailedTitle = ATextStyles.title2;
  final detailedSubtitle = ATextStyles.subtitle3;
  final detailedDate = ATextStyles.subtitle2;
  final detailedDescription = ATextStyles.text;
}

final class NewsThemeColors {
  final cardColor = AColors.white;
  final selectedFilter = AColors.blue;
  final unselectedFilter = AColors.white200;
  final icon = AColors.black100;
}

class NewsTheme {
  static final color = NewsThemeColors();
  static final text = NewsThemeText();
}
