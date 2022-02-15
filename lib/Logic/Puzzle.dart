
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

int PUZZLE_WIDTH = 3;
int PUZZLE_HEIGHT = 3;

class Puzzle {

	// Resets everything and shuffles the tiles with the following algorithm:
	// start sorted and then apply random shuffles
	Puzzle() {
		numMoves = 0;
		numInverts = 0;
		shareInfo.clear();

		final Random rng = Random();

		backPuzzlePieces.clear();
		puzzlePieces.clear();

		for (int i = 1; i <= PUZZLE_WIDTH * PUZZLE_HEIGHT; i++) {
			backPuzzlePieces.add(i);
			if (i != PUZZLE_HEIGHT * PUZZLE_WIDTH) {
				puzzlePieces.add(i);
			} else {
				puzzlePieces.add(null);
			}
		}

		// Get end state
		simulateRandomSwaps(100, rng, keepGoing: () {
			for (int i = 0; i < puzzlePieces.length; i++) {
				if (puzzlePieces[i] == i) {
					return true;
				}
				if (backPuzzlePieces[i] == i) {
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

	List<int> backPuzzlePieces = <int>[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 ];
	List<int?> puzzlePieces = <int?>[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, null ];
	int numMoves = 0;
	int numInverts = 0;
	bool isBoosted = false;
	TileKeyTranslationLayer? keyTranslationLayer;

	// Schedule a save in the future and if no one overwrites it save.
	// This is to cut down on unnecessary saves
	DateTime? scheduledSave;

	int get currentMaxNumChecks => 6;

	StringBuffer shareInfo = StringBuffer();

	void simulateRandomSwaps(int numSwaps, Random rng, {bool Function()? keepGoing}) {
		final List<Swap> swaps = <Swap>[];
		int counter = 1;
		while (true) {
			swaps.clear();
			final int holeIndex = puzzlePieces.indexOf(null);
			swaps.add(Swap.INVERT);
			if (canSwapHoleWithLeft(holeIndex)) {
				swaps.add(Swap.LEFT);
			}
			if (canSwapHoleWithRight(holeIndex)) {
				swaps.add(Swap.RIGHT);
			}
			if (canSwapHoleWithUp(holeIndex)) {
				swaps.add(Swap.UP);
			}
			if (canSwapHoleWithDown(holeIndex)) {
				swaps.add(Swap.DOWN);
			}
			applySwap(swaps[rng.nextInt(swaps.length)], holeIndex, puzzlePieces);
			counter++;
			if (counter >= numSwaps && (keepGoing == null || !keepGoing())) {
				break;
			}
		}
	}

	void applySwap(Swap swap, int holeIndex, List<int?> tiles) {
		switch (swap) {
			case Swap.LEFT:
				swapHoleWithLeft(holeIndex, tiles);
				break;
			case Swap.UP:
				swapHoleWithUp(holeIndex, tiles);
				break;
			case Swap.DOWN:
				swapHoleWithDown(holeIndex, tiles);
				break;
			case Swap.RIGHT:
				swapHoleWithRight(holeIndex, tiles);
				break;
			case Swap.INVERT:
				invertPieces();
				break;
		}
	}

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

	void invertPieces() {
		statDisplayStateGroup.notifyAll();
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

	void trySwapHoleWithLeft() {
		final int holeIndex = keyTranslationLayer!.keys.indexOf(null);
		if (canSwapHoleWithLeft(holeIndex)) {
			trySwapHoleWith(keyTranslationLayer!.keys[holeIndex - 1]);
		}
	}

	void trySwapHoleWithRight() {
		final int holeIndex = keyTranslationLayer!.keys.indexOf(null);
		if (canSwapHoleWithRight(holeIndex)) {
			trySwapHoleWith(keyTranslationLayer!.keys[holeIndex + 1]);
		}
	}

	void trySwapHoleWithUp() {
		final int holeIndex = keyTranslationLayer!.keys.indexOf(null);
		if (canSwapHoleWithUp(holeIndex)) {
			trySwapHoleWith(keyTranslationLayer!.keys[holeIndex - PUZZLE_WIDTH]);
		}
	}

	void trySwapHoleWithDown() {
		final int holeIndex = keyTranslationLayer!.keys.indexOf(null);
		if (canSwapHoleWithDown(holeIndex)) {
			trySwapHoleWith(keyTranslationLayer!.keys[holeIndex + PUZZLE_WIDTH]);
		}
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
