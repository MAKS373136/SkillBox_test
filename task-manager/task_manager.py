# task_manager.py

class TaskManager:
    def __init__(self):
        self.tasks = []

    def add_task(self, task):
        """Добавляет новую задачу."""
        if not task:
            raise ValueError("Задача не может быть пустой")
        self.tasks.append({"task": task, "completed": False})

    def complete_task(self, index):
        """Помечает задачу как выполненную по её индексу."""
        if index < 0 or index >= len(self.tasks):
            raise IndexError("Неверный индекс задачи")
        self.tasks[index]["completed"] = True

    def list_tasks(self):
        """Возвращает список задач."""
        return self.tasks