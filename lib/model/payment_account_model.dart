class PaymentAccModel {
  final String? pKCODE;
  final String? nAME;
  final String? fKCLSD;

  PaymentAccModel({
    this.pKCODE,
    this.nAME,
    this.fKCLSD,
  });

  PaymentAccModel.fromJson(Map<String, dynamic> json)
      : pKCODE = json['PKCODE'] as String?,
        nAME = json['NAME'] as String?,
        fKCLSD = json['FKCLSD'] as String?;

  Map<String, dynamic> toJson() => {
    'PKCODE' : pKCODE,
    'NAME' : nAME,
    'FKCLSD' : fKCLSD
  };
}