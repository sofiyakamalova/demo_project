import 'dart:convert';

import 'package:demo_project/src/core/common_widgets/common_title.dart';
import 'package:demo_project/src/core/constants/app_color.dart';
import 'package:demo_project/src/features/events_page/event_model/event_model.dart';
import 'package:demo_project/src/features/events_page/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    eventProvider.init();
    eventProvider.fetch();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            toolbarHeight: 70,
            backgroundColor: AppColor.mainColor,
            title: const CommonTitle(
              title: 'Events',
              textColor: AppColor.white_color,
              size: 30,
            ),
            actions: [
              PopupMenuButton(
                icon: const SizedBox(
                  width: 30,
                  child: Icon(
                    Icons.more_vert,
                    color: AppColor.white_color,
                  ),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text("Read"),
                    value: "read",
                    onTap: () {
                      eventProvider.runFilter(true);
                    },
                  ),
                  PopupMenuItem(
                    child: const Text("Unread"),
                    value: "unread",
                    onTap: () {
                      eventProvider.runFilter(false);
                    },
                  ),
                  PopupMenuItem(
                    child: const Text("All"),
                    value: "",
                    onTap: () {
                      eventProvider.runFilter(null);
                    },
                  ),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ]),
        body: Column(
          children: <Widget>[
            Consumer<EventProvider>(builder: (context, data, child) {
              if (data.events.isNotEmpty) {
                return Expanded(
                  child: data.events.isNotEmpty
                      ? EventList(eventList: data.events)
                      : const Text('No results found'),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}

class EventList extends StatefulWidget {
  final List<EventModel> eventList;
  const EventList({super.key, required this.eventList});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  List<dynamic> dataList = [];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    try {
      // Read the JSON file
      String jsonString =
          await rootBundle.loadString('json_files/events_data.json.json');

      final jsonData = json.decode(jsonString);

      // Update the state with the loaded data
      setState(() {
        dataList = jsonData;
      });
    } catch (e) {
      print('Error loading JSON: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: widget.eventList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Image.asset(
                  fit: BoxFit.cover,
                  '${widget.eventList[index].eventPictures?.first}'),
              title: Column(
                children: [
                  Text(
                    '${widget.eventList[index].eventTitle}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${widget.eventList[index].eventText}',
                    style: TextStyle(color: AppColor.greyColor),
                    maxLines: 2,
                  ),
                ],
              ),
              subtitle: Text('${widget.eventList[index].eventReadStatus}'),
            ),
          );
        },
      ),
    );
  }
}

/*
FutureBuilder(
future: eventList,

builder: (context, data) {
if (data.hasError) {
return Center(child: Text("${data.error}"));
} else if (data.hasData) {
var items = data.data as List<EventModel>;
return ListView.separated(
itemCount: items == null ? 0 : items.length,
separatorBuilder: (BuildContext context, int index) {
return const SizedBox(height: 5);
},
itemBuilder: (context, index) {
return Card(
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
children: <Widget>[
const SizedBox(width: 10),
Expanded(
child: Text(
items[index].eventTitle.toString(),
style: const TextStyle(
fontSize: 18,
fontWeight: FontWeight.w500,
color: Color(0xFF164F80),
),
maxLines: 2,
),
),
],
),
),
);
});
} else {
return const Center(
child: CircularProgressIndicator(),
);
}
}),


 */
