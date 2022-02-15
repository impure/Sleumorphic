
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InstructionsDialog extends StatefulWidget {
	const InstructionsDialog({Key? key}) : super(key: key);

	@override
	InstructionsDialogState createState() => InstructionsDialogState();
}

class InstructionsDialogState extends State<InstructionsDialog> {

	late ScrollController _controller;

	@override
	void initState() {
		_controller = ScrollController();
    super.initState();
  }

  @override
	void dispose() {
		_controller.dispose();
		super.dispose();
	}

	List<InlineSpan> makeText() {

		final List<InlineSpan> spans = <InlineSpan>[];

		spans.add(
			const TextSpan(
				text: "Sleumorphic is an experiment in applying a neumorphic UI to a slide puzzle so it plays around with depth a lot. One of the ways this is done is by having two slide puzzles. You can switch between them by clicking the empty square.\n\n"),
		);
		spans.add(
			const TextSpan(
				text: "And if you don't know how to solve a slide puzzle "),
		);
		spans.add(
			TextSpan(
				text: "here's",
				style: const TextStyle(
					decoration: TextDecoration.underline,
					decorationThickness: 2,
				),
				recognizer: TapGestureRecognizer()..onTap = () => launch("https://andrewzuo.com/how-to-solve-a-slide-puzzle-3fe533f76232?sk=dcd1f5500484386196d1133b9fc5461a"),
			),
		);
		spans.add(
			const TextSpan(text: " a post I made on how to do it. Good luck."),
		);

		return spans;
	}

	@override
	Widget build(BuildContext context) {
		final bool restrictWidth = MediaQuery.of(context).size.width > 500;
		return AlertDialog(
			title: const Center(
				child: Text("How To Play"),
			),
			content: !restrictWidth ? SingleChildScrollView(
				controller: _controller,
				child: RichText(
					text: TextSpan(
						style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
						children: makeText(),
					),
				),
			) : SizedBox(
				width: 500,
				child: SingleChildScrollView(
					controller: _controller,
					child: RichText(
						text: TextSpan(
							style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
							children: makeText(),
						),
					),
				),
			),
			actions: <Widget>[
				TextButton(
					child: Text("DISMISS", style: Theme.of(context).textTheme.bodyText1),
					onPressed: () {
						if (_controller.offset < _controller.position.maxScrollExtent * 0.9) {
							_controller.animateTo(
								_controller.position.maxScrollExtent,
								duration: const Duration(milliseconds: 200),
								curve: Curves.easeOut,
							);
						} else {
							Navigator.pop(context);
						}
					},
				),
			],
		);
	}
}
