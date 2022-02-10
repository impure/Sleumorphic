
import 'package:flutter/material.dart';
import 'package:sleumorphic/Data/Data.dart';
import 'package:sleumorphic/Logic/Puzzle.dart';
import 'package:state_groups/state_groups.dart';

class BottomButton extends StatefulWidget {
  const BottomButton(this.width, {Key? key}) : super(key: key);

  final double width;

	@override
	BottomButtonState createState() => BottomButtonState();
}

class BottomButtonState extends SyncState<void, BottomButton> {

	BottomButtonState() : super(bottomButtonStateGroup);

	@override
	Widget build(BuildContext context) {

		void onTap() {
			puzzle = Puzzle();
			statDisplayStateGroup.notifyAll();
		}

		return Semantics(
			label: "Shuffle",
			child: MaterialButton(
				onPressed: onTap,
				shape: RoundedRectangleBorder(
					side: BorderSide(
						color: Theme.of(context).textTheme.button?.color ?? Colors.black,
					),
					borderRadius: BorderRadius.circular(widget.width),
				),
				child: Padding(
					padding: const EdgeInsets.only(top: 10, bottom: 10),
					child: Row(
						mainAxisSize: MainAxisSize.min,
						mainAxisAlignment: MainAxisAlignment.center,
						children: const <Widget>[
							SizedBox(width: 20),
							Icon(Icons.grading, size: 30),
							SizedBox(width: 5),
							Text("Shuffle", style: TextStyle(fontSize: 25)),
							SizedBox(width: 20),
						],
					),
				),
			),
		);
	}
}
