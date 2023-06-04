import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trabalho_consumo_api/marvel_api.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  CharacterBloc() : super(CharacterInitial());

  @override
  Stream<CharacterState> mapEventToState(CharacterEvent event) async* {
    if (event is FetchCharacters) {
      yield CharacterLoading();

      try {
        final characters = await MarvelAPI.getCharacters(
          offset: event.offset,
          limit: event.limit,
        );

        yield CharacterLoaded(characters: characters);
      } catch (e) {
        yield CharacterError(message: e.toString());
      }
    }
  }
}

abstract class CharacterEvent extends Equatable {
  const CharacterEvent();

  @override
  List<Object> get props => [];
}

class FetchCharacters extends CharacterEvent {
  final int offset;
  final int limit;

  FetchCharacters({required this.offset, required this.limit});

  @override
  List<Object> get props => [offset, limit];
}

abstract class CharacterState extends Equatable {
  const CharacterState();

  @override
  List<Object> get props => [];
}

class CharacterInitial extends CharacterState {}

class CharacterLoading extends CharacterState {}

class CharacterLoaded extends CharacterState {
  final List<dynamic> characters;

  CharacterLoaded({required this.characters});

  @override
  List<Object> get props => [characters];
}

class CharacterError extends CharacterState {
  final String message;

  CharacterError({required this.message});

  @override
  List<Object> get props => [message];
}
