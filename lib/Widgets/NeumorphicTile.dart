
import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sleumorphic/Data/Data.dart';
import 'package:sleumorphic/Dialogs/StatsDialog.dart';
import 'package:sleumorphic/Logic/Puzzle.dart';
import 'package:state_groups/state_groups.dart';
import 'package:tools/BasicExtensions.dart';

StateGroup<Offset> neumorphicTiles = StateGroup<Offset>();

class NeumorphicTile extends StatefulWidget {
  const NeumorphicTile({required this.offset, required this.height, required this.width, required this.num, required this.foreground, required Key? key}) : super(key: key);

  final double height, width;
  final int num;
  final bool foreground;
  final Offset offset;

	@override
	NeumorphicTileState createState() => NeumorphicTileState();
}

class NeumorphicTileState extends SyncState<Offset, NeumorphicTile> with TickerProviderStateMixin {

	NeumorphicTileState() : super(neumorphicTiles);

	late AnimationController _flipController;
	late AnimationController _initController;
	late Animation<double> _flipAnimation;
	late Animation<double> _initAnimation;
	double? _prevAnimationValue;
	late int displayNum;

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
		if (offset == null) {
			int index = puzzle.keyTranslationLayer!.keys.indexOf(widget.key);
			if (index == -1) {
				index = puzzle.keyTranslationLayer!.keys.indexOf(null);
			}
			displayNum = puzzle.puzzlePieces[index] ?? puzzle.backPuzzlePieces[index];
			super.update(null);
			return;
		}
		Future<void>.delayed(Duration(milliseconds: (75 * ((widget.offset - offset).distance - 1)).round())).then((_) {
			_flipController.forward(from: 0);
		});
	}

	@override
	void initState() {
		_initController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
		_initController.value = 0;
		_initAnimation = Tween<double>(begin: 0, end: 1)
				.animate(CurvedAnimation(parent: _initController, curve: const Interval(0.25, 1, curve: Curves.easeInOutCubic)));

		_flipController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
		_flipController.value = 0;
		_flipAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _flipController, curve: Curves.linear));
		_flipAnimation.addListener(() {
			if (_prevAnimationValue != null && _prevAnimationValue! < 0.25 && _flipAnimation.value >= 0.25) {
				displayNum = widget.num;
			}
			_prevAnimationValue = _flipAnimation.value;
		});
		displayNum = widget.num;
		super.initState();
	}

	@override
	void dispose() {
		_flipController.dispose();
		_initController.dispose();
		super.dispose();
	}
	
	double computeDepth(double animationValue) {
		return max(1 - Curves.easeOutExpo.transform(animationValue) * 2, Curves.easeIn.transform(animationValue) * 2 - 1) * maxDepth;
	}

	double get maxDepth {
		return max(widget.width, widget.width) * 0.05;
	}

	Puzzle? previousPuzzle;

	@override
	Widget build(BuildContext context) {

		if (puzzle == null || puzzle != previousPuzzle) {
			_initController.forward(from: 0);
		}

		final ThemeData themeData = Theme.of(context);

		return AnimatedBuilder(
			animation: _initController,
			builder: (_, __) {
				return AnimatedBuilder(
					animation: _flipAnimation,
					builder: (_, __) {

						Paint.enableDithering = true;
						final double currentDepth = _initAnimation.value * (widget.foreground ? computeDepth(_flipAnimation.value) : -maxDepth);
						final num multiplier = _initAnimation.value * pow(max(currentDepth/maxDepth, 0), 0.25);

						return Stack(
							children: <Widget>[
								Neumorphic(
									style: NeumorphicStyle(
										boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(max(widget.width, widget.height) * 0.1)),
										depth: currentDepth,
										lightSource: LightSource.topLeft,
										color: themeData.canvasColor,
										shadowDarkColor: themeData.darkModeEnabled ? Colors.black : Colors.black54,
										shadowLightColor: themeData.darkModeEnabled ? Colors.white70 : Colors.white.withOpacity(0.9),
									),
									child: GestureDetector(
										behavior: HitTestBehavior.translucent,
										child: Container(
											height: widget.height,
											width: widget.width,
											decoration: BoxDecoration(
													gradient: LinearGradient(
															begin: Alignment.topLeft,
															end: Alignment.bottomRight,
															colors: <Color>[
																widget.foreground ? themeData.canvasColor.brighten((8 * multiplier).round()) : themeData.canvasColor,
																themeData.canvasColor,
															]
													)
											),
										),
										onTap: () {
											if (!widget.foreground) {
												puzzle.numInverts++;
												puzzle.invertPieces();
												boardStateGroup.notifyAll();
												neumorphicTiles.notifyAll(widget.offset);
												puzzle.checkWin(context);
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
											puzzle.trySwapHoleWith(widget.key);
											puzzle.checkWin(context);
										},
									),
								),
								IgnorePointer(
									child: SizedBox(
										height: widget.height,
										width: widget.width,
										child: Padding(
											padding: EdgeInsets.symmetric(vertical: widget.height * 0.2),
											child: Center(
												child: AutoSizeText(
													displayNum.toString(),
													style: const TextStyle(
														fontSize: 50,
														fontWeight: FontWeight.w700,
													),
												),
											),
										),
									),
								),
							],
						);
					},
				);
			},
		);
	}
}
