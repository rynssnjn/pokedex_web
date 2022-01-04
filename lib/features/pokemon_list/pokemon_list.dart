import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_web/apis/pokeapi/models/pokemon_pokemon.dart';
import 'package:pokedex_web/features/pokemon_list/widgets/pokemon_list_item.dart';
import 'package:pokedex_web/models/async.dart';
import 'package:pokedex_web/utilties/constants.dart';

class PokemonList extends StatelessWidget {
  const PokemonList({
    required this.onSelectPokemon,
    required this.loadNextPage,
    required this.pokemons,
    this.selectedPokemonId,
    this.isExpanded = false,
    Key? key,
  }) : super(key: key);

  final Future<void> Function(int id) onSelectPokemon;
  final Future<void> Function() loadNextPage;
  final Async<List<PokemonPokemon>> pokemons;
  final int? selectedPokemonId;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Scaffold(
        appBar: isExpanded ? null : AppBar(title: Text('Pokedex')),
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            final currentScroll = scrollInfo.metrics.pixels;
            final maxScroll = scrollInfo.metrics.maxScrollExtent;
            if (currentScroll >= maxScroll) {
              loadNextPage();
            }
            return false;
          },
          child: pokemons.when(
            (p) => ListView(
              children: p
                      ?.mapIndexed(
                        (index, pokemon) => PokemonListItem(
                          onSelectPokemon: () => onSelectPokemon(index + 1),
                          imageUrl: pokemonImageUrl.replaceAll('%s', '${index + 1}'),
                          name: pokemon.name,
                          isSelected: selectedPokemonId == index + 1,
                        ),
                      )
                      .toList() ??
                  [Container()],
            ),
            loading: () => Center(child: CircularProgressIndicator()),
            error: (key) => Text(key ?? 'sss'),
          ),
        ),
      ),
    );
  }
}
