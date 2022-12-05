import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SQLiteOpenHelper helper = SQLiteOpenHelper();

  List<Contato> listContatos = List();

  @override
  void initState() {
    super.initState();
    obterTodosContatos();
  }

  _exibirPaginaContato({Contato contato}) async {
    final retornoContato = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AdicionarContatoScreen(contato: contato)));

    if (retornoContato != null) {
      if (contato != null) {
        await helper.update(retornoContato);
      } else {
        await helper.insert(retornoContato);
      }
      obterTodosContatos();
    }
  }

  obterTodosContatos() {
    helper
        .findAll()
        .then((list) => setState(() {
              listContatos = list;
            }))
        .catchError((error) {
      print('Erroa ao recuperar contatos: ${error.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQLite Contacts'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: listContatos[index].caminhoImagem != null
                              ? FileImage(
                                  File(listContatos[index].caminhoImagem))
                              : AssetImage('assets/images/social.png')
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            listContatos[index].nome,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          Text(
                            listContatos[index].email,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            listContatos[index].telefone,
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              _exibirPaginaContato(contato: listContatos[index]);
            },
          );
        },
        itemCount: listContatos.length,
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Navegação
          _exibirPaginaContato();
          MaterialPageRoute(builder: ((context) => AdicionarContatoScreen()));
        },
      ),
    );
  }
}