import 'dart:convert';

Events eventsFromJson(String str) => Events.fromJson(json.decode(str));

String eventsToJson(Events data) => json.encode(data.toJson());

class Events {
  final int id;
  final String name;
  final String eventUniqueCode;
  final dynamic eventStartDateTime;
  // final String startTime;
  // final String eventStartTime;
  final dynamic eventEndDateTime;
  // final String endTime;
  // final String eventEndTime;
  // final int numberOfAttendees;
  // final String eventContactEmail;
  // final dynamic imageName;
  // final String venueName;
  // final String address;
  // final String city;
  // final String postCode;
  // final String countyState;
  // final int countryId;
  // final String country;
  // final int insertedId;
  // final String imageBytes;
  // final String imageType;
  // final bool isFileSelected;
  final String imagePath;
  // final double licensePrice;
  // final int tenantId;

  Events({
    required this.id,
    required this.name,
    // required this.eventType,
    // required this.eventTypeId,
    // required this.description,
    required this.eventUniqueCode,
    required this.eventStartDateTime,
    // required this.startTime,
    // required this.eventStartTime,
    required this.eventEndDateTime,
    // required this.endTime,
    // required this.eventEndTime,
    // required this.numberOfAttendees,
    // required this.eventContactEmail,
    // required this.imageName,
    // required this.venueName,
    // required this.address,
    // required this.city,
    // required this.postCode,
    // required this.countyState,
    // required this.countryId,
    // required this.country,
    // required this.insertedId,
    // required this.imageBytes,
    // required this.imageType,
    // required this.isFileSelected,
    required this.imagePath,
    // required this.licensePrice,
    // required this.tenantId,
  });

  factory Events.fromJson(Map<String, dynamic> json) => Events(
        id: json["id"],
        name: json["name"],
        // eventType: json["eventType"],
        // eventTypeId: json["eventTypeId"],
        // description: json["description"],
        eventUniqueCode: json["eventUniqueCode"],
        eventStartDateTime: DateTime.parse(json["eventStartDateTime"]),
        // startTime: json["startTime"],
        // eventStartTime: json["eventStartTime"],
        eventEndDateTime: DateTime.parse(json["eventEndDateTime"]),
        // endTime: json["endTime"],
        // eventEndTime: json["eventEndTime"],
        // numberOfAttendees: json["numberOfAttendees"],
        // eventContactEmail: json["eventContactEmail"],
        // imageName: json["imageName"],
        // venueName: json["venueName"],
        // address: json["address"],
        // city: json["city"],
        // postCode: json["postCode"],
        // countyState: json["countyState"],
        // countryId: json["countryId"],
        // country: json["country"],
        // insertedId: json["insertedId"],
        // imageBytes: json["imageBytes"],
        // imageType: json["imageType"],
        // isFileSelected: json["isFileSelected"],
        imagePath: json["imagePath"],
        // licensePrice: json["licensePrice"],
        // tenantId: json["tenantId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        // "eventType": eventType,
        // "eventTypeId": eventTypeId,
        // "description": description,
        "eventUniqueCode": eventUniqueCode,
        "eventStartDateTime": eventStartDateTime.toIso8601String(),
        // "startTime": startTime,
        // "eventStartTime": eventStartTime,
        "eventEndDateTime": eventEndDateTime.toIso8601String(),
        // "endTime": endTime,
        // "eventEndTime": eventEndTime,
        // "numberOfAttendees": numberOfAttendees,
        // "eventContactEmail": eventContactEmail,
        // "imageName": imageName,
        // "venueName": venueName,
        // "address": address,
        // "city": city,
        // "postCode": postCode,
        // "countyState": countyState,
        // "countryId": countryId,
        // "country": country,
        // "insertedId": insertedId,
        // "imageBytes": imageBytes,
        // "imageType": imageType,
        // "isFileSelected": isFileSelected,
        "imagePath": imagePath,
        // "licensePrice": licensePrice,
        // "tenantId": tenantId,
      };
}

class Events1 {
  final int id;
  final String name;

  Events1({
    required this.id,
    required this.name,
  });

  factory Events1.fromJson(Map<String, dynamic> json) => Events1(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
