import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_mobile/app/config/colors.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharacterViewmodel>().fetchCharacters();
    });
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
                  borderRadius: AppColors.borderRadiusCard,
                  child: Image.asset('assets/logo.png', fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: size.width * 0.02),
              Flexible(
                child: Text(
                  'Rick And Morty Explorer',
                  style: TextStyle(
                    fontSize: size.width * 0.052,
                    color: AppColors.bgColor,
                    fontWeight: FontWeight.w600,
                  ),
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
              icon: const Icon(Icons.menu, color: AppColors.bgColor),
            ),
          ),
        ],
      ),
      drawer: Drawer(width: size.width * 0.80, child: DrawerHome()),
      body: Container(
        color: AppColors.bgMain,
        child: Consumer<CharacterViewmodel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildBody(viewModel),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: AppColors.colorBorder, width: 1),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 6.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed:
                            (viewModel.isLoading || viewModel.prevBtn == null)
                            ? null
                            : () => viewModel.previousPage(),
                        icon: Icon(
                          Icons.arrow_back,
                          color:
                              (viewModel.isLoading || viewModel.prevBtn == null)
                              ? AppColors.colorBorder
                              : AppColors.primaryColor,
                        ),
                      ),
                      Text(
                        'Página ${viewModel.currentPage} de ${viewModel.pageTotal ?? ''} ',
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        onPressed:
                            (viewModel.isLoading || viewModel.nextBtn == null)
                            ? null
                            : () => viewModel.nextPage(),
                        icon: Icon(
                          Icons.arrow_forward,
                          color:
                              (viewModel.isLoading || viewModel.nextBtn == null)
                              ? AppColors.colorBorder
                              : AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(CharacterViewmodel viewModel) {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.bgAside),
      );
    }
    if (viewModel.error != null) {
      return Center(
        child: Text(
          viewModel.error!,
          style: const TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemCount: viewModel.characters.length,
      itemBuilder: (context, index) {
        return CharacterCard(character: viewModel.characters[index]);
      },
    );
  }
}
