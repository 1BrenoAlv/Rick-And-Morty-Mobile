import 'package:flutter/material.dart';
import 'package:rick_and_morty_mobile/app/view/pages/home-page/widgets/character_card.dart';
import 'package:rick_and_morty_mobile/app/view/pages/home-page/widgets/drawer_home.dart';
import 'package:rick_and_morty_mobile/app/viewmodels/character_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CharacterViewmodel _viewModel = CharacterViewmodel();

  @override
  void initState() {
    super.initState();
    _viewModel.fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final logoSize = size.width * 0.13;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
          child: Row(
            children: [
              SizedBox(
                width: logoSize,
                height: logoSize,
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  child: Image.asset('assets/logo.png', fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: size.width * 0.02),
              Flexible(
                child: Text(
                  'Rick And Morty Explorer',
                  style: TextStyle(fontSize: size.width * 0.052),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: IconButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              icon: Icon(Icons.menu),
            ),
          ),
        ],
      ),
      drawer: Drawer(width: size.width * 0.80, child: DrawerHome()),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedBuilder(
          animation: _viewModel,
          builder: (context, child) {
            if (_viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (_viewModel.error != null) {
              return Center(
                child: Text('Erro', style: TextStyle(color: Colors.red)),
              );
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemCount: _viewModel.characters.length,
              itemBuilder: (context, index) {
                return CharacterCard(character: _viewModel.characters[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
