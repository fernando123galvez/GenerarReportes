import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:formvalidation/src/models/reporte_model.dart';
import 'package:formvalidation/src/providers/reporte_provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;

class ReportePage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ReportePage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final reporteProvider = new ReporteProvider();

  ReporteModel reporte = new ReporteModel();
  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {
    final ReporteModel prodData = ModalRoute.of(context).settings.arguments;
    if (prodData != null) {
      reporte = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Reportar '),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearReporte(),
                _crearCaracteristicas(),
                _crearMapa(),
                _crearBoton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearReporte() {
    return TextFormField(
      initialValue: reporte.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Descripcion del lugar'),
      onSaved: (value) => reporte.titulo = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Describe el lugar';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearCaracteristicas() {
    return TextFormField(
      initialValue: reporte.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Caracteristicas fisicas '),
      onSaved: (value) => reporte.titulo = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Describe a la mascota';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearMapa() {
    return SwitchListTile(
      value: reporte.disponible,
      title: Text('Activar Map'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        reporte.disponible = value;
      }),
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });

    if (foto != null) {
      reporte.fotoUrl = await reporteProvider.subirImagen(foto);
    }

    if (reporte.id == null) {
      reporteProvider.crearProducto(reporte);
    } else {
      reporteProvider.editarProducto(reporte);
    }

    // setState(() {_guardando = false; });
    mostrarSnackbar('Registro guardado');

    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _mostrarFoto() {
    if (reporte.fotoUrl != null) {
      return FadeInImage(
        image: NetworkImage(reporte.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      return Image(
        image: AssetImage(foto?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    foto = await ImagePicker.pickImage(source: origen);

    if (foto != null) {
      reporte.fotoUrl = null;
    }

    setState(() {});
  }
}
