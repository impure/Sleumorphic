
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sleumorphic/Data/Data.dart';
import 'package:sleumorphic/Logic/Puzzle.dart';
import 'package:sleumorphic/Widgets/NeumorphicTile.dart';
import 'package:state_groups/state_groups.dart';

StateGroup<Map<int, DIRECTION_HINT>> tilesStateGroup = StateGroup<Map<int, DIRECTION_HINT>>();

class Tile extends StatefulWidget {
	const Tile(this.num, this.width, this.height, this.offset, this.foreground, this.unitOffset, {Key? key}) : super(key: key);

	factory Tile.fromIndices(int num, double width, double height, int x, int y, bool foreground, {Key? key}) {
		return Tile(
			num, width, height,
			Offset(x * (width + PADDING_SIZE) + PADDING_SIZE * 0.5, y * (height + PADDING_SIZE) + PADDING_SIZE * 0.5),
			foreground,
			Offset(x.toDouble(), y.toDouble()),
			key: key,
		);
	}

	final int num;
	final double width, height;
	final Offset offset;
	final Offset unitOffset;
	final bool foreground;

	@override
	TileState createState() => TileState();
}

class TileState extends SyncState<Map<int, DIRECTION_HINT>, Tile> with SingleTickerProviderStateMixin {

	TileState() : super(tilesStateGroup);

	Offset? oldOffset;

	late AnimationController _controller;
	late Animation<double> _animation;
	DIRECTION_HINT? hintInfo;

	@override
	void update(Map<int, DIRECTION_HINT>? message) {
		hintInfo = message?[widget.num];
		super.update(message);
  }

	@override
	void didUpdateWidget(Tile oldWidget) {

		if (oldWidget.offset != widget.offset) {
			oldOffset = oldWidget.offset;
			_controller.forward(from: 0);
		}

		super.didUpdateWidget(oldWidget);
	}

	@override
	void initState() {
		_controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
		_controller.value = 0;
		_animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));
		super.initState();
	}

	@override
	void dispose() {
		_controller.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {

		//final ThemeData themeData = Theme.of(context);

		return AnimatedBuilder(
			animation: _controller,
			builder: (_, __) {
				return Transform.translate(
					offset: oldOffset == null ? widget.offset : Offset.lerp(oldOffset, widget.offset, _animation.value)!,
					child: SizedBox(
						height: widget.height,
						width: widget.width,
						child: NeumorphicTile(
							offset: widget.unitOffset,
							height: widget.height,
							width: widget.width,
							num: widget.num,
							foreground: widget.foreground,
							key: widget.key,
						),
					),
				);
			}
		);
	}
}
