class PermitVoucherListModel {
  final String? sRNO;
  final String? vDT;
  final String? fKPCD;
  final String? fKMCD;
  final String? fKUNIT;
  final String? vTYP;
  final int? vNO;
  final String? fKFSCD;
  final dynamic rMKS;
  final dynamic rDNO;
  final dynamic rDDT;
  final dynamic dLVDT;
  final String? pST;
  final String? sOSTATUS;
  final String? cUSTNAME;
  final double? nETAMT;
  final double? qTY;

  PermitVoucherListModel({
    this.sRNO,
    this.vDT,
    this.fKPCD,
    this.fKMCD,
    this.fKUNIT,
    this.vTYP,
    this.vNO,
    this.fKFSCD,
    this.rMKS,
    this.rDNO,
    this.rDDT,
    this.dLVDT,
    this.pST,
    this.sOSTATUS,
    this.cUSTNAME,
    this.nETAMT,
    this.qTY,
  });

  PermitVoucherListModel.fromJson(Map<String, dynamic> json)
      : sRNO = json['SRNO'] as String?,
        vDT = json['VDT'] as String?,
        fKPCD = json['FKPCD'] as String?,
        fKMCD = json['FKMCD'] as String?,
        fKUNIT = json['FKUNIT'] as String?,
        vTYP = json['VTYP'] as String?,
        vNO = json['VNO'] as int?,
        fKFSCD = json['FKFSCD'] as String?,
        rMKS = json['RMKS'],
        rDNO = json['RDNO'],
        rDDT = json['RDDT'],
        dLVDT = json['DLVDT'],
        pST = json['PST'] as String?,
        sOSTATUS = json['SO_STATUS'] as String?,
        cUSTNAME = json['CUST_NAME'] as String?,
        nETAMT = json['NETAMT'] as double?,
        qTY = json['QTY'] as double?;

  Map<String, dynamic> toJson() => {
    'SRNO' : sRNO,
    'VDT' : vDT,
    'FKPCD' : fKPCD,
    'FKMCD' : fKMCD,
    'FKUNIT' : fKUNIT,
    'VTYP' : vTYP,
    'VNO' : vNO,
    'FKFSCD' : fKFSCD,
    'RMKS' : rMKS,
    'RDNO' : rDNO,
    'RDDT' : rDDT,
    'DLVDT' : dLVDT,
    'PST' : pST,
    'SO_STATUS' : sOSTATUS,
    'CUST_NAME' : cUSTNAME,
    'NETAMT' : nETAMT,
    'QTY' : qTY
  };
}