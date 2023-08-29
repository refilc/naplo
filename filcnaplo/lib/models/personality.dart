class Personality {
  PersonalityType type;

  Personality({
    this.type = PersonalityType.npc,
  });
}

enum PersonalityType {
  geek,
  sick,
  late,
  quitter,
  healthy,
  acceptable,
  fallible,
  average,
  diligent,
  cheater,
  npc
}
