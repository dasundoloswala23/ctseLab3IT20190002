import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ViewAllRecipe.dart';


class AddRecipe extends StatefulWidget {

  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  Future<void> taskAdd () async {

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    //uploading to cloudfirestore
    await firebaseFirestore.collection("recipes").doc().set({
      "recipeName": recipeName.text,
      "description": description.text,
      "ingredients" :ingredients.text,// set isCompleted field to false
    }).whenComplete(() => {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomeScreen())),
      showSnackBar("Recipe added successfully", const Duration(seconds: 2))
    });
  }
  //snackbar for  showing error
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  TextEditingController  recipeName =  TextEditingController();
  TextEditingController  description =  TextEditingController();
  TextEditingController  ingredients =  TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Recipe Name',
                ),
                controller:  recipeName,
              ),
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Recipe description',
                ),
                controller: description,
              ),TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Recipe ingredients',
                ),
                controller: ingredients,
              ),


              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    taskAdd();
                  },
                  child: Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
