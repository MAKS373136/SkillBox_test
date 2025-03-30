# tests/test_task_manager.py
import unittest
from task_manager import TaskManager

class TestTaskManager(unittest.TestCase):

    def setUp(self):
        """Создаём новый экземпляр TaskManager перед каждым тестом."""
        self.manager = TaskManager()

    def test_add_task(self):
        self.manager.add_task("Купить молоко")
        self.assertEqual(len(self.manager.list_tasks()), 1)
        self.assertEqual(self.manager.list_tasks()[0]["task"], "Купить молоко")

    def test_complete_task(self):
        self.manager.add_task("Купить хлеб")
        self.manager.complete_task(0)
        self.assertTrue(self.manager.list_tasks()[0]["completed"])

    def test_invalid_index(self):
        self.manager.add_task("Купить яблоки")
        with self.assertRaises(IndexError):
            self.manager.complete_task(5)

    def test_empty_task(self):
        with self.assertRaises(ValueError):
            self.manager.add_task("")

if __name__ == "__main__":
    unittest.main()