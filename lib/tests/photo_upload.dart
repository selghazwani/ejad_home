import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PhotoUploadScreen(),
    );
  }
}

class PhotoUploadScreen extends StatefulWidget {
  @override
  _PhotoUploadScreenState createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];

  Future<void> _pickImage(ImageSource source) async {
    try {
      final List<XFile>? pickedImages = await _picker.pickMultiImage();
      if (pickedImages != null) {
        setState(() {
          if (_images.length + pickedImages.length <= 8) {
            _images.addAll(pickedImages);
            print('Images added: ${_images.length}'); // Debug print
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You can only upload up to 8 photos.')),
            );
          }
        });
      }
    } catch (e) {
      print('Error picking images: $e'); // Debug print
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick images: $e')),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          if (_images.length < 8) {
            _images.add(photo);
            print('Photo added: ${photo.path}'); // Debug print
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You can only upload up to 8 photos.')),
            );
          }
        });
      }
    } catch (e) {
      print('Error taking photo: $e'); // Debug print
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to take photo: $e')),
      );
    }
  }

  Future<void> _uploadImages() async {
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No images selected.')),
      );
      return;
    }

    var uri = Uri.parse('https://ejad-home.ly/uploadPhoto.php');
    var request = http.MultipartRequest('POST', uri);

    for (var image in _images) {
      var file = await http.MultipartFile.fromPath(
        'photos[]', // Key for the PHP script
        image.path,
        contentType: MediaType('image', 'jpeg'), // Adjust if needed
      );
      request.files.add(file);
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Images uploaded successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload images.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Photos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                final file = File(_images[index].path);
                if (file.existsSync() &&
                    (_images[index].path.endsWith('.jpg') ||
                        _images[index].path.endsWith('.png'))) {
                  return Image.file(
                    file,
                    fit: BoxFit.cover,
                  );
                } else {
                  print(
                      'Unsupported file type or file does not exist: ${_images[index].path}'); // Debug print
                  return Center(child: Text('Unsupported image'));
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: Text('Pick from Gallery'),
              ),
              ElevatedButton(
                onPressed: _takePhoto,
                child: Text('Take a Photo'),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _uploadImages,
            child: Text('Upload Images'),
          ),
        ],
      ),
    );
  }
}
