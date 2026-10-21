import 'package:flutter/material.dart';

import 'appointment_page.dart';
import 'doctor.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _servicii = ['Tooth', 'Eye', 'Lungs', 'Ear'];

  // Medicii marcați ca favoriți (inimioara din listă)
  final Set<String> _favoriti = {};

  String? _serviciuSelectat;
  String _textCautat = '';
  bool _totiMedicii = false;

  // Lista afișată la "Nearby Doctor", după serviciul ales și textul căutat
  List<Doctor> get _mediciAfisati {
    final text = _textCautat.trim().toLowerCase();
    final filtrat = _serviciuSelectat != null || text.isNotEmpty;

    final rezultat = medici.where((m) {
      final potrivitServiciu =
          _serviciuSelectat == null || m.servicii.contains(_serviciuSelectat);
      final potrivitText =
          text.isEmpty ||
          m.nume.toLowerCase().contains(text) ||
          m.specialitate.toLowerCase().contains(text);
      return potrivitServiciu && potrivitText;
    }).toList();

    // Fără filtru se arată doar primii doi, ca în design
    if (!filtrat && !_totiMedicii) return rezultat.take(2).toList();
    return rezultat;
  }

  void _deschideProgramare(Doctor medic) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AppointmentPage(medic: medic)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lista = _mediciAfisati;
    final filtrat = _serviciuSelectat != null || _textCautat.trim().isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _antet(),
              const SizedBox(height: 24),
              _cautare(),
              const SizedBox(height: 24),
              _cardProgramare(),
              const SizedBox(height: 52),
              _titluSectiune(
                'Health Services',
                _serviciuSelectat == null ? 'See All' : 'Clear',
                () => setState(() => _serviciuSelectat = null),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [for (final s in _servicii) _serviciu(s)],
              ),
              const SizedBox(height: 28),
              _titluSectiune(
                'Nearby Doctor',
                filtrat ? '' : (_totiMedicii ? 'See Less' : 'See All'),
                () => setState(() => _totiMedicii = !_totiMedicii),
              ),
              const SizedBox(height: 8),
              if (lista.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No doctors found',
                      style: TextStyle(color: kGrey),
                    ),
                  ),
                ),
              for (final m in lista) _medic(m),
            ],
          ),
        ),
      ),
    );
  }

  Widget _antet() {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            'assets/images/user_jonathan.png',
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, Jonathan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: kDark,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'May you always be healthy',
                style: TextStyle(fontSize: 11, color: kGrey),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            const Icon(Icons.notifications_none, size: 28, color: kDark),
            Positioned(
              right: 3,
              top: 3,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _cautare() {
    return TextField(
      onChanged: (text) => setState(() => _textCautat = text),
      decoration: InputDecoration(
        hintText: 'Search something',
        hintStyle: const TextStyle(color: Color(0xFFB4B8C5), fontSize: 14),
        prefixIcon: const Icon(Icons.search, color: Color(0xFFB4B8C5)),
        suffixIcon: const Icon(Icons.tune, color: Color(0xFFB4B8C5)),
        filled: true,
        fillColor: const Color(0xFFF7F8FA),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _cardProgramare() {
    // Programarea existentă este la Dr. Richar Kandowen
    final medic = medici[2];

    return GestureDetector(
      onTap: () => _deschideProgramare(medic),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 62),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF34B3C4), Color(0xFF1E9DB8)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Appointment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        children: [
                          _RandInfo(
                            Icons.event_available_outlined,
                            '22 October, 2023',
                          ),
                          SizedBox(height: 10),
                          _RandInfo(Icons.access_time, '08:00 AM - 10.30 AM'),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit_note,
                        color: Color(0xFF1E9DB8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 22,
            right: 22,
            bottom: -26,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      medic.imagine,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medic.nume,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: kDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          medic.specialitate,
                          style: const TextStyle(fontSize: 12, color: kGrey),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chat_outlined, color: kDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _titluSectiune(String titlu, String actiune, VoidCallback laApasare) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          titlu,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: kDark,
          ),
        ),
        GestureDetector(
          onTap: laApasare,
          child: Text(
            actiune,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E9DB8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _serviciu(String nume) {
    final activ = _serviciuSelectat == nume;
    return GestureDetector(
      // A doua apăsare pe același serviciu scoate filtrul
      onTap: () => setState(() => _serviciuSelectat = activ ? null : nume),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: activ ? const Color(0xFFDFF3F6) : const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: activ ? kPrimary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Image.asset(
              'assets/images/${nume.toLowerCase()}.png',
              width: 40,
              height: 40,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            nume,
            style: TextStyle(
              fontSize: 14,
              color: activ ? kPrimary : kGrey,
              fontWeight: activ ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _medic(Doctor medic) {
    final favorit = _favoriti.contains(medic.nume);
    return InkWell(
      onTap: () => _deschideProgramare(medic),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: Image.asset(
                medic.imagine,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medic.nume,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: kDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    medic.specialitate,
                    style: const TextStyle(fontSize: 12, color: kGrey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: Color(0xFF1E9DB8),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          medic.adresa,
                          style: const TextStyle(fontSize: 12, color: kDark),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  favorit
                      ? _favoriti.remove(medic.nume)
                      : _favoriti.add(medic.nume);
                });
              },
              icon: Icon(
                favorit ? Icons.favorite : Icons.favorite_border,
                color: favorit ? Colors.red : kGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RandInfo extends StatelessWidget {
  const _RandInfo(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
