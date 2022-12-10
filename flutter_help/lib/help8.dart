import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// https://stackoverflow.com/questions/74713379/ui-changes-only-when-i-hot-reload-the-app
///
/// UI changes only when I hot reload the app
void main() => runApp(const ProviderScope(
    child: MaterialApp(home: MyHomePage(title: 'MyHomePage'))));

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  bool isChecked = false;
  final boy = TextEditingController();
  final adet = TextEditingController();
  final kilo = TextEditingController();

  final firma = TextEditingController();
  final kalit = TextEditingController();
  final kalinlik = TextEditingController();
  final en = TextEditingController();

  @override
  void dispose() {
    boy.dispose();
    adet.dispose();
    kilo.dispose();
    firma.dispose();
    kalit.dispose();
    kalinlik.dispose();
    en.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final productInfoProvider = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.5,
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 5,
                  thickness: 2,
                );
              },
              itemCount: productInfoProvider.products.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: Text(
                        productInfoProvider.products[index].firmAdi.toString()),
                    subtitle:
                        Text(productInfoProvider.products[index].en.toString()),
                    title: Text(
                        "${productInfoProvider.products[index].kalite.toString()}  kalite"),
                  ),
                );
              },
            ),
          ),
          Center(
            child: SizedBox(
              height: size.height * 0.2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black),
                onPressed: () {
                  print(productInfoProvider.products.length);

                  showModalBottomSheet(
                    context: context,
                    builder: ((context) {
                      return StatefulBuilder(
                          builder: (BuildContext context, StateSetter myState) {
                        return SizedBox(
                          height: size.height * 0.5,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    solBottomSheet(size, myState),
                                    sagBottomSheet(size, myState),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: ElevatedButton(
                                    onPressed: (() {
                                      final newProduct = createNewProduct();

                                      ref
                                          .read(productProvider)
                                          .addProduct(newProduct);

                                      inspect(productInfoProvider.products);
                                    }),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff74a6cc)),
                                    child: const Text("ekle"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    }),
                  );
                },
                child: const Text("BottomSheet"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  createNewProduct() {
    return ProductInfos(
      firmAdi: firma.text,
      kalite: kalit.text,
      kalinlik: kalinlik.text,
      en: en.text,
      boy: boy.text,
      adet: adet.text,
      kilo: kilo.text,
      pvc: isChecked,
    );
  }

  SizedBox sagBottomSheet(Size size, StateSetter myState) {
    print('build sagBottomSheet');
    return SizedBox(
      width: size.width * 0.4,
      child: Column(
        children: [
          CustomTextField(
            textController: boy,
            t: TextInputType.number,
            hintText: "Boy",
            ic: const Icon(Icons.numbers_outlined),
            dgonly: true,
          ),
          space(),
          CustomTextField(
            textController: adet,
            t: TextInputType.number,
            hintText: "Adet",
            ic: const Icon(Icons.numbers_outlined),
            dgonly: true,
          ),
          space(),
          CustomTextField(
            textController: kilo,
            t: TextInputType.number,
            hintText: "Kilo",
            ic: const Icon(Icons.numbers_outlined),
            dgonly: true,
          ),
          space(),
          CheckboxListTile(
            title: const Text(
              "PVC",
              style: TextStyle(
                  color: Color(0xff74a6cc), fontWeight: FontWeight.w800),
            ),
            value: isChecked,
            onChanged: ((value) {
              myState(() {
                isChecked = value ?? false;
              });
            }),
          ),
        ],
      ),
    );
  }

  SizedBox solBottomSheet(Size size, StateSetter myState) {
    return SizedBox(
      width: size.width * 0.4,
      child: Column(
        children: [
          CustomTextField(
            textController: firma,
            t: TextInputType.name,
            hintText: "Firma",
            ic: const Icon(Icons.home),
          ),
          space(),
          CustomTextField(
            textController: kalit,
            t: TextInputType.number,
            hintText: "Kalite",
            ic: const Icon(Icons.high_quality_outlined),
            dgonly: true,
          ),
          space(),
          CustomTextField(
            textController: kalinlik,
            t: TextInputType.number,
            hintText: "Kalınlık",
            ic: const Icon(Icons.high_quality_outlined),
            dgonly: true,
          ),
          space(),
          CustomTextField(
            textController: en,
            t: TextInputType.number,
            hintText: "En",
            ic: const Icon(Icons.numbers_outlined),
            dgonly: true,
          ),
        ],
      ),
    );
  }

  SizedBox space() {
    return const SizedBox(
      height: 10,
    );
  }
}

class CustomTextField extends ConsumerWidget {
  const CustomTextField({
    required this.textController,
    required this.t,
    required this.hintText,
    required this.ic,
    this.dgonly,
    Key? key,
  }) : super(key: key);

  final TextEditingController textController;
  final TextInputType t;
  final String hintText;
  final Icon ic;
  final bool? dgonly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        icon: ic,
      ),
      controller: textController,
      keyboardType: TextInputType.number,
      inputFormatters:
          dgonly ?? false ? [FilteringTextInputFormatter.digitsOnly] : null,
    );
  }
}

final productProvider = ChangeNotifierProvider((ref) {
  return ProductInfoRepo();
});

class ProductInfoRepo extends ChangeNotifier {
  List<ProductInfos> products = [
    ProductInfos(
      firmAdi: "firm1",
      kalite: "430",
      kalinlik: "0.50",
      en: "750",
      boy: "1000",
      adet: "500",
      kilo: "1500",
      pvc: true,
    ),
  ];

  addProduct(ProductInfos product) {
    products.add(product);
    notifyListeners();
  }
}

class ProductInfos {
  ProductInfos({
    required this.firmAdi,
    required this.kalite,
    required this.kalinlik,
    required this.en,
    required this.boy,
    required this.adet,
    required this.kilo,
    required this.pvc,
  });
  final String firmAdi;
  final String kalite;
  final String kalinlik;
  final String en;
  final String boy;
  final String adet;
  final String kilo;
  final bool pvc;
}
