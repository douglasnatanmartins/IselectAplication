import 'package:cloud_firestore/cloud_firestore.dart';

class ModelServico {


  String _id; // id do servico
  String _categoria; // id da categoria
  String _title;
  String _telefone;
  String _desc;
  String _preco;
  double _lat;
  double _long;
  double _rating = 0.5;
  String _cidade;
  String _pais;
  String _rua;
  String _estado;
  String _codigoPais;

  List<String> _fotos;

  ModelServico();

  ModelServico.fromdocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot.documentID;
    this.categoria = documentSnapshot["categoria"];
    this.desc = documentSnapshot["desc"];
    this.title = documentSnapshot["title"];
    this.telefone = documentSnapshot["telefone"];
    this.fotos = List<String>.from(documentSnapshot["fotos"]);
    this.preco = documentSnapshot["preco"];
    this.lat = documentSnapshot["lat"];
    this.long = documentSnapshot["long"];
    this.rating = documentSnapshot["rating"];
    this.cidade = documentSnapshot["cidade"];
    this.pais = documentSnapshot["pais"];
    this.rua = documentSnapshot["rua"];
    this.estado = documentSnapshot["estado"];
    this.codigoPais = documentSnapshot["codigoPais"];
  }

  ModelServico.gerarId(){ // Construtor Nomeado

    //gerando id Antes de guardar
    Firestore db = Firestore.instance;
    CollectionReference servicos = db.collection("categoriasdeservico");
    this.id = servicos.document().documentID;

    this.fotos = [];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id" : this.id,
      "categoria": this.categoria,
      "title": this.title,
      "telefone": this.telefone,
      "desc": this.desc,
      "fotos": this.fotos,
      "preco": this.preco,
      "lat": this.lat,
      "long": this.long,
      "rating": this.rating,
      "cidade": this.cidade,
      "pais": this.pais,
      "rua":this.rua,
      "estado": this.estado,
      "codigoPais": this.codigoPais
    };
    return map;
  }
  List<String> get fotos => _fotos;

  String get codigoPais => _codigoPais;

  set codigoPais(String value) {
    _codigoPais = value;
  }

  double get rating => _rating;

  set rating(double value) {
    _rating = value;
  }

  double get lat => _lat;

  set lat(double value) {
    _lat = value;
  }

  set fotos(List<String> value) {
    _fotos = value;
  }

  String get preco => _preco;

  String get estado => _estado;

  set estado(String value) {
    _estado = value;
  }

  set preco(String value) {
    _preco = value;
  }

  String get desc => _desc;

  set desc(String value) {
    _desc = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get categoria => _categoria;

  set categoria(String value) {
    _categoria = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  double get long => _long;

  set long(double value) {
    _long = value;
  }

  String get rua => _rua;

  set rua(String value) {
    _rua = value;
  }

  String get pais => _pais;

  set pais(String value) {
    _pais = value;
  }

  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }
}