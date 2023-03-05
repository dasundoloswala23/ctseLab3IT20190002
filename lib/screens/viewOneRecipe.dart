import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/recipeModel.dart';
import 'ViewAllRecipe.dart';


class ViewOneRecipeScreen extends StatefulWidget {
  const ViewOneRecipeScreen({Key? key, required this.id})
      : super(key: key);
  final String id;

  @override
  State<ViewOneRecipeScreen> createState() =>
      _ViewOneRecipeScreenScreenState();
}

class _ViewOneRecipeScreenScreenState
    extends State<ViewOneRecipeScreen> {
  Recipe? oneRecipe;
  bool loading = false;

  @override
  initState() {
    super.initState();
    loading = true;

    getRecipe();
  }

  //uploading the image , then getting the download url and then
  //adding that download url to our cloud fire store



  //snackbar for  showing error
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> getRecipe() async {
    final id = widget.id;
    final reference = FirebaseFirestore.instance.doc('recipes/$id');
    final snapshot = reference.get();

    final result = await snapshot.then((snap) =>
    snap.data() == null ? null : Recipe.fromJson(snap.data()!));
    print('result is ====> $result');
    setState(() {
      oneRecipe= result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.id);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "View One Recipe",
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.black,

            decorationColor: Colors.redAccent,
            // fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body:loading // <--- added this
          ? Center(child: CircularProgressIndicator()) :
      Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(oneRecipe!.recipeName,
                  style: const TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: 45),
              const SizedBox(
                height: 20,
              ),
              Text( oneRecipe!.description,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500)),
              Text( oneRecipe!.ingredients,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500)),


            ],
          ),
        ),
      ),
    );
  }



  void delete() {
    final id = widget.id;
    FirebaseFirestore.instance.doc('recipes/$id').delete().whenComplete(() =>
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomeScreen())));
  }

//
}
