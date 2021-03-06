import 'package:delivery_food/General/Constants.dart';
import 'package:delivery_food/General/Dialogs.dart';
import 'package:delivery_food/controller/Cart_controller.dart';
import 'package:delivery_food/controller/Products_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ListProdCart extends StatelessWidget {
  ListProdCart({
    Key? key,
    required this.item,
  }) : super(key: key);

  var item = [];
  var prodController = Get.find<ProductsController>();

  var cart = Get.put(CartController());
  StatusCode statusCode = StatusCode();

  @override
  Widget build(BuildContext context) {
    prodController.getstoragcart();
    Size size = MediaQuery.of(context).size;
    List controlleritem = [].obs;
    item.forEach((element) {
      controlleritem.add(element);
    });

    return Obx(() {
      cart.updata = [];

      return ListView.builder(
          controller: cart.listScrollController,
          itemCount: controlleritem.length,
          itemBuilder: (context, index) {
            var counter = 0.obs;
            int? ind;
            if (statusCode.Token != '') {
              cart.updata.add({
                'productId': controlleritem[index].id,
                'quantity': controlleritem[index].Cartid[0].quantity
              });
              counter.value = controlleritem[index].Cartid[0].quantity;
            } else {
              print(prodController.cartsid);
              print(prodController.cartscountupdate);

              for (int u = 0; u < prodController.cartsid.length; u++) {
                if (controlleritem[index].id == prodController.cartsid[u]) {
                  ind = u;
                  break;
                }
              }
              List cartscounte = prodController.cartscounte;
              List cartsid = prodController.cartsid;

              if (ind != null) {
                counter.value = cartscounte[ind];
              }
            }
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.network(
                        statusCode.urlimage + controlleritem[index].avatar,
                        width: size.width >= 600 ? 80 : 35,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        controlleritem[index].name,
                        style: size.width >= 600
                            ? Styles.defualttab
                            : Styles.defualtmobile,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          if (counter > 0 && counter > item[index].min) {
                            counter = counter - item[index].min;
                            if (statusCode.Token == '') {
                              prodController.cartscountupdate[ind!] =
                                  prodController.cartscountupdate[ind] -
                                      item[index].min;
                            } else {
                              cart.updata[index]['quantity'] =
                                  cart.updata[index]['quantity']! -
                                      item[index].min;
                            }
                          }
                        },
                        child: Container(
                          height: size.width >= 600 ? 40 : 25,
                          width: size.width >= 600 ? 40 : 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            color: AppColors.whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '-',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: size.width >= 600 ? 40 : 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: size.width >= 600 ? 40 : 25,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          color: AppColors.whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Obx(() {
                          return Center(
                            child: Text(
                                '${counter.value}  ${item[index].measuringUnit}',
                                style: size.width >= 600
                                    ? Styles.defualttab
                                    : Styles.defualtmobile),
                          );
                        }),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          if (counter < item[index].max) {
                            counter = counter + item[index].min;
                            if (statusCode.Token == '') {
                              prodController.cartscountupdate[ind!] =
                                  prodController.cartscountupdate[ind] +
                                      item[index].min;
                            } else {
                              cart.updata[index]['quantity'] =
                                  cart.updata[index]['quantity']! +
                                      item[index].min;
                            }
                          }
                        },
                        child: Container(
                          height: size.width >= 600 ? 40 : 25,
                          width: size.width >= 600 ? 40 : 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            color: AppColors.whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '+',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: size.width >= 600 ? 35 : 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() {
                        return Container(
                          width: size.width >= 600 ? 92 : 52,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                                '${NumberFormat.decimalPattern().format(controlleritem[index].price * counter.value)} \$',
                                style: size.width >= 600
                                    ? Styles.defualttab
                                    : Styles.defualtmobile),
                          ),
                        );
                      }),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          DialogsUtils.showdialogdelete(
                              m: 'Proceed ?',
                              onPressedCancel: () {
                                Get.back();
                              },
                              onPressedOk: () {
                                if (statusCode.Token == '') {
                                  var item = controlleritem;

                                  prodController.cartscountupdate
                                      .removeAt(ind!);
                                  prodController.cartsdeleteupdate
                                      .removeAt(ind);
                                  item.removeAt(index);
                                  Get.back();
                                  // ListProdCart(
                                  //   item: item,
                                  // );
                                  return false;
                                } else {
                                  var item = controlleritem;
                                  cart.updatadelete.add(item[index].id);
                                  item.removeAt(index);
                                  ListProdCart(
                                    item: item,
                                  );
                                  Get.back();
                                }
                              });
                        },
                        child: Image.asset(
                          'assets/png/remove.png',
                          scale: size.width >= 600 ? 0.5 : 1,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          });
    });
  }
}
