import 'package:bot_toast/bot_toast.dart';
import 'package:delivery_food/General/Api_Result.dart';
import 'package:delivery_food/General/Constants.dart';
import 'package:delivery_food/General/Dialogs.dart';
import 'package:delivery_food/controller/Cart_controller.dart';
import 'package:delivery_food/controller/Offer_controller.dart';
import 'package:delivery_food/model/DeletePutPost.dart';
import 'package:delivery_food/model/Img_History.dart';
import 'package:delivery_food/model/Order_model.dart';
import 'package:delivery_food/services/Order_services.dart';
import 'package:delivery_food/view/Home_page/Home_page.dart';
import 'package:delivery_food/view/navbar.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  var orders = <OrderResponse>[].obs;
  var ordersImg = <ImgOrderResponse>[].obs;
  var postorder = DeletePutPostResponse().obs;
  var hasError = true.obs;
  var massage = ''.obs;

  ApiResult apiResult = ApiResult();
  OrderService orderService = OrderService();

  @override
  void onInit() {
    getorderAsset();

    super.onInit();
  }

  getorder(String q) async {
    try {
      orders.value = [];
      BotToast.showLoading();
      apiResult = await orderService.getorderData(q);
      if (apiResult.rfreshToken) {
        if (!apiResult.hasError!) {
          orders.value = apiResult.data;
          hasError.value = apiResult.hasError!;
        } else {
          hasError.value = apiResult.hasError!;
          massage.value = apiResult.errorMassage!;
          DialogsUtils.showdialog(
              m: massage.value,
              onPressed: () {
                Get.back();
                Get.back();
              });
        }
      } else {
        getorder(q);
      }
    } catch (e) {
      hasError.value = apiResult.hasError!;
      massage.value = apiResult.errorMassage!;
      DialogsUtils.showdialog(
          m: 'حدث خطأ غير متوقع',
          onPressed: () {
            Get.back();
            Get.back();
          });
    } finally {
      BotToast.closeAllLoading();
    }
  }

  getorderAsset() async {
    try {
      apiResult = await orderService.getorderAsset();
      if (!apiResult.hasError!) {
        ordersImg.value = apiResult.data;
        hasError.value = apiResult.hasError!;
      } else {
        hasError.value = apiResult.hasError!;
        massage.value = apiResult.errorMassage!;
        DialogsUtils.showdialog(
            m: massage.value,
            onPressed: () {
              Get.back();
              Get.back();
            });
      }
    } catch (e) {
      hasError.value = apiResult.hasError!;
      massage.value = apiResult.errorMassage!;
      DialogsUtils.showdialog(
          m: 'حدث خطأ غير متوقع',
          onPressed: () {
            Get.back();
            Get.back();
          });
    }
  }

  postOrder(var body) async {
    try {
      BotToast.showLoading();
      apiResult = await orderService.postorderData(body);
      if (!apiResult.hasError!) {
        postorder.value = apiResult.data;
        hasError.value = apiResult.hasError!;

        await Constansbox.box.write('offersId', []);
        Get.find<OfferController>().getOfferid();
        Get.offAll(
          BottomBar(
            intid: 0,
            fu: HomeView(),
          ),
        );
        Get.back();
      } else {
        hasError.value = apiResult.hasError!;
        massage.value = apiResult.errorMassage!;
        DialogsUtils.showdialog(
            m: massage.value,
            onPressed: () {
              Get.back();
            });
      }
    } catch (e) {
      hasError.value = apiResult.hasError!;
      massage.value = apiResult.errorMassage!;
      print(e);
    } finally {
      BotToast.closeAllLoading();
    }
  }
}
