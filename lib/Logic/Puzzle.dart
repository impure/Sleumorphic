
import 'dart:async';
import 'dart:math';

import 'package:binary_codec/binary_codec.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sleumorphic/Data/Data.dart';
import 'package:sleumorphic/Dialogs/StatsDialog.dart';
import 'package:sleumorphic/Logic/PuzzleFunctions.dart';
import 'package:sleumorphic/Widgets/Counter.dart';
import 'package:sleumorphic/Widgets/Tile.dart';
import 'package:tools/SaveLoadManager.dart';
import 'package:tools/Startup.dart';
import 'package:tuple/tuple.dart';

enum DIRECTION_HINT {
	ROW_OR_COLUMN,
	BOTH,
}

List<List<int?>> magicSquares = <List<int?>>[
	<int?>[5, null, 7, 6, 4, 2, 1, 8, 3],
	<int?>[6, null, 9, 8, 5, 2, 1, 10, 4],
	<int?>[7, null, 5, 2, 4, 6, 3, 8, 1],
	<int?>[7, null, 8, 6, 5, 4, 2, 10, 3],
	<int?>[7, null, 11, 10, 6, 2, 1, 12, 5],
	<int?>[8, null, 7, 4, 5, 6, 3, 10, 2],
	<int?>[8, null, 13, 12, 7, 2, 1, 14, 6],
	<int?>[9, null, 6, 2, 5, 8, 4, 10, 1],
	<int?>[9, null, 12, 10, 7, 4, 2, 14, 5],
	<int?>[9, null, 15, 14, 8, 2, 1, 16, 7],
	<int?>[10, null, 11, 8, 7, 6, 3, 14, 4],
	<int?>[10, null, 14, 12, 8, 4, 2, 16, 6],
	<int?>[10, null, 17, 16, 9, 2, 1, 18, 8],
	<int?>[11, null, 7, 2, 6, 10, 5, 12, 1],
	<int?>[11, null, 10, 6, 7, 8, 4, 14, 3],
	<int?>[11, null, 13, 10, 8, 6, 3, 16, 5],
	<int?>[11, null, 16, 14, 9, 4, 2, 18, 7],
	<int?>[12, null, 9, 4, 7, 10, 5, 14, 2],
	<int?>[13, null, 8, 2, 7, 12, 6, 14, 1],
	<int?>[13, null, 11, 6, 8, 10, 5, 16, 3],
	<int?>[13, null, 14, 10, 9, 8, 4, 18, 5],
	<int?>[14, null, 10, 4, 8, 12, 6, 16, 2],
	<int?>[14, null, 13, 8, 9, 10, 5, 18, 4],
	<int?>[15, null, 9, 2, 8, 14, 7, 16, 1],
	<int?>[16, null, 11, 4, 9, 14, 7, 18, 2],
	<int?>[17, null, 10, 2, 9, 16, 8, 18, 1],
];

const int PUZZLE_WIDTH = 3;
const int PUZZLE_HEIGHT = 3;

class Puzzle {

	// Resets everything and shuffles the tiles with the following algorithm:
	// start sorted and then apply random shuffles
	Puzzle() {
		numMoves = 0;
		numChecks = 0;
		shareInfo.clear();

		final Random rng = Random();

		final List<int?> possibleSolution = magicSquares[rng.nextInt(magicSquares.length)];
		puzzlePieces = possibleSolution.toList();

		//print("The magic sum is: ${(possibleSolution[0] ?? 0) + (possibleSolution[1] ?? 0) + (possibleSolution[2] ?? 0)}");

		// Get end state
		puzzlePieces = simulateRandomSwaps(puzzlePieces, 100, rng, keepGoing: (List<int?> currentTiles) {
			for (int i = 0; i < currentTiles.length; i++) {
				if (currentTiles[i] == possibleSolution[i]) {
					return true;
				}
			}
			return false;
		});

		// Also make sure no tiles are currently coloured
		tilesStateGroup.notifyAll(null);
		counterGroup.notifyAll(null);
		boardStateGroup.notifyAll(null);
	}

	factory Puzzle.fromMap(Map<dynamic, dynamic> data) {

		return Puzzle._(
			numMoves: data[Data.NUM_MOVES.index],
			numChecks: data[Data.NUM_CHECKS.index],
			puzzlePieces: List<int?>.from(data[Data.PUZZLE_PIECES.index]),
			isBoosted: (data[Data.MAX_CHECKS_DEPRECATED.index] != null && data[Data.MAX_CHECKS_DEPRECATED.index] >= 6) || data[Data.IS_BOOSTED.index] == true,
			shareInfo: StringBuffer(data[Data.SHARE_INFO.index]),
		);
	}

	Puzzle._({
		required this.numMoves,
		required this.numChecks,
		required this.puzzlePieces,
		required this.shareInfo,
		required this.isBoosted,
	});

	List<int?> puzzlePieces = <int?>[];
	int numMoves = 0;
	int numChecks = 0;
	bool isBoosted = false;

	// Schedule a save in the future and if no one overwrites it save.
	// This is to cut down on unnecessary saves
	DateTime? scheduledSave;

	int get currentMaxNumChecks => 6;

	StringBuffer shareInfo = StringBuffer();

