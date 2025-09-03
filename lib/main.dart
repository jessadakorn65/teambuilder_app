import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const TeamBuilderApp());
}

class TeamBuilderApp extends StatelessWidget {
  const TeamBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TeamBuilder (Pokémon + GetX)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const PokemonListPage(),
    );
  }
}

/* =======================
   Model
======================= */
class Pokemon {
  final String name;
  final String image;
  final String type;
  final List<String> skills;

  const Pokemon({
    required this.name,
    required this.image,
    required this.type,
    this.skills = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pokemon && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class TeamPreset {
  String name;
  List<String> memberNames; // เก็บเป็น "ชื่อ" เพื่อ serialize ง่าย

  TeamPreset({required this.name, required this.memberNames});

  Map<String, dynamic> toJson() => {'name': name, 'members': memberNames};

  factory TeamPreset.fromJson(Map<String, dynamic> j) => TeamPreset(
        name: j['name'] as String,
        memberNames: List<String>.from(j['members'] ?? []),
      );
}

/* =======================
   Data ≥ 20 Pokémon + รูป
======================= */
const String base =
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork';

const List<Pokemon> allPokemon = [
  Pokemon(name: 'Bulbasaur', image: '$base/1.png', type: "Grass", skills: ["Vine Whip", "Leech Seed"]),
  Pokemon(name: 'Ivysaur', image: '$base/2.png', type: "Grass", skills: ["Razor Leaf"]),
  Pokemon(name: 'Venusaur', image: '$base/3.png', type: "Grass", skills: ["Solar Beam"]),
  Pokemon(name: 'Charmander', image: '$base/4.png', type: "Fire", skills: ["Ember"]),
  Pokemon(name: 'Charmeleon', image: '$base/5.png', type: "Fire", skills: ["Flame Burst"]),
  Pokemon(name: 'Charizard', image: '$base/6.png', type: "Fire", skills: ["Flamethrower", "Air Slash"]),
  Pokemon(name: 'Squirtle', image: '$base/7.png', type: "Water", skills: ["Water Gun"]),
  Pokemon(name: 'Wartortle', image: '$base/8.png', type: "Water", skills: ["Water Pulse"]),
  Pokemon(name: 'Blastoise', image: '$base/9.png', type: "Water", skills: ["Hydro Pump"]),
  Pokemon(name: 'Caterpie', image: '$base/10.png', type: "Bug", skills: ["Tackle"]),
  Pokemon(name: 'Pikachu', image: '$base/25.png', type: "Electric", skills: ["Thunderbolt"]),
  Pokemon(name: 'Jigglypuff', image: '$base/39.png', type: "Fairy", skills: ["Sing"]),
  Pokemon(name: 'Meowth', image: '$base/52.png', type: "Normal", skills: ["Bite"]),
  Pokemon(name: 'Psyduck', image: '$base/54.png', type: "Water", skills: ["Confusion"]),
  Pokemon(name: 'Machop', image: '$base/66.png', type: "Fighting", skills: ["Karate Chop"]),
  Pokemon(name: 'Geodude', image: '$base/74.png', type: "Rock", skills: ["Rock Throw"]),
  Pokemon(name: 'Onix', image: '$base/95.png', type: "Rock", skills: ["Rock Tomb"]),
  Pokemon(name: 'Eevee', image: '$base/133.png', type: "Normal", skills: ["Quick Attack"]),
  Pokemon(name: 'Snorlax', image: '$base/143.png', type: "Normal", skills: ["Body Slam"]),
  Pokemon(name: 'Articuno', image: '$base/144.png', type: "Ice", skills: ["Ice Beam"]),
  Pokemon(name: 'Zapdos', image: '$base/145.png', type: "Electric", skills: ["Discharge"]),
  Pokemon(name: 'Moltres', image: '$base/146.png', type: "Fire", skills: ["Flamethrower"]),
  Pokemon(name: 'Dratini', image: '$base/147.png', type: "Dragon", skills: ["Dragon Breath"]),
  Pokemon(name: 'Mewtwo', image: '$base/150.png', type: "Psychic", skills: ["Psychic"]),
  Pokemon(name: 'Mew', image: '$base/151.png', type: "Psychic", skills: ["Aura Sphere"]),
];

Pokemon? findPokemon(String name) =>
    allPokemon.firstWhereOrNull((p) => p.name.toLowerCase() == name.toLowerCase());

/* =======================
   Type chart (ย่อ) + สี
======================= */
const Map<String, List<String>> typeAdvantages = {
  "Fire": ["Grass", "Ice"],
  "Water": ["Fire", "Rock"],
  "Grass": ["Water", "Rock"],
  "Electric": ["Water", "Flying"],
  "Rock": ["Fire", "Flying", "Ice"],
  "Flying": ["Grass", "Fighting", "Bug"],
  "Ground": ["Electric", "Fire", "Rock"],
  "Fighting": ["Rock", "Ice"],
  "Psychic": ["Fighting", "Poison"],
  "Ice": ["Grass", "Flying"],
  "Dragon": ["Dragon"],
  "Poison": ["Grass", "Fairy"],
  "Bug": ["Grass", "Psychic"],
  "Ghost": ["Psychic"],
  "Steel": ["Rock", "Ice", "Fairy"],
  "Fairy": ["Fighting", "Dragon"],
  "Normal": [],
};

List<String> weaknessesOf(String t) {
  final losers = <String>[];
  typeAdvantages.forEach((attacker, losersList) {
    if (losersList.contains(t)) losers.add(attacker);
  });
  return losers;
}

Color typeColor(String t, BuildContext ctx) {
  switch (t) {
    case "Fire":
      return Colors.orange;
    case "Water":
      return Colors.blue;
    case "Grass":
      return Colors.green;
    case "Electric":
      return Colors.amber;
    case "Rock":
      return Colors.brown;
    case "Flying":
      return Colors.indigo;
    case "Ground":
      return Colors.deepOrange;
    case "Fighting":
      return Colors.red;
    case "Psychic":
      return Colors.purple;
    case "Ice":
      return Colors.cyan;
    case "Dragon":
      return Colors.teal;
    case "Poison":
      return Colors.deepPurple;
    case "Bug":
      return Colors.lightGreen;
    case "Ghost":
      return Colors.deepPurpleAccent;
    case "Steel":
      return Colors.grey;
    case "Fairy":
      return Colors.pinkAccent;
    default:
      return Theme.of(ctx).colorScheme.secondary;
  }
}

/* =======================
   Controllers
======================= */
class TeamController extends GetxController {
  final RxList<Pokemon> team = <Pokemon>[].obs;
  final int maxSize = 3;

  void add(Pokemon p) {
    if (team.length >= maxSize) {
      Get.snackbar('Limit Reached', 'เลือกได้ไม่เกิน $maxSize ตัว',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (team.contains(p)) {
      Get.snackbar('Duplicate', '${p.name} อยู่ในทีมแล้ว',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    team.add(p);
  }

  void remove(Pokemon p) => team.remove(p);
  void clear() => team.clear();

  void loadFromNames(List<String> names) {
    team.value = names.map(findPokemon).whereType<Pokemon>().toList();
  }

  List<String> toNameList() => team.map((e) => e.name).toList();
}

class PresetsController extends GetxController {
  final _box = GetStorage();
  final key = 'team_presets_v1';
  final RxList<TeamPreset> presets = <TeamPreset>[].obs;

  @override
  void onInit() {
    super.onInit();
    final raw = _box.read<List>(key) ?? [];
    presets.value = raw
        .whereType<Map>()
        .map((e) => TeamPreset.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  void _persist() => _box.write(key, presets.map((p) => p.toJson()).toList());

  void addPreset(TeamPreset p) {
    presets.add(p);
    _persist();
    Get.snackbar('Saved', 'บันทึกทีม "${p.name}" แล้ว', snackPosition: SnackPosition.BOTTOM);
  }

  void updatePreset(int index, TeamPreset p) {
    presets[index] = p;
    presets.refresh();
    _persist();
    Get.snackbar('Updated', 'อัปเดตทีม "${p.name}" แล้ว', snackPosition: SnackPosition.BOTTOM);
  }

  void deletePreset(int index) {
    final name = presets[index].name;
    presets.removeAt(index);
    _persist();
    Get.snackbar('Deleted', 'ลบทีม "$name" แล้ว', snackPosition: SnackPosition.BOTTOM);
  }
}

/* =======================
   Pages
======================= */
class PokemonListPage extends StatelessWidget {
  const PokemonListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final team = Get.put(TeamController());
    final presets = Get.put(PresetsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('เลือกโปเกม่อน (สูงสุด 3)'),
        actions: [
          Obx(() => Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text('เลือกแล้ว: ${team.team.length}/3'),
                ),
              )),
          IconButton(
            tooltip: 'ล้างทีม',
            icon: const Icon(Icons.refresh),
            onPressed: team.clear,
          ),
          IconButton(
            tooltip: 'บันทึกเป็นทีม',
            icon: const Icon(Icons.save_as),
            onPressed: () async {
              if (team.team.length != 3) {
                Get.snackbar('Incomplete', 'ต้องเลือกให้ครบ 3 ตัวก่อนบันทึก',
                    snackPosition: SnackPosition.BOTTOM);
                return;
              }
              final name = await _askNameDialog(context, hint: 'ทีมตาที่ 1 / ทีมบอสน้ำ ฯลฯ');
              if (name == null || name.trim().isEmpty) return;
              presets.addPreset(TeamPreset(name: name.trim(), memberNames: team.toNameList()));
            },
          ),
          IconButton(
            tooltip: 'ดู/ใช้ทีมที่บันทึกไว้',
            icon: const Icon(Icons.folder_shared),
            onPressed: () => Get.to(() => const PresetListPage()),
          ),
        ],
      ),
      body: Column(
        children: [
          // ทีมที่เลือก (ชิป)
          Obx(
            () => Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: team.team
                    .map((p) => Chip(
                          avatar: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(p.image, width: 24, height: 24, fit: BoxFit.cover),
                          ),
                          label: Text('${p.name} (${p.type})'),
                          backgroundColor: typeColor(p.type, context).withOpacity(0.15),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () => team.remove(p),
                        ))
                    .toList(),
              ),
            ),
          ),
          const Divider(height: 1),

          // รายการทั้งหมด
          Expanded(
            child: ListView.separated(
              itemCount: allPokemon.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final p = allPokemon[i];
                return Obx(() {
                  final inTeam = team.team.contains(p);
                  final disabled = inTeam || team.team.length >= 3;
                  final weaknesses = weaknessesOf(p.type);
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(p.image, width: 56, height: 56, fit: BoxFit.cover),
                    ),
                    title: Text(p.name),
                    subtitle: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _TypePill(type: p.type),
                        if (p.skills.isNotEmpty)
                          ...p.skills.take(2).map((s) => _MiniPill(label: s, icon: Icons.star)),
                        if (weaknesses.isNotEmpty)
                          _MiniPill(label: 'แพ้: ${weaknesses.join(", ")}', icon: Icons.warning_amber),
                      ],
                    ),
                    trailing: ElevatedButton.icon(
                      icon: Icon(inTeam ? Icons.check : Icons.add),
                      label: Text(inTeam ? 'Added' : 'Add'),
                      onPressed: disabled ? null : () => team.add(p),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.visibility),
        label: const Text('Preview Team'),
        onPressed: () => Get.to(() => const TeamPreviewPage()),
      ),
    );
  }
}

class TeamPreviewPage extends StatelessWidget {
  const TeamPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final team = Get.find<TeamController>();

    return Scaffold(
      appBar: AppBar(title: const Text('ทีมของฉัน')),
      body: Obx(() {
        final list = team.team;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('สมาชิกที่เลือก (${list.length}/3)',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              const SizedBox(height: 12),
              if (list.isEmpty)
                const Text('ยังไม่ได้เลือกโปเกม่อน')
              else
                ...list.map((p) {
                  final adv = typeAdvantages[p.type] ?? const [];
                  final weak = weaknessesOf(p.type);
                  return Card(
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(p.image, width: 56, height: 56, fit: BoxFit.cover),
                      ),
                      title: Row(
                        children: [
                          Text(p.name),
                          const SizedBox(width: 8),
                          _TypePill(type: p.type),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (p.skills.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Wrap(
                                spacing: 6, runSpacing: 6,
                                children: p.skills
                                    .map((s) => _MiniPill(label: s, icon: Icons.sports_martial_arts))
                                    .toList(),
                              ),
                            ),
                          const SizedBox(height: 6),
                          Text('ชนะทาง: ${adv.isEmpty ? "—" : adv.join(", ")}'),
                          Text('แพ้ทาง: ${weak.isEmpty ? "—" : weak.join(", ")}'),
                        ],
                      ),
                    ),
                  );
                }),
              const Spacer(),
              FilledButton.icon(
                icon: const Icon(Icons.check_circle),
                label: const Text('ยืนยันทีม'),
                onPressed: list.length == 3
                    ? () => Get.snackbar('Success', 'ยืนยันทีมเรียบร้อย!',
                        snackPosition: SnackPosition.BOTTOM)
                    : () => Get.snackbar('Incomplete', 'ต้องมีสมาชิกครบ 3 ตัวก่อนยืนยัน',
                        snackPosition: SnackPosition.BOTTOM),
              ),
            ],
          ),
        );
      }),
    );
  }
}

