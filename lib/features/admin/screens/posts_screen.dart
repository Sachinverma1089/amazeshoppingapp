import 'package:amazeshoppingapp/common/widgets/loader.dart';
import 'package:amazeshoppingapp/features/account/widgets/single_product.dart';
import 'package:amazeshoppingapp/features/admin/services/admin_service.dart';
import 'package:flutter/material.dart';

import '../../../models/product.dart';
import 'add_product_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Product>? products;
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  fetchAllProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {});
  }

  void deleteProduct(Product product, int index) {
    adminServices.deleteProduct(
        context: context,
        product: product,
        onSucces: () {
          products!.removeAt(index);
          setState(() {});
        });
  }

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Scaffold(
            body: GridView.builder(
                itemCount: products!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  final productData = products![index];
                  return Column(
                    children: [
                      SizedBox(
                        height: 140,
                        child: SingleProduct(image: productData.images[0]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Text(
                              productData.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          IconButton(
                              onPressed: () =>
                                  deleteProduct(productData, index),
                              icon: Icon(Icons.delete_outline))
                        ],
                      )
                    ],
                  );
                }),
            floatingActionButton: FloatingActionButton(
              onPressed: navigateToAddProduct,
              tooltip: 'Add a Product',
              child: Icon(Icons.add),
              backgroundColor: Colors.teal,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
