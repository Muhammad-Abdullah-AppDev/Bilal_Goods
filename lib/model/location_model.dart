class LocationModel {
  final String? fKUSER;
  final String? fKUNIT;
  final String? nAME;
  final String? uSID;

  LocationModel({
    this.fKUSER,
    this.fKUNIT,
    this.nAME,
    this.uSID,
  });

  LocationModel.fromJson(Map<String, dynamic> json)
      : fKUSER = json['FKUSER'] as String?,
        fKUNIT = json['FKUNIT'] as String?,
        nAME = json['NAME'] as String?,
        uSID = json['USID'] as String?;

  Map<String, dynamic> toJson() => {
    'FKUSER' : fKUSER,
    'FKUNIT' : fKUNIT,
    'NAME' : nAME,
    'USID' : uSID
  };
}