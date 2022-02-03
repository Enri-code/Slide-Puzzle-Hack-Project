// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import 'package:slide_puzzle/colors/colors.dart';
import 'package:slide_puzzle/l10n/l10n.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/models/models.dart';
import 'package:slide_puzzle/puzzle/puzzle.dart';
import 'package:slide_puzzle/renders/tile.dart';
import 'package:slide_puzzle/theme/theme.dart';
import 'package:slide_puzzle/typography/typography.dart';
import 'package:zflutter/zflutter.dart';

/// {@template advanced_puzzle_layout_delegate}
/// A delegate for computing the layout of the puzzle UI
/// that uses an [AdvancedTheme].
/// {@endtemplate}
class AdvancedPuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  /// {@macro advanced_puzzle_layout_delegate}
  const AdvancedPuzzleLayoutDelegate();

  @override
  Widget startSectionBuilder(PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => Padding(
        padding: const EdgeInsets.only(left: 50, right: 32),
        child: child,
      ),
      child: (_) => AdvancedStartSection(state: state),
    );
  }

  @override
  Widget endSectionBuilder(PuzzleState state) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
        ResponsiveLayoutBuilder(
          small: (_, child) => const AdvancedPuzzleShuffleButton(),
          medium: (_, child) => const AdvancedPuzzleShuffleButton(),
          large: (_, __) => const SizedBox(),
        ),
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
      ],
    );
  }

  @override
  Widget backgroundBuilder(PuzzleState state) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: ResponsiveLayoutBuilder(
        small: (_, __) => SizedBox(
          width: 184,
          height: 118,
          child: Image.asset(
            'assets/images/simple_dash_small.png',
            key: const Key('advanced_puzzle_dash_small'),
          ),
        ),
        medium: (_, __) => SizedBox(
          width: 380.44,
          height: 214,
          child: Image.asset(
            'assets/images/simple_dash_medium.png',
            key: const Key('advanced_puzzle_dash_medium'),
          ),
        ),
        large: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 53),
          child: SizedBox(
            width: 568.99,
            height: 320,
            child: Image.asset(
              'assets/images/simple_dash_large.png',
              key: const Key('advanced_puzzle_dash_large'),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget boardBuilder(int size, List<PuzzleTileBody> tiles) {
    return Column(
      children: [
        const ResponsiveGap(small: 32, medium: 48, large: 96),
        ResponsiveLayoutBuilder(
          small: (_, __) => SizedBox.square(
            dimension: _BoardSize.small,
            child: AdvancedPuzzleBoard(
              key: const Key('advanced_puzzle_board_small'),
              size: size,
              tileBodies: tiles,
            ),
          ),
          medium: (_, __) => SizedBox.square(
            dimension: _BoardSize.medium,
            child: AdvancedPuzzleBoard(
              key: const Key('advanced_puzzle_board_medium'),
              size: size,
              tileBodies: tiles,
            ),
          ),
          large: (_, __) => SizedBox.square(
            dimension: _BoardSize.large,
            child: AdvancedPuzzleBoard(
              key: const Key('advanced_puzzle_board_large'),
              size: size,
              tileBodies: tiles,
            ),
          ),
        ),
        const ResponsiveGap(large: 96),
      ],
    );
  }

  @override
  Widget tileBuilder(Tile tile, PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => AdvancedPuzzleTile(
        key: Key('advanced_puzzle_tile_${tile.value}_small'),
        tile: tile,
        tileFontSize: _TileFontSize.small,
        puzzleState: state,
      ),
      medium: (_, __) => AdvancedPuzzleTile(
        key: Key('advanced_puzzle_tile_${tile.value}_medium'),
        tile: tile,
        tileFontSize: _TileFontSize.medium,
        puzzleState: state,
      ),
      large: (_, __) => AdvancedPuzzleTile(
        key: Key('advanced_puzzle_tile_${tile.value}_large'),
        tile: tile,
        tileFontSize: _TileFontSize.large,
        puzzleState: state,
      ),
    );
  }

  @override
  List<Object?> get props => [];
}

/// {@template advanced_start_section}
/// Displays the start section of the puzzle based on [state].
/// {@endtemplate}
@visibleForTesting
class AdvancedStartSection extends StatelessWidget {
  /// {@macro advanced_start_section}
  const AdvancedStartSection({Key? key, required this.state}) : super(key: key);

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveGap(small: 20, medium: 83, large: 151),
        const PuzzleName(),
        const ResponsiveGap(large: 16),
        AdvancedPuzzleTitle(status: state.puzzleStatus),
        const ResponsiveGap(small: 12, medium: 16, large: 32),
        NumberOfMovesAndTilesLeft(
          numberOfMoves: state.numberOfMoves,
          numberOfTilesLeft: state.numberOfTilesLeft,
        ),
        const ResponsiveGap(large: 32),

        // TODO(Eric): place timer here
        const ResponsiveGap(large: 32),
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(),
          medium: (_, __) => const SizedBox(),
          large: (_, __) => const AdvancedPuzzleShuffleButton(),
        ),
      ],
    );
  }
}

/// {@template advanced_puzzle_title}
/// Displays the title of the puzzle based on [status].
///
/// Shows the success state when the puzzle is completed,
/// otherwise defaults to the Puzzle Challenge title.
/// {@endtemplate}
@visibleForTesting
class AdvancedPuzzleTitle extends StatelessWidget {
  /// {@macro advanced_puzzle_title}
  const AdvancedPuzzleTitle({Key? key, required this.status}) : super(key: key);

