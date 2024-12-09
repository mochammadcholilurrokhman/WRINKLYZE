import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wrinklyze_6/main.dart';
import 'package:intl/intl.dart';

class FaceScanResultPage extends StatelessWidget {
  final String skinType;
  final double confidence;
  final List<dynamic> probabilities;
  final String imagePath;
  final String title;

  const FaceScanResultPage({
    Key? key,
    required this.skinType,
    required this.confidence,
    required this.probabilities,
    required this.imagePath,
    required this.title,
  }) : super(key: key);

  Future<void> _showPredictionDialog(BuildContext context) {
    String title = 'Skin Type: $skinType';
    String content =
        'Confidence: ${confidence.toStringAsFixed(2)}\n\nProbabilities: ${probabilities.toString()}';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Text(content),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );

    return Future
        .value(); // Indicate that the method has completed successfully
  }

  Future<void> _saveToFirestore(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    DateTime dateTime = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('face_results')
            .add({
          'title': title,
          'skinType': skinType,
          'confidence': confidence,
          'probabilities': probabilities,
          'imagePath': imagePath,
          'timestamp': formattedDate,
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
          (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to save data: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show the prediction dialog when the page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPredictionDialog(context);
    });

    String title = '';
    String description = '';
    switch (skinType) {
      case 'wrinkle_ringan':
        title = 'Wrinkles in Motion (kerutan ringan)';
        description = '''
Pengertian
Kerutan hanya muncul saat otot wajah bergerak, biasanya di area yang sering digunakan seperti sekitar mata dan mulut.

Klasifikasi
- Photoaging sedang
- Mulai muncul bercak hitam (hiperpigmentasi)
- Adanya tumor kulit awal namun tidak tampak secara kasat mata
- Garis senyum paralel mulai muncul di sisi lateral wajah

Solusi
- Pemakaian krim anti-aging yang mengandung tretinoin atau asam alfa hidroksi untuk mengurangi garis halus dan meningkatkan pergantian sel kulit.
- Chemical peeling ringan untuk memperbaiki tekstur kulit dan mengurangi perubahan warna.
- Perawatan kulit rutin dengan pelembab dan tabir surya untuk mencegah kerusakan lebih lanjut akibat sinar UV.
- Perawatan laser atau IPL untuk mengatasi hiperpigmentasi dan memperbaiki struktur kulit.
        ''';
        break;
      case 'wrinkle_sedang':
        title = 'Wrinkles at Rest (kerutan sedang)';
        description = '''
Pengertian
Kerutan tetap terlihat meskipun wajah dalam keadaan rileks, menunjukkan penuaan yang lebih lanjut.

Klasifikasi
- Photoaging berat
- Diskromia nyata, telangiectasis (pelebaran pembuluh darah kecil)
- Adanya tumor kulit seperti keratosis
- Kerut persisten dan dalam

Solusi
- Tindakan medis lebih intensif seperti mikrodermabrasi atau laser resurfacing untuk menghilangkan lapisan atas kulit dan merangsang produksi kolagen.
- Botox atau filler kulit untuk mengatasi kerutan dalam yang tidak hilang dengan krim topikal.
- Pemakaian krim tretinoin atau retinoid kuat untuk meningkatkan regenerasi kulit dan mengurangi tampilan kerutan.
- Pemeriksaan rutin ke dokter kulit untuk menangani tumor kulit dan melakukan tindakan pencegahan kanker kulit.
        ''';
        break;
      case 'wrinkle_berat':
        title = 'Only Wrinkles (kerutan berat)';
        description = '''
Pengertian
Kulit penuh dengan kerutan, bahkan di area yang jarang digunakan untuk ekspresi. Hampir seluruh area wajah menunjukkan tanda penuaan.

Klasifikasi
- Photoaging sangat berat
- Kulit kuning-keabuan
- Adanya tumor kulit ganas
- Hampir tidak ada kulit normal yang tersisa

Solusi
- Pembedahan kosmetik seperti facelift atau browlift untuk memperbaiki kulit yang sangat kendur dan kerut dalam.
- Perawatan laser intensif untuk meremajakan kulit dan mengatasi hiperpigmentasi dan kerusakan berat akibat sinar matahari.
- Konsultasi dengan ahli bedah plastik untuk penanganan tumor kulit ganas.
- Penggunaan krim anti-aging yang kuat serta pengobatan sistemik seperti hormon replacement therapy jika diperlukan.
        ''';
        break;
      default:
        title = 'Unknown Skin Type';
        description = 'No information available for this skin type.';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Face Scan Result'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => _saveToFirestore(context),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xff052135),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Save Information",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
