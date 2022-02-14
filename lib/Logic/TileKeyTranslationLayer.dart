
import 'package:flutter/material.dart';
import 'package:sleumorphic/Logic/Puzzle.dart';
import 'package:sleumorphic/Logic/PuzzleFunctions.dart';

class TileKeyTranslationLayer {

	factory TileKeyTranslationLayer(List<int?> tiles) {
		final List<Key?> keys = <Key?>[];
		for (int i = 0; i < tiles.length; i++) {
			if (tiles[i] == null) {
				keys.add(null);
			} else {
				keys.add(Key(tiles[i].toString()));
			}
		}
		return TileKeyTranslationLayer._(keys);
	}

	TileKeyTranslationLayer._(this.keys);

	List<Key?> keys;

	void trySwapHoleWithIndex(int index) {
		if (index >= 0 && index < keys.length) {
			trySwapHoleWith(keys[index]!);
		}
	}

	void trySwapHoleWith(Key key) {

		final int numIndex = keys.indexOf(key);
		final int holeIndex = keys.indexOf(null);

		if (numIndex == holeIndex - 1 && canSwapHoleWithLeft(holeIndex)) {
			swapHoleWithLeft(holeIndex, keys);
		} else if (numIndex == holeIndex + 1 && canSwapHoleWithRight(holeIndex)) {
			swapHoleWithRight(holeIndex, keys);
		} else if (numIndex == holeIndex - PUZZLE_WIDTH && canSwapHoleWithUp(holeIndex)) {
			swapHoleWithUp(holeIndex, keys);
		} else if (numIndex == holeIndex + PUZZLE_WIDTH && canSwapHoleWithDown(holeIndex)) {
			swapHoleWithDown(holeIndex, keys);
		}
	}
}
