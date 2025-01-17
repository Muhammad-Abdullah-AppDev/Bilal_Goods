import 'dart:convert';

import 'package:bilal_goods/model/party_balance_model.dart';
import 'package:bilal_goods/model/payment_voucherList_model.dart';
import 'package:bilal_goods/model/permit_voucherList_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/customer-items_model.dart';
import '../model/customer_balance_mode.dart';
import '../model/customer_ledger_model.dart';
import '../model/getcustomer_model.dart';
import '../model/pending_order_model.dart';
import '../model/receipt_list_model.dart';

class ApiService {
  static const baseUrl = "https://erm.scarletsystems.com:2012/Api/";

  static Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));
      debugPrint('Response = $response');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  static Future<http.Response> post(String endpoint,
      {Map<String, dynamic>? body}) async {
    try {
      final response = await http.post(Uri.parse("$baseUrl$endpoint"),
          body: json.encode(body),
          headers: {"Content-Type": "application/json"});

      debugPrint('Response Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else if (response.statusCode == 400) {
        final responseBody = json.decode(response.body);
        debugPrint('Inner Exception: ${responseBody["Message"]}');
        throw Exception("Bad Request: ${responseBody["Message"]}");
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  static Future<List<CustomerBalanceModel>> getCustomerBalance(
      String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => CustomerBalanceModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  static Future<List<PartyBalanceModel>> getPartyBalance(
      String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => PartyBalanceModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  static Future<List<PermitVoucherListModel>> getPermitVoucher(
      String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        List<PermitVoucherListModel> permitVoucher = jsonList
            .map((json) => PermitVoucherListModel.fromJson(json))
            .toList();

        return permitVoucher;
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  static Future<List<PaymentVoucherListModel>> getPaymentVoucher(
      String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        List<PaymentVoucherListModel> paymentVoucher = jsonList
            .map((json) => PaymentVoucherListModel.fromJson(json))
            .toList();

        return paymentVoucher;
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  static Future<List<PermitVoucherListModel>> deletePermitVoucher(
      String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        List<PermitVoucherListModel> permitVoucher = jsonList
            .map((json) => PermitVoucherListModel.fromJson(json))
            .toList();

        return permitVoucher;
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  static Future<List<CustomerItemsModel>> getCustomerItems(
      String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => CustomerItemsModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  static Future<List<GetCustomersModel>> getCustomers(String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => GetCustomersModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  // get Pendings order
  static Future<List<PendingOrderModel>> getPendingOrders(
      String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => PendingOrderModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  // customer ledger api
  static Future<List<CustomerLegderModel>> getCustomerLedger(
      String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        debugPrint("$jsonList");
        return jsonList
            .map((json) => CustomerLegderModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  // ReceiptList api
  static Future<List<RecieptListModel>> getReceiptList(String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$endpoint"));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        // print(jsonList);
        return jsonList.map((json) => RecieptListModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }
}
