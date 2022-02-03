import 'dart:ui';

import 'package:slide_puzzle/colors/colors.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/theme/themes/themes.dart';

/// {@template advanced_theme}
/// The advanced puzzle theme.
/// {@endtemplate}
class AdvancedTheme extends PuzzleTheme {
  /// {@macro advanced_theme}
  const AdvancedTheme() : super();

  @override
  String get name => 'Advanced';

  @override
  bool get hasTimer => true;

  @override
  bool get hasCountdown => false;

  @override
  Color get backgroundColor => PuzzleColors.white;

  @override
  Color get defaultColor => PuzzleColors.primary5;

  @override
  Color get hoverColor => PuzzleColors.primary3.withOpacity(0.6);

  @override
  Color get pressedColor => PuzzleColors.primary7;

  @override
  PuzzleLayoutDelegate get layoutDelegate =>
      const AdvancedPuzzleLayoutDelegate();

  @override
  List<Object?> get props => [
        name,
        hasTimer,
        hasCountdown,
        backgroundColor,
        defaultColor,
        hoverColor,
        pressedColor,
        layoutDelegate,
      ];
}
