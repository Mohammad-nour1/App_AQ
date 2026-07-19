import 'package:flutter/material.dart';

import '../models/place/place.dart';
import '../models/place/place_categories.dart';
import '../models/place/place_location.dart';

List<Place> getPlaces() => [
  // ===== Damascus =====
  Place(
    id: "d1",
    name: "الجامع الأموي",
    city: "Damascus",
    category: PlaceCategories.ReligionistPlaces,
    rating: 4.9,
    location: PlaceLocation(
      address: "الجامع الأموي، دمشق",
      latitude: 33.5119,
      longitude: 36.3066,
    ),
    image: "assets/images/omawi_main.jpg",
    images: [
      "assets/images/omawi1.jpg",
      "assets/images/omawi2.jpg",
      "assets/images/omawi3.jpg",
      "assets/images/omawi4.jpg",
      "assets/images/omawi5.jpg",
      "assets/images/omawi6.jpg",
    ],
    description:
        "One of the largest and oldest mosques in the world, built in the 8th century. It is a masterpiece of Islamic architecture and houses the shrine of John the Baptist.",
  ),
  Place(
    id: "d2",
    name: "سوق الحميدية",
    city: "Damascus",
    category: PlaceCategories.Markets,
    rating: 4.5,
    location: PlaceLocation(
      address: "سوق الحميدية، دمشق",
      latitude: 33.5103,
      longitude: 36.2937,
    ),
    image: "assets/images/souq.jpg",
    images: ["assets/images/souq.jpg","assets/images/souq1.jpg"],
    description:
        "A bustling covered market dating back to the Ottoman era, famous for its handicrafts, spices, textiles, and traditional Damascene sweets.",
  ),
  Place(
    id: "d3",
    name: "جبل قاسيون",
    city: "Damascus",
    category: PlaceCategories.NaturalViews,
    rating: 4.3,
    location: PlaceLocation(
      address: "جبل قاسيون، دمشق",
      latitude: 33.5440,
      longitude: 36.2850,
    ),
    image: "assets/images/Mount_Qasioun1.jpg",
    images: ["assets/images/Mount_Qasioun1.jpg","assets/images/Mount_Qasioun.jpg"],
    description:
        "A scenic mountain overlooking Damascus, offering panoramic views of the city. A popular spot for locals and visitors, especially at sunset.",
  ),
  Place(
    id: "d4",
    name: "قصر العظم",
    city: "Damascus",
    category: PlaceCategories.HistoricalPlaces,
    rating: 4.6,
    location: PlaceLocation(
      address: "قصر العظم، البزورية، دمشق",
      latitude: 33.5100,
      longitude: 36.3068,
    ),
    image: "assets/images/Qasr_al-Azem.jpg",
    images: [
      "assets/images/Qasr_al-Azem.jpg",
      "assets/images/Qasr_al-Azem1.jpg",
      "assets/images/Qasr_al-Azem2.jpg",
    ],
    description:
        "A stunning 18th-century Ottoman palace, now a museum of arts and popular traditions. Its intricate woodwork, mosaic panels, and tranquil courtyards offer a glimpse into Damascene aristocratic life.",
  ),
  Place(
    id: "d5",
    name: "متحف دمشق الوطني",
    city: "Damascus",
    category: PlaceCategories.HistoricalPlaces,
    rating: 4.5,
    location: PlaceLocation(
      address: "متحف دمشق الوطني، شارع شكري القوتلي، دمشق",
      latitude: 33.5126,
      longitude: 36.2900,
    ),
    image: "assets/images/national_museum_main.jpg",
    images: [
      "assets/images/museum.jpg",

    ],
    description:
        "Home to an extraordinary collection of artifacts spanning Syria's 11,000-year history, including the Dura-Europos synagogue frescoes and the Ugaritic alphabet tablets.",
  ),
  Place(
    id: "d6",
    name: "ساحة المرجة",
    city: "Damascus",
    category: PlaceCategories.HistoricalPlaces,
    rating: 4.2,
    location: PlaceLocation(
      address: "ساحة المرجة، دمشق",
      latitude: 33.5132,
      longitude: 36.2963,
    ),
    image: "assets/images/marjeh_main.jpg",
    images: [
      "assets/images/marjeh_main1.jpg"
    ],
    description:
        "A historic square in central Damascus, known for its iconic Ottoman clock tower and the surrounding colonial-era buildings. It is a lively crossroads of commerce and daily life.",
  ),
  Place(
    id: "d7",
    name: "باب شرقي",
    city: "Damascus",
    category: PlaceCategories.HistoricalPlaces,
    rating: 4.4,
    location: PlaceLocation(
      address: "باب شرقي، دمشق",
      latitude: 33.5090,
      longitude: 36.3172,
    ),
    image: "assets/images/bab_sharqi.jpg",
    images: [
      "assets/images/bab_sharqi.jpg",
      "assets/images/bab_sharqi1.jpg",
    ],
    description:
        "The Eastern Gate of the old city of Damascus, one of the original Roman gates still standing. It opens into the historic Straight Street and is surrounded by vibrant souks.",
  ),
  Place(
    id: "d8",
    name: "مجمع الصالحية",
    city: "Damascus",
    category: PlaceCategories.ReligionistPlaces,
    rating: 4.3,
    location: PlaceLocation(
      address: "مجمع الصالحية، جبل قاسيون، دمشق",
      latitude: 33.5275,
      longitude: 36.2875,
    ),
    image: "assets/images/salihiya.jpg",
    images: [
      "assets/images/salihiya.jpg",
    ],
    description:
        "A historic religious complex on the slopes of Mount Qasioun, containing several mosques, madrasas, and the tomb of Sheikh Muhyiddin Ibn Arabi, a renowned Sufi mystic.",
  ),

  // ===== Aleppo =====
  Place(
    id: "a1",
    name: "قلعة حلب",
    city: "Aleppo",
    category: PlaceCategories.HistoricalPlaces,
    rating: 4.8,
    location: PlaceLocation(
      address: "قلعة حلب، حلب",
      latitude: 36.1990,
      longitude: 37.1629,
    ),
    image: "assets/images/aleppo.jpg",
    images: ["assets/images/aleppo.jpg",
    "assets/images/aleppo1.jpg","assets/images/aleppo2.jpg"],
    description:
        "A massive medieval fortified palace in the centre of Aleppo, considered one of the oldest and largest castles in the world, dating back to the 3rd millennium BC.",
  ),
  Place(
    id: "a2",
    name: "الجامع الكبير بحلب",
    city: "Aleppo",
    category: PlaceCategories.ReligionistPlaces,
    rating: 4.7,
    location: PlaceLocation(
      address: "الجامع الكبير، حلب",
      latitude: 36.1976,
      longitude: 37.1577,
    ),
    image: "assets/images/mosque.jpg",
    images: ["assets/images/mosque1.jpg"],
    description:
        "Also known as the Umayyad Mosque of Aleppo, it is the largest and oldest mosque in the city, built in the 8th century. Its minaret and courtyard are iconic.",
  ),
  Place(
    id: "a3",
    name: "سوق المدينة",
    city: "Aleppo",
    category: PlaceCategories.Markets,
    rating: 4.6,
    location: PlaceLocation(
      address: "سوق المدينة، حلب",
      latitude: 36.1982,
      longitude: 37.1604,
    ),
    image: "assets/images/souq_aleppo.jpg",
    images: ["assets/images/souq_aleppo1.jpg"],
    description:
        "A labyrinth of covered market streets stretching for kilometres, it is the largest covered historical market in the world and a UNESCO World Heritage site.",
  ),

  // ===== Homs =====
  Place(
    id: "h1",
    name: "قلعة الحصن",
    city: "Homs",
    category: PlaceCategories.HistoricalPlaces,
    rating: 4.9,
    location: PlaceLocation(
      address: "قلعة الحصن، حمص",
      latitude: 34.7569,
      longitude: 36.2945,
    ),
    image: "assets/images/castle_homs.jpg",
    images: ["assets/images/castle_homs.jpg","assets/images/castle_homs1.jpg","assets/images/castle_homs2.jpg"],
    description:
        "A Crusader castle and one of the most important preserved medieval castles in the world. It is a UNESCO World Heritage site, perched on a hill with stunning views.",
  ),
  Place(
    id: "h2",
    name: "مسجد خالد بن الوليد",
    city: "Homs",
    category: PlaceCategories.ReligionistPlaces,
    rating: 4.7,
    location: PlaceLocation(
      address: "مسجد خالد بن الوليد، حمص",
      latitude: 34.7357,
      longitude: 36.7153,
    ),
    image: "assets/images/Khalid_ib_ al-Walid1.jpg",
    images: ["assets/images/Khalid_ib_ al-Walid.jpg","assets/images/Khalid_ib_ al-Walid1.jpg","assets/images/Khalid_ib_ al-Walid2.jpg"],
    description:
        "A beautiful Ottoman-style mosque containing the tomb of the famous Muslim military commander Khalid ibn al-Walid. Its silver dome is a city landmark.",
  ),
  Place(
    id: "h3",
    name: "بحيرة قطينة",
    city: "Homs",
    category: PlaceCategories.NaturalViews,
    rating: 4.2,
    location: PlaceLocation(
      address: "بحيرة قطينة، حمص",
      latitude: 34.6500,
      longitude: 36.6000,
    ),
    image: "assets/images/syria_place3.jpg",
    images: ["assets/images/syria_place3.jpg"],
    description:
        "A large reservoir on the Orontes River, surrounded by agricultural land. It is a popular spot for picnics, birdwatching, and enjoying the natural scenery.",
  ),

  // ===== Hama =====
  Place(
    id: "hm1",
    name: "نواعير حماة",
    city: "Hama",
    category: PlaceCategories.HistoricalPlaces,
    rating: 4.6,
    location: PlaceLocation(
      address: "نواعير حماة، حماة",
      latitude: 35.1351,
      longitude: 36.7546,
    ),
    image: "assets/images/hama.jpg",
    images: ["assets/images/hama.jpg"],
    description:
        "Giant historic water wheels (norias) along the Orontes River, dating back to the Byzantine era. They are up to 20 metres in diameter and produce a distinctive sound.",
  ),
  Place(
    id: "hm2",
    name: "الجامع الكبير بحماة",
    city: "Hama",
    category: PlaceCategories.ReligionistPlaces,
    rating: 4.3,
    location: PlaceLocation(
      address: "الجامع الكبير، حماة",
      latitude: 35.1361,
      longitude: 36.7538,
    ),
    image: "assets/images/hama_.jpg",
    images: ["assets/images/hama_.jpg"],
    description:
        "An 8th-century mosque with a richly decorated minaret and a peaceful courtyard. It stands on the site of a former Roman temple.",
  ),
  Place(
    id: "hm3",
    name: "قلعة حماة",
    city: "Hama",
    category: PlaceCategories.HistoricalPlaces,
    rating: 4.0,
    location: PlaceLocation(
      address: "قلعة حماة، حماة",
      latitude: 35.1369,
      longitude: 36.7481,
    ),
    image: "assets/images/Hama.jpg",
    images: ["assets/images/Hama.jpg"],
    description:
        "An ancient tell (mound) that once held a citadel. Today it is an archaeological site with remains of various civilisations, offering a view over the city.",
  ),

  // ===== Latakia =====
  Place(
    id: "l1",
    name: "قلعة صلاح الدين",
    city: "Latakia",
    category: PlaceCategories.HistoricalPlaces,
    rating: 4.7,
    location: PlaceLocation(
      address: "قلعة صلاح الدين، اللاذقية",
      latitude: 35.5836,
      longitude: 35.8839,
    ),
    image: "assets/images/Latakia1.jpg",
    images: ["assets/images/Latakia.jpg","assets/images/Latakia1.jpg","assets/images/Latakia2.jpg"],
    description:
        "A Crusader fortress built on a narrow rocky ridge, surrounded by deep ravines. It is a UNESCO World Heritage site and a remarkable example of military architecture.",
  ),
  Place(
    id: "l2",
    name: "أوغاريت",
    city: "Latakia",
    category: PlaceCategories.HistoricalPlaces,
    rating: 4.6,
    location: PlaceLocation(
      address: "أوغاريت، اللاذقية",
      latitude: 35.6021,
      longitude: 35.7845,
    ),
    image: "assets/images/Latakia4.jpg",
    images: ["assets/images/Latakia4.jpg"],
    description:
        "The ruins of the ancient Bronze Age city of Ugarit, where the world's oldest known alphabet was discovered. A fascinating site for history enthusiasts.",
  ),
  Place(
    id: "l3",
    name: "كورنيش اللاذقية",
    city: "Latakia",
    category: PlaceCategories.NaturalViews,
    rating: 4.4,
    location: PlaceLocation(
      address: "كورنيش اللاذقية، اللاذقية",
      latitude: 35.5200,
      longitude: 35.7800,
    ),
    image: "assets/images/sae1.jpg",
    images: ["assets/images/sae.jpg","assets/images/sae.jpg"],
    description:
        "A beautiful seaside promenade along the Mediterranean coast, lined with palm trees, cafés, and restaurants. Ideal for a relaxing walk by the sea.",
  ),

  // ===== Deir ez-Zor =====
  Place(
    id: "dz1",
    name: "الجسر المعلق بدير الزور",
    city: "Deir ez-Zor",
    category: PlaceCategories.HistoricalPlaces,
    rating: 4.0,
    location: PlaceLocation(
      address: "الجسر المعلق، دير الزور",
      latitude: 35.3339,
      longitude: 40.1531,
    ),
    image: "assets/images/Deir_ez-Zor1.jpg",
    images: ["assets/images/Deir_ez-Zor1.jpg","assets/images/Deir_ez-Zor.jpg"],
    description:
        "A historic pedestrian suspension bridge over the Euphrates River, built during the French Mandate period. It is a symbol of the city and offers great river views.",
  ),
  Place(
    id: "dz2",
    name: "متحف دير الزور",
    city: "Deir ez-Zor",
    category: PlaceCategories.HistoricalPlaces,
    rating: 4.2,
    location: PlaceLocation(
      address: "متحف دير الزور، دير الزور",
      latitude: 35.3372,
      longitude: 40.1372,
    ),
    image: "assets/images/museum.jpg",
    images: ["assets/images/museum.jpg"],
    description:
        "The museum houses a rich collection of artefacts from ancient Mesopotamian civilisations, including tablets, pottery, and jewellery found in the region.",
  ),
  Place(
    id: "dz3",
    name: "ضفاف الفرات",
    city: "Deir ez-Zor",
    category: PlaceCategories.NaturalViews,
    rating: 4.1,
    location: PlaceLocation(
      address: "ضفاف الفرات، دير الزور",
      latitude: 35.3300,
      longitude: 40.1500,
    ),
    image: "assets/images/River.jpg",
    images: ["assets/images/River.jpg","assets/images/River1.jpg"],
    description:
        "The broad Euphrates River cuts through the desert landscape. The riverbank is a popular gathering place for families, especially during spring when the weather is mild.",
  ),

  // ===== Raqqa =====
  Place(
    id: "r1",
    name: "قصر البنات",
    city: "Raqqa",
    category: PlaceCategories.HistoricalPlaces,
    rating: 3.9,
    location: PlaceLocation(
      address: "قصر البنات، الرقة",
      latitude: 35.9495,
      longitude: 39.0205,
    ),
    image: "assets/images/Raqqa.jpg",
    images: ["assets/images/Raqqa.jpg"],
    description:
        "Ruins of a 12th-century brick palace complex, believed to have been a residence for the daughters of the ruling family. The site reflects Abbasid architectural styles.",
  ),
  Place(
    id: "r2",
    name: "مسجد المنصور (أطلال)",
    city: "Raqqa",
    category: PlaceCategories.ReligionistPlaces,
    rating: 3.8,
    location: PlaceLocation(
      address: "مسجد المنصور، الرقة",
      latitude: 35.9490,
      longitude: 39.0190,
    ),
    image: "assets/images/raqqa1.jpg",
    images: ["assets/images/raqqa1.jpg"],
    description:
        "The remains of a grand mosque built during the Abbasid Caliphate by Caliph al-Mansur. Though largely destroyed, the surviving brick structures are historically significant.",
  ),
  Place(
    id: "r3",
    name: "ممشى الفرات",
    city: "Raqqa",
    category: PlaceCategories.NaturalViews,
    rating: 3.7,
    location: PlaceLocation(
      address: "ممشى الفرات، الرقة",
      latitude: 35.9500,
      longitude: 39.0100,
    ),
    image: "assets/images/raqqa2.jpg",
    images: ["assets/images/raqqa2.jpg"],
    description:
        "A riverside park and walkway along the Euphrates, offering a green escape from the city. It's a favourite spot for evening strolls and picnics.",
  ),

  // ===== Hasakah =====
  Place(
    id: "hsk1",
    name: "تل براك",
    city: "Hasakah",
    category: PlaceCategories.HistoricalPlaces,
    rating: 4.3,
    location: PlaceLocation(
      address: "تل براك، الحسكة",
      latitude: 36.6683,
      longitude: 41.0583,
    ),
    image: "assets/images/Hasakah.jpg",
    images: ["assets/images/Hasakah.jpg"],
    description:
        "One of the oldest cities in the world, dating back to the 6th millennium BC. Excavations revealed temples, palaces, and famous eye idols. A must-see for archaeology lovers.",
  ),
  Place(
    id: "hsk2",
    name: "متحف الحسكة",
    city: "Hasakah",
    category: PlaceCategories.HistoricalPlaces,
    rating: 4.0,
    location: PlaceLocation(
      address: "متحف الحسكة، الحسكة",
      latitude: 36.4975,
      longitude: 40.7472,
    ),
    image: "assets/images/Hasakah2.jpg",
    images: ["assets/images/Hasakah2.jpg"],
    description:
        "The museum displays artefacts from various archaeological sites in the Jazira region, including pottery, tools, and statues from the Neolithic to Islamic periods.",
  ),
  Place(
    id: "hsk3",
    name: "نهر الخابور",
    city: "Hasakah",
    category: PlaceCategories.NaturalViews,
    rating: 4.2,
    location: PlaceLocation(
      address: "نهر الخابور، الحسكة",
      latitude: 36.4980,
      longitude: 40.7450,
    ),
    image: "assets/images/Hasakah3.jpg",
    images: ["assets/images/Hasakah3.jpg"],
    description:
        "A major tributary of the Euphrates, the Khabur River supports a fertile valley. It is a serene setting for nature walks and observing local wildlife.",
  ),

  // ===== Idlib =====
  Place(
    id: "i1",
    name: "إيبلا (تل مرديخ)",
    city: "Idlib",
    category: PlaceCategories.HistoricalPlaces,
    rating: 4.6,
    location: PlaceLocation(
      address: "إيبلا، إدلب",
      latitude: 35.8281,
      longitude: 36.7961,
    ),
    image: "assets/images/idlib.jpg",
    images: ["assets/images/idlib.jpg"],
    description:
        "The site of the ancient kingdom of Ebla, one of the most important archaeological discoveries of the 20th century. Thousands of cuneiform tablets were found here.",
  ),
  Place(
    id: "i2",
    name: "سيرجيلة (المدن المنسية)",
    city: "Idlib",
    category: PlaceCategories.HistoricalPlaces,
    rating: 4.5,
    location: PlaceLocation(
      address: "سيرجيلة، إدلب",
      latitude: 35.8278,
      longitude: 36.5842,
    ),
    image: "assets/images/idlib1.jpg",
    images: ["assets/images/idlib1.jpg"],
    description:
        "One of the best-preserved 'Dead Cities' of northern Syria, featuring ancient Byzantine stone buildings, including a bathhouse, villas, and a church.",
  ),
  Place(
    id: "i3",
    name: "متحف إدلب",
    city: "Idlib",
    category: PlaceCategories.HistoricalPlaces,
    rating: 3.9,
    location: PlaceLocation(
      address: "متحف إدلب، إدلب",
      latitude: 35.9308,
      longitude: 36.6322,
    ),
    image: "assets/images/idlib2.jpg",
    images: ["assets/images/idlib2.jpg"],
    description:
        "A regional museum that exhibits finds from the many archaeological sites around Idlib, including mosaics, pottery, and statues from different eras.",
  ),

  // ===== Daraa =====
  Place(
    id: "dr1",
    name: "المسرح الروماني بدرعا",
    city: "Daraa",
    category: PlaceCategories.HistoricalPlaces,
    rating: 4.3,
    location: PlaceLocation(
      address: "المسرح الروماني، درعا",
      latitude: 32.6253,
      longitude: 36.1083,
    ),
    image: "assets/images/darra.jpg",
    images: ["assets/images/darra.jpg"],
    description:
        "A well-preserved Roman theatre built in the 2nd century AD, once seating up to 15,000 spectators. It is still used for cultural events today.",
  ),
  Place(
    id: "dr2",
    name: "المسجد العمري",
    city: "Daraa",
    category: PlaceCategories.ReligionistPlaces,
    rating: 4.2,
    location: PlaceLocation(
      address: "المسجد العمري، درعا",
      latitude: 32.6235,
      longitude: 36.1059,
    ),
    image: "assets/images/darra2.jpg",
    images: ["assets/images/darra2.jpg"],
    description:
        "An early Islamic mosque built on the site of a Roman temple, reflecting centuries of religious history. It is the heart of the city's old quarter.",
  ),
  Place(
    id: "dr3",
    name: "برج الساعة بدرعا",
    city: "Daraa",
    category: PlaceCategories.HistoricalPlaces,
    rating: 3.9,
    location: PlaceLocation(
      address: "برج الساعة، درعا",
      latitude: 32.6232,
      longitude: 36.1035,
    ),
    image: "assets/images/darra2.jpg",
    images: ["assets/images/darra2.jpg"],
    description:
        "A stone clock tower from the Ottoman period, located in the city centre. It is a popular meeting point and a reminder of the city's Ottoman heritage.",
  ),

  // ===== As-Suwayda =====
  Place(
    id: "s1",
    name: "شهبا (فيليبوبوليس)",
    city: "As-Suwayda",
    category: PlaceCategories.HistoricalPlaces,
    rating: 4.3,
    location: PlaceLocation(
      address: "شهبا، السويداء",
      latitude: 32.8422,
      longitude: 36.6306,
    ),
    image: "assets/images/shahba.jpg",
    images: ["assets/images/shahba.jpg"],
    description:
        "The ancient Roman city of Philippopolis, birthplace of Emperor Philip the Arab. It contains well-preserved mosaics, a theatre, and baths.",
  ),
  Place(
    id: "s2",
    name: "قنوات",
    city: "As-Suwayda",
    category: PlaceCategories.HistoricalPlaces,
    rating: 4.4,
    location: PlaceLocation(
      address: "قنوات، السويداء",
      latitude: 32.7539,
      longitude: 36.6192,
    ),
    image: "assets/images/kanwat.jpg",
    images: ["assets/images/kanwat.jpg"],
    description:
        "Ancient Roman ruins set among modern buildings, including a beautiful temple complex, basilica, and a nymphaeum. A charming site with basalt stone architecture.",
  ),
  Place(
    id: "s3",
    name: "متحف السويداء",
    city: "As-Suwayda",
    category: PlaceCategories.HistoricalPlaces,
    rating: 4.1,
    location: PlaceLocation(
      address: "متحف السويداء، السويداء",
      latitude: 32.7147,
      longitude: 36.5658,
    ),
    image: "assets/images/suwayda.jpg",
    images: ["assets/images/suwayda.jpg","assets/images/suwayda1.jpg"],
    description:
        "The museum houses an outstanding collection of Roman and Byzantine mosaics, as well as statues and jewellery from the Hauran region.",
  ),
];
Map<String, Color> getCityColors() => {
  'Damascus': Colors.red,
  'Aleppo': Colors.blue,
  'Homs': Colors.orange,
  'Hama': Colors.green,
  'Latakia': Colors.teal,
  'Deir ez-Zor': Colors.purple,
  'Raqqa': Colors.brown,
  'Hasakah': Colors.pink,
  'Idlib': Colors.indigo,
  'Daraa': Colors.cyan,
  'As-Suwayda': Colors.lime,
};
List<String> getAllCities() => [
  'Damascus',
  'Aleppo',
  'Homs',
  'Hama',
  'Latakia',
  'Deir ez-Zor',
  'Raqqa',
  'Hasakah',
  'Idlib',
  'Daraa',
  'As-Suwayda',
];
