import 'package:matrimony_flutter/Utils/importFiles.dart';

Widget getTextFormField({
  controller,
  label,
  errorMsg,
  icon,
  inputFormator,
  Function? validateFun,
  keyboardType,
  onTap,
  readOnly,
  hideText,
  suffixIcon,
  focusNode,
  onChanged,
  fillColor,
  labelColor,
  iconColor,
  contentColor,
  onEditingComplete
}){
  return StatefulBuilder(
    builder: (context,setState){
      return TextFormField(
        controller: controller,
        focusNode: focusNode,
        cursorColor: Colors.purple.shade100,
        decoration: InputDecoration(
          labelStyle: GoogleFonts.nunito(color: labelColor ?? Colors.black),
          contentPadding: EdgeInsets.all(20),
          labelText: label,
          hintStyle: GoogleFonts.nunito(color: labelColor ?? Colors.black),
          errorText: errorMsg,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Colors.black12)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Colors.purple)
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          fillColor: fillColor ?? Colors.white,
          filled: true,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(icon,size: 25,color: iconColor ?? Colors.black,),
          ),
          suffixIcon: suffixIcon,
        ),
        keyboardType: keyboardType,

        inputFormatters:inputFormator ?? [],

        validator: (value) {
          return validateFun!(value);
        },
        
        style:GoogleFonts.nunito(
          color: contentColor ?? Colors.black
        ),

        onChanged: (value) {
          setState(() {
            errorMsg = validateFun!(value);
          });
          if(onChanged!=null){
            onChanged();
          }
        },
        obscureText: hideText ?? false,

        readOnly: readOnly!=null?true:false,
        onTap: onTap,

      );
    },
  );
}

Widget buildFloatingActionButton(
  {
    required BuildContext context,
    required Function onPressed,
  }

){
  return FloatingActionButton(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                onPressed: (){
                  onPressed();
                },
                child: Icon(Iconsax.arrow_circle_right));
}


Widget getRadioButtonError(context) {
  if (genderError != null) {
    return Text(
      genderError!,
      style: TextStyle(color: Colors.redAccent),
    );
  }
  return SizedBox.shrink();
}

Widget getCityError(context) {
  if (cityError != null) {
    return Container(
        child: Text(
          cityError!,
          style: TextStyle(color: Colors.redAccent),
        ));
  }
  return SizedBox.shrink();
}

Widget getHobbiesError(context) {
  if (hobbiesError != null) {
    return Container(
      child: Text(
        hobbiesError!,
        style: TextStyle(color: Colors.redAccent),
      ),
    );
  }
  return SizedBox.shrink();
}