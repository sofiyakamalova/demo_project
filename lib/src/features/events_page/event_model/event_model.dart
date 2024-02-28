class EventModel {
  String? eventId;
  String? eventTitle;
  String? eventText;
  bool? eventReadStatus;
  List? eventPictures;

  EventModel(this.eventTitle);

  EventModel.fromJson(Map<String, dynamic> json) {
    eventId = json['eventId'];
    eventTitle = json['eventTitle'];
    eventText = json['eventText'];
    eventReadStatus = json['eventReadStatus'];
    eventPictures = json['eventPictures'];
  }
}
