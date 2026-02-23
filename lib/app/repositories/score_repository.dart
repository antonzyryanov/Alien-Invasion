import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/score_entry.dart';

class ScoreRepository {
  static const _scoresKey = 'best_scores';

  Future<Map<String, double>> readScoresMap() async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = preferences.getString(_scoresKey);
    if (encoded == null || encoded.isEmpty) {
      return <String, double>{};
    }
    final decoded = jsonDecode(encoded);
    if (decoded is! Map<String, dynamic>) {
      return <String, double>{};
    }
    return decoded.map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );
  }

  Future<List<ScoreEntry>> readSortedScores() async {
    final scoreMap = await readScoresMap();
    final entries = scoreMap.entries
        .map((entry) => ScoreEntry(name: entry.key, value: entry.value))
        .toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  Future<void> upsertScore({
    required String playerName,
    required double score,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final scoreMap = await readScoresMap();
    final normalized = double.parse(score.toStringAsFixed(2));
    final old = scoreMap[playerName];
    if (old == null || normalized > old) {
      scoreMap[playerName] = normalized;
      await preferences.setString(_scoresKey, jsonEncode(scoreMap));
    }
  }
}
