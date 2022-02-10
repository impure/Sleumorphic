
import 'package:flutter/material.dart';
import 'package:sleumorphic/Data/Data.dart';
import 'package:sleumorphic/Logic/Puzzle.dart';

class StatsDialog extends StatefulWidget {
	const StatsDialog({Key? key}) : super(key: key);

	@override
	StatsDialogState createState() => StatsDialogState();
}

class StatsDialogState extends State<StatsDialog> {

	@override
	Widget build(BuildContext context) {
		return AlertDialog(
			title: Center(
				child: Text(puzzle.solved ? "Congratulations!" : "Statistics"),
			),
			actions: <Widget>[
				TextButton(
					child: Text("SHUFFLE", style: Theme.of(context).textTheme.bodyText1),
					onPressed: () {
						puzzle = Puzzle();
						statDisplayStateGroup.notifyAll();
						boardStateGroup.notifyAll();
						bottomButtonStateGroup.notifyAll();
						Navigator.pop(context);
					},
				),
				TextButton(
					child: Text("DISMISS", style: Theme.of(context).textTheme.bodyText1),
					onPressed: () => Navigator.pop(context),
				),
			],
		);
	}
}

String todaysDate(DateTime now) {
	const List<String> months = <String>["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
	return "${months[now.month - 1]} ${now.day}, ${now.year}";
}
