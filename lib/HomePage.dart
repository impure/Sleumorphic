
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sleumorphic/Data/Data.dart';
import 'package:sleumorphic/Dialogs/SettingsDialog.dart';
import 'package:sleumorphic/Logic/Puzzle.dart';
import 'package:sleumorphic/Widgets/BoardDisplay.dart';
import 'package:sleumorphic/Widgets/NeumorphicTile.dart';
import 'package:sleumorphic/Widgets/StatsDisplay.dart';
import 'package:tools/BasicExtensions.dart';

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

		final bool darkModeEnabled = Theme.of(context).darkModeEnabled;

		SystemChrome.setSystemUIOverlayStyle(darkModeEnabled ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);

		final Size size = MediaQuery.of(context).size;
		final double gridSize = min(min(800, size.width * 4 / 5), size.height * 3.5 / 6);

		if (size.height > size.width) {

		} else {

		}

		return Scaffold(
			body: SafeArea(
				child: Center(
					child: size.height > size.width * 0.8 ? gameBoardPortrait(darkModeEnabled, gridSize) : gameBoardLandscape(darkModeEnabled, gridSize),
				),
			),
		);
	}

	Widget topWidgets() {
		return Column(
			children: const <Widget>[
				Text(
					"#FlutterPuzzleHack",
					style: TextStyle(fontSize: 45),
				),
				SizedBox(height: 10),
				StatsDisplay(),
				SizedBox(height: 20),
			],
		);
	}

	Widget bottomWidgets() {
		return Row(
			children: <Widget>[
				IconButton(
					tooltip: "Settings",
					iconSize: 50,
					onPressed: () {
						showDialog(
							context: context,
							builder: (_) {
								return const SettingsDialog();
							}
						);
					},
					icon: const Icon(
						Icons.settings,
					),
				),
				const SizedBox(width: 20),
				IconButton(
					tooltip: "Invert",
					iconSize: 50,
					onPressed: () {
						puzzle.invertPieces();
						boardStateGroup.notifyAll();
						final int holeLocation = puzzle.puzzlePieces.indexOf(null);
						neumorphicTiles.notifyAll(Offset((holeLocation % PUZZLE_WIDTH).toDouble(), (holeLocation ~/ PUZZLE_WIDTH).toDouble()));
					},
					icon: const Icon(
						Icons.flip_camera_android, // Icons.flip_to_front
					),
				),
			],
		);
	}
	
	Widget gameBoardLandscape(bool darkModeEnabled, double gridSize) {
		return Row(
			children: <Widget>[
				const Flexible(
					fit: FlexFit.tight,
					flex: 1,
					child: SizedBox(),
				),
				SizedBox(
					width: gridSize,
					child: FittedBox(
						child: Column(
							children: <Widget>[
								topWidgets(),
								bottomWidgets(),
							],
						),
					),
				),
				const Flexible(
					fit: FlexFit.tight,
					flex: 1,
					child: SizedBox(),
				),
				Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						Center(
							child: BoardDisplay(gridSize),
						),
					],
				),
				const Flexible(
					fit: FlexFit.tight,
					flex: 1,
					child: SizedBox(),
				),
			],
		);
	}

	Widget gameBoardPortrait(bool darkModeEnabled, double gridSize) {
		return Column(
			children: <Widget>[
				const Flexible(
					fit: FlexFit.tight,
					flex: 1,
					child: SizedBox(),
				),
				Flexible(
					fit: FlexFit.tight,
					flex: 5,
					child: SizedBox(
						width: gridSize,
						child: Padding(
							padding: EdgeInsets.symmetric(horizontal: 20),
							child: FittedBox(
								child: topWidgets(),
							),
						),
					),
				),
				const Flexible(
					fit: FlexFit.tight,
					flex: 1,
					child: SizedBox(),
				),
				BoardDisplay(gridSize),
				const Flexible(
					fit: FlexFit.tight,
					flex: 1,
					child: SizedBox(),
				),
				Flexible(
					fit: FlexFit.tight,
					flex: 2,
					child: FittedBox(
						child: Padding(
							padding: const EdgeInsets.symmetric(horizontal: 50),
							child: SizedBox(
								height: gridSize * 0.15,
								child: FittedBox(
									child: bottomWidgets(),
								),
							),
						)
					),
				),
				const Flexible(
					fit: FlexFit.tight,
					flex: 1,
					child: SizedBox(),
				),
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
}
