class Onboarding {
  final String title;
  final String description;
  final String image;

  Onboarding(
      {required this.title, required this.description, required this.image});
}

// list
List<Onboarding> contents = [
  Onboarding(
      title: "Choose Your Product",
      description: "Welcome to EasyShop - Your Perfect Product Awaits!",
      image: "assets/onboarding/Page1.gif"),
  Onboarding(
      title: "Select Payment Method",
      description:
          "For Seamless Transactions, Choose Your Payment Path - Your Convenience, Our Priority!",
      image: "assets/onboarding/Page2.gif"),
  Onboarding(
      title: "Delivery At Your Door Step",
      description:
          "From Our Doorstep to Yours - Swift, Secure, and Contactless Delivery!",
      image: "assets/onboarding/Page3.gif")
];
