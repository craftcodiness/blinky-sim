# Blinky Sim

[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

> Simulator for WS2801/WS2812 NeoPixel LED displays

This is an NCurses / terminal-based simulator for NeoPixel LED displays. The simulator receives a pixel data stream over a named pipe, and renders the resulting display on the console.

## Table of Contents

 - [Background](#background)
 - [Install](#install)
 - [Usage](#usage)
 - [Maintainer](#maintainer)
 - [Contribute](#contribute)
 - [License](#license)

## Background

[Ed](https://github.com/edwardmccaughan) is a master of all things crafty. He builds strange and wonderful contraptions with his bare hands, then shares the contraptions with his friends so that they can create their own artistic wonders. The LED devices Ed likes to play with are usually WS2801 or WS2812 NeoPixel LED strips / rings. You can see the controller code in his [rgb_led_control](https://github.com/edwardmccaughan/rgb_led_control) project. Because it isn't always practical to carry the physical LED devices, and for testing / development purposes, it is useful to be able to simulate the displays locally. This simulator makes that possible, by emulating the serial protocol used to drive the serial strips.

## Install

`bundler` can be used to pull in the required dependencies:

```
bundle install
```

You may need `ncurses` development headers to build the required `ncurses-ruby` Gem. This code was tested with Ruby 2.2.0.

## Usage

To run the simulator, you will first need to create a named pipe to receive the serial control codes:

```
mkfifo /tmp/serial.pipe
```

Running the simulator is then a simple matter of:

```
bundle exec ruby sim.rb /tmp/serial.pipe
```

If you are using the [arduino-lights](https://github.com/craftcodiness/arduino-lights) library to drive your LED strips, you can pass the path of the named pipe into the `serial_port` constructor to connect to the simulator rather than the serial port.

## Maintainer

This library is maintained by [@codders](https://github.com/codders)

## Contribute

Pull requests are welcome!

## License

This code is licensed under the [GNU GPLv3](https://www.gnu.org/licenses/gpl.txt), a [copy of which](LICENSE) is included in this repository.

Copyright Arthur Taylor 2017

