
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sleumorphic/Data/Data.dart';
import 'package:sleumorphic/Dialogs/SettingsDialog.dart';
import 'package:sleumorphic/Dialogs/StatsDialog.dart';
import 'package:sleumorphic/Logic/Puzzle.dart';
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

		/*
		for (int i = 0; i < puzzle.backPuzzlePieces.length; i++) {
			if (puzzle.backPuzzlePieces[i] == null) {
				cells.add(Container());
			} else {
				cells.add(Tile.fromIndices(
						puzzle.backPuzzlePieces[i]!,
						(widget.gridSize / PUZZLE_WIDTH) - PADDING_SIZE,
						(widget.gridSize / PUZZLE_HEIGHT) - PADDING_SIZE,
						i % PUZZLE_WIDTH, i ~/ PUZZLE_WIDTH,
						key: Key("${puzzle.backPuzzlePieces[i]} back"))
				);
			}
		}
		*/

		for (int i = 0; i < puzzle.puzzlePieces.length; i++) {
			if (puzzle.puzzlePieces[i] == null) {
				cells.add(Container());
			} else {
				cells.add(Tile.fromIndices(
					puzzle.puzzlePieces[i]!,
					(widget.gridSize / PUZZLE_WIDTH) - PADDING_SIZE,
					(widget.gridSize / PUZZLE_HEIGHT) - PADDING_SIZE,
					i % PUZZLE_WIDTH, i ~/ PUZZLE_WIDTH,
					key: Key("${puzzle.puzzlePieces[i]} front"))
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
				if (key.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
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
