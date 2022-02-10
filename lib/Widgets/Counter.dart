
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:state_groups/state_groups.dart';

StateGroup<void> counterGroup = StateGroup<void>();

class Counter extends StatefulWidget {
	const Counter(this.size, this.numberGenerator, this.image, {Key? key}) : super(key: key);

	final double size;
	final int Function() numberGenerator;
	final AssetImage image;

	@override
	CounterState createState() => CounterState();
}

class CounterState extends SyncState<void, Counter> {
  CounterState() : super(counterGroup);

  @override
  Widget build(BuildContext context) {
		return SizedBox(
			height: widget.size,
			width: widget.size,
			child: Center(
				child: Container(
					height: widget.size * 0.5,
					width: widget.size * 0.5,
					decoration: BoxDecoration(
						image: DecorationImage(
							colorFilter: ColorFilter.mode(Colors.brown.withOpacity(0.1), BlendMode.difference),
							fit: BoxFit.cover, // I don't know what this does but we need it
							image: widget.image,
						),
						color: Colors.white10,
						boxShadow: const <BoxShadow>[
							BoxShadow(color: Colors.black54, blurStyle: BlurStyle.outer, blurRadius: 10)
						]
					),
					child: FractionallySizedBox(
						heightFactor: 0.5,
						widthFactor: 0.5,
						child: Padding(
							// Don't know why but if I don't add padding here on web it doesn't look right
							padding: kIsWeb ? EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.006) : EdgeInsets.zero,
							child: AutoSizeText(widget.numberGenerator().toString(), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
						),
					),
				),
			),
		);
  }

}
