import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_1/models/property_model.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PropertyDetailsScreen extends StatefulWidget {
  final Property property;
  final List<Property> favoriteProperties;

  PropertyDetailsScreen({
    required this.property,
    required this.favoriteProperties,
  });

  @override
  _PropertyDetailsScreenState createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  List<String> images = [];

  @override
  void initState() {
    super.initState();
    fetchPropertyImages();
  }

  Future<void> fetchPropertyImages() async {
    var url = Uri.parse(
        "https://ejad-home.ly/getPropertyDetails.php?property_id=${widget.property.id}");
    try {
      var response = await http.get(url);
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['success']) {
        setState(() {
          images = List<String>.from(jsonResponse['property']['images']);
        });
      }
    } catch (e) {
      print("Error fetching property images: $e");
    }
  }

  Future<void> _sharePropertyViaWhatsApp() async {
    final String shareText = "🏠 ${widget.property.name}\n\n"
        "📍 المنطقة: ${widget.property.location}\n"
        "💰 السعر: ${widget.property.price} د.ل\n"
        "📄 الوصف: ${widget.property.description}\n\n"
        "👉 اكتشف المزيد!";

    try {
      if (images.isNotEmpty) {
        // Download the first image
        final response = await http.get(Uri.parse(images[0]));
        final Uint8List imageBytes = response.bodyBytes;

        // Get temporary directory
        final tempDir = await getTemporaryDirectory();
        final file =
            await File('${tempDir.path}/${widget.property.name}.jpg').create();

        // Write image bytes to file
        await file.writeAsBytes(imageBytes);

        // Convert File to XFile
        final xFile = XFile(file.path);

        // Share via WhatsApp with image
        final Uri whatsappUri =
            Uri.parse("whatsapp://send?text=${Uri.encodeComponent(shareText)}");

        if (await canLaunchUrl(whatsappUri)) {
          await Share.shareXFiles(
            [xFile],
            text: shareText,
            subject: 'عقار: ${widget.property.name}',
          );
        }
      } else {
        // Share text only if no image available
        final Uri whatsappUri =
            Uri.parse("whatsapp://send?text=${Uri.encodeComponent(shareText)}");
        if (await canLaunchUrl(whatsappUri)) {
          await launchUrl(whatsappUri);
        } else {
          await Share.share(shareText);
        }
      }
    } catch (e) {
      print('Error sharing via WhatsApp: $e');
      // Fallback to text-only sharing
      await Share.share(shareText);
    }
  }

  Future<void> _shareProperty() async {
    final String shareText = "🏠 ${widget.property.name}\n\n"
        "📍 المنطقة: ${widget.property.location}\n"
        "💰 السعر: ${widget.property.price} د.ل\n"
        "📄 الوصف: ${widget.property.description}\n\n"
        "👉 اكتشف المزيد!";

    try {
      if (images.isNotEmpty) {
        // Download the first image
        final response = await http.get(Uri.parse(images[0]));
        final Uint8List imageBytes = response.bodyBytes;

        // Get temporary directory
        final tempDir = await getTemporaryDirectory();
        final file =
            await File('${tempDir.path}/${widget.property.name}.jpg').create();

        // Write image bytes to file
        await file.writeAsBytes(imageBytes);

        // Convert File to XFile
        final xFile = XFile(file.path);

        // Share both text and image
        await Share.shareXFiles(
          [xFile],
          text: shareText,
          subject: 'عقار: ${widget.property.name}',
        );
      } else {
        // Share text only if no image available
        await Share.share(shareText);
      }
    } catch (e) {
      print('Error sharing: $e');
      // Fallback to text-only sharing
      await Share.share(shareText);
    }
  }

  void _callNumber() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '0925066999');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print('Could not launch $phoneUri');
    }
  }

  void _toggleFavorite(BuildContext context) {
    if (widget.favoriteProperties.contains(widget.property)) {
      widget.favoriteProperties.remove(widget.property);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تمت إزالة العقار من المفضلة')),
      );
    } else {
      widget.favoriteProperties.add(widget.property);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تمت إضافة العقار إلى المفضلة')),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color.fromARGB(229, 19, 60, 117),
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: images.isNotEmpty
                  ? PageView.builder(
                      itemCount: images.length,
                      itemBuilder: (context, index) => Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'assets/noimage.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Image.asset(
                      'assets/noimage.png',
                      fit: BoxFit.cover,
                    ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  widget.favoriteProperties.contains(widget.property)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () => _toggleFavorite(context),
              ),
              IconButton(
                icon: Icon(Icons.share, color: Colors.white),
                onPressed: _shareProperty,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.property.name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(229, 19, 60, 117),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: Color.fromARGB(229, 19, 60, 117)),
                      SizedBox(width: 8),
                      Text(
                        "المنطقة: ${widget.property.location}",
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.property.state == 'للبيع'
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.property.state,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(228, 255, 255, 255),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.property.state,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(228, 255, 255, 255),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                      Text(
                        "السعر: \ ${widget.property.price} د.ل",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Icon(Icons.home, color: Color.fromARGB(229, 19, 60, 117)),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.property.type,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(229, 19, 60, 117),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Icon(Icons.chair,
                          color: Color.fromARGB(229, 19, 60, 117)),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.property.furniture,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(229, 19, 60, 117),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(children: [
                    Icon(Icons.pages_sharp,
                        color: Color.fromARGB(229, 19, 60, 117)),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.property.certificate,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(229, 19, 60, 117),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.apartment,
                        color: Color.fromARGB(229, 19, 60, 117)),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'عدد طوابق \ ${widget.property.floor}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(229, 19, 60, 117),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 23),
                  Text(
                    "الوصف",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(229, 19, 60, 117),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.property.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  if (images.length > 1) ...[
                    SizedBox(height: 24),
                    Text(
                      "الصور",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(229, 19, 60, 117),
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              images[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/noimage.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 24),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _sharePropertyViaWhatsApp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Icon(
                            IconlyBold.chat,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _callNumber,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "اتصل الآن",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
