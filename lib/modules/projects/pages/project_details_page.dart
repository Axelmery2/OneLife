import 'package:flutter/material.dart';

import '../models/project.dart';
import '../services/project_service.dart';
import '../models/project_task.dart';
import '../models/project_expense.dart';
import '../widgets/add_expense_dialog.dart';

class ProjectDetailsPage extends StatefulWidget {
  final Project project;

  const ProjectDetailsPage({
    super.key,
    required this.project,
  });

  @override
  State<ProjectDetailsPage> createState() =>
      _ProjectDetailsPageState();
}

class _ProjectDetailsPageState
    extends State<ProjectDetailsPage> {
  late Project project;

  @override
  void initState() {
    super.initState();
    project = widget.project;
  }

  Future<void> deleteProject() async {
    final confirm =
        await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Supprimer le projet',
        ),
        content: const Text(
          'Voulez-vous vraiment supprimer ce projet ?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
              context,
              false,
            ),
            child:
                const Text(
              'Annuler',
            ),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(
              context,
              true,
            ),
            child:
                const Text(
              'Supprimer',
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await ProjectService.deleteProject(
      project.id,
    );

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  Future<void> addTask() async {
    final controller =
        TextEditingController();

    final task =
        await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Nouvelle tâche',
        ),
        content: TextField(
          controller: controller,
          decoration:
              const InputDecoration(
            hintText:
                'Nom de la tâche',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
              context,
            ),
            child:
                const Text(
              'Annuler',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
                controller.text.trim(),
              );
            },
            child:
                const Text(
              'Ajouter',
            ),
          ),
        ],
      ),
    );
    if (task == null || task.trim().isEmpty) {
  return;
}

   if (double.tryParse(task) != null) {
  ScaffoldMessenger.of(context)
      .showSnackBar(
    const SnackBar(
      content: Text(
        'Veuillez saisir une vraie tâche.',
      ),
    ),
  );
  return;
}

print('Tâche saisie : $task');
print('Nombre tâches avant : ${project.tasks.length}');

    final tasks =
    List<ProjectTask>.from(
  project.tasks,
);


