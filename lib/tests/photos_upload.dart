import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Upload App',
      initialRoute: '/',
      routes: {
        '/': (context) => UploadScreen(),
        '/gallery': (context) => GalleryScreen(),
      },
    );
  }
}

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  List<File> _images = [];
  final picker = ImagePicker();
  final int maxImages = 8;

  Future<void> _pickImage() async {
    if (_images.length >= maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum 8 photos allowed')),
      );
      return;
    }

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _uploadImages() async {
    if (_images.isEmpty) return;

    var uri = Uri.parse('https://ejad-home.ly/upload.php');
    var request = http.MultipartRequest('POST', uri);

    // Add property_id to the request
    request.fields['property_id'] = '1'; // Replace with dynamic value if needed

    for (var image in _images) {
      request.files
          .add(await http.MultipartFile.fromPath('images[]', image.path));
    }

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      print('Upload response: $responseData'); // Debug output

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseData);
        if (jsonResponse['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload successful')),
          );
          setState(() {
            _images.clear();
          });
          Navigator.pushNamed(context, '/gallery');
        } else {
          String errorMsg = jsonResponse['message'];
          if (jsonResponse['errors'] != null &&
              jsonResponse['errors'].isNotEmpty) {
            errorMsg += ': ' + jsonResponse['errors'].join(', ');
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: $errorMsg')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Upload failed: Server error ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
      print('Upload error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Photos (${_images.length}/$maxImages)'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Image.file(_images[index], fit: BoxFit.cover),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () {
                          setState(() {
                            _images.removeAt(index);
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Add Photo'),
                ),
                ElevatedButton(
                  onPressed: _uploadImages,
                  child: Text('Upload'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<String> imageUrls = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    var url = Uri.parse('https://ejad-home.ly/get_images.php');
    try {
      var response = await http.get(url);
      print('Response status: ${response.statusCode}'); // Debug
      print('Response body: ${response.body}'); // Debug

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          setState(() {
            imageUrls = List<String>.from(jsonResponse['images']);
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Failed to load images from server';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Server error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching images: $e';
        isLoading = false;
      });
      print('Fetch error: $e'); // Debug
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchImages,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : imageUrls.isEmpty
                  ? Center(child: Text('No images found'))
                  : GridView.builder(
                      padding: EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey,
                              child:
                                  Center(child: Text('Image failed to load')),
                            );
                          },
                        );
                      },
                    ),
    );
  }
}
