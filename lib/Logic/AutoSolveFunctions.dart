
import 'package:sleumorphic/Data/Data.dart';
import 'package:sleumorphic/Logic/PuzzleFunctions.dart';

List<Swap> autoSolve(List<int?> currentPuzzle, List<int?> solution) {
	final List<int?> simulatedPuzzle = List<int?>.from(currentPuzzle);
	final List<Swap> allSwaps = <Swap>[];
	List<Swap> currentSwaps;
	final Set<int> blockedTiles = <int>{};

	void movePieceWrapper(int indexInSolution, int desiredIndex) {
		final List<Swap> currentSwaps = moveSinglePiece(simulatedPuzzle.indexOf(null), simulatedPuzzle.indexOf(solution[indexInSolution]), desiredIndex, blockedTiles);
		applySwaps(currentSwaps, simulatedPuzzle);
		allSwaps.addAll(currentSwaps);
		blockedTiles.add(desiredIndex);
	}

	movePieceWrapper(0, 0);
	movePieceWrapper(1, 1);

	final List<Swap> swapsForTwoFirst = moveSinglePiece(simulatedPuzzle.indexOf(null), simulatedPuzzle.indexOf(solution[2]), 3, blockedTiles);
	final List<Swap> swapsForThreeFirst = moveSinglePiece(simulatedPuzzle.indexOf(null), simulatedPuzzle.indexOf(solution[3]), 2, blockedTiles);
	if (swapsForTwoFirst.length < swapsForThreeFirst.length) {
		movePieceWrapper(2, 3);
		movePieceWrapper(3, 11);
		final List<Swap> holeSwaps = moveHole(simulatedPuzzle.indexOf(null), 7, blockedTiles);
		applySwaps(holeSwaps, simulatedPuzzle);
		allSwaps.addAll(holeSwaps);
		currentSwaps = <Swap>[
			Swap.DOWN, Swap.LEFT, Swap.UP, Swap.UP, Swap.RIGHT, Swap.DOWN,
		];
		applySwaps(currentSwaps, simulatedPuzzle);
		allSwaps.addAll(currentSwaps);
		blockedTiles.add(2);
		blockedTiles.remove(11);
	} else {
		movePieceWrapper(3, 2);
		movePieceWrapper(2, 10);
		final List<Swap> holeSwaps = moveHole(simulatedPuzzle.indexOf(null), 6, blockedTiles);
		applySwaps(holeSwaps, simulatedPuzzle);
		allSwaps.addAll(holeSwaps);
		currentSwaps = <Swap>[
			Swap.DOWN, Swap.RIGHT, Swap.UP, Swap.UP, Swap.LEFT, Swap.DOWN,
		];
		applySwaps(currentSwaps, simulatedPuzzle);
		allSwaps.addAll(currentSwaps);
		blockedTiles.add(3);
		blockedTiles.remove(10);
	}

	movePieceWrapper(4, 4);
	movePieceWrapper(5, 5);

	final List<Swap> swapsForSixFirst = moveSinglePiece(simulatedPuzzle.indexOf(null), simulatedPuzzle.indexOf(solution[6]), 7, blockedTiles);
	final List<Swap> swapsForSevenFirst = moveSinglePiece(simulatedPuzzle.indexOf(null), simulatedPuzzle.indexOf(solution[7]), 6, blockedTiles);
	if (swapsForSixFirst.length < swapsForSevenFirst.length) {
		movePieceWrapper(6, 7);
		movePieceWrapper(7, 16);
		final List<Swap> holeSwaps = moveHole(simulatedPuzzle.indexOf(null), 11, blockedTiles);
		applySwaps(holeSwaps, simulatedPuzzle);
		allSwaps.addAll(holeSwaps);
		currentSwaps = <Swap>[
			Swap.DOWN, Swap.LEFT, Swap.UP, Swap.UP, Swap.RIGHT, Swap.DOWN,
		];
		applySwaps(currentSwaps, simulatedPuzzle);
		allSwaps.addAll(currentSwaps);
		blockedTiles.add(6);
		blockedTiles.remove(15);
	} else {
		movePieceWrapper(7, 6);
		movePieceWrapper(6, 14);
		final List<Swap> holeSwaps = moveHole(simulatedPuzzle.indexOf(null), 10, blockedTiles);
		applySwaps(holeSwaps, simulatedPuzzle);
		allSwaps.addAll(holeSwaps);
		currentSwaps = <Swap>[
			Swap.DOWN, Swap.RIGHT, Swap.UP, Swap.UP, Swap.LEFT, Swap.DOWN,
		];
		applySwaps(currentSwaps, simulatedPuzzle);
		allSwaps.addAll(currentSwaps);
		blockedTiles.add(7);
		blockedTiles.remove(14);
	}

	final List<Swap> swapsForEightFirst = moveSinglePiece(simulatedPuzzle.indexOf(null), simulatedPuzzle.indexOf(solution[8]), 12, blockedTiles);
	final List<Swap> swapsForTwelveFirst = moveSinglePiece(simulatedPuzzle.indexOf(null), simulatedPuzzle.indexOf(solution[12]), 8, blockedTiles);
	if (swapsForEightFirst.length < swapsForTwelveFirst.length) {
		movePieceWrapper(8, 12);
		movePieceWrapper(12, 14);
		final List<Swap> holeSwaps = moveHole(simulatedPuzzle.indexOf(null), 13, blockedTiles);
		applySwaps(holeSwaps, simulatedPuzzle);
		allSwaps.addAll(holeSwaps);
		currentSwaps = <Swap>[
			Swap.RIGHT, Swap.UP, Swap.LEFT, Swap.LEFT, Swap.DOWN, Swap.RIGHT,
		];
		applySwaps(currentSwaps, simulatedPuzzle);
		allSwaps.addAll(currentSwaps);
		blockedTiles.add(8);
		blockedTiles.remove(14);
	} else {
		movePieceWrapper(12, 8);
		movePieceWrapper(8, 10);
		final List<Swap> holeSwaps = moveHole(simulatedPuzzle.indexOf(null), 9, blockedTiles);
		applySwaps(holeSwaps, simulatedPuzzle);
		allSwaps.addAll(holeSwaps);
		currentSwaps = <Swap>[
			Swap.RIGHT, Swap.DOWN, Swap.LEFT, Swap.LEFT, Swap.UP, Swap.RIGHT,
		];
		applySwaps(currentSwaps, simulatedPuzzle);
		allSwaps.addAll(currentSwaps);
		blockedTiles.add(12);
		blockedTiles.remove(10);
	}


	final List<Swap> swapsForNineFirst = moveSinglePiece(simulatedPuzzle.indexOf(null), simulatedPuzzle.indexOf(solution[9]), 13, blockedTiles);
	final List<Swap> swapsForThirteenFirst = moveSinglePiece(simulatedPuzzle.indexOf(null), simulatedPuzzle.indexOf(solution[13]), 9, blockedTiles);
	if (swapsForNineFirst.length < swapsForThirteenFirst.length) {
		movePieceWrapper(9, 13);
		movePieceWrapper(13, 15);
		final List<Swap> holeSwaps = moveHole(simulatedPuzzle.indexOf(null), 14, blockedTiles);
		applySwaps(holeSwaps, simulatedPuzzle);
		allSwaps.addAll(holeSwaps);
		currentSwaps = <Swap>[
			Swap.RIGHT, Swap.UP, Swap.LEFT, Swap.LEFT, Swap.DOWN, Swap.RIGHT,
		];
		applySwaps(currentSwaps, simulatedPuzzle);
		allSwaps.addAll(currentSwaps);
		blockedTiles.add(9);
		blockedTiles.remove(15);
	} else {
		movePieceWrapper(13, 9);
		movePieceWrapper(9, 11);
		final List<Swap> holeSwaps = moveHole(simulatedPuzzle.indexOf(null), 10, blockedTiles);
		applySwaps(holeSwaps, simulatedPuzzle);
		allSwaps.addAll(holeSwaps);
		currentSwaps = <Swap>[
			Swap.RIGHT, Swap.DOWN, Swap.LEFT, Swap.LEFT, Swap.UP, Swap.RIGHT,
		];
		applySwaps(currentSwaps, simulatedPuzzle);
		allSwaps.addAll(currentSwaps);
		blockedTiles.add(13);
		blockedTiles.remove(11);
	}


	return allSwaps;
}

