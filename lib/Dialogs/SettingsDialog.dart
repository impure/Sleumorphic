
import 'package:flutter/material.dart';
import 'package:tools/Startup.dart';

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
