import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'dart:typed_data';

import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_textfield.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../services/admin_service.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';

  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final AdminServices adminServices = AdminServices();

  String category = 'Mobiles';
  List<io.File> images = [];
  List<Uint8List> webImages = [];
  final _addProductFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  List<String> productCategories = [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion'
  ];

  void sellProduct() {
    if (_addProductFormKey.currentState!.validate() &&
        (images.isNotEmpty || webImages.isNotEmpty)) {
      adminServices.sellProduct(
        context: context,
        name: productNameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        quantity: double.parse(quantityController.text),
        category: category,
        webImages: webImages,
        mobileImages: images,
      );
    } else {
      showSnackBar(context, 'Please select product images');
    }
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res['files'] as List<io.File>;
      webImages = res['webFiles'] as List<Uint8List>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: GlobalVariables.appBarGradient,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                images.isNotEmpty || webImages.isNotEmpty
                    ? CarouselSlider(
                        items: [
                          ...images.map((e) => Builder(
                              builder: (BuildContext context) => Image.file(
                                    e,
                                    fit: BoxFit.cover,
                                    height: 200,
                                  ))),
                          ...webImages.map((e) => Builder(
                              builder: (BuildContext context) => Image.memory(
                                    e,
                                    fit: BoxFit.cover,
                                    height: 200,
                                  )))
                        ],
                        options:
                            CarouselOptions(viewportFraction: 1, height: 200),
                      )
                    : GestureDetector(
                        onTap: selectImages,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.folder_open, size: 40),
                                const SizedBox(height: 15),
                                Text(
                                  'Select Product Images',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade400),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 30),
                CustomTextField(
                    hintText: 'Product Name',
                    controller: productNameController),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Description',
                  controller: descriptionController,
                  maxLines: 6,
                ),
                const SizedBox(height: 10),
                CustomTextField(hintText: 'Price', controller: priceController),
                const SizedBox(height: 10),
                CustomTextField(
                    hintText: 'Quantity', controller: quantityController),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    onChanged: (String? newVal) {
                      setState(() {
                        category = newVal!;
                      });
                    },
                    value: category,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: productCategories.map((String item) {
                      return DropdownMenuItem(value: item, child: Text(item));
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(text: 'Sell', onTap: sellProduct),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
