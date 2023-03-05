import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctserecipeapplabtest/screens/updateRecipe.dart';
import 'package:ctserecipeapplabtest/screens/viewOneRecipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../models/recipeModel.dart';
import 'addRecipe.dart';
import 'login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Recipe> recipes = [];

  void _deleteTask(int index) {
    setState(() {

      recipes.removeAt(index);
    });
  }

  // fetch data from collection
  @override
  Future<List<Recipe>> fetchRecords() async {
    var records = await FirebaseFirestore.instance.collection('recipes').get();
    return mapRecords(records);
  }
  List<Recipe> mapRecords(QuerySnapshot<Object?>? records) {
    var _list = records?.docs
        .map(
          (recipes) => Recipe(
        id: recipes.id,
            recipeName: recipes['recipeName'],
            description: recipes["description"],
            ingredients: recipes["ingredients"],
      ),
    )
        .toList();

    return _list ?? [];
  }
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Recipe List'),
          actions: [
            IconButton(
              onPressed: () {
                logout(context);
              },
              icon: Icon(Icons.logout),
            )
          ],
        ),
        body: Scrollbar(
          isAlwaysShown: true,
          child: SizedBox(
            width: width * 1,
            height: height * 1,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Recipe> data = mapRecords(snapshot.data);
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height:  height * 0.20,
                        child: Card(
                          color: Colors.blue.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.redAccent,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                child:  Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Padding(
                                    padding:  EdgeInsets.only(left: 1),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              data[index].recipeName,
                                              style: const TextStyle(color: Colors.black,fontSize: 30),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              data[index].description,
                                              style: const TextStyle(color: Colors.black,fontStyle: FontStyle.italic),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20),
                                          child: Row(
                                            children: [
                                              Text(
                                                data[index].ingredients,
                                                style: const TextStyle(color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left:120,top: 10),
                                          child: Row(
                                            children: [
                                              ElevatedButton(
                                                child: Text('View'),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewOneRecipeScreen(
                                                                id: data[
                                                                index]
                                                                    .id,
                                                              )));
                                                },
                                              ),
                                              SizedBox(
                                                width:  5,
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await FirebaseFirestore.instance
                                                      .collection('recipes')
                                                      .doc(data[index].id)
                                                      .delete();
                                                },
                                                child: Text("Delete"),
                                                style: ButtonStyle(
                                                  textStyle: MaterialStateProperty.all(
                                                    const TextStyle(fontSize: 12),
                                                  ),
                                                  backgroundColor: MaterialStateProperty.all(
                                                    Colors.red,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width:  5,
                                              ),
                                              ElevatedButton(
                                                child: Text('Edit'),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewOneRecipeUpdateScreen(
                                                                id: data[
                                                                index]
                                                                    .id,
                                                              )));
                                                },
                                              ),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),

          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        AddRecipe( )));
          },
          child: Icon(Icons.add),
        ),

      ),
    );
  }
}

