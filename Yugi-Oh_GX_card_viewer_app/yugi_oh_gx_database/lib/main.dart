import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const YuGiOhCardsApp());
}

final cardsRef = FirebaseFirestore.instance
    .collection('yugioh_gx_cards')
    .withConverter<YuGiOhCard>(
      fromFirestore: (snapshots, _) => YuGiOhCard.fromJson(snapshots.data()!),
      toFirestore: (card, _) => card.toJson(),
    );

enum CardType {
  Monster,
  Spell,
  Trap,
}

class YuGiOhCardsApp extends StatelessWidget {
  const YuGiOhCardsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yu-Gi-Oh! GX Cards Database',
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: Center(child: CardList()),
      ),
    );
  }
}

class CardList extends StatefulWidget {
  const CardList({Key? key}) : super(key: key);

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  CardType filter = CardType.Monster;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yu-Gi-Oh! GX Cards'),
        actions: <Widget>[
          PopupMenuButton<CardType>(
            onSelected: (value) => setState(() => filter = value),
            icon: const Icon(Icons.filter_alt),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: CardType.Monster,
                  child: Text('Show Monsters'),
                ),
                const PopupMenuItem(
                  value: CardType.Spell,
                  child: Text('Show Spells'),
                ),
                const PopupMenuItem(
                  value: CardType.Trap,
                  child: Text('Show Traps'),
                ),
              ];
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<YuGiOhCard>>(
        stream: cardsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          final filteredCards = data.docs.where((card) {
            switch (filter) {
              case CardType.Monster:
                return card.data().cardType == 'Monster';
              case CardType.Spell:
                return card.data().cardType == 'Spell';
              case CardType.Trap:
                return card.data().cardType == 'Trap';
            }
          }).toList();

          return ListView.builder(
            itemCount: filteredCards.length,
            itemBuilder: (context, index) {
              return CardItem(
                filteredCards[index].data(),
                filteredCards[index].reference,
              );
            },
          );
        },
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem(this.card, this.reference, {Key? key}) : super(key: key);

  final YuGiOhCard card;
  final DocumentReference<YuGiOhCard> reference;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(card.cardName),
      subtitle: Text(card.description),
      trailing: Text(card.cardType),
      onTap: () {
        // Implement what happens when a card is tapped
        // For example, show card details in a dialog or navigate to a details screen
        // You can customize this as per your application's requirements
      },
    );
  }
}

@immutable
class YuGiOhCard {
  const YuGiOhCard({
    required this.cardName,
    required this.description,
    required this.cardType,
    required this.attack,
    required this.beastType,
    required this.defense,
    required this.imageUrl,
    // Add more properties for Yu-Gi-Oh! card attributes
  });

  YuGiOhCard.fromJson(Map<String, Object?> json)
      : this(
          cardName: json['cardName']! as String,
          description: json['description']! as String,
          cardType: json['card_type']! as String,
          attack: json['attack']! as int,
          beastType: json['beast_type']! as String,
          defense: json['defense']! as int,
          imageUrl: json['image_url']! as String,
          // Initialize other properties from JSON
        );

  final String cardName;
  final String description;
  final String cardType;
  final int attack;
  final String beastType;
  final int defense;
  final String imageUrl;
  // Add more properties for Yu-Gi-Oh! card attributes

  Map<String, Object?> toJson() {
    return {
      'cardName': cardName,
      'description': description,
      'card_type': cardType,
      'attack': attack,
      'beast_type': beastType,
      'defense': defense,
      'image_url': imageUrl,
      // Add other properties to serialize to JSON
    };
  }
}