/* =======================
   Preset List & Editor
======================= */
class PresetListPage extends StatelessWidget {
  const PresetListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final presets = Get.find<PresetsController>();
    final team = Get.find<TeamController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ทีมที่บันทึกไว้'),
        actions: [
          IconButton(
            tooltip: 'สร้างทีมใหม่',
            icon: const Icon(Icons.add),
            onPressed: () => Get.to(() => const PresetEditorPage()),
          )
        ],
      ),
      body: Obx(() {
        if (presets.presets.isEmpty) {
          return const Center(child: Text('ยังไม่มีทีมที่บันทึกไว้'));
        }
        return ListView.separated(
          itemCount: presets.presets.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final p = presets.presets[i];
            final members = p.memberNames.map(findPokemon).whereType<Pokemon>().toList();
            return ListTile(
              leading: CircleAvatar(
                child: Text((i + 1).toString()),
              ),
              title: Text(p.name),
              subtitle: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: members
                    .map((m) => Chip(
                          avatar: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(m.image, width: 20, height: 20, fit: BoxFit.cover),
                          ),
                          label: Text(m.name, style: const TextStyle(fontSize: 12)),
                          backgroundColor: typeColor(m.type, context).withOpacity(0.15),
                        ))
                    .toList(),
              ),
              trailing: Wrap(
                spacing: 6,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('ใช้ทีม'),
                    onPressed: () {
                      team.loadFromNames(p.memberNames);
                      Get.back(); // กลับไปหน้าเลือกตัว
                      Get.snackbar('Loaded', 'โหลดทีม "${p.name}" แล้ว', snackPosition: SnackPosition.BOTTOM);
                    },
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('แก้ไข'),
                    onPressed: () => Get.to(() => PresetEditorPage(index: i, initial: p)),
                  ),
                  IconButton(
                    tooltip: 'ลบทีม',
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(context, onYes: () => presets.deletePreset(i)),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}

class PresetEditorPage extends StatefulWidget {
  final int? index;           // null = create, not null = edit
  final TeamPreset? initial;  // ใช้ตอนแก้ไข
  const PresetEditorPage({super.key, this.index, this.initial});

  @override
  State<PresetEditorPage> createState() => _PresetEditorPageState();
}

class _PresetEditorPageState extends State<PresetEditorPage> {
  final _nameCtrl = TextEditingController();
  final RxList<String> _selectedNames = <String>[].obs;
  final int _maxSize = 3;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      _nameCtrl.text = widget.initial!.name;
      _selectedNames.assignAll(widget.initial!.memberNames);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final presets = Get.find<PresetsController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.index == null ? 'สร้างทีมใหม่' : 'แก้ไขทีม'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('บันทึก'),
            onPressed: () {
              final name = _nameCtrl.text.trim();
              if (name.isEmpty) {
                Get.snackbar('Missing name', 'กรุณาตั้งชื่อทีม', snackPosition: SnackPosition.BOTTOM);
                return;
              }
              if (_selectedNames.length != _maxSize) {
                Get.snackbar('Incomplete', 'ต้องมีสมาชิก $_maxSize ตัว', snackPosition: SnackPosition.BOTTOM);
                return;
              }
              final preset = TeamPreset(name: name, memberNames: _selectedNames.toList());
              if (widget.index == null) {
                presets.addPreset(preset);
              } else {
                presets.updatePreset(widget.index!, preset);
              }
              Get.back();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'ชื่อทีม',
                hintText: 'เช่น ตา 1 / ทีมบอสน้ำ / ทีมไฟแรง',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Obx(() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedNames
                        .map((n) => Chip(
                              label: Text(n),
                              deleteIcon: const Icon(Icons.close),
                              onDeleted: () => _selectedNames.remove(n),
                            ))
                        .toList(),
                  ),
                ),
              )),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: allPokemon.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final p = allPokemon[i];
                return Obx(() {
                  final checked = _selectedNames.contains(p.name);
                  final disabled = !checked && _selectedNames.length >= _maxSize;
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(p.image, width: 48, height: 48, fit: BoxFit.cover),
                    ),
                    title: Text(p.name),
                    subtitle: _TypePill(type: p.type),
                    trailing: Checkbox(
                      value: checked,
                      onChanged: disabled
                          ? null
                          : (v) {
                              if (v == true) {
                                _selectedNames.add(p.name);
                              } else {
                                _selectedNames.remove(p.name);
                              }
                            },
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

/* =======================
   Widgets / Helpers
======================= */
class _TypePill extends StatelessWidget {
  final String type;
  const _TypePill({required this.type});

  @override
  Widget build(BuildContext context) {
    final c = typeColor(type, context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.withOpacity(0.5)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.bolt, size: 14),
        const SizedBox(width: 4),
        Text(type),
      ]),
    );
  }
}

class _MiniPill extends StatelessWidget {
  final String label;
  final IconData icon;
  const _MiniPill({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cs.secondaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14),
        const SizedBox(width: 4),
        Text(label),
      ]),
    );
  }
}

Future<String?> _askNameDialog(BuildContext context, {String? hint}) async {
  final ctrl = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('ตั้งชื่อทีม'),
      content: TextField(
        controller: ctrl,
        decoration: InputDecoration(hintText: hint ?? 'ตั้งชื่อทีมของคุณ'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('ยกเลิก')),
        FilledButton(onPressed: () => Navigator.pop(ctx, ctrl.text.trim()), child: const Text('บันทึก')),
      ],
    ),
  );
}

void _confirmDelete(BuildContext context, {required VoidCallback onYes}) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('ยืนยันการลบ'),
      content: const Text('ต้องการลบทีมนี้ใช่ไหม?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('ยกเลิก')),
        FilledButton(
          onPressed: () {
            Navigator.pop(ctx);
            onYes();
          },
          child: const Text('ลบ'),
        ),
      ],
    ),
  );
}
