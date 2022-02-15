
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sleumorphic/Dialogs/InstructionsDialog.dart';
import 'package:sleumorphic/Dialogs/SettingsDialog.dart';
import 'package:sleumorphic/Widgets/BoardDisplay.dart';
import 'package:tools/BasicExtensions.dart';
import 'package:tools/Startup.dart';

class HomePage extends StatefulWidget {
	const HomePage({Key? key}) : super(key: key);

	@override
	State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

	@override
	Widget build(BuildContext context) {

		SystemChrome.setPreferredOrientations(<DeviceOrientation>[
			DeviceOrientation.portraitUp,
			DeviceOrientation.portraitDown,
		]);


		WidgetsBinding.instance!.addPostFrameCallback((_) {
			if (!prefs!.containsKey("DisplayHelp")) {
				displayHelp();
				prefs!.setBool("DisplayHelp", true);
			}
		});
		WidgetsBinding.instance!.scheduleFrame();

		final bool darkModeEnabled = Theme.of(context).darkModeEnabled;

		SystemChrome.setSystemUIOverlayStyle(darkModeEnabled ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);

		final Size size = MediaQuery.of(context).size;
		final double gridSize = min(min(800, size.width * 4 / 5), size.height * 2 / 3);

		return Scaffold(
			body: SafeArea(
				child: Center(
					child: SingleChildScrollView(
						scrollDirection: Axis.horizontal,
						child: SingleChildScrollView(
							child: gameBoard(darkModeEnabled, gridSize),
						),
					)
				),
			)
		);
	}

	Widget gameBoard(bool darkModeEnabled, double gridSize) {
		return Column(
			children: <Widget>[
				NeumorphicText(
					"#FlutterPuzzleHack",
					textStyle: NeumorphicTextStyle(
						fontSize: 50,
					),
					style: NeumorphicStyle(
						color: darkModeEnabled ? null : const Color.fromRGBO(50, 50, 50, 1),
						shape: NeumorphicShape.convex,
						lightSource: LightSource.topLeft,
						shadowDarkColor: darkModeEnabled ? Colors.black : Colors.black54,
						shadowLightColor: darkModeEnabled ? Colors.white70 : Colors.white,
					),
				),
				const SizedBox(height: 20),
				NeumorphicText(
					"Moves: ?? - Inversions: ??",
					textStyle: NeumorphicTextStyle(
						fontSize: 20,
					),
					style: NeumorphicStyle(
						color: darkModeEnabled ? null : const Color.fromRGBO(50, 50, 50, 1),
						shape: NeumorphicShape.convex,
						lightSource: LightSource.topLeft,
						shadowDarkColor: darkModeEnabled ? Colors.black : Colors.black54,
						shadowLightColor: darkModeEnabled ? Colors.white70 : Colors.white,
					),
				),
				const SizedBox(height: 20),
				BoardDisplay(gridSize),
				const SizedBox(height: 20),
				Row(
					children: <Widget>[
						GestureDetector(
							onTap: () {
								showDialog(
									context: context,
									builder: (_) {
										return const SettingsDialog();
									}
								);
							},
							child: NeumorphicIcon(
								Icons.settings,
								size: 60,
								style: NeumorphicStyle(
									color: darkModeEnabled ? null : const Color.fromRGBO(50, 50, 50, 1),
									shape: NeumorphicShape.convex,
									lightSource: LightSource.topLeft,
									shadowDarkColor: darkModeEnabled ? Colors.black : Colors.black54,
									shadowLightColor: darkModeEnabled ? Colors.white70 : Colors.white,
								),
							),
						),
						const SizedBox(width: 20),
						GestureDetector(
							onTap: displayHelp,
							child: NeumorphicIcon(
								Icons.info_outline,
								size: 60,
								style: NeumorphicStyle(
									color: darkModeEnabled ? null : const Color.fromRGBO(50, 50, 50, 1),
									shape: NeumorphicShape.convex,
									lightSource: LightSource.topLeft,
									shadowDarkColor: darkModeEnabled ? Colors.black : Colors.black54,
									shadowLightColor: darkModeEnabled ? Colors.white70 : Colors.white,
								),
							),
						),
					],
				)
			],
		);
		/*
		return Container(
			padding: EdgeInsets.only(left: gridSize * 0.1, top: gridSize * 0.05, bottom: gridSize * 0.05, right: gridSize * 0.05),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				mainAxisSize: MainAxisSize.min,
				children: <Widget>[
					Row(
						mainAxisSize: MainAxisSize.min,
						crossAxisAlignment: CrossAxisAlignment.end,
						children: <Widget>[
							Column(
								children: <Widget>[
									SizedBox(
										height: gridSize * 0.33,
										child: SingleChildScrollView(
											scrollDirection: Axis.horizontal,
											child: Row(
												mainAxisSize: MainAxisSize.min,
												mainAxisAlignment: MainAxisAlignment.center,
												children: <Widget>[
													AutoSizeText("F8", style: TextStyle(fontSize: gridSize * 0.12, fontWeight: FontWeight.bold, letterSpacing: 2)),
													SizedBox(width: gridSize / 25),
													VerticalDivider(
														thickness: gridSize / 50,
														width: gridSize / 10,
														indent: gridSize * 0.1,
														endIndent: gridSize * 0.087,
														color: Colors.white,
													),
													Padding(
														padding: EdgeInsets.only(top: gridSize / 50, left: gridSize / 50),
														child: IconButton(
															visualDensity: VisualDensity.compact,
															icon: const Icon(Icons.help_outline),
															iconSize: gridSize / 10,
															tooltip: "Instructions",
															onPressed: () {
																displayHelp();
															},
														),
													),
													Padding(
														padding: EdgeInsets.only(top: gridSize / 50, left: gridSize / 50),
														child: IconButton(
															visualDensity: VisualDensity.compact,
															icon: const Icon(Icons.restart_alt),
															iconSize: gridSize / 10,
															tooltip: "Restart",
															onPressed: () {
																displayHelp();
															},
														),
													),
													Padding(
														padding: EdgeInsets.only(top: gridSize / 50, left: gridSize / 50),
														child: IconButton(
															visualDensity: VisualDensity.compact,
															icon: const Icon(Icons.settings),
															iconSize: gridSize / 10,
															tooltip: "Settings",
															onPressed: () {
																showDialog(
																	context: context,
																	builder: (BuildContext context) {
																		return const SettingsDialog();
																	},
																);
															},
														),
													),
												],
											),
										),
									),
									BoardDisplay(gridSize),
								],
							),
						],
					),
				],
			),
		);*/
	}

	void displayHelp() {
		showDialog(
			context: context,
			builder: (BuildContext context) {
				return const InstructionsDialog();
			}
		);
	}
}
