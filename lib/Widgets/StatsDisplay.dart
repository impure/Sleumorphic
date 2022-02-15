
import 'package:flutter/material.dart';
import 'package:sleumorphic/Data/Data.dart';
import 'package:state_groups/state_groups.dart';

class StatsDisplay extends StatefulWidget {
  const StatsDisplay({Key? key}) : super(key: key);

	@override
	StatsDisplayState createState() => StatsDisplayState();
}

class StatsDisplayState extends SyncState<void, StatsDisplay> {

	StatsDisplayState() : super(statDisplayStateGroup);

	@override
	Widget build(BuildContext context) {
		return Text.rich(TextSpan(
			style: const TextStyle(
				fontSize: 20,
				shadows: <Shadow>[
					Shadow(
						offset: Offset(5, 5),
						color: Colors.black,
						blurRadius: 5,
					)
				],
			),
			children: <InlineSpan>[
				TextSpan(text: puzzle.numMoves.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
				const TextSpan(text: " Moves | "),
				TextSpan(text: puzzle.numInverts.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
				const TextSpan(text: " Inverts"),
			]
		));
	}
}
