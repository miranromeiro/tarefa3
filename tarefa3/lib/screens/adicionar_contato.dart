class AdicionarContatoScreen extends StatefulWidget {
  @override
  _AdicionarContatoScreenState createState() => _AdicionarContatoScreenState();
}

class _AdicionarContatoScreenState extends State<AdicionarContatoScreen> {
  final Contato contato;
  AdicionarContatoScreen({this.contato});

  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();

  Contato contatoEdicao;
  final ImagePicker imagePicker = ImagePicker();
  PickedFile _caminhoImagem;

  @override
  void initState() {
    super.initState();
    if (widget.contato == null) {
      contatoEdicao = Contato();
    } else {
      contatoEdicao = Contato.fromMap(widget.contato.toMap());
      nomeController.text = contatoEdicao.nome;
      emailController.text = contatoEdicao.email;
      telefoneController.text = contatoEdicao.telefone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionat Contato'),
      ),
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          SizedBox(
            height: 20,
          ),
          GestureDetector(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contatoEdicao.caminhoImagem != null
                        ? FileImage(File(contatoEdicao.caminhoImagem))
                        : AssetImage('assets/images/social.png')
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: () {
                imagePicker.getImage(source: ImageSource.camera).then((value) {
                  setState(() {
                    _caminhoImagem = value;
                    contatoEdicao.caminhoImagem = _caminhoImagem.path;
                  });
                });
              }),
          children: [
            CustomTextField(
              hint: "Nome",
              icon: Icons.text_fields,
              controller: nomeController,
            ),
            CustomTextField(
              hint: "E-mail",
              icon: Icons.email,
              controller: emailController,
            ),
            CustomTextField(
              hint: "Telefone",
              icon: Icons.phone,
              controller: telefoneController,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.teal.shade200,
                onPressed: () {
                  var contato = Contato(
                      nome: nomeController.text,
                      email: emailController.text,
                      telefone: telefoneController.text,
                      caminhoImagem: _caminhoImagem.path);
                  if (contatoEdicao.nome != null) contato.id = contatoEdicao.id;
                  Navigator.pop(context, contato);
                },
                child: Text('Salvar', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
