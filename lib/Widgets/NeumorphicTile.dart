
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sleumorphic/Data/Data.dart';
import 'package:sleumorphic/Dialogs/StatsDialog.dart';
import 'package:state_groups/state_groups.dart';
import 'package:tools/BasicExtensions.dart';

StateGroup<Offset> neumorphicTiles = StateGroup<Offset>();

class NeumorphicTile extends StatefulWidget {
  const NeumorphicTile({required this.offset, required this.height, required this.width, required this.num, required this.foreground, Key? key}) : super(key: key);

  final double height, width;
  final int num;
  final bool foreground;
  final Offset offset;

	@override
	NeumorphicTileState createState() => NeumorphicTileState();
}

class NeumorphicTileState extends SyncState<Offset, NeumorphicTile> with SingleTickerProviderStateMixin {

	NeumorphicTileState() : super(neumorphicTiles);

	late AnimationController _controller;
	late Animation<double> _animation;

	/*
	Offset? oldOffset;
	DIRECTION_HINT? hintInfo;

	@override
	void didUpdateWidget(Tile oldWidget) {

		if (oldWidget.offset != widget.offset) {
			oldOffset = oldWidget.offset;
			_controller.forward(from: 0);
		}

		super.didUpdateWidget(oldWidget);
	}
	*/

	@override
	void update(Offset? offset) {
		Future<void>.delayed(Duration(milliseconds: (2 * (widget.offset - offset!).distance).round())).then((_) {
			_controller.forward(from: 0);
		});

		super.update(null);
	}

	@override
	void initState() {
		_controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
		_controller.value = 0;
		_animation = Tween<double>(begin: 0, end: 2).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
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
			animation: _animation,
			builder: (_, __) {
				return Neumorphic(
					style: NeumorphicStyle(
						shape: NeumorphicShape.convex,
						boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
						depth: widget.foreground ? (1 - _animation.value).abs() * 5 : -5,
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
							if (!widget.foreground) {
								neumorphicTiles.notifyAll(widget.offset);
								return;
							}
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
				);
			},
		);
		/*
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
								depth: widget.foreground ? 5 : -5,
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
									if (!widget.foreground) {
										return;
									}
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
		*/
	}
}
