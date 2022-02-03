// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:slide_puzzle/colors/colors.dart';
import 'package:zflutter/zflutter.dart';

///{@template tile_3d}
///The Rendered 3D shape of each tile
//////{@endtemplate}
class Tile3D extends StatelessWidget {
  ///{@macro tile_3d}
  const Tile3D({Key? key, required this.size}) : super(key: key);

  /// The size of the tile
  final double size;

  static const _thickness = 20.0;

  @override
  Widget build(BuildContext context) {
    //final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    return ZPositioned.rotate(
      x: 0.19,
      child: ZGroup(
        children: [
          ZPositioned.translate(
            z: -_thickness,
            child: ZBox(
              width: size,
              height: size,
              depth: _thickness,
              color: Colors.green.withOpacity(0.1),
              bottomColor: Colors.green[900]?.withOpacity(0.1),
            ),
          ),
          ZPositioned.translate(
            x: 10,
            y: 10,
            child: ZBox(
              width: size,
              height: size,
              depth: _thickness,
              color: Colors.orange.withOpacity(0.1),
              bottomColor: Colors.orange[900]?.withOpacity(0.1),
            ),
          ),
          ZPositioned.translate(
            z: _thickness,
            child: ZBox(
              width: size,
              height: size,
              depth: _thickness,
              color: PuzzleColors.primary6.withOpacity(0.1),
              bottomColor: PuzzleColors.primary3.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}
