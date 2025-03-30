# utils.py

def format_tasks(tasks):
    """Форматирует список задач для вывода."""
    formatted = []
    for i, task in enumerate(tasks):
        status = "✓" if task["completed"] else "✗"
        formatted.append(f"{i + 1}. [{status}] {task['task']}")
    return "\n".join(formatted)