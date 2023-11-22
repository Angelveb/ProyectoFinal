import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_v2/componentes/drawer.dart';
import 'package:proyecto_v2/presentation/pages/assembly/views/assembly_section.dart';
import 'package:proyecto_v2/presentation/pages/files/dowload_page_movil.dart';
import 'package:proyecto_v2/presentation/pages/club/club_page.dart';
import 'package:proyecto_v2/presentation/pages/home/views/start_page.dart';
import 'package:proyecto_v2/presentation/pages/home/views/uploader_page.dart';
import 'package:proyecto_v2/presentation/pages/home/views/uploader_page_people.dart';
import 'package:proyecto_v2/presentation/pages/profile/profile_page.dart';
import 'package:proyecto_v2/presentation/pages/suggestions/sugerencias_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  static final List<Widget> _widgetOptions = <Widget>[
    const UploaderPage(),
    const WelcomeScreen(),
    const UploaderPage2(),
  ];

  // Usuario
  final currentUser = FirebaseAuth.instance.currentUser!;

  // Controlador texto
  final textController = TextEditingController();

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void goToProfilePage() {
    // pop menu drawer
    Navigator.pop(context);

    // got to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  void goToPQRSPage() {
    // pop menu drawer
    Navigator.pop(context);

    // got to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SugerenciasPage(),
      ),
    );
  }

  void goToAssemblyPage() {
    // pop menu drawer
    Navigator.pop(context);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AssembliesSection(),
        ),
      );
  }

  void goToWalletPage() {
    // pop menu drawer
    Navigator.pop(context);

    // got to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  const DownloadPage(),
      ),
    );
  }

  void goToClubPage() {
    // pop menu drawer
    Navigator.pop(context);

    // got to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ClubPage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Necesario para el AutomaticKeepAliveClientMixin

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        flexibleSpace: const Image(
          image: AssetImage('assets/TT.png'),
          width: 90,
          height: 90,
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xff9a6243),
          tabs: const [
            Tab(icon: Icon(Icons.person, color: Color(0xFFCA8A40))),
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.people_alt, color: Color(0xFF8A352A))),
          ],
        ),
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
        onAssemblyTap: goToAssemblyPage,
        onClubTap: goToClubPage,
        onPQRSTap: goToPQRSPage,
        onWalletTap: goToWalletPage,
      ),
      body: TabBarView(
        controller: _tabController,
        children: _widgetOptions,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
