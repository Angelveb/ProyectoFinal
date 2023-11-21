import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:proyecto_v2/componentes/image_slider.dart';
import 'package:proyecto_v2/presentation/pages/club/modal.dart';

class CommonAreaPage extends StatelessWidget {
  final List _photos = [
    Data(image: "assets/common_areas/1CA.png", text: "Salón de niños 8 o más", text2: 'Piso 5', description: "Descripcion"),
    Data(image: "assets/common_areas/1CA.png", text: "Salón de niños 0 a 8 años", text2: 'Piso 5', description: "Horario de servicio de esta zona martes a viernes de 08:00am a 05:00pm sin servicio de 01:00pm a 02:00pm Sábados 07:00am a 03:00pm, Domingos 10:00am a 02:00pm, el  servicio se tomará en orden de llegada hasta completar el aforo, el residente se debe registrar en la recepción, teniendo en cuenta que el apartamento debe encontrarse al día por todo concepto al conjunto, sólo será válido el acompañamiento de un mayor de edad como acompañante de menores de esta edad."),
    Data(image: "assets/common_areas/2CA.png", text: "Bicicleteros", text2: 'Piso 5', description: "Descripcion3"),
    Data(image: "assets/common_areas/3CA.png", text: "Salón de estudio", text2: 'Piso 5', description: "Descripcion4"),
    Data(image: "assets/common_areas/4CA.png", text: "Gimasio", text2: 'Piso 5', description: "Horarios de gimnasio Lunes a Viernes jornada AM: 6:00am a 10:00am Jornada PM: 05:00pm a 09:00pm, Sábado 07:00am a 12:00m Domingo opera dos domingos al mes y cerrará de esa manera.\nEstos escenario se encuentran adecuados para mayores de 13 años, recuerde que todo usuario de estos servicios se debe encontrar al día por todo concepto con el conjunto"),
    Data(image: "assets/common_areas/5CA.png", text: "Salón de Spinning", text2: 'Piso 5', description: "Descripcion6"),
    Data(image: "assets/common_areas/6CA.png", text: "Salón de aeróbicos", text2: 'Piso 5', description: "Descripcion7"),
    Data(image: "assets/common_areas/7CA.png", text: "Auditorio", text2: 'Piso 5', description: "Descripcion8"),
    Data(image: "assets/common_areas/8CA.png", text: "Zona WIFI", text2: 'Piso 5', description: "Descripcion9"),
    Data(image: "assets/common_areas/9CA.png", text: "Salón de juegos de mesa", text2: 'Piso 5', description: "Descripcion10"),
    Data(image: "assets/common_areas/10CA.png", text: "Salón de lectura", text2: 'Piso 5', description: "Descripcion11"),
    Data(image: "assets/common_areas/11CA.png", text: "Salones de eventos", text2: 'Piso 5', description: "Descripcion12"),
    Data(image: "assets/common_areas/12CA.png", text: "TERRAZA BBQ", description: "Descripcion13"),
    Data(image: "assets/common_areas/13CA.png", text: "Juegos infantiles", text2: 'Piso 5', description: "Descripcion14"),
    Data(image: "assets/common_areas/14CA.png", text: "Espacios verdes", text2: 'Piso 5', description: "Descripcion15"),
    Data(image: "assets/common_areas/15CA.png", text: "Terrazas panorámicas", text2: 'Piso 5', description: "Descripcion16"),
  ];

  final List<Color> _backgroundColors = [
    const Color(0xFFc1ddc7),
    const Color(0xFF69F0AE),
    const Color(0xFFFF8965),
    const Color(0xFFf5e8c6),
    const Color(0xFFbbcd77),
    const Color(0xFFfffbd4),
    const Color(0xFFf4d279),
    const Color(0xFFe3b8b2),
    const Color(0xFFf5ddbb),
    const Color(0xFFfffbd4),
    const Color(0xFFffeec2),
    const Color(0xFFfe9e8e),
    const Color(0xFFcdb28a),
    const Color(0xFFd4ddb1),
    const Color(0xFF69F0AE),
    const Color(0xFFdadabd),
  ];

  final List<List<String>> _imageLists = [
    ['assets/club/salonN/SN1.jpg', 'assets/club/salonN/SN2.jpg', 'assets/club/salonN/SN3.jpg', 'assets/club/salonN/SN4.jpg'],
    ['assets/1.png', 'assets/1.png', 'assets/1.png'],
    ['assets/1.png', 'assets/1.png', 'assets/1.png'],
    ['assets/1.png', 'assets/1.png', 'assets/1.png'],
    ['assets/club/gym/GYM1.jpg', 'assets/club/gym/GYM1.jpg', 'assets/club/gym/GYM1.jpg', 'assets/club/gym/GYM4.jpg'],
    ['assets/1.png', 'assets/1.png', 'assets/1.png'],
    ['assets/1.png', 'assets/1.png', 'assets/1.png'],
    ['assets/1.png', 'assets/1.png', 'assets/1.png'],
    ['assets/1.png', 'assets/1.png', 'assets/1.png'],
    ['assets/1.png', 'assets/1.png', 'assets/1.png'],
    ['assets/1.png', 'assets/1.png', 'assets/1.png'],
    ['assets/1.png', 'assets/1.png', 'assets/1.png'],
    ['assets/1.png', 'assets/1.png', 'assets/1.png'],
    ['assets/1.png', 'assets/1.png', 'assets/1.png'],
    ['assets/1.png', 'assets/1.png', 'assets/1.png'],
    // Agrega más listas de imágenes según sea necesario
  ];

  CommonAreaPage({super.key, final String? imagePath});

  void showTextDialog(BuildContext context, int index) {
    // Muestra un AwesomeDialog con el texto al tocar el elemento.
    final List<String> images = _imageLists[index];
    AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.scale,
        body: Column(
          children: [
            Text(
              _photos[index].text,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            Text(
              _photos[index].text2,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            
          ],
        ),
        btnOkOnPress: () {},
        btnCancelText: 'Ver Fotos',
        btnCancelColor: Colors.amber,
        btnCancelOnPress: () {
          showImageSliderDialog(context, images, index);
        }).show();
  }

  void showImageSliderDialog(BuildContext context, List<String> images, int index) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      body: ImageSliderWithDescription(
        title: _photos[index].text,
        images: images,
        description: _photos[index].description,
      ),
      desc: 'Seleccione imágenes',
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Zonas Comunes'),
      ),
      body: GridView.builder(
        itemCount: _photos.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    showTextDialog(context, index);
                  },
                  child: Container(
                    width: 300,
                    height: 150,
                    decoration: BoxDecoration(
                      color: _backgroundColors[index],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Transform.scale(
                      scale: 1.2,
                      child: Image.asset(
                        _photos[index].image,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(_photos[index].text),
              ],
            ),
          );
        },
      ),
    );
  }
}
