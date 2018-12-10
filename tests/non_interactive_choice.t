#!/usr/bin/env python
# -*- coding: utf-8 -*-

import unittest
from simpletap.fdecrypt import lib


class BaseTemplateInteractiveChoice(object):
    def validate_one(self, userkey, datakey, output):
        expected = lib.get_user_data(userkey)
        matches = lib.grep(datakey, output, context=1)

        self.assertEqual(matches, expected)

    def validate(self, out):
        self.validate_one("doesntexist", "doesntexist", out)
        self.validate_one("onemore", "onemore", out)
        self.validate_one("complex", "cömplex", out)
        self.validate_one("jamie", "jãmïe", out)


class TestNonInteractiveChoice20(unittest.TestCase, BaseTemplateInteractiveChoice):
    def test_firefox(self):
        cmd = lib.get_script() + [lib.get_test_data(), "-nc", "1"]
        pwd = lib.get_password()

        out = lib.run(cmd, stdin=pwd)
        self.validate(out)


class TestNonInteractiveChoice46(unittest.TestCase, BaseTemplateInteractiveChoice):
    def test_firefox(self):
        cmd = lib.get_script() + [lib.get_test_data(), "-nc", "2"]
        pwd = lib.get_password()

        out = lib.run(cmd, stdin=pwd)
        self.validate(out)


class TestNonInteractiveChoiceNoPass(unittest.TestCase, BaseTemplateInteractiveChoice):
    def test_firefox(self):
        cmd = lib.get_script() + [lib.get_test_data(), "-nc", "3"]

        out = lib.run(cmd)
        self.validate(out)


class TestNonInteractiveChoiceMissing(unittest.TestCase):
    def test_firefox(self):
        cmd = lib.get_script() + [lib.get_test_data(), "-n"]

        out = lib.run_error(cmd, returncode=31)  # 31 is MISSING_CHOICE exit
        output = lib.remove_log_date_time(out)
        expected = lib.get_output_data("non_interactive_choice_missing")
        self.assertEqual(output, expected)


if __name__ == "__main__":
    from simpletap import TAPTestRunner
    unittest.main(testRunner=TAPTestRunner())

# vim: ai sts=4 et sw=4
