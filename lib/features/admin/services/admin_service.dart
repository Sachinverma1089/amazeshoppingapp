import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data'; // Import for Uint8List
import 'dart:io' as io; // Import for io.File
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/order.dart';
import '../../../models/product.dart';
import '../../../providers/user_provider.dart';
import 'dart:convert';

import '../models/sales.dart';

class AdminServices {
  Future<void> sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<Uint8List> webImages,
    List<String>? webImageUrls, // URLs for web images
    List<io.File>? mobileImages, // Optional for mobile images
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic('djwjezd9e', 'yi4ijbsm');
      List<String> imageUrls = [];

      // Handle web images
      if (webImages != null && kIsWeb) {
        print('Uploading web images...');
        for (int i = 0; i < webImages.length; i++) {
          CloudinaryResponse res = await cloudinary.uploadFile(
            CloudinaryFile.fromBytesData(
              identifier: '${name}_$i',
              webImages[i],
              folder: name,
            ),
          );

          imageUrls.add(res.secureUrl);
        }
      }

      // Handle mobile images
      if (mobileImages != null && !kIsWeb) {
        print('Uploading mobile images...');
        for (int i = 0; i < mobileImages.length; i++) {
          Uint8List bytes = await mobileImages[i].readAsBytes();
          CloudinaryResponse res = await cloudinary.uploadFile(
            CloudinaryFile.fromBytesData(
              identifier: '${name}_$i',
              bytes,
              folder: name,
            ),
          );
          imageUrls.add(res.secureUrl);
        }
      }

      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: category,
        price: price,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/admin/add-product'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Product Added Successfully');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get all the products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-products'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              productList
                  .add(Product.fromJson(jsonEncode(jsonDecode(res.body)[i])));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  //delete product
  void deleteProduct(
      {required BuildContext context,
      required Product product,
      required VoidCallback onSucces}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res =
          await http.post(Uri.parse('$uri/admin/delete-product'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token,
              },
              body: jsonEncode({
                'id': product.id,
              }));
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            onSucces();
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get all the Orders
  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-orders'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              orderList
                  .add(Order.fromJson(jsonEncode(jsonDecode(res.body)[i])));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orderList;
  }

  //changeorderstatus
  void changeOrderStauts(
      {required BuildContext context,
      required int status,
      required Order order,
      required VoidCallback onSucces}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res =
          await http.post(Uri.parse('$uri/admin/change-order-status'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token,
              },
              body: jsonEncode({
                'id': order.id,
                'status': status,
              }));
      httpErrorHandle(response: res, context: context, onSuccess: onSucces);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get all the earnings
  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sales> sales = [];
    int totalEarning = 0;
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/analytics'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            var response = jsonDecode(res.body);
            totalEarning = response['totalEarnings'];
            sales = [
              Sales('Mobiles', response['mobilesEarnings']),
              Sales('Essentials', response['essentialsEarnings']),
              Sales('Appliances', response['appliancesEarning']),
              Sales('Books', response['booksEarnings']),
              Sales('Fashion', response['fashionEarnings']),
            ];
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }
}
