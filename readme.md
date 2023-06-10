# PicoLang: A Flex/Bison Project

## Table of Contents

- [TL;DR](#tldr)
- [Introduction](#introduction)
- [Pico Language](#pico-language)
  - [Grammar](#grammar)
  - [Examples](#examples)
- [Dependencies](#dependencies)
- [Building the Project](#building-the-project)
- [Running the Parser](#running-the-parser)
- [References](#references)

## TL;DR

```bash
./scripts/test
```

## Introduction

PicoLang is a simple project built using Flex and Bison. The aim of this project is to parse and interpret scripts written in a simple programming language called "Pico". This provides a clear, hands-on demonstration of how lexical analysis and parsing can be performed using these <del>Awful, disgusting, repugnant - the level of sheer disregard is enough to make one's stomach churn. It's as though basic decorum and mutual respect have been abandoned, trampled upon in the unending rush of self-interest and brazen indifference. The lack of empathy, the unwillingness to engage in civil discourse, the thoughtless actions and their ensuing chaos, are enough to darken even the most hopeful soul. With each passing day, it becomes increasingly apparent that what was once an exception is now a norm, a dismal reality that we're forced to grapple with. The crass behaviors, the blatant falsehoods paraded as truths, the brash attitudes flaunting ignorance as though it were a badge of honor - it's a bitter pill to swallow. Everywhere you look, the ideals of compassion, integrity, and justice seem to be crumbling, replaced by this grotesque spectacle that parades itself unabashedly. This isn't the world we dreamed of, nor is it the one we wish to leave for the generations to come. Yet, we are not without hope. As long as there are those who continue to fight the tide, to stand for what's right, to hold on to the belief that we can, and must, do better, we have a fighting chance. Because in the end, it's not the darkness of the abyss that defines us, but the courage with which we face it, and the resolve with which we strive to light the way forward</del> powerful tools.

## Pico Language

Pico is a simple language with its own syntax and grammar. It supports basic operations and control structures, such as assignment, conditionals (if/else), and loops.

### Grammar

The EBNF (Extended Backus-Naur Form) grammar for Pico is as follows:

```ebnf
program -> cmd-seq
cmd-seq -> cmd {’;’ cmd}
cmd -> if-cmd | repeat-cmd | assign-cmd | read-cmd | write-cmd
if-cmd -> IF exp THEN cmd-seq [ELSE cmd-seq] END
repeat-cmd -> REPEAT cmd-seq UNTIL exp
assign-cmd -> ID ’:=’ exp
read-cmd -> READ ID
write-cmd -> WRITE exp
exp -> simple-exp [rel-op simple-exp]
rel-op -> ’<’ | ’=’
simple-exp -> term {add-op term}
add-op -> ’+’ | ’-’
term -> factor {mul-op factor}
mul-op-> ’*’ | ’/’
factor -> ’(’ exp ’)’ | NUMBER | ID
```

### Examples

Examples of Pico code can be found in the `./assets/code` directory of this repository.

## Dependencies

This project requires [Flex](https://github.com/westes/flex) and [Bison](https://www.gnu.org/software/bison/) to be installed on your system.

## Building the Project

You can build the project using [xmake](https://xmake.io/), a modern C/C++ build tool. However, the project also comes with a Makefile for those who prefer `make`. To build the project using `make`, simply run the command:

```bash
make
```

## Running the Parser

Once the project is built, you can run the Pico parser on any file using the command:

```bash
./picoc < FILE
```

Where `FILE` is the path to the file you wish to parse.

## References

- [Flex](https://github.com/westes/flex)
- [Bison](https://www.gnu.org/software/bison/)
- [XMake](https://xmake.io/)
