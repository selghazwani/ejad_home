import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const CarRentalApp());
}

class CarRentalApp extends StatelessWidget {
  const CarRentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CarsGridPage(),
      theme: ThemeData(
        primaryColor: const Color.fromARGB(229, 19, 60, 117),
        fontFamily: 'Cairo',
        useMaterial3: true,
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );
  }
}

class Car {
  final String name;
  final String price1_4;
  final String price5_10;
  final String price11_20;
  final String price21_30;
  final String image;
  final String mileage;
  final List<String> features;

  const Car({
    required this.name,
    required this.price1_4,
    required this.price5_10,
    required this.price11_20,
    required this.price21_30,
    required this.image,
    required this.mileage,
    required this.features,
  });
}

class CarsGridPage extends StatelessWidget {
  const CarsGridPage({super.key});

  final List<Car> cars = const [
    Car(
      name: 'كيا بيجاس',
      price1_4: '270 د.ل',
      price5_10: '230 د.ل',
      price11_20: '205 د.ل',
      price21_30: '150 د.ل',
      image: 'assets/1.png',
      mileage: 'عدد مقاعد 4',
      features: ['نظام ملاحة', 'كاميرا خلفية', 'بلوتوث'],
    ),
    Car(
      name: 'هيونداي اكسنت',
      price1_4: '295 د.ل',
      price5_10: '265 د.ل',
      price11_20: '240 د.ل',
      price21_30: '185 د.ل',
      image: 'assets/2.png',
      mileage: 'عدد مقاعد 4',
      features: ['شاشة لمس', 'مثبت سرعة', 'حساسات ركن'],
    ),
    Car(
      name: 'كيا سبورتاج ',
      price1_4: '385 د.ل',
      price5_10: '325 د.ل',
      price11_20: '280 د.ل',
      price21_30: '240 د.ل',
      image: 'assets/3.png',
      mileage: 'عدد مقاعد 4',
      features: ['شاشة لمس', 'مثبت سرعة', 'حساسات ركن'],
    ),
    Car(
      name: 'تويوتا راف فور ',
      price1_4: '385 د.ل',
      price5_10: '325 د.ل',
      price11_20: '280 د.ل',
      price21_30: '240 د.ل',
      image: 'assets/4.png',
      mileage: 'عدد مقاعد 4',
      features: ['شاشة لمس', 'مثبت سرعة', 'حساسات ركن'],
    ),
    Car(
      name: 'هيونداي توسان ',
      price1_4: '385 د.ل',
      price5_10: '325 د.ل',
      price11_20: '280 د.ل',
      price21_30: '240 د.ل',
      image: 'assets/5.png',
      mileage: 'عدد مقاعد 4',
      features: ['شاشة لمس', 'مثبت سرعة', 'حساسات ركن'],
    ),
    Car(
      name: 'شفرليت كابتيفا ',
      price1_4: '475 د.ل',
      price5_10: '415 د.ل',
      price11_20: '370 د.ل',
      price21_30: '320 د.ل',
      image: 'assets/6.png',
      mileage: 'عدد مقاعد 4',
      features: ['شاشة لمس', 'مثبت سرعة', 'حساسات ركن'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(229, 19, 60, 117),
              Color.fromARGB(178, 19, 60, 117),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'تأجير السيارات',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black26,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.car_rental, color: Colors.white, size: 30),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CarCard(car: cars[index]),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CarCard extends StatefulWidget {
  final Car car;

  const CarCard({super.key, required this.car});

  @override
  State<CarCard> createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                CarDetailsPage(car: widget.car),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Hero(
                        tag: widget.car.name,
                        child: Image.asset(
                          widget.car.image,
                          height: 230,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 130,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.directions_car,
                                size: 50,
                                color: Color.fromARGB(229, 19, 60, 117),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.car.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(229, 19, 60, 117),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '1-4 أيام: ${widget.car.price1_4}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[800]),
                            ),
                            Text(
                              '${widget.car.mileage}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[800]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(229, 19, 60, 117),
                          Color.fromARGB(229, 19, 60, 117)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      'متوفر',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CarDetailsPage extends StatelessWidget {
  final Car car;

  void _callNumber() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '0925066999');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print('Could not launch $phoneUri');
    }
  }

  const CarDetailsPage({super.key, required this.car});

  Future<void> _shareCarDetails() async {
    try {
      // Prepare the text content
      final String shareText = 'سيارة ${car.name} للإيجار\n' +
          'الأسعار:\n' +
          '1-4 أيام: ${car.price1_4}\n' +
          '5-10 أيام: ${car.price5_10}\n' +
          '11-20 يوم: ${car.price11_20}\n' +
          '21-30 يوم: ${car.price21_30}\n' +
          'المميزات: ${car.features.join(", ")}';

      // Load the image from assets
      final ByteData bytes = await rootBundle.load(car.image);
      final Uint8List imageBytes = bytes.buffer.asUint8List();

      // Get temporary directory and create file
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/${car.name}.png').create();

      // Write image bytes to file
      await file.writeAsBytes(imageBytes);

      // Convert File to XFile for share_plus
      final xFile = XFile(file.path);

      // Share both text and image using shareXFiles
      await Share.shareXFiles(
        [xFile],
        text: shareText,
        subject: 'تفاصيل سيارة ${car.name}',
      );
    } catch (e) {
      print('Error sharing: $e');
      // Fallback to text-only sharing if image sharing fails
      await Share.share(
        'سيارة ${car.name} للإيجار\n' +
            'الأسعار:\n' +
            '1-4 أيام: ${car.price1_4}\n' +
            '5-10 أيام: ${car.price5_10}\n' +
            '11-20 يوم: ${car.price11_20}\n' +
            '21-30 يوم: ${car.price21_30}\n' +
            'المميزات: ${car.features.join(", ")}',
        subject: 'تفاصيل سيارة ${car.name}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(229, 19, 60, 117),
              Color.fromARGB(128, 19, 60, 117),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: car.name,
                      child: Image.asset(
                        car.image,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 300,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.directions_car,
                              size: 100,
                              color: Color.fromARGB(229, 19, 60, 117),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.4),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.4),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.share, color: Colors.white),
                          onPressed: _shareCarDetails,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40)),
                  ),
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car.name,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(229, 19, 60, 117),
                          shadows: [
                            Shadow(blurRadius: 5, color: Colors.black12)
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${car.mileage}',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'أسعار الإيجار',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(229, 19, 60, 117),
                        ),
                      ),
                      const SizedBox(height: 15),
                      PriceRow(label: 'من 1-4 أيام', price: car.price1_4),
                      PriceRow(label: 'من 5-10 أيام', price: car.price5_10),
                      PriceRow(label: 'من 11-20 يوم', price: car.price11_20),
                      PriceRow(label: 'من 21-30 يوم', price: car.price21_30),
                      const SizedBox(height: 20),
                      const Text(
                        'المميزات',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(229, 19, 60, 117),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...car.features.map((feature) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Text(
                                  feature,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[800]),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.check_circle,
                                    color: Color.fromARGB(229, 19, 60, 117),
                                    size: 20),
                              ],
                            ),
                          )),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _shareCarDetails,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(229, 19, 60, 117),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(18),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 8,
                            ),
                            child: const Icon(Icons.share),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: _callNumber,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(228, 19, 117 , 71),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 40),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('احجز الآن',
                                    style: TextStyle(fontSize: 20)),
                                SizedBox(width: 10),
                                Icon(Icons.book_online),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PriceRow extends StatelessWidget {
  final String label;
  final String price;

  const PriceRow({super.key, required this.label, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(229, 19, 60, 117).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            price,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(229, 19, 60, 117)),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}