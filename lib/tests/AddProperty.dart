import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/bottombar_nav.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_application_1/models/UserModel.dart';

class AddPropertyPage extends StatefulWidget {
  final User user;
  AddPropertyPage({Key? key, required this.user}) : super(key: key);

  @override
  _AddPropertyPageState createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _bedroomsController = TextEditingController();
  final TextEditingController floor = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _priceController =
      TextEditingController(text: '500');
  String _nameController = '';
  String _districtController = '';
  String _propertyType = '';
  String _propertyStatus = '';
  String _propertyUsageType = '';
  String _furnitureStatus = '';
  String _propertyCertificateType = '';
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  final List<String> _districts = [
    "الصابري",
    "بوعطني",
    "قاريونس",
    "الكيش",
    "الليثي",
    "سيدي خليفة",
    "الهواري",
    "بنينا",
    "البركة",
    "وسط البلاد",
    "سيدي حسين",
    "بلعون ",
    "طريق النهر ",
    "طابلينو ",
    "حي الفاتح",
    "الرويسات ",
    "الفويهات (الفويهات الغربية - الفويهات الشرقية)",
    "الحدائق",
    "الماجوري",
    "بن يونس",
    "سيدي يونس",
    "بوهديمة",
    "الرحبة",
    "حي الدولار",
    "أرض قريش",
    "المساكن",
    "حي السلام",
    "بوعطني",
    "بودزيرة",
    "بوصنيب",
    "تيكا",
    "العمارات الصينية",
    "شبنة",
    "سيدي فرج",
    "المساكن",
    "النواقية",
    "الماجوري ",
    "جليانة",
    "قنفودة",
    "جروثة",
    "الكويفية",
    "السليني",
    "الوحيشي",
    "السلماني الشرقي",
    "السلماني الغربي",
    "رأس عبيدة",
    "بلعون ",
    "فنيسيا ",
    "حي قطر",
    "حي الجامعي",
    "حي سندباد",
    "مثلث سوق السعي ",
    "بودريسة",
    "شارع الكتربلر",
    "شارع المركبات",
    "ارض بن علي",
    "القوارشة - شارع الشجر",
    "القوارشة",
    "الفعكات",
    "حي اكسفورد",
    "حي الرئاسي",
    "حي الدوبلوماسي",
    "دقادوستا",
    "حي لبنان",
  ];

  final List<String> _propertyTypes = [
    ' ',
    'فيلا',
    'شقة',
    'ارض',
    'محل',
    'هنجر',
    'مكتب',
    'استراحة',
    'عمارة',
    'مخطط',
    'استوديو',
  ];
  final List<String> _propertyStatuses = [' ', 'للبيع', 'للإيجار'];
  final List<String> _propertyUsageTypes = [' ', 'تجاري', 'سكني'];
  final List<String> _furnitureStatuses = [' ', 'مفروشة', 'غير مفروشة'];
  final List<String> _propertyCertificateTypes = [
    ' ',
    'ملكية مقدسة',
    'حق انتفاع',
    'شهادة عقارية تخصيص',
    'شهادة عقارية قطعية',
  ];

