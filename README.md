# Actuator

An `actuator` is a generic callable that may invoke a list of `actions`(plain functions or struct/class methods).
It is similar to other `signal and slots` mechanisms with a bit more flexibility.

In current terminology we use `actuator` instead of `signal` and `actions` instead of `slots` as it feels more natural to say `an actuator is something that actuates one or more actions`.

It provides also access to the results after the actions are executed.

