# odin-raddbg

Odin bindings for the RAD Debugger

## How to use
1. Clone this repo into your project using `git clone https://github.com/AntoineGagnon1/odin-raddbg.git`
2. Import the library in an odin file using `import raddbg "odin-raddbg"`

## Demo
The `/demo` subdirectory contains a small demo of the features offered by the raddbg markup functions, run `run_demo.bat` to launch it (`raddbg.exe` needs to be in your PATH)

## Known limitations
`raddbg_entry_point` and `raddbg_type_view` are currently not implemented, if you have an idea on how to implement them in a nice way, please open an issue or pull request !

## Regenerating raddbg.lib and raddbg.pdb
Run `build.bat` **from a VS22 command prompt**
