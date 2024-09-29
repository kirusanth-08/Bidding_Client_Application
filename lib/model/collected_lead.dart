
class Lead {
  // Other fields...
  final dynamic eventUnique;
  final dynamic attendeeId;
  final dynamic eventId;
  final dynamic imageBytes;
  final dynamic imageType;
  final dynamic imagePath;
  final String attendeeModified;
  final Map<String, dynamic> eventAttendee;

  Lead({
    // Other required fields...
    required this.eventUnique,
    required this.attendeeId,
    required this.eventId,
    required this.imageBytes,
    required this.imageType,
    required this.imagePath,
    required this.attendeeModified,
    required this.eventAttendee,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      eventUnique: json["eventUnique"],
      attendeeId: json["attendeeId"],
      eventId: json["eventId"],
      imageBytes: json["imageBytes"],
      imageType: json["imageType"],
      imagePath: json["imagePath"],
      attendeeModified: json['attendeeModified'] ?? '',
      eventAttendee: json['eventAttendee'] ?? {},
    );
  }
}

class Attendee {
  final dynamic firstName;
  final dynamic lastName;
  final dynamic fullName;
  final dynamic registeredEmail;
  final dynamic attendeeTypeId;
  final dynamic mobile;
  final dynamic company;
  final dynamic city;
  final dynamic postCode;
  final dynamic country;
  final dynamic imagePath;
  final dynamic eventId;
  final dynamic countyState;
  final dynamic eventUnique;

  Attendee({
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.registeredEmail,
    required this.attendeeTypeId,
    required this.mobile,
    required this.company,
    required this.city,
    required this.postCode,
    required this.country,
    required this.imagePath,
    required this.eventId,
    required this.countyState,
    required this.eventUnique,
  });

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      firstName: json['firstName'],
      lastName: json['lastName'],
      fullName: json['fullName'],
      registeredEmail: json['registeredEmail'],
      attendeeTypeId: json['attendeeTypeId'],
      mobile: json['mobile'],
      company: json['company'],
      city: json['city'],
      postCode: json['postCode'],
      country: json['country'],
      imagePath: json['imagePath'],
      eventId: json['eventId'],
      countyState: json['countyState'],
      eventUnique: json['eventUnique'],
    );
  }

  // Optionally, you can add a toJson method
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'registeredEmail': registeredEmail,
      'attendeeTypeId': attendeeTypeId,
      'mobile': mobile,
      'company': company,
      'city': city,
      'postCode': postCode,
      'country': country,
      'imagePath': imagePath,
      'eventId': eventId,
      'countyState': countyState,
      'eventUnique': eventUnique,
    };
  }
}
