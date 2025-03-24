class OnBoardingEntity {
  final String image;
  final String heading;
  final String description;

  OnBoardingEntity(
      {required this.image, required this.heading, required this.description});

  static List<OnBoardingEntity> onBoardingData = [
    OnBoardingEntity(
        image: 'assets/slide-two.jpg',
        description: "",
        heading: "كل عقار، في مكانك المفضل"),
    OnBoardingEntity(
        image: 'assets/slide-two-2.png',
        description: "",
        heading: "نساعدك في إيجاد بيتك الجديد"),
    OnBoardingEntity(
        image: 'assets/slide-two-3.png',
        description: "",
        heading: "ابحث، اختر، اسكن"),
    OnBoardingEntity(
        image: 'assets/slide-two-4.png',
        description: "",
        heading: "حلول عقارية مبتكرة لراحتك"),
  ];
}