tasks.add(
  ProjectTask(
    title: task,
    completed: false,
  ),
);
print('Nombre tâches après : ${tasks.length}');

    

    final updated =
        project.copyWith(
      tasks: tasks,
    );

    await ProjectService.updateProject(
      updated,
    );

    setState(() {
      project = updated;
    });
  }

  Future<void> addExpense() async {
  showDialog(
    context: context,
    builder: (_) => AddExpenseDialog(
      onAdd: (
        title,
        amount,
        description,
      ) async {
        final expenses =
            List<ProjectExpense>.from(
          project.expenses,
        );

        expenses.add(
          ProjectExpense(
            title: title,
            amount: amount,
            description:
                description,
            date: DateTime.now(),
          ),
        );

        final totalSpent =
            expenses.fold<double>(
          0,
          (sum, e) =>
              sum + e.amount,
        );

       final updated =
    project.copyWith(
  expenses: expenses,
  spentAmount: totalSpent,
  status: totalSpent > project.budget
      ? 'Budget dépassé'
      : project.status,
);
        await ProjectService
            .updateProject(
          updated,
        );

        setState(() {
          project = updated;
        });
      },
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final progress =
    (project.progress / 100)
        .clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Détails Projet',
        ),
        actions: [
  IconButton(
  onPressed: () async {
    final titleController =
        TextEditingController(
      text: project.title,
    );

    final descriptionController =
        TextEditingController(
      text: project.description,
    );

    final result =
        await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Modifier projet',
        ),
        content: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            TextField(
              controller:
                  titleController,
              decoration:
                  const InputDecoration(
                labelText: 'Titre',
              ),
            ),
            TextField(
              controller:
                  descriptionController,
              decoration:
                  const InputDecoration(
                labelText:
                    'Description',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
              context,
              false,
            ),
            child:
                const Text(
              'Annuler',
            ),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(
              context,
              true,
            ),
            child:
                const Text(
              'Enregistrer',
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      final updated =
          project.copyWith(
        title:
            titleController.text,
        description:
            descriptionController
                .text,
      );

      await ProjectService
          .updateProject(
        updated,
      );

      setState(() {
        project = updated;
      });
    }
  },
  icon: const Icon(
    Icons.edit,
  ),
),

  IconButton(
    onPressed: deleteProject,
    icon: const Icon(
      Icons.delete,
    ),
  ),
],
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              project.title,
              style:
                  const TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Text(
              project.description,
            ),

            const SizedBox(
              height: 20,
            ),

            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(
                  16,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      'Budget : ${project.budget.toStringAsFixed(0)} FCFA',
                    ),

                    Text(
                      'Dépensé : ${project.spentAmount.toStringAsFixed(0)} FCFA',
                    ),
                 Text(
  project.spentAmount > project.budget
      ? 'Dépassement : ${(project.spentAmount - project.budget).toStringAsFixed(0)} FCFA'
      : 'Restant : ${(project.budget - project.spentAmount).toStringAsFixed(0)} FCFA',
  style: TextStyle(
    color: project.spentAmount > project.budget
        ? Colors.red
        : Colors.green,
    fontWeight: FontWeight.bold,
  ),
),
                    if (project.deadline != null)
  Text(
    'Date limite : ${project.deadline!.day}/${project.deadline!.month}/${project.deadline!.year}',
  ),

                    const SizedBox(
                      height: 10,
                    ),

                    LinearProgressIndicator(
                      value: progress,
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Text(
                      '${project.progress}% terminé',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
  height: 20,
),

const Text(
  'Dépenses',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(
  height: 10,
),

if (project.expenses.isEmpty)
  const Card(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'Aucune dépense',
      ),
    ),
  ),

...project.expenses.map(
  (expense) => Card(
    child: ListTile(
      leading: const Icon(
        Icons.payments,
      ),
      title: Text(
        expense.title,
      ),
      subtitle: Text(
        expense.description,
      ),
      trailing: Text(
        '${expense.amount.toStringAsFixed(0)} FCFA',
      ),
    ),
  ),
),

            const SizedBox(
              height: 20,
            ),

            const Text(
  'Tâches',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

if (project.tasks.isEmpty)
  const Card(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'Aucune tâche pour le moment',
      ),
    ),
  ),

...project.tasks.map(
  (task) => Card(
    child: CheckboxListTile(
      value: task.completed,
      title: Text(task.title),

      secondary: IconButton(
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onPressed: () async {
          final tasks =
              List<ProjectTask>.from(
            project.tasks,
          );

          tasks.remove(task);

          final completedCount =
              tasks.where(
                (t) => t.completed,
              ).length;

          final progress =
              tasks.isEmpty
                  ? 0
                  : ((completedCount /
                              tasks.length) *
                          100)
                      .round();

          final updated =
              project.copyWith(
            tasks: tasks,
            progress: progress,
          );

          await ProjectService
              .updateProject(
            updated,
          );

          setState(() {
            project = updated;
          });
        },
      ),

      onChanged: (value) async {
        final tasks =
            List<ProjectTask>.from(
          project.tasks,
        );

        final index =
            tasks.indexOf(task);

        tasks[index] =
            ProjectTask(
          title: task.title,
          completed:
              value ?? false,
        );

        final completedCount =
            tasks.where(
              (t) => t.completed,
            ).length;

        final progress =
            tasks.isEmpty
                ? 0
                : ((completedCount /
                            tasks.length) *
                        100)
                    .round();

        final updated =
            project.copyWith(
          tasks: tasks,
          progress: progress,
          status: progress == 100
              ? 'Terminé'
              : 'En cours',
        );

        await ProjectService
            .updateProject(
          updated,
        );

        setState(() {
          project = updated;
        });
      },
    ),
  ),
),

            const SizedBox(
              height: 20,
            ),

            SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: addTask,
    icon: const Icon(
      Icons.add_task,
    ),
    label: const Text(
      'Ajouter une tâche',
    ),
  ),
),

const SizedBox(
  height: 10,
),

SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: addExpense,
    icon: const Icon(
      Icons.payments,
    ),
    label: const Text(
      'Ajouter une dépense',
    ),
  ),
),    ],
        ),
      ),
    );
  }
}