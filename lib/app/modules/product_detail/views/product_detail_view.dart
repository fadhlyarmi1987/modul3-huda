import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:liedle/app/data/model/brands.dart';
import 'package:liedle/app/data/service/brands_controller.dart';
import 'package:liedle/app/modules/product_detail/views/product_detail_web_view.dart';
import 'package:liedle/app/routes/app_pages.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controller/product_detail_controller.dart';
import 'package:flutter_image_carousel_slider/flutter_image_slider.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  _ProductDetailViewState createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  // Access the controller via GetX dependency injection
  final ProductDetailController controller = Get.put(ProductDetailController());

  List<String> imageList = [
    "https://thumbs.dreamstime.com/z/luxury-yacht-mediteranean-sea-sardinia-26104031.jpg?ct=jpeg",
    "https://thumbs.dreamstime.com/z/luxury-yacht-sea-26613003.jpg?ct=jpeg",
    "https://thumbs.dreamstime.com/z/speed-boat-5750774.jpg?ct=jpeg",
  ];

  int _rating = 0;
  bool isFavorite = false; // Initial state (not favorite)

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite; // Toggle the state
    });
  }

  // Sample review data
  final List<Map<String, String>> reviews = [
    {
      'title': 'Great Product!',
      'username': 'User1',
      'description': 'This product exceeded my expectations.',
    },
    {
      'title': 'Not Bad',
      'username': 'User2',
      'description': 'It is okay, but I expected more features.',
    },
    {
      'title': 'Could be better',
      'username': 'User3',
      'description': 'The product is decent, but it has some flaws.',
    },
  ];

  // Function to build each star
  Widget buildStar(int index) {
    return SizedBox(
      width: 25,
      child: IconButton(
        icon: Icon(
          index < _rating ? Icons.star : Icons.star_border,
          color: Colors.black,
        ),
        iconSize: 20,
        onPressed: () {
          setState(() {
            _rating = index + 1; // Update rating on click
          });
        },
      ),
    );
  }

  String selectedSize = '';

  // Function to handle button press
  void _selectSize(String size) {
    setState(() {
      selectedSize = size; // Update selected size
    });
  }

  String selectedColor = '';

  // Function to handle color selection
  void _selectColor(String color) {
    setState(() {
      selectedColor = color; // Update selected color
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    child: ImageCarouselSlider(
                      items: imageList,
                      imageHeight: 350,
                      dotColor: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Name',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$0.00',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 27),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (index) {
                            return Row(
                              children: [
                                buildStar(index),
                                if (index < 4)
                                  const SizedBox(
                                      width: 4), // Adjust spacing here
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Size'),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => _selectSize('S'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedSize == 'S'
                                    ? Colors.blue
                                    : Colors.white,
                              ),
                              child: const Text('S'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _selectSize('M'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedSize == 'M'
                                    ? Colors.blue
                                    : Colors.white,
                              ),
                              child: const Text('M'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _selectSize('L'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedSize == 'L'
                                    ? Colors.blue
                                    : Colors.white,
                              ),
                              child: const Text('L'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _selectSize('XL'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedSize == 'XL'
                                    ? Colors.blue
                                    : Colors.white,
                              ),
                              child: const Text('XL'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text('Colors'),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _selectColor('color1'),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8.0),
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  border: Border.all(
                                    color: selectedColor == 'color1'
                                        ? Colors.red
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _selectColor('color2'),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8.0),
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color.fromARGB(255, 0, 112, 224),
                                  border: Border.all(
                                    color: selectedColor == 'color2'
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _selectColor('color3'),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8.0),
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      const Color.fromARGB(255, 247, 158, 27),
                                  border: Border.all(
                                    color: selectedColor == 'color3'
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _selectColor('color4'),
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color.fromARGB(255, 145, 31, 39),
                                  border: Border.all(
                                    color: selectedColor == 'color4'
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      CircleAvatar(
                        child: Image.asset('assets/card.png'),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Shop The Look'),
                          Text('Model Description'),
                        ],
                      ),
                      const SizedBox(width: 100),
                      const Text('SM-SIZE'),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Product Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 170,
                              height: 300,
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        SizedBox(
                                          height: 240,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              'assets/card.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 170,
                              height: 300,
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        SizedBox(
                                          height: 240,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              'assets/card.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const ExpansionTile(
                    title: Text(
                      'PRODUCT DETAILS',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(Icons.chevron_right), // Chevron icon
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                            'Detailed description of the product goes here.'),
                      ),
                    ],
                  ),
                  // Reviews Section
                  const SizedBox(
                    height: 20,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reviews',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 170,
                                    height: 300,
                                    child: Card(
                                      color: Colors.transparent,
                                      elevation: 0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              SizedBox(
                                                height: 240,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.asset(
                                                    'assets/card.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 170,
                                    height: 300,
                                    child: Card(
                                      color: Colors.transparent,
                                      elevation: 0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              SizedBox(
                                                height: 240,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.asset(
                                                    'assets/card.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Row for stars and username
                                    Row(
                                      children: [
                                        // Display stars
                                        Row(
                                          children:
                                              List.generate(5, (starIndex) {
                                            return Icon(
                                              starIndex < _rating
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.yellow,
                                              size: 18, // Adjust size as needed
                                            );
                                          }),
                                        ),
                                        const SizedBox(
                                            width:
                                                150), // Space between stars and username
                                        Text(
                                          'by ${reviews[index]['username']}',
                                          style: const TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    // Title of the review
                                    Text(
                                      reviews[index]['title']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    // Description of the review
                                    Text(reviews[index]['description']!),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'RECOMMENDED',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 170,
                        height: 300,
                        child: Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    height: 240,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/card.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 170,
                        height: 300,
                        child: Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    height: 240,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/card.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _toggleFavorite,
              icon: Icon(
                isFavorite
                    ? Icons.favorite
                    : Icons.favorite_outline, // Change icon
                color: isFavorite ? Colors.red : Colors.black, // Change color
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.black),
                  shape: WidgetStateProperty.all(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // No border radius
                    ),
                  ),
                ),
                child: Text(
                  'Add to Cart',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            IconButton(
                onPressed: () {
                  Get.to(() => ProductDetailWebView(),
                      arguments:
                          'https://www.zara.com/id/' // URL yang ingin ditampilkan
                      );
                },
                icon: const Icon(Icons.next_plan_outlined))
          ],
        ),
      ),
    );
  }
}
