
import 'package:sleumorphic/Logic/Puzzle.dart';
import 'package:sleumorphic/Widgets/Counter.dart';
import 'package:state_groups/state_groups.dart';

late Puzzle puzzle;
const double PADDING_SIZE = 10;

enum Swap {
	LEFT, UP, DOWN, RIGHT,
}

void notifyGame() {
	boardStateGroup.notifyAll();
	statDisplayStateGroup.notifyAll();
	bottomButtonStateGroup.notifyAll();
	counterGroup.notifyAll(null);
}

StateGroup<void> boardStateGroup = StateGroup<void>();
StateGroup<void> statDisplayStateGroup = StateGroup<void>();
StateGroup<void> bottomButtonStateGroup = StateGroup<void>();
