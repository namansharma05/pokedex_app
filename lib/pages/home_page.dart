import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_app/controllers/home_page_controller.dart';
import 'package:pokedex_app/models/page_data.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/widgets/pokemon_list_tile.dart';

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController(
    HomePageData.initial(),
  );
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _allPokemonsListsController = ScrollController();

  late HomePageController _homePageController;
  late HomePageData _homePageData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _allPokemonsListsController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _allPokemonsListsController.removeListener(_scrollListener);
    _allPokemonsListsController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_allPokemonsListsController.offset >=
            _allPokemonsListsController.position.maxScrollExtent * 1 &&
        !_allPokemonsListsController.position.outOfRange) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(
      homePageControllerProvider.notifier,
    );

    _homePageData = ref.watch(homePageControllerProvider);

    return Scaffold(
      body: _buildUI(
        context,
      ),
    );
  }

  Widget _buildUI(
    BuildContext context,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _allPokemonsList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _allPokemonsList(
    BuildContext context,
  ) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'All Pokemons',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.60,
            child: ListView.builder(
              controller: _allPokemonsListsController,
              itemCount: _homePageData.data?.results?.length ?? 0,
              itemBuilder: (context, index) {
                PokemonListResult pokemon = _homePageData.data!.results![index];
                return PokemonListTile(pokemonURL: pokemon.url!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
