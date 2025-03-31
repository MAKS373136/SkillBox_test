# Makefile

# Запуск тестов проверк
test:
	python3 -m unittest discover -s tests -p "test_*.py"

# Очистка временных файлов
clean:
	rm -rf __pycache__ tests/__pycache__

# Запуск приложения (если нужно)
run:
	python3 -c "from task_manager import TaskManager; from utils import format_tasks; manager = TaskManager(); manager.add_task('Пример задачи'); print(format_tasks(manager.list_tasks()))"

# Все задачи
all: clean test run