void applySwaps(List<Swap> swaps, List<int?> gameBoard) {
	for (int i = 0; i < swaps.length; i++) {
		applySwap(swaps[i], gameBoard.indexOf(null), gameBoard);
	}
}

List<Swap> moveSinglePiece(int holeIndex, int currentIndex, int endIndex, Set<int> blockedIndices) {
	final List<Swap> swapList = <Swap>[];

	// Do path finding to find how to get start index to end index
	final List<double?> distancesFromSolution = pathFinding(endIndex, blockedIndices);

	double currentDistance = distancesFromSolution[currentIndex]!;

	if (currentDistance.isInfinite) {
		throw Exception("Cannot move piece at position $currentIndex to $endIndex given blocked Indices $blockedIndices");
	}

	while (currentIndex != endIndex) {

		currentDistance = distancesFromSolution[currentIndex]!;

		if (currentIndex - 1 >= 0 && sameRow(currentIndex - 1, currentIndex) && (distancesFromSolution[currentIndex - 1] ?? double.infinity) < currentDistance) {
			swapList.addAll(moveHole(holeIndex, currentIndex - 1, Set<int>.from(blockedIndices)..add(currentIndex)));
			swapList.add(Swap.RIGHT);
			holeIndex = currentIndex;
			currentIndex -= 1;
		} else if (currentIndex + 1 < 16 && sameRow(currentIndex + 1, currentIndex) && (distancesFromSolution[currentIndex + 1] ?? double.infinity) < currentDistance) {
			swapList.addAll(moveHole(holeIndex, currentIndex + 1, Set<int>.from(blockedIndices)..add(currentIndex)));
			swapList.add(Swap.LEFT);
			holeIndex = currentIndex;
			currentIndex += 1;
		} else if (currentIndex + 4 < 16 && sameColumn(currentIndex + 4, currentIndex) && (distancesFromSolution[currentIndex + 4] ?? double.infinity) < currentDistance) {
			swapList.addAll(moveHole(holeIndex, currentIndex + 4, Set<int>.from(blockedIndices)..add(currentIndex)));
			swapList.add(Swap.UP);
			holeIndex = currentIndex;
			currentIndex += 4;
		} else if (currentIndex - 4 >= 0 && sameColumn(currentIndex - 4, currentIndex) && (distancesFromSolution[currentIndex - 4] ?? double.infinity) < currentDistance) {
			swapList.addAll(moveHole(holeIndex, currentIndex - 4, Set<int>.from(blockedIndices)..add(currentIndex)));
			swapList.add(Swap.DOWN);
			holeIndex = currentIndex;
			currentIndex -= 4;
		} else {
			throw Exception("Unable to move piece. Cannot move hole at position $currentIndex to $endIndex given blocked Indices $blockedIndices");
		}
	}

	return swapList;
}

