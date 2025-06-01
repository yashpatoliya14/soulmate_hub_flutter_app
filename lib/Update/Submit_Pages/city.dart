import 'package:matrimony_flutter/Home/user_list/user_controllers.dart';
import 'package:matrimony_flutter/Home/user_list/user_model.dart';
import 'package:matrimony_flutter/Update/Submit_Pages/Hobbies.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';

class City extends StatefulWidget {
  const City({super.key});

  @override
  State<City> createState() => _CityState();
}

class _CityState extends State<City> {
  GlobalKey<FormState> _city = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isDisplayFloatButton = false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Form(
        key: _city,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenWidth * 0.2),
                Container(
                  child: Text(
                    "Select your city",
                    style: GoogleFonts.nunito(
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.1),
                Container(
                  width: screenWidth * 0.9,
                  margin: EdgeInsets.all(screenWidth * 0.025),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0), // Softer corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(2, 2), // Subtle shadow
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedCity ?? cities[0],
                    decoration: InputDecoration(
                      border: InputBorder.none, // Removes the default border
                      contentPadding: EdgeInsets.zero,
                    ),
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.purple,
                    ), // Stylish dropdown icon
                    dropdownColor: Colors.white,
                    items:
                        cities.map((city) {
                          return DropdownMenuItem(
                            value: city,
                            child: Text(
                              city,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedCity = value!;
                        cityError = validateCity(selectedCity);
                      });
                    },
                    validator:
                        (value) =>
                            value == null
                                ? "Please select a city"
                                : null, // Validation
                  ),
                ),
                buildButton(
                  label: "Save",
                  textColor: Colors.white,
                  backgroundColor: Colors.purple,
                  icon: Icon(Iconsax.next, color: Colors.white),
                  onPressed: () async {
                    SharedPreferences prefs =
                    Get.find<SharedPreferences>();
                    if(selectedCity!=null){

                    UserModel userModel = UserModel(CITY: selectedCity!);
                    UserOperations userOperations = UserOperations();
                    userOperations.updateUserByEmail(email: Auth().currentUser!.email.toString(), updatedData: userModel.toJson());

                                          Get.to(Hobbies(),transition: Transition.fade);
                    }else{
                      Get.snackbar("Select Your City", "Try Again!");
                    }

                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
