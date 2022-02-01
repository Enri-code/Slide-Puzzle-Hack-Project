import 'package:flutter/material.dart';
import 'package:slide_puzzle/colors/colors.dart';
import 'package:zflutter/zflutter.dart';

///The Rendered 3D shape of each tile
class Tile3D extends StatelessWidget {
  const Tile3D({Key? key, required this.size}) : super(key: key);

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
