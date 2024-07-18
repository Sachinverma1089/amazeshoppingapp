import 'package:amazon_clone_project/common/widgets/stars.dart';
import 'package:amazon_clone_project/models/product.dart';
import 'package:flutter/material.dart';

class SearchedProduct extends StatelessWidget {
  final Product product;
  const SearchedProduct({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    double totalRating = 0;
    for (int i = 0; i < product.rating!.length; i++) {
      totalRating += product.rating![i].rating;
    }
    double avgRating = 0;
    if (totalRating != 0) {
      avgRating = totalRating / product.rating!.length;
    }
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(children: [
            Image.network(
              product.images[0],
              fit: BoxFit.contain,
              height: 130,
              width: 130,
            ),
            Column(
              children: [
                Container(
                  width: 200,
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    maxLines: 2,
                  ),
                ),
                Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Stars(rating: avgRating)),
                Container(
                  width: 200,
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Text(
                    '\$${product.price}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    maxLines: 2,
                  ),
                ),
                Container(
                  width: 200,
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: Text(
                    'Eligible for FREE Shipping',
                    style: TextStyle(fontSize: 15),
                    maxLines: 2,
                  ),
                ),
                Container(
                  width: 200,
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: const Text(
                    'In Stock',
                    style: TextStyle(color: Colors.teal),
                    maxLines: 2,
                  ),
                ),
              ],
            )
          ]),
        )
      ],
    );
  }
}