List<Swap> moveHole(int holeIndex, int endIndex, Set<int> blockedIndices) {
	final List<double?> distancesFromSolution = pathFinding(endIndex, blockedIndices);
	final List<Swap> moves = <Swap>[];

	double? currentDistance = distancesFromSolution[holeIndex];

	if (currentDistance == null || currentDistance.isInfinite) {
		throw Exception("Cannot move hole at position $holeIndex to $endIndex given blocked Indices $blockedIndices");
	}

	while (holeIndex != endIndex) {
		currentDistance = distancesFromSolution[holeIndex];

		if (holeIndex - 1 >= 0 && sameRow(holeIndex - 1, holeIndex) && (distancesFromSolution[holeIndex - 1] ?? double.infinity) < currentDistance!) {
			moves.add(Swap.LEFT);
			holeIndex -= 1;
		} else if (holeIndex + 1 < 16 && sameRow(holeIndex + 1, holeIndex) && (distancesFromSolution[holeIndex + 1] ?? double.infinity) < currentDistance!) {
			moves.add(Swap.RIGHT);
			holeIndex += 1;
		} else if (holeIndex + 4 < 16 && sameColumn(holeIndex + 4, holeIndex) && (distancesFromSolution[holeIndex + 4] ?? double.infinity) < currentDistance!) {
			moves.add(Swap.DOWN);
			holeIndex += 4;
		} else if (holeIndex - 4 >= 0 && sameColumn(holeIndex - 4, holeIndex) && (distancesFromSolution[holeIndex - 4] ?? double.infinity) < currentDistance!) {
			moves.add(Swap.UP);
			holeIndex -= 4;
		} else {
			throw Exception("We are stuck. Cannot move hole at position $holeIndex to $endIndex given blocked Indices $blockedIndices");
		}
	}

	return moves;
}

List<double?> pathFinding(int endIndex, Set<int> blockedIndices) {
	final List<double?> distancesFromSolution = <double?>[];
	for (int i = 0; i < 16; i++) {
		if (blockedIndices.contains(i)) {
			distancesFromSolution.add(null);
		} else if (i == endIndex) {
			distancesFromSolution.add(0);
		} else {
			distancesFromSolution.add(double.infinity);
		}
	}
	// We make sure to use last iteration distance because some directions can have
	// their distances populated faster leading to an incorrect order of checks
	for (int lastIterationDistance = 0; lastIterationDistance < 16; lastIterationDistance++) {
		for (int tile = 0; tile < 16; tile++) {
			if (distancesFromSolution[tile] == null || distancesFromSolution[tile]!.isFinite) {
				continue;
			}
			if (tile - 1 >= 0 && sameRow(tile - 1, tile) && distancesFromSolution[tile - 1] == lastIterationDistance) {
				distancesFromSolution[tile] = distancesFromSolution[tile - 1]! + 1;
			} else if (tile + 1 < 16 && sameRow(tile + 1, tile) && distancesFromSolution[tile + 1] == lastIterationDistance) {
				distancesFromSolution[tile] = distancesFromSolution[tile + 1]! + 1;
			} else if (tile + 4 < 16 && sameColumn(tile + 4, tile) && distancesFromSolution[tile + 4] == lastIterationDistance) {
				distancesFromSolution[tile] = distancesFromSolution[tile + 4]! + 1;
			} else if (tile - 4 >= 0 && sameColumn(tile - 4, tile) && distancesFromSolution[tile - 4] == lastIterationDistance) {
				distancesFromSolution[tile] = distancesFromSolution[tile - 4]! + 1;
			}
		}
	}

	return distancesFromSolution;
}
