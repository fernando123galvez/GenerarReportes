import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/reporte_model.dart';

import 'package:formvalidation/src/providers/reporte_provider.dart';

class HomePage extends StatelessWidget {
  final reporteProvider = new ReporteProvider();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Modulo Reporte')),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
      future: reporteProvider.cargarReporte(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ReporteModel>> snapshot) {
        if (snapshot.hasData) {
          final reporte = snapshot.data;
          return ListView.builder(
            itemCount: reporte.length,
            itemBuilder: (context, i) => _crearItem(context, reporte[i]),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ReporteModel reporte) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) {
          reporteProvider.borrarReporte(reporte.id);
        },
        child: Card(
          child: Column(
            children: <Widget>[
              (reporte.fotoUrl == null)
                  ? Image(image: AssetImage('assets/no-image.png'))
                  : FadeInImage(
                      image: NetworkImage(reporte.fotoUrl),
                      placeholder: AssetImage('assets/jar-loading.gif'),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ListTile(
                title: Text('${reporte.titulo} - ${reporte.valor}'),
                subtitle: Text(reporte.id),
                onTap: () =>
                    Navigator.pushNamed(context, 'reporte', arguments: reporte),
              ),
            ],
          ),
        ));
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'reporte'),
    );
  }
}
