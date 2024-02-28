import 'dart:convert';

import 'package:demo_project/src/features/events_page/event_model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EventProvider extends ChangeNotifier {
  List<EventModel> eventsList = [];

  Future<void> fetch() async {
    try {
      String jsonString =
          await rootBundle.loadString('json_files/events_data.json');
      List<dynamic> jsonData = json.decode(jsonString);

      eventsList = jsonData.map((item) => EventModel.fromJson(item)).toList();
    } catch (e) {
      print('Ошибка при получении: $e');
    }
  }

  List<EventModel> foundEvents = [];

  void init() {
    foundEvents = eventsList;
    print('init');
  }

  List<EventModel> get events => foundEvents;

  void runFilter(bool? completed) {
    List<EventModel> results = [];
    if (completed == null) {
      results = eventsList;
    } else {
      results = eventsList
          .where((product) => product.eventReadStatus == completed)
          .toList();
    }
    foundEvents = results;
    notifyListeners();
  }
}
