
import 'dart:math';

import 'package:tools/BasicFunctions.dart';
import 'package:tools/Startup.dart';
import 'package:tools/TestUtils.dart';

int get numWins => prefs?.getInt("NumWins_Flurdle") ?? 0;
int get numPlays => prefs?.getInt("NumPlays_Flurdle") ?? 0;
int get winPercentage => ((numWins / (numPlays != 0 ? numPlays : 1)) * 100).round();
int get currentStreak => prefs?.getInt("CurrentStreak_Flurdle") ?? 0;
int get maxStreak => prefs?.getInt("MaxStreak_Flurdle") ?? 0;

int get lastDayStarted => prefs?.getInt("LastStart_Flurdle") ?? 0;
int get lastDayWon => prefs?.getInt("LastWin_Flurdle") ?? 0;

enum TimeState {
	SAME_DAY,
	ONE_DAY_IN_FUTURE,
	OTHER,
}

// Returns if solved already
bool startGame() {

	if (isTest() && prefs == null) {
		return false;
	}

	final TimeState state = getTimeState(lastDayStarted);

	switch (state) {
		case TimeState.SAME_DAY:
			return prefs!.getBool("PlayedCurrentDay_Flurdle") ?? false;
		case TimeState.ONE_DAY_IN_FUTURE:
		case TimeState.OTHER:
			prefs!.setInt("NumPlays_Flurdle", numPlays + 1);
			prefs!.setInt("LastStart_Flurdle", DateTime.now().millisecondsSinceEpoch);
			return false;
	}
}

void endGame(bool win) {

	final TimeState state = getTimeState(lastDayWon);

	if (win) {
		switch (state) {
			case TimeState.SAME_DAY:
				crashlyticsRecordError("Trying to end a game twice!", StackTrace.current);
				break;
			case TimeState.ONE_DAY_IN_FUTURE:
				prefs!.setInt("CurrentStreak_Flurdle", currentStreak + 1);
				break;
			case TimeState.OTHER:
				prefs!.setInt("CurrentStreak_Flurdle", 1);
				break;
		}
		prefs!.setInt("MaxStreak_Flurdle", max(currentStreak, maxStreak));

		prefs!.setInt("LastWin_Flurdle", DateTime.now().millisecondsSinceEpoch);
		prefs!.setInt("NumWins_Flurdle", numWins + 1);
	}

	prefs!.setBool("PlayedCurrentDay_Flurdle", true);
}

TimeState getTimeState(int timestamp) {
	if (timestamp == 0) {
		return TimeState.OTHER;
	}
	final DateTime oneDayAhead = DateTime.fromMillisecondsSinceEpoch(timestamp + 24 * 60 * 60 * 1000);
	final DateTime lastTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
	final DateTime now = DateTime.now();
	if (oneDayAhead.day == now.day && oneDayAhead.month == now.month && oneDayAhead.year == now.year) {
		return TimeState.ONE_DAY_IN_FUTURE;
	} else if (lastTime.day == now.day && lastTime.month == now.month && lastTime.year == now.year) {
		return TimeState.SAME_DAY;
	} else {
		return TimeState.OTHER;
	}
}
