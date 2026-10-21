class Doctor {
  const Doctor({
    required this.nume,
    required this.specialitate,
    required this.adresa,
    required this.imagine,
    required this.servicii,
    required this.pret,
  });

  final String nume;
  final String specialitate;
  final String adresa;
  final String imagine;

  // Categoriile din "Health Services" în care apare medicul
  final List<String> servicii;
  final String pret;
}

const medici = [
  Doctor(
    nume: 'Dr. Emmly Lestiryno',
    specialitate: 'General Practitioner',
    adresa: '3167 Durgan Shores - 500M from you',
    imagine: 'assets/images/doctor_emmly.png',
    servicii: ['Eye', 'Ear', 'Lungs'],
    pret: '\$80.00',
  ),
  Doctor(
    nume: 'Dr. Sonja Littel',
    specialitate: 'Dental Specialist',
    adresa: '950 Sigrid Port - 753M from you',
    imagine: 'assets/images/doctor_sonja.png',
    servicii: ['Tooth'],
    pret: '\$100.00',
  ),
  Doctor(
    nume: 'Dr. Richar Kandowen',
    specialitate: 'Child Specialist',
    adresa: '12 Harbor Lane - 1.2KM from you',
    imagine: 'assets/images/doctor_richar.png',
    servicii: ['Lungs', 'Ear'],
    pret: '\$90.00',
  ),
  Doctor(
    nume: 'Dr.Upul',
    specialitate: 'Denteeth',
    adresa: '48 Maple Street - 1.5KM from you',
    imagine: 'assets/images/doctor_upul.png',
    servicii: ['Tooth'],
    pret: '\$120.00',
  ),
];
