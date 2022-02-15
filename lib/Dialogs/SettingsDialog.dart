
import 'package:flutter/material.dart';
import 'package:sleumorphic/Data/Data.dart';
import 'package:sleumorphic/Logic/Puzzle.dart';
import 'package:tools/Startup.dart';
import 'package:tuple/tuple.dart';

bool get invertControls => prefs?.getBool("InvertControls") ?? false;

class SettingsDialog extends StatefulWidget {
	const SettingsDialog({Key? key}) : super(key: key);

	@override
	SettingsDialogState createState() => SettingsDialogState();
}

class SettingsDialogState extends State<SettingsDialog> {

	@override
	Widget build(BuildContext context) {
		return AlertDialog(
			title: const Center(
				child: Text("Settings"),
			),
			content: Column(
				mainAxisSize: MainAxisSize.min,
				children: <Widget>[
					const Text("Move tiles: arrow keys\nFlip board: control key"),
					const SizedBox(height: 20),
					SwitchListTile(
						title: const Text("Invert Keyboard Controls"),
						value: invertControls,
						onChanged: (bool? value) {
							if (value != null) {
								setState(() {
									prefs!.setBool("InvertControls", value);
								});
							}
						},
					),
					ListTile(
						title: const Text("Board Size"),
						subtitle: const Text("Restarts Game"),
						trailing: DropdownButton<Tuple2<int, int>>(
							value: Tuple2<int, int>(PUZZLE_WIDTH, PUZZLE_HEIGHT),
							items: const <DropdownMenuItem<Tuple2<int, int>>>[
								DropdownMenuItem<Tuple2<int, int>>(
									value: Tuple2<int, int>(2, 2),
									child: Text("2x2"),
								),
								DropdownMenuItem<Tuple2<int, int>>(
									value: Tuple2<int, int>(2, 3),
									child: Text("2x3"),
								),
								DropdownMenuItem<Tuple2<int, int>>(
									value: Tuple2<int, int>(3, 3),
									child: Text("3x3"),
								),
								DropdownMenuItem<Tuple2<int, int>>(
									value: Tuple2<int, int>(3, 4),
									child: Text("3x4"),
								),
								DropdownMenuItem<Tuple2<int, int>>(
									value: Tuple2<int, int>(4, 4),
									child: Text("4x4"),
								),
							],
							onChanged: (Tuple2<int, int>? value) {
								PUZZLE_WIDTH = value!.item1;
								PUZZLE_HEIGHT = value.item2;
								puzzle = Puzzle();
								statDisplayStateGroup.notifyAll();
								boardStateGroup.notifyAll();
								bottomButtonStateGroup.notifyAll();
								setState(() {});
							},
						),
					),
					ListTile(
						title: const Text("Device ID"),
						subtitle: SelectableText(deviceID ?? "Null"),
					),
				],
			),
			actions: <Widget>[
				TextButton(
					child: Text("DISMISS", style: Theme.of(context).textTheme.bodyText1),
					onPressed: () => Navigator.pop(context),
				),
			],
		);
	}
}
