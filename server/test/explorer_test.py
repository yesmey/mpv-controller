import unittest

from mpvserver import explorer

class ExplorerTestCase(unittest.TestCase):
    def test_get_root(self):
        result = explorer.get_root()
        self.assertTrue(all([x["isFolder"] for x in result]))
        self.assertTrue(all([path.exists(x["path"]) for x in result]))

    def test_is_folder(self):
        self.assertFalse(explorer.is_folder(""))
        self.assertFalse(explorer.is_folder(__file__))
        self.assertTrue(explorer.is_folder(path.dirname(__file__)))

if __name__ == '__main__':
    unittest.main()