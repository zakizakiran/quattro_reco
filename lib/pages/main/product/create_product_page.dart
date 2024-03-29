// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:reco_app/controller/auth_controller.dart';
import 'package:reco_app/controller/product_controller.dart';
import 'package:reco_app/helper/text_formatter.dart';
import 'package:reco_app/models/product_model.dart';
import 'package:reco_app/navigation/bottom_navigation.dart';
import 'package:reco_app/widgets/custom/custom_button.dart';

class CreateProductPage extends ConsumerStatefulWidget {
  const CreateProductPage({super.key});

  @override
  ConsumerState<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends ConsumerState<CreateProductPage> {
  TextEditingController title = TextEditingController();
  TextEditingController captions = TextEditingController();
  TextEditingController price = TextEditingController();

  File? _file;

  final picker = ImagePicker();
  final storage = FirebaseStorage.instance;

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _file = File(pickedFile!.path);
    });
  }

  Future<String?> uploadProductImages() async {
    try {
      if (_file == null) return null;

      final Reference storageReference =
          storage.ref().child('product_images/${DateTime.now().toString()}');
      final UploadTask uploadTask = storageReference.putFile(_file!);
      final TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => null);
      final String downloadURL = await taskSnapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      Logger().i(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    Card(
                      color: Colors.grey[300],
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 0,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: _file == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/img/no_img.svg',
                                    fit: BoxFit.fill,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      pickImage();
                                    },
                                    child: const Text(
                                      'Add image',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54),
                                    ),
                                  )
                                ],
                              )
                            : Image.file(
                                _file!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    TextFormField(
                      controller: title,
                      cursorColor: HexColor('4DC667'),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'Product Title',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: HexColor('4DC667')),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: price,
                      cursorColor: HexColor('4DC667'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'Product Price',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: HexColor('4DC667')),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: captions,
                      maxLines: null,
                      cursorColor: HexColor('4DC667'),
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Captions',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: HexColor('4DC667'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomButton(
                    onPressed: () async {
                      try {
                        String? imageUrl = await uploadProductImages();

                        Product product = Product(
                          title: title.text,
                          captions: encodeToBase64(captions.text),
                          author: currentUser.name,
                          imgUrl: imageUrl,
                          price: int.tryParse(price.text),
                          authorImg: currentUser.profileImg,
                          uid: currentUser.uid,
                        );
                        await ref
                            .read(productControllerProvider.notifier)
                            .createProduct(context: context, product: product);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const BottomNavigation(initialIndex: 2),
                          ),
                        );
                        if (!mounted) return;
                      } on FirebaseException catch (e) {
                        Logger().i(e);
                      }
                    },
                    label: 'Post Product',
                    backgroundColor: '4DC667',
                    textColor: Colors.white,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
