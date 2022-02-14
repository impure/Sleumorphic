
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sleumorphic/Data/Data.dart';
import 'package:sleumorphic/Dialogs/SettingsDialog.dart';
import 'package:sleumorphic/Dialogs/StatsDialog.dart';
import 'package:sleumorphic/Logic/Puzzle.dart';
import 'package:sleumorphic/Widgets/NeumorphicTile.dart';
import 'package:sleumorphic/Widgets/Tile.dart';
import 'package:state_groups/state_groups.dart';

class BoardDisplay extends StatefulWidget {
  const BoardDisplay(this.gridSize, {Key? key}) : super(key: key);

  final double gridSize;

	@override
	BoardDisplayState createState() => BoardDisplayState();
}

class BoardDisplayState extends SyncState<void, BoardDisplay> {

  BoardDisplayState() : super(boardStateGroup);

	@override
	Widget build(BuildContext context) {
		final List<Widget> cells = <Widget>[];

		final double width = widget.gridSize / PUZZLE_WIDTH;
		final double height = widget.gridSize / PUZZLE_HEIGHT;
		final double paddingSize = max(width, height) * 0.15;

		for (int i = 0; i < puzzle.backPuzzlePieces.length; i++) {
			if (puzzle.backPuzzlePieces[i] == null) {
				cells.add(Container());
			} else {
				cells.add(Tile.fromIndices(
					puzzle.backPuzzlePieces[i],
					width - paddingSize,
					height - paddingSize,
					i % PUZZLE_WIDTH, i ~/ PUZZLE_WIDTH,
					false,
					paddingSize,
				));
			}
		}

		for (int i = 0; i < puzzle.puzzlePieces.length; i++) {
			if (puzzle.puzzlePieces[i] == null) {
				cells.add(Container());
			} else {
				cells.add(Tile.fromIndices(
					puzzle.puzzlePieces[i]!,
					width - paddingSize,
					height - paddingSize,
					i % PUZZLE_WIDTH, i ~/ PUZZLE_WIDTH,
					true,
					paddingSize,
					key: puzzle.keyTranslationLayer!.keys[i])
				);
			}
		}

		return RawKeyboardListener(
			autofocus: true,
			onKey: (RawKeyEvent key) {
				if (puzzle.solved) {
					showDialog(
						context: context,
						builder: (_) {
							return const StatsDialog();
						},
					);
					return;
				}
				if (key.isKeyPressed(LogicalKeyboardKey.space)) {
					puzzle.invertPieces();
					boardStateGroup.notifyAll();
					final int holeLocation = puzzle.puzzlePieces.indexOf(null);
					neumorphicTiles.notifyAll(Offset((holeLocation % PUZZLE_WIDTH).toDouble(), (holeLocation ~/ PUZZLE_WIDTH).toDouble()));
				} else if (key.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
					if (!invertControls) {
						puzzle.trySwapHoleWithLeft();
					} else {
						puzzle.trySwapHoleWithRight();
					}
				} else if (key.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
					if (!invertControls) {
						puzzle.trySwapHoleWithUp();
					} else {
						puzzle.trySwapHoleWithDown();
					}
				} else if (key.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
					if (!invertControls) {
						puzzle.trySwapHoleWithRight();
					} else {
						puzzle.trySwapHoleWithLeft();
					}
				} else if (key.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
					if (!invertControls) {
						puzzle.trySwapHoleWithDown();
					} else {
						puzzle.trySwapHoleWithUp();
					}
				}
			},
			focusNode: FocusNode(),
			child: Column(
				children: <Widget>[
					SizedBox(
						height: widget.gridSize,
						width: widget.gridSize,
						child: Stack(
							children: cells,
						),
					),
				],
			),
		);
	}
}
