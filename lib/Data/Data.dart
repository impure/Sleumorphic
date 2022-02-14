
import 'package:sleumorphic/Logic/Puzzle.dart';
import 'package:state_groups/state_groups.dart';

late Puzzle puzzle;

enum Swap {
	LEFT, UP, DOWN, RIGHT, INVERT,
}

void notifyGame() {
	boardStateGroup.notifyAll();
	statDisplayStateGroup.notifyAll();
	bottomButtonStateGroup.notifyAll();
}

StateGroup<void> boardStateGroup = StateGroup<void>();
StateGroup<void> statDisplayStateGroup = StateGroup<void>();
StateGroup<void> bottomButtonStateGroup = StateGroup<void>();