	bool get solved {
		final int magicNumber = (puzzlePieces[0] ?? 0) + (puzzlePieces[1] ?? 0) + (puzzlePieces[2] ?? 0);
		return magicNumber == (puzzlePieces[3] ?? 0) + (puzzlePieces[4] ?? 0) + (puzzlePieces[5] ?? 0) &&
					magicNumber == (puzzlePieces[6] ?? 0) + (puzzlePieces[7] ?? 0) + (puzzlePieces[8] ?? 0) &&
					magicNumber == (puzzlePieces[0] ?? 0) + (puzzlePieces[3] ?? 0) + (puzzlePieces[6] ?? 0) &&
					magicNumber == (puzzlePieces[1] ?? 0) + (puzzlePieces[4] ?? 0) + (puzzlePieces[7] ?? 0) &&
					magicNumber == (puzzlePieces[2] ?? 0) + (puzzlePieces[5] ?? 0) + (puzzlePieces[8] ?? 0) &&
					magicNumber == (puzzlePieces[0] ?? 0) + (puzzlePieces[4] ?? 0) + (puzzlePieces[8] ?? 0) &&
					magicNumber == (puzzlePieces[2] ?? 0) + (puzzlePieces[4] ?? 0) + (puzzlePieces[6] ?? 0);
	}

	String getRequirements(Tuple4<int, int, int, int> requirements) {
		return "${requirements.item1.toString().padLeft(2, "0")} ${requirements.item2.toString().padLeft(2, "0")} ${requirements.item3.toString().padLeft(2, "0")} ${requirements.item4.toString().padLeft(2, "0")}";
	}

	void trySwapHoleWithIndex(int index) {
		if (index >= 0 && index < puzzlePieces.length) {
			trySwapHoleWith(puzzlePieces[index]!);
		}
	}

	void trySwapHoleWith(int num) {

		final int numIndex = puzzlePieces.indexOf(num);
		final int holeIndex = puzzlePieces.indexOf(null);

		void onSuccess() {
			numMoves++;
			tilesStateGroup.notifyAll(null);
			notifyGame();

			scheduledSave = DateTime.now().add(const Duration(seconds: 2));
		}

		if (numIndex == holeIndex - 1 && canSwapHoleWithLeft(holeIndex)) {
			swapHoleWithLeft(holeIndex, puzzlePieces);
			onSuccess();
		} else if (numIndex == holeIndex + 1 && canSwapHoleWithRight(holeIndex)) {
			swapHoleWithRight(holeIndex, puzzlePieces);
			onSuccess();
		} else if (numIndex == holeIndex - PUZZLE_WIDTH && canSwapHoleWithUp(holeIndex)) {
			swapHoleWithUp(holeIndex, puzzlePieces);
			onSuccess();
		} else if (numIndex == holeIndex + PUZZLE_WIDTH && canSwapHoleWithDown(holeIndex)) {
			swapHoleWithDown(holeIndex, puzzlePieces);
			onSuccess();
		}
	}

	void checkWin(BuildContext context) {
		if (solved) {
			unawaited(save());
			showDialog(
				context: context,
				builder: (_) {
					return const StatsDialog();
				}
			);
		}
	}

	void trySwapHoleWithLeft() {
		trySwapHoleWithIndex(puzzlePieces.indexOf(null) - 1);
	}

	void trySwapHoleWithUp() {
		trySwapHoleWithIndex(puzzlePieces.indexOf(null) - PUZZLE_WIDTH);
	}

	void trySwapHoleWithRight() {
		trySwapHoleWithIndex(puzzlePieces.indexOf(null) + 1);
	}

	void trySwapHoleWithDown() {
		trySwapHoleWithIndex(puzzlePieces.indexOf(null) + PUZZLE_WIDTH);
	}

	Map<int, dynamic> toMap() {
		return <int, dynamic> {
			Data.PUZZLE_PIECES.index : puzzlePieces,
			Data.NUM_MOVES.index : numMoves,
			Data.NUM_CHECKS.index : numChecks,
			Data.SHARE_INFO.index : shareInfo.toString(),
			Data.IS_BOOSTED.index : isBoosted,
		};
	}

	void checkScheduledSave(DateTime now) {
		if (scheduledSave != null && now.isAfter(scheduledSave!)) {
			scheduledSave = null;
			unawaited(save());
		}
	}

	Future<void> save() async {
		if (kIsWeb) {
			unawaited(prefs!.setString("Save", binaryCodec.encode(toMap()).toString().
					replaceAll(" ", "").replaceAll("[", "").replaceAll("]", "")));
		} else {
			return saveToFile(
				authenticatedSaveName: "Puzzle1",
				unauthenticatedSaveName: "Puzzle2",
				dataToSave: binaryCodec.encode(toMap()),
				onSave: () {
					debugPrint("Save");
				},
				tryDisplaySavedBlockedMessage: () {
					// Flurdle saves cannot be blocked
				},
				authenticateTime: false,
			);
		}
	}
}

Map<int, List<int>> mapSetToMapList(Map<int, Set<int>> data) {
	final Map<int, List<int>> returnMap = <int, List<int>>{};
	for (final MapEntry<int, Set<int>> entry in data.entries) {
		returnMap[entry.key] = entry.value.toList();
	}
	return returnMap;
}

enum Data {
	PUZZLE_PIECES,
	NUM_MOVES,
	NUM_CHECKS,
	MAX_CHECKS_DEPRECATED,
	SHARE_INFO,
	IS_BOOSTED,
}
