import 'package:flutter/material.dart';

import 'doctor.dart';
import 'main.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key, required this.medic});

  final Doctor medic;

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  static const _ore = [
    '10.00 AM',
    '11.00 AM',
    '12.00 PM',
    '01.00 PM',
    '02.00 PM',
    '03.00 PM',
    '04.00 PM',
  ];
  static const _zile = [
    'Sun 4',
    'Mon 5',
    'Tue 6',
    'Wed 7',
    'Thu 8',
    'Fri 9',
    'Sat 10',
  ];

  int _oraSelectata = 1;
  int _ziSelectata = 0;

  // "See All" comută între lista orizontală și afișarea tuturor opțiunilor
  bool _toateOrele = false;
  bool _toateZilele = false;

  void _mesaj(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _rezerva() {
    _mesaj('Programare: ${_zile[_ziSelectata]}, ${_ore[_oraSelectata]}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        title: const Text(
          'Appointment',
          style: TextStyle(
            color: kPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _medic(),
                    ),
                    const SizedBox(height: 40),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 14),
                          Text(
                            'Worem ipsum dolor sit amet, consectetur adipiscing '
                            'elit. Nunc vulputate libero et velit interdum, ac '
                            'aliquet odio mattis. Class aptent taciti sociosqu '
                            'ad litora torquent per conubia nostra, per inceptos '
                            'himenaeos. Curabitur tempus urna at turpis '
                            'condimentum lobortis. Ut commodo efficitur neque. '
                            'Ut diam quam, semper iaculis condimentum ac, '
                            'vestibulum eu nisl.',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.35,
                              color: kGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    _titluSectiune(
                      'Working Hours',
                      _toateOrele,
                      () => setState(() => _toateOrele = !_toateOrele),
                    ),
                    const SizedBox(height: 14),
                    _optiuni(
                      _ore,
                      _oraSelectata,
                      _toateOrele,
                      (i) => setState(() => _oraSelectata = i),
                    ),
                    const SizedBox(height: 24),
                    _titluSectiune(
                      'Date',
                      _toateZilele,
                      () => setState(() => _toateZilele = !_toateZilele),
                    ),
                    const SizedBox(height: 14),
                    _optiuni(
                      _zile,
                      _ziSelectata,
                      _toateZilele,
                      (i) => setState(() => _ziSelectata = i),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _rezerva,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Book an Appointment',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _medic() {
    final medic = widget.medic;
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            medic.imagine,
            width: 130,
            height: 130,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 22),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      medic.nume,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _actiune(Icons.chat_bubble_outline, 'Chat'),
                  _actiune(Icons.phone_outlined, 'Call'),
                  _actiune(Icons.videocam_outlined, 'Video call'),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                medic.specialitate,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: kAccent,
                ),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Payment',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    medic.pret,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: kAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actiune(IconData icon, String nume) {
    return GestureDetector(
      onTap: () => _mesaj('$nume: ${widget.medic.nume}'),
      child: Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.only(left: 8),
        decoration: const BoxDecoration(
          color: Color(0xFFD8ECE8),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 17, color: Colors.black87),
      ),
    );
  }

  Widget _titluSectiune(String titlu, bool extins, VoidCallback laApasare) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titlu,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          GestureDetector(
            onTap: laApasare,
            child: Text(
              extins ? 'See Less' : 'See All',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _optiune(String text, bool activ, VoidCallback laApasare) {
    return GestureDetector(
      onTap: laApasare,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: activ ? kPrimary : kChip,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: activ ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Opțiunile selectabile: listă orizontală sau, la "See All", toate pe rânduri
  Widget _optiuni(
    List<String> valori,
    int selectat,
    bool extins,
    ValueChanged<int> laSelectare,
  ) {
    if (extins) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            for (var i = 0; i < valori.length; i++)
              _optiune(valori[i], i == selectat, () => laSelectare(i)),
          ],
        ),
      );
    }

    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: valori.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, i) =>
            _optiune(valori[i], i == selectat, () => laSelectare(i)),
      ),
    );
  }
}
