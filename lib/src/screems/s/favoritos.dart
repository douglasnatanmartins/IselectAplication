import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iselectaplication1990/model/model_servico.dart';
import 'package:iselectaplication1990/src/screems/s/widgets_pages/detalhe_anuncio.dart';
import 'package:iselectaplication1990/src/tiles/item_servico_favorito.dart';


class Favoritos extends StatefulWidget {
  @override
  _FavoritosState createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {

  final _controller = StreamController<QuerySnapshot>.broadcast();


  bool isSerach = false;
  var selecCurrency;
  String _idUsuarioLogado;



  _recuperarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerFavoritos() async  {
    await _recuperarUsuario(); /// Recuperar o Usuario antes de executar a consulta


    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("meus_favoritos")
        .document(_idUsuarioLogado).collection("favoritos")
        .snapshots();

    stream.listen((dados){
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperarUsuario();
    _adicionarListenerFavoritos();
  }

  @override
  Widget build(BuildContext context) {

    final orientation = MediaQuery.of(context).orientation;

    return Container(
        child: Column(
          children: <Widget>[
            /* Row(
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
              ),*/
            SizedBox(height: 25),
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
                          child: Center(
                            child: Text("Ningún Favorito! :( ", style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),),                          )
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
                              ModelServico favorito = ModelServico.fromdocumentSnapshot(documentSnapshot);


                              return ItemServicoFavoritos(
                                servico: favorito,
                                onTapItem: (){
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DetalheAnuncio(favorito)
                                  ));
                                }, onTapRemover:null,
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
    );
  }
}