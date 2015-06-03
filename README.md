Resident Database Manager
=========================
The Resident Database  Manager (RDM) is a software tool set for applications that access and update information residing in main-memory. Traditionally, the code responsible for handling main-memory data is handwritten. RDM allows developers to declaratively specify objects and operations on them using a SQL-like language to generate an embedded main-memory database in C. The workflow is as follows.

1. The LDM compiler compiles the logical data model into a physical plan.
2. The PDM compiler translates the physical data model into the database in C.
3. The CDB compiler takes the application written in an extended C language called C/DB and compiles it to C.
4. A C compiler is invoked to compile and link the application and the database.

Installation
------------

This version of the RDM tool requires the following to be installed.
 * sbcl
 * bison
 * flex
 * a C compiler
 * indent (C code beautifier)

To compile, run `make` from the `src/` directory.

Usage
-----
Included in the `samples` folder are examples of how RDM could be used. The `frv` example is used.

1. Run `./lpdmc frv.ldm` to get `frv.c` and `frv.h`.
2. Run  `./cdbc -f frv.pdm frvMain.cdb` to get `frvMain.c`.
3. Run `gcc -o frv frvMain.c frv.c`.

The application is then compiled and ready to run: `./frv`.

License
-------
RDM is released under the GNU Public License v3.0

