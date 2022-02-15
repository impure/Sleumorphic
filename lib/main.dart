
import 'dart:typed_data';

import 'package:binary_codec/binary_codec.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sleumorphic/Data/Data.dart';
import 'package:sleumorphic/HomePage.dart';
import 'package:sleumorphic/Logic/Puzzle.dart';
import 'package:tools/BasicExtensions.dart';
import 'package:tools/SaveLoadManager.dart';
import 'package:tools/Startup.dart';
import 'package:tools/TestUtils.dart';
import 'package:tuple/tuple.dart';

void main() {
	onAppStart(() => const MyApp(), () {});
}

class MyApp extends StatelessWidget {
	const MyApp({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			theme: ThemeData(
				primarySwatch: MaterialColor(0xff303030, <int, Color>{
					50 : const Color(0xff303030).withOpacity(0.1),
					100 : const Color(0xff303030).withOpacity(0.2),
					200 : const Color(0xff303030).withOpacity(0.3),
					300 : const Color(0xff303030).withOpacity(0.4),
					400 : const Color(0xff303030).withOpacity(0.5),
					500 : const Color(0xff303030).withOpacity(0.6),
					600 : const Color(0xff303030).withOpacity(0.7),
					700 : const Color(0xff303030).withOpacity(0.8),
					800 : const Color(0xff303030).withOpacity(0.9),
					900 : const Color(0xff303030),
				}),
				scaffoldBackgroundColor: const Color(0xffCCCCCC),
				canvasColor: const Color.fromRGBO(200, 200, 200, 1),
			),
			darkTheme: ThemeData(
				brightness: Brightness.dark,
				primarySwatch: MaterialColor(0xffc8c8c8, <int, Color>{
					50 : const Color(0xffc8c8c8).withOpacity(0.1),
					100 : const Color(0xffc8c8c8).withOpacity(0.2),
					200 : const Color(0xffc8c8c8).withOpacity(0.3),
					300 : const Color(0xffc8c8c8).withOpacity(0.4),
					400 : const Color(0xffc8c8c8).withOpacity(0.5),
					500 : const Color(0xffc8c8c8).withOpacity(0.6),
					600 : const Color(0xffc8c8c8).withOpacity(0.7),
					700 : const Color(0xffc8c8c8).withOpacity(0.8),
					800 : const Color(0xffc8c8c8).withOpacity(0.9),
					900 : const Color(0xffc8c8c8),
				}),
			),
			home: const LoadingPage(),
		);
	}
}

class LoadingPage extends StatefulWidget {
	const LoadingPage({Key? key}) : super(key: key);

	@override
	LoadingPageState createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {

	dynamic _error;

	@override
	void initState() {
		_initGame();
		super.initState();
	}

	Future<void> _initGame() async {
		try {
			await mainInit(
				appCheckWebToken: null,
				purchaseUpdateFunction: (_) {},
			);

			puzzle = Puzzle();

			WidgetsBinding.instance!.addPostFrameCallback((_) {
				Navigator.pushReplacement(
					context,
					MaterialPageRoute<dynamic>(
						builder: (_) {
							return const HomePage();
						}
					),
				);
			});
			WidgetsBinding.instance!.scheduleFrame();

		} catch (e, stacktrace) {
			crashlyticsRecordError(e, stacktrace);
			_error = e;
			WidgetsBinding.instance!.addPostFrameCallback((_) {
				if (mounted) {
					setState(() {});
				}
			});
			WidgetsBinding.instance!.scheduleFrame();
		}
	}

	@override
	Widget build(BuildContext context) {

		final bool darkModeEnabled = Theme.of(context).darkModeEnabled;

		SystemChrome.setSystemUIOverlayStyle(darkModeEnabled ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);

		return Scaffold(
			body: AnnotatedRegion<SystemUiOverlayStyle>(
				value: SystemUiOverlayStyle.light,
				child: _error != null
						? Center(
					child: Text("The following error occurred:\n$_error", textAlign: TextAlign.center),
				)
						: Container()
			),
		);
	}
}

Future<Map<dynamic, dynamic>?> loadSave() async {
	if (kIsWeb) {
		final String? data = prefs!.getString("Save");
		if (data == null) {
			return null;
		}
		final List<String> splitStrings = data.split(",");
		final List<int> bytes = <int>[];
		for (int i = 0; i < splitStrings.length; i++) {
			bytes.add(int.parse(splitStrings[i]));
		}
		return binaryCodec.decode(Uint8List.fromList(bytes));
	} else {
		final Tuple2<int, Map<dynamic, dynamic>>? data = await readMostRecentValidSaveFile(
			unauthenticatedSaveName: "Puzzle2",
			authenticatedSaveName: "Puzzle1",
			backupSaveName: "Puzzle3",
			saveTimeKey: null,
		);
		return data?.item2;
	}
}
