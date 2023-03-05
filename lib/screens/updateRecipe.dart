import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/recipeModel.dart';

class ViewOneRecipeUpdateScreen extends StatefulWidget {
  final String id;

  const ViewOneRecipeUpdateScreen({Key? key, required this.id}) : super(key: key);

  @override
  _ViewOneRecipeUpdateScreenState createState() =>
      _ViewOneRecipeUpdateScreenState();
}
Recipe? oneRecipe;
bool loading = false;
class _ViewOneRecipeUpdateScreenState
    extends State<ViewOneRecipeUpdateScreen> {
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();

  @override
  initState() {
    super.initState();
    loading = true;

    getRecipes();
  }
  Future<void> getRecipes() async {
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
    _recipeNameController.text = oneRecipe!.recipeName ;
    _descriptionController.text = oneRecipe!.description;
    _ingredientsController.text = oneRecipe!.ingredients;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Recipe"),
      ),
      body: loading ?
          Center(child: CircularProgressIndicator()) : Container(
               child :SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _recipeNameController,
                          decoration: InputDecoration(
                            labelText: "name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: "description",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _ingredientsController,
                          decoration: InputDecoration(
                            labelText: "ingredients",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('recipes')
                                .doc(widget.id)
                                .update({
                              'recipeName': _recipeNameController.text,
                              'description':      _descriptionController.text,
                            'ingredients':    _ingredientsController.text

                            });

                            Navigator.pop(context);
                          },
                          child: Text("Save"),
                        ),
                      ),
                    ],
                  ),
                ),),);

              }
            }


