class PendingOrderModel {
  final String? sRNO;
  final String? vDT;
  final String? dRVNAME;
  final String? tRCNO;
  final String? fKMAST;
  final String? iTEMNAME;
  final double? qTY;
  final double? rATE;
  final double? aMOUNT;
  final String? fKPCD;
  final String? fKMCD;
  final String? fKUNIT;
  final String? vTYP;
  final int? vNO;
  final String? fKFSCD;
  final dynamic rMKS;
  final String? rDNO;
  final dynamic rDDT;
  final String? pST;
  final String? sOSTATUS;
  final String? cUSTNAME;

  PendingOrderModel({
    this.sRNO,
    this.vDT,
    this.dRVNAME,
    this.tRCNO,
    this.fKMAST,
    this.iTEMNAME,
    this.qTY,
    this.rATE,
    this.aMOUNT,
    this.fKPCD,
    this.fKMCD,
    this.fKUNIT,
    this.vTYP,
    this.vNO,
    this.fKFSCD,
    this.rMKS,
    this.rDNO,
    this.rDDT,
    this.pST,
    this.sOSTATUS,
    this.cUSTNAME,
  });

  PendingOrderModel.fromJson(Map<String, dynamic> json)
      : sRNO = json['SRNO'] as String?,
        vDT = json['VDT'] as String?,
        dRVNAME = json['DRVNAME'] as String?,
        tRCNO = json['TRCNO'] as String?,
        fKMAST = json['FKMAST'] as String?,
        iTEMNAME = json['ITEMNAME'] as String?,
        qTY = json['QTY'] as double?,
        rATE = json['RATE'] as double?,
        aMOUNT = json['AMOUNT'] as double?,
        fKPCD = json['FKPCD'] as String?,
        fKMCD = json['FKMCD'] as String?,
        fKUNIT = json['FKUNIT'] as String?,
        vTYP = json['VTYP'] as String?,
        vNO = json['VNO'] as int?,
        fKFSCD = json['FKFSCD'] as String?,
        rMKS = json['RMKS'],
        rDNO = json['RDNO'] as String?,
        rDDT = json['RDDT'],
        pST = json['PST'] as String?,
        sOSTATUS = json['SO_STATUS'] as String?,
        cUSTNAME = json['CUST_NAME'] as String?;

  Map<String, dynamic> toJson() => {
    'SRNO' : sRNO,
    'VDT' : vDT,
    'DRVNAME' : dRVNAME,
    'TRCNO' : tRCNO,
    'FKMAST' : fKMAST,
    'ITEMNAME' : iTEMNAME,
    'QTY' : qTY,
    'RATE' : rATE,
    'AMOUNT' : aMOUNT,
    'FKPCD' : fKPCD,
    'FKMCD' : fKMCD,
    'FKUNIT' : fKUNIT,
    'VTYP' : vTYP,
    'VNO' : vNO,
    'FKFSCD' : fKFSCD,
    'RMKS' : rMKS,
    'RDNO' : rDNO,
    'RDDT' : rDDT,
    'PST' : pST,
    'SO_STATUS' : sOSTATUS,
    'CUST_NAME' : cUSTNAME
  };
}
