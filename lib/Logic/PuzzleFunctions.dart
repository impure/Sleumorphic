
import 'dart:math';

import 'package:sleumorphic/Data/Data.dart';
import 'package:sleumorphic/Logic/Puzzle.dart';
import 'package:tools/RandomBag.dart';
import 'package:tuple/tuple.dart';

bool canSwapHoleWithLeft(int holeIndex) => holeIndex % PUZZLE_WIDTH != 0;
bool canSwapHoleWithRight(int holeIndex) => holeIndex % PUZZLE_WIDTH != (PUZZLE_WIDTH - 1);
bool canSwapHoleWithUp(int holeIndex) => holeIndex >= PUZZLE_WIDTH;
bool canSwapHoleWithDown(int holeIndex) => holeIndex <= (PUZZLE_HEIGHT - 1) * PUZZLE_WIDTH - 1;

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
	}
}

void swapHoleWithLeft(int holeIndex, List<dynamic> puzzle) => swap(holeIndex, holeIndex - 1, puzzle);
void swapHoleWithRight(int holeIndex, List<dynamic> puzzle) => swap(holeIndex, holeIndex + 1, puzzle);
void swapHoleWithUp(int holeIndex, List<dynamic> puzzle) => swap(holeIndex, holeIndex - PUZZLE_WIDTH, puzzle);
void swapHoleWithDown(int holeIndex, List<dynamic> puzzle) => swap(holeIndex, holeIndex + PUZZLE_WIDTH, puzzle);

bool sameRow(int currentIndex, int correctIndex) {
	return currentIndex ~/ PUZZLE_WIDTH == correctIndex ~/ PUZZLE_WIDTH;
}

bool sameColumn(int currentIndex, int correctIndex) {
	return currentIndex % PUZZLE_WIDTH == correctIndex % PUZZLE_WIDTH;
}

/*
Tuple4<int, int, int, int> getTopRequirements(List<int?> futurePuzzle) {
	return Tuple4<int, int, int, int>(
		futurePuzzle[0] ?? futurePuzzle[4]!,
		futurePuzzle[1] ?? futurePuzzle[5]!,
		futurePuzzle[2] ?? futurePuzzle[6]!,
		futurePuzzle[3] ?? futurePuzzle[7]!,
	);
}

Tuple4<int, int, int, int> getBottomRequirements(List<int?> futurePuzzle) {
	return Tuple4<int, int, int, int>(
		futurePuzzle[12] ?? futurePuzzle[8]!,
		futurePuzzle[13] ?? futurePuzzle[9]!,
		futurePuzzle[14] ?? futurePuzzle[10]!,
		futurePuzzle[15] ?? futurePuzzle[11]!,
	);
}
*/

void swap(int piece1, int piece2, List<dynamic> puzzle) {
	final int? temp = puzzle[piece1];
	puzzle[piece1] = puzzle[piece2];
	puzzle[piece2] = temp;
}

RandomBag<int> getRandomBagOfUnusedNumbers(List<int?> usedNumbers) {
	final Set<int?> numbers = usedNumbers.toSet();
	final RandomBag<int> returnBag = RandomBag<int>();
	for (int i = 1; i <= 99; i++) {
		if (!numbers.contains(i)) {
			returnBag.add(i);
		}
	}
	return returnBag;
}

extension Contains on Tuple4<int, int, int, int> {
	bool contains(int item) {
		return item1 == item || item2 == item || item3 == item || item4 == item;
	}

	bool containsAny(Tuple4<int, int, int, int> item) {
		return contains(item.item1) || contains(item.item2) || contains(item.item3) || contains(item.item4);
	}
}
