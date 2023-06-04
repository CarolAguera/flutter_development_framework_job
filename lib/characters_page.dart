import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trabalho_consumo_api/character_bloc.dart';
import 'package:trabalho_consumo_api/character_details_page.dart';

class CharactersPage extends StatefulWidget {
  @override
  _CharactersPageState createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final _scrollController = ScrollController();
  final _characterBloc = CharacterBloc();
  final _pageSize = 20;
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMoreCharacters = true;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _characterBloc.close();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (_hasMoreCharacters && !_isLoading) {
        _loadCharacters();
      }
    }
  }

  void _loadCharacters() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      try {
        _characterBloc.add(FetchCharacters(
            offset: _currentPage * _pageSize, limit: _pageSize));

        _currentPage++;
      } catch (e) {
        print('Erro ao carregar os personagens: $e');
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personagens da Marvel'),
      ),
      body: BlocBuilder<CharacterBloc, CharacterState>(
        bloc: _characterBloc,
        builder: (context, state) {
          if (state is CharacterLoading && _currentPage == 0) {
            return _buildLoadingIndicator();
          } else if (state is CharacterLoaded) {
            final characters = state.characters;
            _hasMoreCharacters = characters.length >= _pageSize;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: characters.length,
                    itemBuilder: (context, index) {
                      final character = characters[index];
                      return ListTile(
                        leading: Image.network(
                          '${character['thumbnail']['path']}.${character['thumbnail']['extension']}',
                          width: 50,
                          height: 50,
                        ),
                        title: Text(
                          character['name'],
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CharacterDetailsPage(character: character),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                if (_isLoading)
                  _buildLoadingIndicator(), // Exibe o indicador de carregamento abaixo da lista
              ],
            );
          } else if (state is CharacterError) {
            return Center(
              child: Text('Erro ao carregar os dados: ${state.message}'),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
