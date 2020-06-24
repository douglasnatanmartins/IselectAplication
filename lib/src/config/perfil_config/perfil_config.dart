import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iselectaplication1990/componentes/localizacao.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:validadores/validadores.dart';


class PerfilConfig extends StatefulWidget {
  @override
  _PerfilConfigState createState() => _PerfilConfigState();
}

class _PerfilConfigState extends State<PerfilConfig> {

  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _telefonecontroller = TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "+### #### ######", filter: {"#": RegExp(r'[0-9]')});


  File _image;
  String _idUsuarioLogado;
  String _name;
  String _telefone;
  bool _subindoImagen = false;
  String _urlImagemRecuperada;

  Future _recuperarImagem(String origemImagen) async {

    File imagemSelecionanda;

    switch(origemImagen){
      case "Camera":
      // ignore: deprecated_member_use
        imagemSelecionanda = await ImagePicker.pickImage(
            source: ImageSource.camera);
        break;
      case "Galeria":
      // ignore: deprecated_member_use
        imagemSelecionanda = await ImagePicker.pickImage(
            source: ImageSource.gallery);
        break;
    }
    setState(() {
      _image = imagemSelecionanda;
      if(_image != null){
        _subindoImagen = true;
        _uploadImage();
      }
    });
  }

  Future _uploadImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("perfil").child(_idUsuarioLogado + ".jpg");
    //upload Imagem
    StorageUploadTask task = arquivo.putFile(_image);
    //Controllar o Prograsso
    task.events.listen((StorageTaskEvent storageTaskEvent){
      if(storageTaskEvent.type == StorageTaskEventType.progress){
        setState(() {
          _subindoImagen = true;
        });
      }  else if(storageTaskEvent.type == StorageTaskEventType.success){
        setState(() {
          _subindoImagen = false;
        });
      }
    });
    task.onComplete.then((StorageTaskSnapshot snapshot){
      _recuperarUrlImage(snapshot);
    });
  }

  Future _recuperarUrlImage(StorageTaskSnapshot snapshot) async {

    String url = await snapshot.ref.getDownloadURL();
    _atualizarUrlImagenFirestore(url);
    setState(() {
      _urlImagemRecuperada = url;
    });
  }

  _atualizarUrlImagenFirestore(String url){
    Firestore db = Firestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      "icon": url
    };

    db.collection("users").document(_idUsuarioLogado).updateData(dadosAtualizar);
  }

  _atualizarDadosFirestore(){
    String nome = _namecontroller.text;
    String tel = _telefonecontroller.text;
    Firestore db = Firestore.instance;

    Map<String, dynamic> dadosAtualizarNome = {
      "name": nome,
      "telefone": tel
    };
    db.collection("users")
        .document(_idUsuarioLogado)
        .updateData(dadosAtualizarNome)
        .then((_){

      showDialog(context: context,
        builder: (context) => Dialog(
          elevation: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10, right: 12, left: 12),
                child: Text(
                  "Dados salvos com Sucesso",
                  style: TextStyle(
                      color: Colors.green[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 12),
                    child: RaisedButton(
                      elevation: 3,
                      color: Colors.green,
                      child: Text(
                        "Ok",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white
                        ),
                      ),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              )
            ],
          ),
          insetAnimationDuration: Duration(milliseconds: 800),
        ),
      ).then((_){
        Navigator.of(context).pop(true);
      });
    });
  }

  _recuperarDadosDoUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("users")
        .document(_idUsuarioLogado).get();

    Map<String, dynamic> dados = snapshot.data;
    _namecontroller.text = dados["name"];
    _telefonecontroller.text = dados["telefone"];

    if(dados["icon"] != null){
      setState(() {
        _urlImagemRecuperada = dados["icon"];
      });
    }
    if(dados["name"] != null){
      setState(() {
        _name = dados["name"];
      });
    }
    if(dados["telefone"] != null){
      setState(() {
        _telefone = dados["telefone"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosDoUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.orange,
          title: Text(
            "Editar Perfil",
            style: GoogleFonts.amaranth(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500)),
          ),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.only(top: 20, left: 16, right: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: _subindoImagen
                              ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                          )
                              : Container(),
                        ),
                        SizedBox(width: 20),
                        Text(_subindoImagen ? "Loading..." : "",
                          style: GoogleFonts.acme(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54
                              )
                          ),)
                      ],
                    ),
                  ),
                  CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey,
                      backgroundImage: _urlImagemRecuperada != null ?
                      NetworkImage(_urlImagemRecuperada) : AssetImage("images/ideia.jpg")
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.linked_camera, color: Colors.orange[900],),
                            SizedBox(width: 5.0),
                            Text(
                              "Camera",
                              style: TextStyle(
                                color: Colors.orange[900],
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          _recuperarImagem("Camera");
                        },
                      ),
                      SizedBox(width: 35.0),
                      FlatButton(
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Galeria",
                              style: TextStyle(
                                color: Colors.orange[900],
                              ),
                            ),
                            SizedBox(width: 5.0),
                            Icon(Icons.image, color: Colors.orange[900],),
                          ],
                        ),
                        onPressed: () {
                          _recuperarImagem("Galeria");
                        },
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, bottom: 12),
                          child: TextFormField(
                            controller: _namecontroller,
                            autofocus: false,
                            keyboardType: TextInputType.text,
                            style: GoogleFonts.amaranth(
                              textStyle: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.grey[700]
                              ),
                            ),
                            // ignore: missing_return
                            validator: (text){
                              if(text.isEmpty || text.length <= 5){
                                return "Nombre Invalido, debe contener 5 caracteres";
                              }
                            },
                            cursorColor:  Colors.orange[900],
                            decoration: InputDecoration(
                              icon: Icon(Icons.person, color: Colors.orange,),
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            controller: _telefonecontroller,
                            inputFormatters: [
                              maskTextInputFormatter
                            ],
                            autofocus: false,
                            keyboardType: TextInputType.phone,
                            style: GoogleFonts.amaranth(
                              textStyle: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.grey[700]
                              ),
                            ),
                            validator: (text) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                  msg:
                                  "Intente un telefono válido")
                                  .minLength(6)
                                  .valido(text);
                            },
                            cursorColor:  Colors.orange[900],
                            decoration: InputDecoration(
                              hintText: "+595 1234 123456",
                              icon: Icon(Icons.phone, color: Colors.orange,),
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        )
                    ),
                  ),
                  SizedBox(height: 7),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Localizacao()));
                          final snackbar = SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("Localización Guardada!"),
                          );
                          Scaffold.of(context).showSnackBar(snackbar);
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width -200,
                            height: 50,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[700],
                                    blurRadius: 4.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(1.0, 1.0),
                                  )
                                ],
                                gradient: LinearGradient(colors: [
                                  Colors.orange[400],
                                  Colors.orange[300],
                                  Colors.orange[200],
                                ], begin: Alignment.bottomRight, end: Alignment.topLeft),
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.add_location),
                                SizedBox(),
                                Text(
                                  "Elija su Ubicación",
                                  style: GoogleFonts.amaranth(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      child: GestureDetector(
                        onTap: () {
                          if(_formKey.currentState.validate()){
                            salvando();
                            _atualizarDadosFirestore();

                          }
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width -80,
                            height: 58,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[700],
                                    blurRadius: 4.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(1.0, 1.0),
                                  )
                                ],
                                gradient: LinearGradient(colors: [
                                  Colors.orange[400],
                                  Colors.orange[300],
                                  Colors.orange[200],
                                ], begin: Alignment.bottomRight, end: Alignment.topLeft),
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.save),
                                SizedBox(width: 10,),
                                Text(
                                  "Salvar",
                                  style: GoogleFonts.amaranth(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  void salvando(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text(
          "Salvando dados...!!!",
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
    );
  }
}