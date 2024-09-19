class PartyBalanceModel {
  final String? pkcode;
  final String? name;
  final double? debit;
  final double? credit;
  final double? balance;

  PartyBalanceModel({
    required this.pkcode,
    required this.name,
    required this.debit,
    required this.credit,
    required this.balance,
  });

  factory PartyBalanceModel.fromJson(Map<String, dynamic> json) {
    return PartyBalanceModel(
      pkcode: json['PKCODE'],
      name: json['NAME'],
      debit: json['DEBIT'],
      credit: json['CREDIT'],
      balance: json['BAL'],
    );
  }
}
