

class Attendees {
  final dynamic id;
  final dynamic attendeeUniqueCode;
  final dynamic firstName;
  final dynamic lastName;
  final dynamic fullName;
  final dynamic ticketTypeId;
  final dynamic ticketTypeName;
  final dynamic registeredEmail;
  final dynamic summary;
  final dynamic attendeeTypeId;
  final dynamic attendeeTypeName;
  final dynamic mobile;
  final dynamic company;
  final dynamic address;
  final dynamic city;
  final dynamic postCode;
  final dynamic countryId;
  final dynamic country;
  final dynamic externalProfileId;
  final dynamic qrCodePath;
  final dynamic checkedIn;
  final dynamic status;
  final dynamic checkInDateTime;
  final dynamic imagePath;
  final dynamic eventId;
  final dynamic imageBytes;
  final dynamic imageType;
  final dynamic isFileSelected;
  final dynamic countyState;
  final dynamic emailSent;
  final dynamic eventUnique;
  final dynamic createUser;
  final dynamic createDate;
  final dynamic modifyUser;
  final dynamic modifyDate;
  final dynamic loginUser;

  Attendees({
    required this.id,
    required this.attendeeUniqueCode,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.ticketTypeId,
    required this.ticketTypeName,
    required this.registeredEmail,
    required this.summary,
    required this.attendeeTypeId,
    required this.attendeeTypeName,
    required this.mobile,
    required this.company,
    required this.address,
    required this.city,
    required this.postCode,
    required this.countryId,
    required this.country,
    required this.externalProfileId,
    required this.qrCodePath,
    required this.checkedIn,
    required this.status,
    required this.checkInDateTime,
    required this.imagePath,
    required this.eventId,
    required this.imageBytes,
    required this.imageType,
    required this.isFileSelected,
    required this.countyState,
    required this.emailSent,
    required this.eventUnique,
    required this.createUser,
    required this.createDate,
    required this.modifyUser,
    required this.modifyDate,
    required this.loginUser,
  });

  factory Attendees.fromJson(Map<String, dynamic> json) => Attendees(
        id: json["id"],
        attendeeUniqueCode: json["attendeeUniqueCode"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        fullName: json["fullName"],
        ticketTypeId: json["ticketTypeId"],
        ticketTypeName: json["ticketTypeName"],
        registeredEmail: json["registeredEmail"],
        summary: json["summary"],
        attendeeTypeId: json["attendeeTypeId"],
        attendeeTypeName: json["attendeeTypeName"],
        mobile: json["mobile"],
        company: json["company"],
        address: json["address"],
        city: json["city"],
        postCode: json["postCode"],
        countryId: json["countryId"],
        country: json["country"],
        externalProfileId: json["externalProfileId"],
        qrCodePath: json["qrCodePath"],
        checkedIn: json["checkedIn"],
        status: json["status"],
        checkInDateTime: json["checkInDateTime"],
        imagePath: json["imagePath"],
        eventId: json["eventId"],
        imageBytes: json["imageBytes"],
        imageType: json["imageType"],
        isFileSelected: json["isFileSelected"],
        countyState: json["countyState"],
        emailSent: json["emailSent"],
        eventUnique: json["eventUnique"],
        createUser: json["createUser"],
        createDate: json["createDate"],
        modifyUser: json["modifyUser"],
        modifyDate: json["modifyDate"],
        loginUser: json["loginUser"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attendeeUniqueCode": attendeeUniqueCode,
        "firstName": firstName,
        "lastName": lastName,
        "fullName": fullName,
        "ticketTypeId": ticketTypeId,
        "ticketTypeName": ticketTypeName,
        "registeredEmail": registeredEmail,
        "summary": summary,
        "attendeeTypeId": attendeeTypeId,
        "attendeeTypeName": attendeeTypeName,
        "mobile": mobile,
        "company": company,
        "address": address,
        "city": city,
        "postCode": postCode,
        "countryId": countryId,
        "country": country,
        "externalProfileId": externalProfileId,
        "qrCodePath": qrCodePath,
        "checkedIn": checkedIn,
        "status": status,
        "checkInDateTime": checkInDateTime,
        "imagePath": imagePath,
        "eventId": eventId,
        "imageBytes": imageBytes,
        "imageType": imageType,
        "isFileSelected": isFileSelected,
        "countyState": countyState,
        "emailSent": emailSent,
        "eventUnique": eventUnique,
        "createUser": createUser,
        "createDate": createDate,
        "modifyUser": modifyUser,
        "modifyDate": modifyDate,
        "loginUser": loginUser,
      };
}
