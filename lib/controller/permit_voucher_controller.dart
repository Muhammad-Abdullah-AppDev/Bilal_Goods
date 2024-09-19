import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;


class TaskStatusController extends GetxController {
  int selectedTaskStId = -1;
  RxBool isInsertingStatus = false.obs;
  final box = GetStorage();
  var fkcoid;

  @override
  void onInit() {
    super.onInit();
    fkcoid = box.read("fkCoid");
  }

  Future<dynamic> deleteTaskStatus(BuildContext context, var SRNO) async {
    try {
      isInsertingStatus.value = true;
      final response = await http.get(Uri.parse(
          "https://erm.scarletsystems.com:2012/Api/NewPermit/DeletePermit?srno=$SRNO"));

      if (response.statusCode == 200) {
        GFToast.showToast('Voucher deleted successfully!', context,
            toastDuration: 4, backgroundColor: Color(0xFF144b9d));
        isInsertingStatus.value = false;
        return response;

      } else if (response.statusCode == 400) {
        debugPrint('statuscode:${response.statusCode == 400}');
        GFToast.showToast(
            'Unable to Delete Record Due to  Foreign key Constraint', context,
            toastDuration: 4, backgroundColor: Colors.red.shade600);
        isInsertingStatus.value = false;
        // Handle foreign key constraint error
      } else {
        isInsertingStatus.value = false;
        // Handle other error cases
        debugPrint("Failed to delete data. Status code: ${response.statusCode}");
        throw Exception("Failed to delete data");
      }
    } catch (e) {
      isInsertingStatus.value = false;
      debugPrint("Error: $e");
      rethrow;
    }
  }

}

