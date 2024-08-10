import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addYuGiOhCardsToFirestore() async {
  // Initialize Firebase
  await Firebase.initializeApp();

  // Access the Firestore instance
  final firestore = FirebaseFirestore.instance;

  // Sample Yu-Gi-Oh! card data
  final List<Map<String, dynamic>> cardsData = [
    {
      'cardName': 'Dark Magician',
      'description': 'The ultimate wizard.',
      'type': 'Monster',
      // Other card properties...
    },
    {
      'cardName': 'Mirror Force',
      'description': 'Trap card for defense.',
      'type': 'Trap',
      // Other card properties...
    },
    {
      'cardName': 'Raigeki',
      'description': 'Destroy all opponent\'s monsters.',
      'type': 'Spell',
      // Other card properties...
    },
    // Add more cards...
  ];

  // Add cards to Firestore
  for (final cardData in cardsData) {
    await firestore.collection('yugioh_cards').add(cardData);
  }

  print('Yu-Gi-Oh! cards added to Firestore!');
}

void main() {
  addYuGiOhCardsToFirestore();
}
