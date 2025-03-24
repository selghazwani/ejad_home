import 'package:flutter/material.dart';
import 'package:flutter_application_1/tests/fliter_result.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchFilterPage extends StatefulWidget {
  @override
  _SearchFilterPageState createState() => _SearchFilterPageState();
}

class _SearchFilterPageState extends State<SearchFilterPage> {
  String propertyState = "الكل";
  String district = "الكل";
  String propertyType = "سكني";
  RangeValues priceRange = RangeValues(50000, 500000);
  int bedrooms = 1;
  int bathrooms = 1;

  final List<String> districts = [
    "الكل",
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

  Future<void> searchProperties() async {
    final url = Uri.parse("https://ejad-home.ly/searchProperty.php");
    final response = await http.post(
      url,
      body: {
        "state": propertyState,
        "location": district,
        "type": propertyType,
        "min_price": priceRange.start.toString(),
        "max_price": priceRange.end.toString(),
        "bedrooms": bedrooms.toString(),
        "bathrooms": bathrooms.toString(),
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FilteredResultsPage(results: data),
        ),
      );
    } else {
      print("فشل في جلب نتائج البحث");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text("بحث وتصنيف", style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("حالة العقار"),
            _buildChoiceChips(),
            SizedBox(height: 20),
            _buildSectionTitle("المنطقة"),
            _buildDistrictDropdown(),
            SizedBox(height: 20),
            _buildSectionTitle("نوع العقار"),
            _buildPropertyChips(),
            SizedBox(height: 20),
            _buildSectionTitle("نطاق السعر"),
            _buildPriceRangeSlider(),
            SizedBox(height: 20),
            _buildCountersRow(),
            SizedBox(height: 30),
            _buildSearchButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildChoiceChips() {
    return Wrap(
      spacing: 8.0,
      children: ["الكل", "للبيع", "للإيجار"].map((label) {
        return ChoiceChip(
          label: Text(
            label,
          ),
          selected: propertyState == label,
          onSelected: (selected) {
            setState(() {
              propertyState = label;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildDistrictDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<String>(
        value: district,
        isExpanded: true,
        underline: SizedBox(),
        items: districts.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(fontSize: 16)),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            district = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildPropertyChips() {
    return Wrap(
      spacing: 8.0,
      children: ["سكني", "تجاري"].map((label) {
        return ChoiceChip(
          label: Text(label),
          selected: propertyType == label,
          onSelected: (selected) {
            setState(() {
              propertyType = label;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildPriceRangeSlider() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          RangeSlider(
            activeColor: Color.fromARGB(229, 19, 60, 117),
            values: priceRange,
            min: 50000,
            max: 5000000,
            divisions: 10,
            labels: RangeLabels(
              "${priceRange.start.toInt()}",
              "${priceRange.end.toInt()}",
            ),
            onChanged: (RangeValues values) {
              setState(() {
                priceRange = values;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${priceRange.start.toInt()}"),
              Text("${priceRange.end.toInt()}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountersRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCounter("عدد الغرف", bedrooms, (value) {
          setState(() => bedrooms = value);
        }),
        _buildCounter("عدد الحمامات", bathrooms, (value) {
          setState(() => bathrooms = value);
        }),
      ],
    );
  }

  Widget _buildCounter(String label, int value, Function(int) onChanged) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.black87)),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove, color: Color.fromARGB(229, 19, 60, 117)),
              onPressed: () {
                if (value > 1) onChanged(value - 1);
              },
            ),
            Text("$value",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              icon: Icon(Icons.add, color: Color.fromARGB(229, 19, 60, 117)),
              onPressed: () {
                onChanged(value + 1);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchButton() {
    return Center(
      child: ElevatedButton(
        onPressed: searchProperties,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(229, 19, 60, 117),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text("بحث", style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}

class CustomChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Function(bool) onSelected;

  const CustomChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label), // Use `Text` for the label
      selected: selected,
      onSelected: onSelected,
      selectedColor: Color.fromARGB(229, 19, 60, 117),
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black87,
      ),
      backgroundColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}
