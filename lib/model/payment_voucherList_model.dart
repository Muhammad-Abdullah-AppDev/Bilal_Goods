class PaymentVoucherListModel {
  final String? fKUNIT;
  final String? fKPCD;
  final dynamic fKMCD;
  final String? sRNO;
  final String? vDT;
  final String? vTYP;
  final dynamic rDNO;
  final dynamic rDDT;
  final String? cHQNO;
  final dynamic cHQDT;
  final dynamic pAYE;
  final String? rMKS;
  final String? iNUSID;
  final String? pST;
  final String? nAME;
  final double? dEBIT;
  final double? cREDIT;

  PaymentVoucherListModel({
    this.fKUNIT,
    this.fKPCD,
    this.fKMCD,
    this.sRNO,
    this.vDT,
    this.vTYP,
    this.rDNO,
    this.rDDT,
    this.cHQNO,
    this.cHQDT,
    this.pAYE,
    this.rMKS,
    this.iNUSID,
    this.pST,
    this.nAME,
    this.dEBIT,
    this.cREDIT,
  });

  PaymentVoucherListModel.fromJson(Map<String, dynamic> json)
      : fKUNIT = json['FKUNIT'] as String?,
        fKPCD = json['FKPCD'] as String?,
        fKMCD = json['FKMCD'],
        sRNO = json['SRNO'] as String?,
        vDT = json['VDT'] as String?,
        vTYP = json['VTYP'] as String?,
        rDNO = json['RDNO'],
        rDDT = json['RDDT'],
        cHQNO = json['CHQNO'] as String?,
        cHQDT = json['CHQDT'],
        pAYE = json['PAYE'],
        rMKS = json['RMKS'] as String?,
        iNUSID = json['INUSID'] as String?,
        pST = json['PST'] as String?,
        nAME = json['NAME'] as String?,
        dEBIT = json['DEBIT'] as double?,
        cREDIT = json['CREDIT'] as double?;

  Map<String, dynamic> toJson() => {
    'FKUNIT' : fKUNIT,
    'FKPCD' : fKPCD,
    'FKMCD' : fKMCD,
    'SRNO' : sRNO,
    'VDT' : vDT,
    'VTYP' : vTYP,
    'RDNO' : rDNO,
    'RDDT' : rDDT,
    'CHQNO' : cHQNO,
    'CHQDT' : cHQDT,
    'PAYE' : pAYE,
    'RMKS' : rMKS,
    'INUSID' : iNUSID,
    'PST' : pST,
    'NAME' : nAME,
    'DEBIT' : dEBIT,
    'CREDIT' : cREDIT
  };
}