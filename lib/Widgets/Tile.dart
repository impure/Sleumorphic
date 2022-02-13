
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sleumorphic/Data/Data.dart';
import 'package:sleumorphic/Dialogs/StatsDialog.dart';
import 'package:sleumorphic/Logic/Puzzle.dart';
import 'package:state_groups/state_groups.dart';
import 'package:tools/BasicExtensions.dart';

StateGroup<Map<int, DIRECTION_HINT>> tilesStateGroup = StateGroup<Map<int, DIRECTION_HINT>>();

class Tile extends StatefulWidget {
	const Tile(this.num, this.width, this.height, this.offset, this.depth, {Key? key}) : super(key: key);

	factory Tile.fromIndices(int num, double width, double height, int x, int y, double depth, {Key? key}) {
		return Tile(
			num, width, height,
			Offset(x * (width + PADDING_SIZE) + PADDING_SIZE * 0.5, y * (height + PADDING_SIZE) + PADDING_SIZE * 0.5),
			depth,
			key: key,
		);
	}

	final int num;
	final double width, height;
	final Offset offset;
	final double depth;

	@override
	TileState createState() => TileState();
}

class TileState extends SyncState<Map<int, DIRECTION_HINT>, Tile> with SingleTickerProviderStateMixin {

	TileState() : super(tilesStateGroup);

	Offset? oldOffset;

	late AnimationController _controller;
	late Animation<double> _animation;
	DIRECTION_HINT? hintInfo;

	@override
	void update(Map<int, DIRECTION_HINT>? message) {
		hintInfo = message?[widget.num];
		super.update(message);
  }

	@override
	void didUpdateWidget(Tile oldWidget) {

		if (oldWidget.offset != widget.offset) {
			oldOffset = oldWidget.offset;
			_controller.forward(from: 0);
		}

		super.didUpdateWidget(oldWidget);
	}

	@override
	void initState() {
		_controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
		_controller.value = 0;
		_animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));
		super.initState();
	}

	@override
	void dispose() {
		_controller.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {

		final ThemeData themeData = Theme.of(context);

		return AnimatedBuilder(
			animation: _controller,
			builder: (_, __) {
				return Transform.translate(
					offset: oldOffset == null ? widget.offset : Offset.lerp(oldOffset, widget.offset, _animation.value)!,
					child: SizedBox(
						height: widget.height,
						width: widget.width,
						child: Neumorphic(
							style: NeumorphicStyle(
								shape: NeumorphicShape.convex,
								boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
								depth: widget.depth,
								lightSource: LightSource.topLeft,
								color: themeData.canvasColor,
								shadowDarkColor: themeData.darkModeEnabled ? Colors.black : Colors.black54,
								shadowLightColor: themeData.darkModeEnabled ? Colors.white70 : Colors.white,
							),
							child: GestureDetector(
								behavior: HitTestBehavior.translucent,
								child: SizedBox(
									height: widget.height,
									width: widget.width,
									child: Center(
										child: Padding(
											padding: EdgeInsets.symmetric(vertical: widget.width * 0.2, horizontal: widget.height * 0.2),
											child: AutoSizeText(
												widget.num.toString(),
												style: const TextStyle(
													//color: Colors.white,
													fontSize: 50,
													fontWeight: FontWeight.w900,
													//shadows: <Shadow>[
													//	Shadow(
													//		color: shadowColour,
													//		blurRadius: 10,
													//	),
													//],
												),
											),
										),
									),
								),
								onTap: () {
									if (puzzle.solved) {
										showDialog(
											context: context,
											builder: (_) {
												return const StatsDialog();
											}
										);
										return;
									}
									puzzle.trySwapHoleWith(widget.num);
									puzzle.checkWin(context);
								},
							),
						),
					),
				);
			}
		);
	}
}
