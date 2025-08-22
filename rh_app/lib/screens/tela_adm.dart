// screens/tela_adm.dart

import 'package:flutter/material.dart';
import 'package:rh_app/models/solicitacao_senha.dart';
import '../models/usuario.dart';
import '../services/solicitacao_senha_service.dart';
import '../services/usuario_service.dart';

class TelaAdm extends StatefulWidget {
  const TelaAdm({super.key});

  @override
  State<TelaAdm> createState() => _TelaAdmState();
}

class _TelaAdmState extends State<TelaAdm> {
  int _paginaSelecionada = 0;
  String _buscaUsuario = '';

  final _solicitacaoService = SolicitacaoSenhaService();
  final _usuarioService = UsuarioService();

  // --- LÓGICA DAS VIEWS ---


  Future<void> _aprovar(SolicitacaoSenha solicitacao) async {
    try {
      final usuarioAtual = await _usuarioService.buscarPorId(solicitacao.usuarioId);

      if (usuarioAtual == null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ERRO: Usuário ${solicitacao.usuarioEmail} não encontrado.'), backgroundColor: Colors.red));
        return;
      }

      final usuarioAtualizado = Usuario(
        id: solicitacao.usuarioId,
        nome: usuarioAtual.nome,
        email: solicitacao.usuarioEmail,
        senha: solicitacao.novaSenhaSugerida,
      );

      await _usuarioService.atualizar(usuarioAtualizado);
      await _solicitacaoService.removerSolicitacao(solicitacao.id);

      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Senha de ${solicitacao.usuarioEmail} atualizada!'), backgroundColor: Colors.green));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ocorreu um erro ao aprovar: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _negar(SolicitacaoSenha solicitacao) async {
    await _solicitacaoService.removerSolicitacao(solicitacao.id);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Solicitação de ${solicitacao.usuarioEmail} negada.'), backgroundColor: Colors.orange));
  }

  void _excluirUsuario(Usuario usuario) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir o usuário ${usuario.nome}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              _usuarioService.excluir(usuario.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuário excluído!'), backgroundColor: Colors.green));
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _mostrarModalEdicao(Usuario usuario) {
    final nomeController = TextEditingController(text: usuario.nome);
    final emailController = TextEditingController(text: usuario.email);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Usuário'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (value) => (value == null || value.isEmpty || !value.contains('@')) ? 'E-mail inválido' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final novoEmail = emailController.text.trim();
                if (novoEmail != usuario.email) {
                  final usuarioExistente = await _usuarioService.buscarPorEmail(novoEmail);
                  if (mounted && usuarioExistente != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Este e-mail já está em uso por outro usuário.'), backgroundColor: Colors.red),
                    );
                    return;
                  }
                }
                final usuarioAtualizado = Usuario(
                  id: usuario.id,
                  nome: nomeController.text,
                  email: novoEmail,
                  senha: usuario.senha,
                );
                _usuarioService.atualizar(usuarioAtualizado);
                if(mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuário atualizado!'), backgroundColor: Colors.green));
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DAS VIEWS ---
  Widget _buildViewSolicitacoes() {
    return StreamBuilder<List<SolicitacaoSenha>>(
      stream: _solicitacaoService.listarSolicitacoesPendentes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return Center(child: Text("Ocorreu um erro: ${snapshot.error}"));
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('Nenhuma solicitação pendente.'));

        final solicitacoes = snapshot.data!;
        return ListView.builder(
          itemCount: solicitacoes.length,
          itemBuilder: (context, index) {
            final s = solicitacoes[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: Text(s.usuarioNome, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('E-mail: ${s.usuarioEmail}\nSenha sugerida: ${s.novaSenhaSugerida}'),
                isThreeLine: true,
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(icon: const Icon(Icons.check_circle, color: Colors.green), onPressed: () => _aprovar(s), tooltip: 'Aprovar'),
                  IconButton(icon: const Icon(Icons.cancel, color: Colors.red), onPressed: () => _negar(s), tooltip: 'Negar'),
                ]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildViewUsuarios() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: TextField(
            onChanged: (value) => setState(() => _buscaUsuario = value),
            decoration: const InputDecoration(labelText: 'Buscar por e-mail...', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Usuario>>(
            stream: _usuarioService.buscarPorEmailStream(_buscaUsuario),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (snapshot.hasError) return Center(child: Text("Ocorreu um erro: ${snapshot.error}"));
              if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('Nenhum usuário encontrado.'));

              final usuarios = snapshot.data!;
              return ListView.builder(
                itemCount: usuarios.length,
                itemBuilder: (context, index) {
                  final u = usuarios[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      title: Text(u.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(u.email),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _mostrarModalEdicao(u), tooltip: 'Editar'),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _excluirUsuario(u), tooltip: 'Excluir'),
                      ]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // --- BUILD PRINCIPAL DA TELA ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => setState(() => _paginaSelecionada = 0),
                  style: TextButton.styleFrom(
                    backgroundColor: _paginaSelecionada == 0 ? Colors.blue[100] : Colors.transparent,
                    foregroundColor: Colors.blue[800],
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)
                  ),
                  child: const Text('Solicitações'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => setState(() => _paginaSelecionada = 1),
                   style: TextButton.styleFrom(
                    backgroundColor: _paginaSelecionada == 1 ? Colors.blue[100] : Colors.transparent,
                    foregroundColor: Colors.blue[800],
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)
                  ),
                  child: const Text('Usuários'),
                ),
              ),
            ],
          ),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _paginaSelecionada == 0
                  ? _buildViewSolicitacoes()
                  : _buildViewUsuarios(),
            ),
          ),
        ],
      ),
    );
  }
}