import 'package:flutter/material.dart';

class WrinklepediaPage extends StatelessWidget {
  final List<Map<String, dynamic>> wrinkleData = [
    {
      'title': 'Wrinkles in Motion (Kerutan Ringan)',
      'image': 'assets/images/wrinkles_in_motion.jpg',
      'description':
          'Kerutan hanya muncul saat otot wajah bergerak, biasanya di area yang sering digunakan seperti sekitar mata dan mulut.',
      'classification': [
        'Photoaging sedang',
        'Mulai muncul bercak hitam (hiperpigmentasi)',
        'Adanya tumor kulit awal namun tidak tampak secara kasat mata',
        'Garis senyum paralel mulai muncul di sisi lateral wajah'
      ],
      'solution': [
        'Pemakaian krim anti-aging yang mengandung tretinoin atau asam alfa hidroksi untuk mengurangi garis halus dan meningkatkan pergantian sel kulit.',
        'Chemical peeling ringan untuk memperbaiki tekstur kulit dan mengurangi perubahan warna.',
        'Perawatan kulit rutin dengan pelembab dan tabir surya untuk mencegah kerusakan lebih lanjut akibat sinar UV.',
        'Perawatan laser atau IPL untuk mengatasi hiperpigmentasi dan memperbaiki struktur kulit.'
      ]
    },
    {
      'title': 'Wrinkles at Rest (Kerutan Sedang)',
      'image': 'assets/images/wrinkles_at_rest.jpg',
      'description':
          'Kerutan tetap terlihat meskipun wajah dalam keadaan rileks, menunjukkan penuaan yang lebih lanjut.',
      'classification': [
        'Photoaging berat',
        'Diskromia nyata, telangiectasis (pelebaran pembuluh darah kecil)',
        'Adanya tumor kulit seperti keratosis',
        'Kerut persisten dan dalam'
      ],
      'solution': [
        'Tindakan medis lebih intensif seperti mikrodermabrasi atau laser resurfacing untuk menghilangkan lapisan atas kulit dan merangsang produksi kolagen.',
        'Botox atau filler kulit untuk mengatasi kerutan dalam yang tidak hilang dengan krim topikal.',
        'Pemakaian krim tretinoin atau retinoid kuat untuk meningkatkan regenerasi kulit dan mengurangi tampilan kerutan.',
        'Pemeriksaan rutin ke dokter kulit untuk menangani tumor kulit dan melakukan tindakan pencegahan kanker kulit.'
      ]
    },
    {
      'title': 'Only Wrinkles (Kerutan Berat)',
      'image': 'assets/images/only_wrinkles.jpg',
      'description':
          'Kulit penuh dengan kerutan, bahkan di area yang jarang digunakan untuk ekspresi. Hampir seluruh area wajah menunjukkan tanda penuaan.',
      'classification': [
        'Photoaging sangat berat',
        'Kulit kuning-keabuan',
        'Adanya tumor kulit ganas',
        'Hampir tidak ada kulit normal yang tersisa'
      ],
      'solution': [
        'Pembedahan kosmetik seperti facelift atau browlift untuk memperbaiki kulit yang sangat kendur dan kerut dalam.',
        'Perawatan laser intensif untuk meremajakan kulit dan mengatasi hiperpigmentasi dan kerusakan berat akibat sinar matahari.',
        'Konsultasi dengan ahli bedah plastik untuk penanganan tumor kulit ganas.',
        'Penggunaan krim anti-aging yang kuat serta pengobatan sistemik seperti hormon replacement therapy jika diperlukan.'
      ]
    },
  ];

  WrinklepediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wrinklepedia',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Color(0xFF052135),
            )),
        backgroundColor: const Color(0xFFe9f0ef),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: wrinkleData.length,
        itemBuilder: (context, index) {
          final item = wrinkleData[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.white,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WrinkleDetailPage(item: item),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16.0)),
                    child: Image.asset(
                      item['image'],
                      width: double.infinity,
                      height: 170,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      item['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class WrinkleDetailPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const WrinkleDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            item['title'],
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Color(0xFF052135),
            ),
          ),
        ),
        backgroundColor: const Color(0xFFe9f0ef),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(
                item['image'],
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Pengertian:',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
            const SizedBox(height: 4),
            Text(item['description'], style: const TextStyle(fontFamily: 'Poppins')),
            const SizedBox(height: 8),
            const Text('Klasifikasi:',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
            ...item['classification'].map<Widget>((classification) => Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                  child: Text('• $classification',
                      style: const TextStyle(fontFamily: 'Poppins')),
                )),
            const SizedBox(height: 8),
            const Text('Solusi:',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
            ...item['solution'].map<Widget>((solution) => Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                  child: Text('• $solution',
                      style: const TextStyle(fontFamily: 'Poppins')),
                )),
          ],
        ),
      ),
    );
  }
}
