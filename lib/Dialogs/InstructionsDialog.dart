
import 'package:flutter/foundation.dart';
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
				text: "Flutter 8 is a cross between a slide puzzle and a magic square puzzle. Your goal is to arrange the tiles in such a way that it forms a magic square. A magic square is a square where each row/column/diagonal of 3 tiles sum up to the same number. Note that every single possible answer has the empty space in the top middle like this:\n\n"),
		);
		spans.add(const WidgetSpan(
			child: Center(
				child: SizedBox(height: 200, width: 200, child: Image(image: AssetImage("assets/SolvedBoard.png")))
			),
		));
		spans.add(
			const TextSpan(
				text: "\n\nThis may sound difficult to solve but it is fairly easy once you know how. First you must calculate the 'magic sum' (the numbers the columns/rows/diagonal of 3 tiles sums up to). You could do this by brute forcing every single value. We know the magic sum must be greater than the highest tile value and lower than the highest and second highest tile values added together. Although a much easier way of doing this is adding up all the numbers and dividing by 3.\n\n"
						"Next, as we know the empty space will always be in the top center we know that there must be at least 2 ways to sum up to the magic sum with only 2 pieces. We then just need to brute force which pieces go in these spots.\n\n"),
		);
		spans.add(const WidgetSpan(
			child: Center(
				child: SizedBox(height: 200, width: 200, child: Image(image: AssetImage("assets/SolvedBoardHighlighted.png")))
			),
		));
		spans.add(
			const TextSpan(
				text: "\n\nAlso note you may have to flip your solution in the Y axis in order to actually solve the slide puzzle.\n\n"),
		);
		spans.add(const WidgetSpan(
			child: Center(
				child: SizedBox(height: 200, width: 200, child: Image(image: AssetImage("assets/BackwardsBoard.png")))
			),
		));
		spans.add(
			const TextSpan(
				text: "\n\nAnd if you don't know how to solve a slide puzzle "),
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
