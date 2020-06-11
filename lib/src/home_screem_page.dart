import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iselectaplication1990/model/model_servico.dart';
import 'package:iselectaplication1990/src/screems/s/pages/detalhe_anuncio.dart';
import 'package:iselectaplication1990/src/tiles/item_servico_tile.dart';

class HomeScreemPage extends StatefulWidget {
  @override
  _HomeScreemPageState createState() => _HomeScreemPageState();
}

class _HomeScreemPageState extends State<HomeScreemPage> {
  final TextEditingController _searchQuery = TextEditingController();
  final _controller = StreamController<QuerySnapshot>.broadcast();


  bool isSerach = false;
  var selecCurrency;

  Future<Stream<QuerySnapshot>> _filtrarServicos() async {
    Firestore db = Firestore.instance;
    Query query = db.collection("servicos");

    if(selecCurrency != null ){
      query = query.where("categoria", isEqualTo: selecCurrency);
    }

    Stream<QuerySnapshot> stream = query.snapshots();
    stream.listen((dados){
      _controller.add(dados);
    });
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerAnuncios() async {

    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("servicos")
        .snapshots();

    stream.listen((dados){
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();
    isSerach = false;
    _adicionarListenerAnuncios();

  }


  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.orange,
          title: !isSerach ? Text(
            "Servicios",
            style: GoogleFonts.amaranth(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 22
                )
            ),
          ): TextField(
            controller: _searchQuery,
            decoration: InputDecoration(
              hintText: "Buscar",
              icon: Icon(Icons.search),
            ),
          ),
          actions: [
            IconButton(
              icon:!isSerach ? Icon(Icons.search, color: Colors.black,):
              Icon(Icons.cancel, color: Colors.black,),
              onPressed: (){
                setState(() {
                  this.isSerach = !this.isSerach;
                });
              },
            )
          ],
        ),
        body: Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection("categoriasdeservico")
                          .orderBy("title").snapshots(),
                      builder: (context, snapshot){
                        if(!snapshot.hasData) {
                          return Center(
                              child: CircularProgressIndicator());
                        } else {

                          List<DropdownMenuItem> currencyItens=[];

                          for(int i= 0; i< snapshot.data.documents.length; i++ ){
                            DocumentSnapshot snap = snapshot.data.documents[i];
                            currencyItens.add(
                                DropdownMenuItem(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        snap.data["title"],
                                        style: GoogleFonts.amaranth(
                                            textStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                  value: "${snap.documentID}",
                                )
                            );
                          }
                          return Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                                          border: InputBorder.none
                                      ),
                                      hint:Text("Categorias",
                                        style: GoogleFonts.amaranth(
                                            textStyle: TextStyle(
                                                color: Colors.orange[700]
                                            )
                                        ),

                                      ),
                                      items: currencyItens..add(
                                          DropdownMenuItem(
                                              child: Text("Categoria - [sin filtros]", style: TextStyle(
                                                  color: Colors.orange[800],
                                                  fontSize: 20
                                              ),
                                              ),
                                              value: null
                                          )
                                      ),
                                      onChanged: (currenceValue){
                                        setState(() {
                                          selecCurrency = currenceValue;
                                          _filtrarServicos();
                                        });
                                      },
                                      value: selecCurrency,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
                StreamBuilder(
                  stream: _controller.stream,
                  builder: (context, snapshot){
                    switch(snapshot.connectionState){
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                        break;
                      case ConnectionState.active:
                      case ConnectionState.done:

                        QuerySnapshot querySnapshot = snapshot.data;

                        if( querySnapshot.documents.length == 0 ){
                          return Container(
                            padding: EdgeInsets.all(25),
                            child: Text("Nenhum servicio encontrado! :( ", style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),),
                          );
                        }
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: (orientation == Orientation.portrait) ? 2 :3,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 0.7,
                                    mainAxisSpacing: 10
                                ),
                                itemCount: querySnapshot.documents.length,
                                itemBuilder: (_, index){

                                  List<DocumentSnapshot> servicos =
                                  querySnapshot.documents.toList();
                                  DocumentSnapshot documentSnapshot = servicos[index];
                                  ModelServico servico = ModelServico.fromdocumentSnapshot(documentSnapshot);
                                  // print(servico);

                                  return ItemServicoHomeTile(
                                    servico: servico,
                                    onTapItem: (){
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => DetalheAnuncio(servico)
                                      ));
                                    },
                                  );

                                }
                            ),
                          ),
                        );
                    }
                    return Container();
                  },
                )
              ],
            )
        )
    );
  }
}