  /// The state of the puzzle.
  final PuzzleStatus status;

  @override
  Widget build(BuildContext context) {
    return PuzzleTitle(
      title: status == PuzzleStatus.complete
          ? context.l10n.puzzleCompleted
          : context.l10n.puzzleChallengeTitle,
    );
  }
}

abstract class _BoardSize {
  static double small = 312;
  static double medium = 424;
  static double large = 472;
}

/// {@template advanced_puzzle_board}
/// Display the board of the puzzle in a [size]x[size] layout
/// filled with [tileBodies].
/// {@endtemplate}
@visibleForTesting
class AdvancedPuzzleBoard extends StatelessWidget {
  /// {@macro advanced_puzzle_board}
  const AdvancedPuzzleBoard({
    Key? key,
    required this.size,
    required this.tileBodies,
  }) : super(key: key);

  /// The size of the board.
  final int size;

  /// The widgets to be displayed in front of the tiles on the board.
  final List<PuzzleTileBody> tileBodies;

  @override
  Widget build(BuildContext context) {
    final tileType =
        context.select((PuzzleBloc bloc) => bloc.state.puzzle.tileType);

    return LayoutBuilder(
      builder: (_, constraints) {
        final _tileSize = constraints.biggest.shortestSide / size;

        double _tileOffset(int currPos) =>
            _tileSize * (currPos - 0.5 - 0.5 * size);

        return Stack(
          fit: StackFit.expand,
          alignment: AlignmentDirectional.center,
          children: [
            if (tileType != PuzzleTileType.images) const _BubblePainter(),
            ZIllustration(
              children: [
                for (var tileWidget in tileBodies)
                  if (!tileWidget.tile.isWhitespace)
                    ZPositioned.translate(
                      x: _tileOffset(tileWidget.tile.currentPosition.x),
                      y: _tileOffset(tileWidget.tile.currentPosition.y),
                      child: Tile3D(size: _tileSize),
                    ),
              ],
            ),
            Transform(
              transform: Matrix4.rotationX(0.19),
              child: GridView.count(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: size,
                children: tileBodies,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BubblePainter extends StatefulWidget {
  const _BubblePainter({Key? key}) : super(key: key);

  @override
  __BubblePainterState createState() => __BubblePainterState();
}

class __BubblePainterState extends State<_BubblePainter>
    with SingleTickerProviderStateMixin {
  late final AnimationController bubblesFrameUpdater;

  @override
  void initState() {
    super.initState();
    bubblesFrameUpdater =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
  }

  @override
  void dispose() {
    bubblesFrameUpdater.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BubblesPainter(bubblesFrameUpdater),
    );
  }
}

abstract class _TileFontSize {
  static double small = 36;
  static double medium = 50;
  static double large = 54;
}

/// {@template advanced_puzzle_tile}
/// Displays the puzzle tile associated with [tile]
/// {@endtemplate}
@visibleForTesting
class AdvancedPuzzleTile extends StatelessWidget {
  /// {@macro advanced_puzzle_tile}
  const AdvancedPuzzleTile({
    Key? key,
    required this.tile,
    required this.tileFontSize,
    required this.puzzleState,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The font size of the tile to be displayed.
  final double tileFontSize;

  /// The state of the puzzle.
  final PuzzleState puzzleState;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return Stack(
      fit: StackFit.expand,
      children: [
        InkResponse(
          highlightShape: BoxShape.rectangle,
          onHover: (val) {
            context
                .read<PuzzleBloc>()
                .add(TileHovered(entered: val, tile: tile));
          },
          onTap: puzzleState.puzzleStatus == PuzzleStatus.incomplete
              ? () {
                  context.read<PuzzleBloc>().add(TileTapped(tile));
                }
              : null,
        ),
        IgnorePointer(
          child: BlocSelector<PuzzleBloc, PuzzleState, bool>(
            selector: (state) => state.lastTappedTile?.value == tile.value,
            builder: (context, isTappedTile) =>
                BlocSelector<PuzzleBloc, PuzzleState, bool>(
              selector: (state) => state.hoveredTile?.value == tile.value,
              builder: (context, isHoveredTile) {
                final size = puzzleState.puzzle.getDimension();
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    () {
                      if (puzzleState.puzzle.tileType ==
                          PuzzleTileType.images) {
                        const _path = 'images/tiles_';
                        return SvgPicture.asset(
                          '$_path${size}x$size/${tile.value}.svg',
                          color: isHoveredTile ? theme.hoverColor : null,
                          colorBlendMode: BlendMode.color,
                          placeholderBuilder: (_) {
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            tile.value.toString(),
                            style: PuzzleTextStyle.headline2.copyWith(
                              fontSize: tileFontSize,
                              color: isHoveredTile
                                  ? PuzzleColors.grey1
                                  : PuzzleColors.white,
                            ),
                          ),
                        );
                      }
                    }(),
                    if (isTappedTile)
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: theme.pressedColor,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// {@template puzzle_shuffle_button}
/// Displays the button to shuffle the puzzle.
/// {@endtemplate}
@visibleForTesting
class AdvancedPuzzleShuffleButton extends StatelessWidget {
  /// {@macro puzzle_shuffle_button}
  const AdvancedPuzzleShuffleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: PuzzleColors.primary6,
      onPressed: () => context.read<PuzzleBloc>().add(const PuzzleReset()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/shuffle_icon.png', width: 17, height: 17),
          const Gap(10),
          Text(context.l10n.puzzleShuffle),
        ],
      ),
    );
  }
}