  Future<void> _pickImages() async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null) {
        if (_images.length + pickedFiles.length <= 8) {
          setState(() {
            _images.addAll(pickedFiles);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('يمكنك تحميل حتى 8 صور فقط!')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في تحميل الصور: $e')),
      );
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Color.fromARGB(229, 19, 60, 117),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'جاري إضافة العقار...',
                    style: TextStyle(
                      color: Color.fromARGB(229, 19, 60, 117),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future addProperty() async {
    if (_formKey.currentState!.validate() &&
        _propertyType != ' ' &&
        _propertyStatus != ' ' &&
        _propertyUsageType != ' ' &&
        _furnitureStatus != ' ' &&
        _propertyCertificateType != ' ' &&
        _districtController != '') {
      setState(() {
        _isLoading = true;
      });
      _showLoadingDialog();

      try {
        var url = Uri.parse("https://ejad-home.ly/addProperty.php");
        var request = http.MultipartRequest('POST', url);

        request.fields['user_id'] = widget.user.id.toString();
        request.fields['name'] = _propertyType;
        request.fields['description'] = _descriptionController.text;
        request.fields['location'] = _districtController;
        request.fields['type'] = _propertyUsageType;
        request.fields['state'] = _propertyStatus;
        request.fields['property_type'] = _propertyUsageType;
        request.fields['furniture'] = _furnitureStatus;
        request.fields['certificate'] = _propertyCertificateType;
        request.fields['price'] = _priceController.text;
        request.fields['area'] = _areaController.text;
        request.fields['floor'] = floor.text;
        request.fields['bedroom'] = _bedroomsController.text;
        request.fields['bathroom'] = _bathroomsController.text;

        for (var image in _images) {
          request.files
              .add(await http.MultipartFile.fromPath('images[]', image.path));
        }

        var response = await request.send();
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);

        Navigator.pop(context);

        if (jsonResponse['success']) {
          Fluttertoast.showToast(
            msg: 'تمت إضافة العقار بنجاح',
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavigationExample(email: widget.user),
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: 'فشل في إضافة العقار',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: 'حدث خطأ: $e',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      Fluttertoast.showToast(
        msg: 'يرجى ملء جميع الحقول المطلوبة',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "تأكيد إضافة العقار",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'في حال العثور على زبون محتمل للعقار، سيتم التواصل مع المالك من قبل فريق إيجاد هوم. وتُحدد عمولة المنصة بنسبة 2% من قيمة البيع، أو 15% من قيمة الإيجار المستلم من المستأجر. بالضغط على موافق، يقر المالك بقبوله لهذه الشروط.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        "إلغاء",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pop(context);
                              addProperty();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        "موافق",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCupertinoPicker({
    required BuildContext context,
    required List<String> options,
    required Function(String) onSelected,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 420,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text('إلغاء'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    child: Text('تم'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    onSelected(options[index]);
                  },
                  children: options.map((String value) {
                    return Center(
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromARGB(229, 19, 60, 117),
        ),
        title: Text('إضافة عقار',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(229, 19, 60, 117))),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCupertinoPickerField(
                    label: 'اسم العقار',
                    value: _propertyType,
                    options: _propertyTypes,
                    onSelected: (value) {
                      setState(() {
                        _propertyType = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  _buildCupertinoPickerField(
                    label: 'حالة العقار',
                    value: _propertyStatus,
                    options: _propertyStatuses,
                    onSelected: (value) {
                      setState(() {
                        _propertyStatus = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  _buildCupertinoPickerField(
                    label: 'نوع الاستخدام',
                    value: _propertyUsageType,
                    options: _propertyUsageTypes,
                    onSelected: (value) {
                      setState(() {
                        _propertyUsageType = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  _buildCupertinoPickerField(
                    label: 'نوع شهادة العقارية',
                    value: _propertyCertificateType,
                    options: _propertyCertificateTypes,
                    onSelected: (value) {
                      setState(() {
                        _propertyCertificateType = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  _buildCupertinoPickerField(
                    label: 'الحي',
                    value: _districtController,
                    options: _districts,
                    onSelected: (value) {
                      setState(() {
                        _districtController = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  _buildCupertinoPickerField(
                    label: 'اثاث',
                    value: _furnitureStatus,
                    options: _furnitureStatuses,
                    onSelected: (value) {
                      setState(() {
                        _furnitureStatus = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(_priceController, 'السعر', LucideIcons.coins),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                            _areaController, 'المساحة (م²)', LucideIcons.ruler),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                            floor, 'طوابق ', LucideIcons.building),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                      _bedroomsController, 'عدد الغرف', LucideIcons.bed),
                  SizedBox(height: 16),
                  _buildTextField(
                      _bathroomsController, 'عدد الحمامات', LucideIcons.bath),
                  SizedBox(height: 16),
                  _buildTextField(_descriptionController, 'معلومات إضافية',
                      LucideIcons.fileText,
                      maxLines: 5),
                  SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      if (index < _images.length) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(_images[index].path),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _images.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return GestureDetector(
                          onTap: _pickImages,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(LucideIcons.image, color: Colors.grey),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _pickImages,
                    icon: Icon(LucideIcons.image, color: Colors.white),
                    label: Text('تحميل الصور (حد أقصى 8)',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(229, 19, 60, 117),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _showConfirmationDialog,
                    icon: Icon(LucideIcons.send, color: Colors.white),
                    label: Text('إضافة', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType:
          label == 'السعر' ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color.fromARGB(229, 19, 60, 117)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color.fromARGB(229, 19, 60, 117)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Color.fromARGB(229, 19, 60, 117), width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }

  Widget _buildCupertinoPickerField({
    required String label,
    required String value,
    required List<String> options,
    required Function(String) onSelected,
  }) {
    return GestureDetector(
      onTap: () {
        _showCupertinoPicker(
          context: context,
          options: options,
          onSelected: onSelected,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(
              color: value == ' ' || value.isEmpty
                  ? Colors.red
                  : Color.fromARGB(229, 19, 60, 117)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value.isEmpty ? label : value,
              style: TextStyle(
                color: value.isEmpty ? Colors.grey : Colors.black,
              ),
            ),
            Icon(Icons.arrow_drop_down,
                color: Color.fromARGB(229, 19, 60, 117)),
          ],
        ),
      ),
    );
  }
}
