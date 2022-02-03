import 'dart:async';
import 'dart:math' as math;

//import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

///Bubble Function
typedef BubbleCallback = void Function(Bubble);

/// {@template bubble}
///A bubble class for spawning bubbles using a BubblePainter
/// {@endtemplate}
// ignore: must_be_immutable
class Bubble extends Equatable {
  /// {@macro bubble}
  Bubble({
    required this.radius,
    required this.position,
    required this.direction,
    required this.timer,
    required this.paint,
    this.onDie,
  });

  /// This creates a bubble with random properties
  factory Bubble.random(Size boundary, {BubbleCallback? onDie}) {
    return Bubble(
      position: Offset(
        _random.nextDouble() * boundary.width,
        _random.nextDouble() * boundary.height,
      ),
      direction: Offset(
        _random.nextDouble() - 0.5,
        _random.nextDouble() - 0.5,
      ),
      radius: _random.nextDouble() * 12 + 6,
      timer: Timer(Duration(milliseconds: _random.nextInt(5000) + 6000), () {}),
      paint: Paint()
        ..color = Color.lerp(
          Color.lerp(Colors.white, Colors.blue, _random.nextDouble()),
          Colors.pink,
          _random.nextDouble(),
        )!
            .withOpacity(0),
      onDie: onDie,
    );
  }

  static final _random = math.Random();

  ///The radius of the bubble
  final double radius;

  /// This counts the amount of time that the paricle will be active
  final Timer timer;

  ///The paint properties for rendering the bubble
  final Paint paint;

  ///Callback function for when the particle's lifetime ends
  final BubbleCallback? onDie;

  ///The position in pixels that the particle begins at
  Offset position;

  ///The amount of pixels to move in the x and y axis for the next frame
  Offset direction;

  ///Determines if the bubbles should bounce in its container or exit
  bool canExitContainer = false;

  ///Moves bubble to its next position for the next frame
  void _moveBubble(Size boundary) {
    position += direction;
    if (canExitContainer) return;

    ///This checks if the bubble is at the edge of the counary and
    ///inverts its direction if it is
    if ((position.dx < radius && direction.dx.isNegative) ||
        (position.dx > boundary.width - radius && !direction.dx.isNegative)) {
      direction = direction.scale(-1, 1);
    }
    if ((position.dy < radius && direction.dy.isNegative) ||
        (position.dy > boundary.height - radius && !direction.dy.isNegative)) {
      direction = direction.scale(1, -1);
    }
  }

  /// Renders the bubble using the canvas reference
  void paintBubble(Canvas canvas, Size boundary) {
    canvas.drawCircle(position, radius, paint);
    _moveBubble(boundary);
    final opacity = paint.color.opacity;
    if (!timer.isActive) {
      if (opacity <= 0) {
        onDie?.call(this);
      } else {
        paint.color = paint.color.withOpacity((opacity - 0.03).clamp(0, 1));
      }
    } else if (opacity < 0.4) {
      paint.color = paint.color.withOpacity((opacity + 0.02).clamp(0, 1));
    }
  }

  @override
  List<Object?> get props => [radius, timer, paint];
}

/// {@template bubble_painter}
///The CustomPainter for the bubbles
///{@endtemplate}
class BubblesPainter extends CustomPainter {
  ///{@macro bubble_painter}
  BubblesPainter(this.anim, {this.bubblesCount = 20}) : super(repaint: anim);

  ///The amount of bubbles to create
  final int bubblesCount;

  ///The animations that drives the bubble frame update
  final AnimationController anim;

  ///The bubbles created and active
  final List<Bubble> bubbles = [];

  ///Determines if a new bubble should replace a dead one
  bool createNewBubble = true;

  ///This boolean initializes the bubbles and ensures that its done only once
  var _isInit = false;

  Bubble _bubble(Size size) {
    return Bubble.random(
      size,
      onDie: (bubble) {
        if (!createNewBubble) return;

        ///Ensures a bubble isn't being rendered while being removed
        ///This prevents jitters in the bubbles
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          bubbles
            ..remove(bubble)
            ..add(_bubble(size));
        });
      },
    );
  }

  /// Creates bubble instances and adds the m to the bubbles array
  void init(Size size) {
    _isInit = true;
    for (var i = 0; i < bubblesCount; i++) {
      bubbles.add(_bubble(size));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (bubbles.isEmpty && bubblesCount < 1) return;
    if (!_isInit) {
      init(size);
    }
    for (final bubble in bubbles) {
      bubble.paintBubble(canvas, size);
    }
  }

  @override
  bool shouldRepaint(BubblesPainter oldDelegate) => true;
}
