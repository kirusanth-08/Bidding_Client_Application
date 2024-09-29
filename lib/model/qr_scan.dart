import 'dart:convert';

Qr qrFromJson(String str) => Qr.fromJson(json.decode(str));

String qrToJson(Qr data) => json.encode(data.toJson());

class Qr {
  // final int id;
  late dynamic id;
  late dynamic firstName;
  late dynamic lastName;
  late dynamic fullName;
  late dynamic registeredEmail;
  late dynamic attendeeTypeId;
  late dynamic mobile;
  late dynamic company;
  late dynamic summary;
  late dynamic city;
  late dynamic postCode;
  late dynamic country;
  late dynamic imagePath;
  late dynamic eventId;
  late dynamic countyState;
  late dynamic eventUnique;

  Qr({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.registeredEmail,
    required this.attendeeTypeId,
    required this.mobile,
    required this.company,
    required this.summary,
    required this.city,
    required this.postCode,
    required this.country,
    required this.imagePath,
    required this.eventId,
    required this.countyState,
    required this.eventUnique,
  });

  factory Qr.fromJson(Map<String, dynamic> json) => Qr(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        fullName: json["fullName"],
        registeredEmail: json["registeredEmail"],
        attendeeTypeId: json["attendeeTypeId"],
        mobile: json["mobile"],
        company: json["company"],
        summary: json["summary"],
        city: json["city"],
        postCode: json["postCode"],
        country: json["country"],
        imagePath: json["imagePath"],
        eventId: json["eventId"],
        countyState: json["countyState"],
        eventUnique: json["eventUnique"],
      );

  Map<String, dynamic> toJson() => {
         "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "fullName": fullName,
        "registeredEmail": registeredEmail,
        "attendeeTypeId": attendeeTypeId,
        "mobile": mobile,
        "company": company,
        "summary": summary,
        "city": city,
        "postCode": postCode,
        "country": country,
        "imagePath": imagePath,
        "eventId": eventId,
        "countyState": countyState,
        "eventUnique": eventUnique,
      };
}
