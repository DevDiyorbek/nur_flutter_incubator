/// Object equipable by a [Character].
abstract class Item {}
enum Slot { hand, hat, torso, legs, shoes }

/// Entity equipping [Item]s.
class Character {
  Item? leftHand;
  Item? rightHand;
  Item? hat;
  Item? torso;
  Item? legs;
  Item? shoes;

  Iterable<Item> get equipped =>
      [leftHand, rightHand, hat, torso, legs, shoes].whereType<Item>();

  int get damage {
    return equipped
        .whereType<Weapon>()
        .fold(0, (sum, weapon) => sum + weapon.damage);
  }

  int get defense {
    return equipped
        .whereType<Armor>()
        .fold(0, (sum, armor) => sum + armor.defense);
  }

  void equip(Item item) {
    if (item is Weapon) {
      if (rightHand == null) {
        rightHand = item;
        return;
      } else if (leftHand == null) {
        leftHand = item;
        return;
      } else {
        throw OverflowException();
      }
    }

    if (item is Armor) {
      switch (item.slot) {
        case Slot.hat:
          if (hat == null) {
            hat = item;
            return;
          }
          throw OverflowException();
        case Slot.torso:
          if (torso == null) {
            torso = item;
            return;
          }
          throw OverflowException();
        case Slot.legs:
          if (legs == null) {
            legs = item;
            return;
          }
          throw OverflowException();
        case Slot.shoes:
          if (shoes == null) {
            shoes = item;
            return;
          }
          throw OverflowException();
        case Slot.hand:
          print("This item can not be equipped to hand");
      }
    }
  }
}

mixin Weapon on Item {
  int get damage;
  Slot get slot;
}

mixin Armor on Item {
  int get defense;
  Slot get slot;
}

class Sword extends Item with Weapon {
  @override
  final int damage;
  @override
  final Slot slot = Slot.hand;

  Sword(this.damage);
}

class Dagger extends Item with Weapon {
  @override
  final int damage;
  @override
  final Slot slot = Slot.hand;

  Dagger(this.damage);
}

class Helmet extends Item with Armor {
  @override
  final int defense;
  @override
  final Slot slot = Slot.hat;

  Helmet(this.defense);
}

class Chestplate extends Item with Armor {
  @override
  final int defense;
  @override
  final Slot slot = Slot.torso;

  Chestplate(this.defense);
}

class OverflowException implements Exception {}

void main() {
  Character character = Character();
  character.equip(Sword(15));
  character.equip(Dagger(10));
  character.equip(Chestplate(15));
  character.equip(Helmet(5));
  character.equip(Helmet(5));

  print(character.damage);
  print(character.defense);
}
