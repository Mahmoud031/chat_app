import 'package:flutter/material.dart';

class CustomFormTextfield extends StatelessWidget {
   CustomFormTextfield({
    super.key,this.hintText,this.onChanged,this.obscureText =false
  });
  Function(String)? onChanged; 
  String? hintText;

  bool? obscureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText!,
      //used to make the validation to the data
      validator: (data){
        if(data!.isEmpty){
          return 'field is required';
        }
      },
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white
        ),
        enabledBorder:const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white
          )
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue
          )
        )
      ),
    );
  }
}