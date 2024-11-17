import 'package:flutter/material.dart';

class WrinklepediaPage extends StatelessWidget {
  final List<Map<String, dynamic>> wrinkleData = [
    {
      'title': 'No Wrinkles (Tanpa kerutan)',
      'image': 'assets/images/no_wrinkles.jpg',
      'description':
          'Kulit tanpa kerutan, dengan tanda-tanda penuaan minimal dan tekstur kulit yang masih terjaga baik.',
      'classification': [
        'Photoaging ringan',
        'Perubahan pigmentasi ringan',
        'Tidak ada tumor kulit',
        'Kerut minimal'
      ],
      'solution': [
        'Pencegahan dengan perlindungan terhadap sinar matahari (menggunakan tabir surya secara rutin) dan menghindari faktor-faktor yang mempercepat penuaan kulit (seperti merokok dan polusi).',
        'Pemakaian krim pelembab yang mengandung antioksidan seperti vitamin C, E, dan retinoid untuk mempertahankan elastisitas kulit.',
        'Menjaga nutrisi dengan diet yang seimbang serta mengonsumsi suplemen antioksidan.',
        'Rutin berolahraga dan menjaga gaya hidup sehat.'
      ]
    },
    {
      'title': 'Wrinkles in Motion (Kerutan ringan)',
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
      'title': 'Wrinkles at Rest (Kerutan sedang)',
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
      'title': 'Only Wrinkles (Kerutan berat)',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wrinklepedia'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
      body: ListView.builder(
        itemCount: wrinkleData.length,
        itemBuilder: (context, index) {
          final item = wrinkleData[index];
          return ExpansionTile(
            title: Text(item['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      item['image'],
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 8),
                    Text('Pengertian:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(item['description']),
                    SizedBox(height: 8),
                    Text('Klasifikasi:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ...item['classification']
                        .map<Widget>((classification) => Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, top: 4.0),
                              child: Text('- $classification'),
                            )),
                    SizedBox(height: 8),
                    Text('Solusi:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ...item['solution'].map<Widget>((solution) => Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                          child: Text('- $solution'),
                        )),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
