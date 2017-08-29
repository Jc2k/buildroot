#! /usr/bin/python

import os
import select
import subprocess


class Pin(object):

    def __init__(self, name, pin, trigger):
        self.name = name
        self.pin = pin
        self.trigger = trigger

        if os.path.exists(f"/sys/class/gpio/gpio{pin}/value"):
            with open("/sys/class/gpio/unexport", "w") as fp:
                fp.write(str(pin))

        with open("/sys/class/gpio/export", "w") as fp:
            fp.write(str(pin))

        with open(f"/sys/class/gpio/gpio{pin}/edge", "w") as fp:
            fp.write(trigger)

        self.fp = open(f"/sys/class/gpio/gpio{pin}/value", "r")

    def fileno(self):
        return self.fp.fileno()

    @property
    def value(self):
        try:
            return self.fp.read().strip()
        finally:
            self.fp.seek(0)

    def close(self):
        self.fp.close()
        del self.fp

        with open(f"/sys/class/gpio/unexport", "w") as fp:
            fp.write(str(self.pin))

    def __repr__(self):
        return f"Pin {self.name}: {self.value}"


class Pins(object):

    def __init__(self):
        self.epoll = select.epoll()
        self.pins = {}

    def register(self, name, pin, trigger):
        p = Pin(name, pin, trigger)
        self.pins[p.fileno()] = p
        self.epoll.register(p, select.EPOLLPRI)

    def poll(self):
        for fd, event in self.epoll.poll():
            yield self.pins[fd]

    def close(self):
        for pin in self.pins.values():
            try:
                pin.close()
            except:
                pass


try:
    pins = Pins()
    pins.register("low-battery", 23, "falling")
    pins.register("shutdown", 27, "falling")

    while True:
        for event in pins.poll():
            print(f"{event}!r")

            if event.name == "shutdown" and event.value == "0":
                subprocess.check_call(["poweroff"])

finally:
    pins.close()
