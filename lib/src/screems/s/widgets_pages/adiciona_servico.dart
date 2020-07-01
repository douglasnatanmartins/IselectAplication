import 'dart:io';

import 'package:brasil_fields/modelos/estados.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iselectaplication1990/model/model_servico.dart';
import 'package:iselectaplication1990/widgets/image_source_dialog.dart';
import 'package:iselectaplication1990/widgets/inputCustomizado.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:validadores/validadores.dart';

class AdiconaServicos extends StatefulWidget {

  final double longitude;
  final double latitude;
  final String cidade;
  final String rua;
  final String estado;
  final String pais;
  AdiconaServicos({this.longitude, this.latitude, this.cidade, this.rua, this.estado, this.pais});

  @override
  _AdiconaServicosState createState() =>
      _AdiconaServicosState( longitude,latitude, cidade, rua, estado, pais);
}

class _AdiconaServicosState extends State<AdiconaServicos> {

  double longitude;
  double latitude;
  String cidade;
  String rua;
  String estado;
  String pais;
  var codigoDoPais;

  _AdiconaServicosState(this.latitude, this.longitude, this.cidade, this.rua, this.estado, this.pais);

  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "##############", filter: {"#": RegExp(r'[0-9]')});


  var selecCurrency;
  String _idUsuarioLogado;

  _recuperarDadosDoUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;
  }

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext _dialogContext;

  ModelServico _servico;

  List<File> _listaImagens = List();
  List<DropdownMenuItem<String>> _listaDepartamentos = List();

  _abrirDialog(BuildContext context){
    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  "Salvando Sericio...",
                  style: GoogleFonts.amaranth(
                      textStyle: TextStyle(
                      )
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  _salvarServico() async{

    _servico.cidade = cidade;
    _servico.rua = rua;
    _servico.lat = latitude;
    _servico.long = longitude;
    _servico.pais = pais;
    _servico.estado = estado;


    _abrirDialog(_dialogContext);
    //upload Imagens no storage
    await _uploadImagens();



    //savando dados do Servico
    Firestore db = Firestore.instance;
    db.collection("meus_servicos")
        .document(_idUsuarioLogado)
        .collection("servico").
    document(_servico.id).
    // ignore: unnecessary_statements
    setData(_servico.toMap()).then((_){

      //Salvar Anuncio Publico
      db.collection("servicos")
          .document(_servico.id)
          .setData(_servico.toMap()).then((_){

        Navigator.pop(_dialogContext);
        Navigator.of(context).pop(true);
      });

    });

  }

  Future _uploadImagens() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();

    for(var imagem in _listaImagens){

      String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();

      StorageReference arquivo = pastaRaiz
          .child("Servicos" + _idUsuarioLogado)
          .child(_servico.id)
          .child(nomeImagem);
      StorageUploadTask uploadTask = arquivo.putFile(imagem);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

      String url = await taskSnapshot.ref.getDownloadURL();
      _servico.fotos.add(url);
    }

  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosDoUsuario();
    _carregarItensDropDow();
    _servico = ModelServico.gerarId();
  }

  _carregarItensDropDow(){

    //Estados
    for(var estado in Estados.listaEstadosAbrv){
      _listaDepartamentos.add(
          DropdownMenuItem(child: Text(estado), value: estado,)
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.orange,
          title: Text("Adiccionar Servicio",
              style: GoogleFonts.amaranth(
                  textStyle: TextStyle(color: Colors.black))),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  FormField<List>(
                    initialValue: _listaImagens,
                    validator: (images) {
                      if (images.length == 0) {
                        return "Seleccione al menos 1 image";
                      }
                      return null;
                    },
                    builder: (state) {
                      return Column(
                        children: <Widget>[
                          Container(
                            height: 100,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _listaImagens.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == _listaImagens.length) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  ImageSouceDialog(
                                                    onImageSlected:
                                                        (image) {
                                                      setState(() {
                                                        _listaImagens
                                                            .add(image);
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ));
                                        },
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.grey[200],
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.add_a_photo,
                                                size: 42,
                                                color: Colors.orange[700],
                                              ),
                                              Text(
                                                "Inserir",
                                                style: GoogleFonts.amaranth(
                                                    textStyle: TextStyle(
                                                        color: Colors
                                                            .orange[700],
                                                        fontSize: 18)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  if (_listaImagens.length > 0) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(context: context,
                                              builder: (context) => Dialog(
                                                elevation: 10,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Image.file(_listaImagens[index]),
                                                    RaisedButton(
                                                      color: Colors.red,
                                                      child: Text(
                                                        "Eliminar",
                                                        style: GoogleFonts.acme(
                                                            textStyle: TextStyle(
                                                                color: Colors.white
                                                            )
                                                        ),
                                                      ),
                                                      onPressed: (){
                                                        setState(() {
                                                          _listaImagens.removeAt(index);
                                                          Navigator.of(context).pop();
                                                        });
                                                      },
                                                    )
                                                  ],
                                                ),
                                              )
                                          );
                                        },
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundImage: FileImage(
                                              _listaImagens[index]),
                                          child: Container(
                                            color: Colors.white.withAlpha(100),
                                            alignment: Alignment.center,
                                            child: Icon(Icons.delete, color: Colors.red,),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return Container();
                                }),
                          ),
                          if (state.hasError)
                            Container(
                              padding: EdgeInsets.only(top: 12),
                              child: Text(
                                "[${state.errorText}]",
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                        ],
                      );
                    },
                  ),
                  Row(
                    children: <Widget>[
                      StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance.collection("categoriasdeservico")
                            .orderBy("title").snapshots(),
                        builder: (context, snapshot){
                          if(!snapshot.hasData) {
                            return Center(
                                child: CircularProgressIndicator( ) );
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
                                        hint:Text("Categorias",
                                          style: GoogleFonts.amaranth(
                                              textStyle: TextStyle(
                                                  color: Colors.orange[700]
                                              )
                                          ),

                                        ),
                                        items: currencyItens,
                                        onChanged: (currenceValue){
                                          final snackbar = SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text("Categoria Seleccionada!"),
                                          );
                                          Scaffold.of(context).showSnackBar(snackbar);
                                          setState(() {
                                            selecCurrency = currenceValue;
                                          });
                                        },
                                        onSaved: (categoria){
                                          _servico.categoria = categoria;
                                        },
                                        value: selecCurrency,
                                        validator: (valor){
                                          return Validador()
                                              .add(Validar.OBRIGATORIO,
                                              msg: "Campo Obligatorio")
                                              .valido(valor);
                                        },
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
                  Padding(
                    padding: EdgeInsets.only(bottom: 20, top: 20),
                    child: InputCustomizado(
                      maxLength: 20,
                      labelText: "Titulo",
                      hint: "Titulo",
                      validator: (valor){
                        return Validador()
                            .add(Validar.OBRIGATORIO,
                            msg: "Campo Obligatorio")
                            .valido(valor);
                      },
                      onSaved: (title){
                        _servico.title = title;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: InputCustomizado(
                      maxLength: 15,
                      labelText: "Precio",
                      inputFormatters: [
                        // maskTextInputFormatterPreco
                      ],
                      hint: "G\$ 1.000",
                      onSaved: (preco){
                        _servico.preco = preco;
                      },
                      type: TextInputType.text,
                      validator: (valor){
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                            .valido(valor);
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Container(
                            margin: EdgeInsets.only(right: 4.0),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black, width: 0.5))),
                            child: CountryCodePicker(
                              onChanged: (CountryCode countryCode){
                                _servico.codigoPais = countryCode.toString();
                              },
                              searchDecoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6)
                                ),
                              ),
                              initialSelection: 'BR',
                              favorite: ['+55', 'BR'],
                              textStyle: GoogleFonts.amaranth(
                                  textStyle: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 18
                                  )
                              ),
                            )),
                      ),
                      SizedBox(width: 7),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: InputCustomizado(
                            type: TextInputType.phone,
                            labelText: "WhatsApp",
                            hint: "WhatsApp",
                            inputFormatters: [
                              maskTextInputFormatter,
                            ],
                            validator: (valor){
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                  msg: "Campo Obligatorio")
                                  .valido(valor);
                            },
                            onSaved: (telefone){
                              _servico.telefone = telefone;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: InputCustomizado(
                      labelText: "Descripcción",
                      hint: "Descripcción",
                      maxLines: null,
                      validator: (valor){
                        return Validador()
                            .add(Validar.OBRIGATORIO,
                            msg: "Campo Obligatorio")
                            .maxLength(200, msg: "Maximo 350 caracteres")
                            .valido(valor);
                      },
                      onSaved: (desc){
                        _servico.desc = desc;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        //salvando os Campos
                        _formKey.currentState.save();

                        //configurando o contexto do dialogo
                        _dialogContext = context;

                        //savar servico
                        await _salvarServico();

                      }
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width -100,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                              colors: [
                                Colors.orange[700],
                                Colors.orange[500],
                                Colors.orange[300],
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomCenter),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.save),
                            SizedBox(),
                            Text(
                              " Salvar",
                              style: GoogleFonts.amaranth(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
