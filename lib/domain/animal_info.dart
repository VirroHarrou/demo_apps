class AnimalInfo {
  final String name;
  final String description;
  final String likes;
  final String fileName;

  const AnimalInfo({
    required this.name,
    required this.description,
    required this.likes,
    required this.fileName,
  });
}

const List<AnimalInfo> zooEncyclopedia = [
  AnimalInfo(
    name: "Тигр",
    description: "Могучий хищник с полосатым мехом. Охотится в джунглях.",
    likes: "Любит: Свежее мясо",
    fileName: "tiger.png",
  ),
  AnimalInfo(
    name: "Панда",
    description: "Большой бамбуковый медведь из горных лесов Китая.",
    likes: "Любит: Молодой бамбук",
    fileName: "panda.png",
  ),
  AnimalInfo(
    name: "Обезьяна",
    description: "Ловкое и веселое животное, мастер лазания по деревьям.",
    likes: "Любит: Спелые бананы",
    fileName: "monkey.png",
  ),
  AnimalInfo(
    name: "Медведь",
    description: "Лесной великан. Отличный рыболов и любитель поспать зимой.",
    likes: "Любит: Свежую рыбку",
    fileName: "bear.png",
  ),
  AnimalInfo(
    name: "Корова",
    description: "Доброе домашнее животное, дающее полезное молоко.",
    likes: "Любит: Сочное пшено и траву",
    fileName: "cow.png",
  ),
  AnimalInfo(
    name: "Ворона",
    description: "Очень умная птица. Находит выход из любых ситуаций.",
    likes: "Любит: Семечки и зерна",
    fileName: "crow.png",
  ),
];
