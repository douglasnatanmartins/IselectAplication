
import 'package:brasil_fields/modelos/estados.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iselectaplication1990/model/model_servico.dart';
import 'package:iselectaplication1990/src/edita_servico/componentes/images_form.dart';
import 'package:iselectaplication1990/widgets/inputCustomizado.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:validadores/validadores.dart';

class EditaServico extends StatefulWidget {

  ModelServico servico;

  EditaServico(this.servico);

  @override
  _EditaServicoState createState() => _EditaServicoState();
}

class _EditaServicoState extends State<EditaServico> {



  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "##############", filter: {"#": RegExp(r'[0-9]')});

  var selecCurrency;
  String _idUsuarioLogado = "Não ten id";

  String idRecuperado;

  _recuperarDadosDoUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    await widget.servico.getFirebaseUser();
  }

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext _dialogContext;


  List<DropdownMenuItem<String>> _listaDepartamentos = List();

  _abrirDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  "Salvando Sericio...",
                  style: GoogleFonts.amaranth(textStyle: TextStyle()),
                )
              ],
            ),
          );
        });
  }

  _salvarServico() async {
    _abrirDialog(_dialogContext);
    //upload Imagens no storage
    await widget.servico.saveImages();

    //savando dados editados no Servico
    Firestore db = Firestore.instance;
    db
        .collection("meus_servicos")
        .document(_idUsuarioLogado)
        .collection("servico")
        .document(widget.servico.id)
        .updateData(widget.servico.toMap())
        .then((_) {
      //Salvando dados editados no Anuncio Publico
      db
          .collection("servicos")
          .document(widget.servico.id)
          .updateData(widget.servico.toMap())
          .then((_) {

            if(db.collection("meus_favoritos").document(_idUsuarioLogado) != null){

              db.collection("meus_favoritos")
                  .document(_idUsuarioLogado)
                  .collection("favoritos").document(widget.servico.id)
                  .updateData(widget.servico.toMap())
                  .then((_) {

                Navigator.pop(_dialogContext);
                Navigator.of(context).pop();
              }).catchError((e){
                print(e);
                Navigator.pop(_dialogContext);
                Navigator.of(context).pop();
              });
            }
        //Salvando dados editados no Anuncio Favorito

      });
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosDoUsuario();
    _carregarItensDropDow();
  }

  _carregarItensDropDow() {
    //Estados
    for (var estado in Estados.listaEstadosAbrv) {
      _listaDepartamentos.add(DropdownMenuItem(
        child: Text(estado),
        value: estado,
      ));
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
          title: Text("Edita Servicio",
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
                  ImagesForm(widget.servico),
                  Row(
                    children: <Widget>[
                      StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection("categoriasdeservico")
                            .orderBy("title")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            List<DropdownMenuItem> currencyItens = [];

                            for (int i = 0;
                                i < snapshot.data.documents.length;
                                i++) {
                              DocumentSnapshot snap =
                                  snapshot.data.documents[i];
                              currencyItens.add(DropdownMenuItem(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      snap.data["title"],
                                      style: GoogleFonts.amaranth(
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                                value: "${snap.documentID}",
                              ));
                            }
                            return Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButtonFormField(
                                        hint: Text(
                                          "Categoria",
                                          style: GoogleFonts.amaranth(
                                              textStyle: TextStyle(
                                                  color: Colors.orange[700])),
                                        ),
                                        items: currencyItens,
                                        onChanged: (currenceValue) {
                                          final snackbar = SnackBar(
                                            backgroundColor: Colors.green,
                                            content:
                                                Text("Categoria Seleccionada!"),
                                          );
                                          Scaffold.of(context)
                                              .showSnackBar(snackbar);
                                          setState(() {
                                            selecCurrency = currenceValue;
                                          });
                                        },
                                        onSaved: (categoria) {
                                          widget.servico.categoria = categoria;
                                        },
                                        value: selecCurrency,
                                        validator: (valor) {
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
                      initialValue: widget.servico.title,
                      labelText: "Titulo",
                      hint: "Titulo",
                      validator: (valor) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo Obligatorio")
                            .valido(valor);
                      },
                      onSaved: (title) {
                        widget.servico.title = title;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: InputCustomizado(
                      maxLength: 15,
                      initialValue: widget.servico.preco,
                      labelText: "Precio",
                      inputFormatters: [
                        // maskTextInputFormatterPreco
                      ],
                      hint: "G\$ 1.000",
                      onSaved: (preco) {
                        widget.servico.preco = preco;
                      },
                      type: TextInputType.text,
                      validator: (valor) {
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
                              onChanged: (CountryCode countryCode) {
                                widget.servico.codigoPais = countryCode.toString();
                              },
                              searchDecoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6)),
                              ),
                              initialSelection: 'BR',
                              favorite: ['+55', 'BR'],
                              textStyle: GoogleFonts.amaranth(
                                  textStyle: TextStyle(
                                      color: Colors.grey[600], fontSize: 18)),
                            )),
                      ),
                      SizedBox(width: 7),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: InputCustomizado(
                            initialValue: widget.servico.telefone,
                            type: TextInputType.phone,
                            labelText: "WhatsApp",
                            hint: "WhatsApp",
                            inputFormatters: [
                              maskTextInputFormatter,
                            ],
                            validator: (valor) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                      msg: "Campo Obligatorio")
                                  .valido(valor);
                            },
                            onSaved: (telefone) {
                              widget.servico.telefone = telefone;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: InputCustomizado(
                      initialValue: widget.servico.desc,
                      labelText: "Descripcción",
                      hint: "Descripcción",
                      maxLines: null,
                      validator: (valor) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo Obligatorio")
                            .maxLength(200, msg: "Maximo 350 caracteres")
                            .valido(valor);
                      },
                      onSaved: (desc) {
                        widget.servico.desc = desc;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        //salvando os Campos
                        _formKey.currentState.save();

                        //configurando o contexto do dialogo
                        _dialogContext = context;

                        //savar servico
                        _salvarServico();
                      }
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width - 100,
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
                                  fontWeight: FontWeight.bold, fontSize: 22),
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
