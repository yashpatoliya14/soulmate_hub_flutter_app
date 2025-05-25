import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:matrimony_flutter/Home/user_list/user_controllers.dart';
import 'package:matrimony_flutter/Home/user_list/user_model.dart';
import 'package:matrimony_flutter/Userform/Submit_Pages/gender.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
class NameProfilephoto extends StatefulWidget {
  const NameProfilephoto({super.key});

  @override
  State<NameProfilephoto> createState() => _NameProfilephotoState();
}

class _NameProfilephotoState extends State<NameProfilephoto> {
  GlobalKey<FormState> _name_profile = GlobalKey();

  Future<bool> requestMediaPermission() async {
    var status = await Permission.photos.request();
    return status.isGranted;
  }
  Future<String?> uploadImageToCloudinary(File imageFile) async {
    const cloudName = 'dpplqlawt';
    const uploadPreset = 'soulmate_hub';

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final mimeType = lookupMimeType(imageFile.path);
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: mimeType != null ? MediaType.parse(mimeType) : null,
      ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final resJson = jsonDecode(resStr);
      return resJson['secure_url']; // This is the Cloudinary image URL
    } else {
      print('Cloudinary upload failed: ${response.statusCode}');
      return null;
    }
  }
    String? imgUrl = "https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Form(
        key: _name_profile,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenWidth * 0.2),
                Container(
                  child: Text(
                    "Profile details",
                    style: GoogleFonts.nunito(
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.1),
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(imgUrl ?? ""),
                  radius: 75,
                ),
                SizedBox(height: screenWidth * 0.1),
                buildButton(
                  label: imgUrl !=null ? "Re-upload":"Upload",
                  textColor: Colors.white,
                  backgroundColor: Colors.purple,
                  onPressed: ()async{
                    final picker = ImagePicker();
                    bool granted = await requestMediaPermission();
                    if (!granted) {
                      print("Permission not granted");
                      return;
                    }
                    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                    if (pickedFile != null) {
                      final file = File(pickedFile.path);
                      final imageUrl = await uploadImageToCloudinary(file);

                      if (imageUrl != null) {
                        print('Image uploaded to: $imageUrl');
                        setState(() {
                          imgUrl = imageUrl;
                        });
                      }
                    }
                  }
                ),
                SizedBox(height: screenWidth * 0.1),
                Container(
                  width: screenWidth * 0.9,
                  margin: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.025,
                  ),
                  child: getTextFormField(
                    controller: fullnameController,
                    label: 'Full Name',
                    errorMsg: firstNameError,
                    icon: Iconsax.user,
                    validateFun: validateFirstName,
                  ),
                ),
                SizedBox(height: screenWidth * .02),
                Container(
                  width: screenWidth * 0.9,
                  margin: EdgeInsets.all(screenWidth * 0.025),
                  child: getTextFormField(
                    controller: dobController,
                    readOnly: true,
                    label: "Date of birth",
                    errorMsg: dobError,
                    validateFun: validateDOB,
                    icon: Iconsax.calendar,
                    labelColor: Colors.purple.shade400,
                    iconColor: Colors.purple.shade400,
                    contentColor: Colors.purple.shade400,
                    fillColor: Colors.purple.shade50,
                    onChanged: (value) {},
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate!,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                          dobController.text = DateFormat(
                            "dd/MM/yyyy",
                          ).format(selectedDate!); // Change format here
                          dobError = validateDOB(dobController.text);
                        });
                      }
                    },
                  ),
                ),
                buildButton(
                  label: "Next",
                  textColor: Colors.white,
                  backgroundColor: Colors.purple,
                  icon: Icon(Iconsax.next, color: Colors.white),
                  onPressed: () async {
                    if (_name_profile.currentState!.validate()) {
                      SharedPreferences prefs = Get.find<SharedPreferences>();
                      UserModel userModel = UserModel(FULLNAME: fullnameController.text,DOB: dobController.text,PROFILEPHOTO: imgUrl );
                      UserOperations userOperations = UserOperations();
                      userOperations.updateUserByEmail(email: prefs.getString("email").toString(), updatedData: userModel.toJson());
                     
                      Get.to(Gender(),transition: Transition.fade);
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
