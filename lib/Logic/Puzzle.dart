
import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sleumorphic/Data/Data.dart';
import 'package:sleumorphic/Dialogs/StatsDialog.dart';
import 'package:sleumorphic/Logic/PuzzleFunctions.dart';
import 'package:sleumorphic/Logic/TileKeyTranslationLayer.dart';
import 'package:sleumorphic/Widgets/Tile.dart';
import 'package:tuple/tuple.dart';

enum DIRECTION_HINT {
	ROW_OR_COLUMN,
	BOTH,
}

const int PUZZLE_WIDTH = 4;
const int PUZZLE_HEIGHT = 4;

class Puzzle {

	// Resets everything and shuffles the tiles with the following algorithm:
	// start sorted and then apply random shuffles
	Puzzle() {
		numMoves = 0;
		numChecks = 0;
		shareInfo.clear();

		final Random rng = Random();

		final List<int?> possibleSolution = <int?>[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, null, ];
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

		keyTranslationLayer = TileKeyTranslationLayer(puzzlePieces);

		// Also make sure no tiles are currently coloured
		tilesStateGroup.notifyAll(null);
		boardStateGroup.notifyAll(null);
	}

	factory Puzzle.fromMap(Map<dynamic, dynamic> data) {

		return Puzzle._(
			numMoves: data[Data.NUM_MOVES.index],
			numChecks: data[Data.NUM_CHECKS.index],
			puzzlePieces: List<int?>.from(data[Data.PUZZLE_PIECES.index]),
			isBoosted: (data[Data.MAX_CHECKS_DEPRECATED.index] != null && data[Data.MAX_CHECKS_DEPRECATED.index] >= 6) || data[Data.IS_BOOSTED.index] == true,
			shareInfo: StringBuffer(data[Data.SHARE_INFO.index]),
			keyTranslationLayer: TileKeyTranslationLayer(List<int?>.from(data[Data.PUZZLE_PIECES.index])),
		);
	}

	Puzzle._({
		required this.numMoves,
		required this.numChecks,
		required this.puzzlePieces,
		required this.shareInfo,
		required this.isBoosted,
		required this.keyTranslationLayer,
	});

	List<int> backPuzzlePieces = <int>[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 ];
	List<int?> puzzlePieces = <int?>[];
	int numMoves = 0;
	int numChecks = 0;
	bool isBoosted = false;
	TileKeyTranslationLayer? keyTranslationLayer;

	// Schedule a save in the future and if no one overwrites it save.
	// This is to cut down on unnecessary saves
	DateTime? scheduledSave;

	int get currentMaxNumChecks => 6;

	StringBuffer shareInfo = StringBuffer();

	bool get solved {
		int counter = 0;
		for (int i = 0; i < puzzlePieces.length; i++) {
			if (puzzlePieces[i] != null) {
				if (puzzlePieces[i]! <= counter) {
					return false;
				} else {
					counter = puzzlePieces[i]!;
				}
			}
		}
		counter = 0;
		for (int i = 0; i < backPuzzlePieces.length; i++) {
			if (backPuzzlePieces[i] != null) {
				if (backPuzzlePieces[i] <= counter) {
					return false;
				} else {
					counter = backPuzzlePieces[i];
				}
			}
		}
		return true;
	}

	void swapPieces() {
		for (int i = 0; i < puzzlePieces.length; i++) {
			if (puzzlePieces[i] != null) {
				final int tempValue = backPuzzlePieces[i];
				backPuzzlePieces[i] = puzzlePieces[i]!;
				puzzlePieces[i] = tempValue;
			}
		}
	}

	String getRequirements(Tuple4<int, int, int, int> requirements) {
		return "${requirements.item1.toString().padLeft(2, "0")} ${requirements.item2.toString().padLeft(2, "0")} ${requirements.item3.toString().padLeft(2, "0")} ${requirements.item4.toString().padLeft(2, "0")}";
	}

	void trySwapHoleWith(Key? key) {

		final int numIndex = keyTranslationLayer!.keys.indexOf(key);
		final int holeIndex = keyTranslationLayer!.keys.indexOf(null);

		void onSuccess() {
			numMoves++;
			tilesStateGroup.notifyAll(null);
			notifyGame();

			scheduledSave = DateTime.now().add(const Duration(seconds: 2));
		}

		if (numIndex == holeIndex - 1 && canSwapHoleWithLeft(holeIndex)) {
			swapHoleWithLeft(holeIndex, puzzlePieces);
			swapHoleWithLeft(holeIndex, keyTranslationLayer!.keys);
			onSuccess();
		} else if (numIndex == holeIndex + 1 && canSwapHoleWithRight(holeIndex)) {
			swapHoleWithRight(holeIndex, puzzlePieces);
			swapHoleWithRight(holeIndex, keyTranslationLayer!.keys);
			onSuccess();
		} else if (numIndex == holeIndex - PUZZLE_WIDTH && canSwapHoleWithUp(holeIndex)) {
			swapHoleWithUp(holeIndex, puzzlePieces);
			swapHoleWithUp(holeIndex, keyTranslationLayer!.keys);
			onSuccess();
		} else if (numIndex == holeIndex + PUZZLE_WIDTH && canSwapHoleWithDown(holeIndex)) {
			swapHoleWithDown(holeIndex, puzzlePieces);
			swapHoleWithDown(holeIndex, keyTranslationLayer!.keys);
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
		/*
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
				},
				authenticateTime: false,
			);
		}
		*/
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
