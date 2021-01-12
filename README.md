ScriptActions is a Windows Tool that can be used to quickly move & click the mouse to/at different screen coordinates or press buttons.

# Getting Started - Basic Concepts
Each instructions/interactions is called an action. Actions are globaly named/defined in the 'config/actions.ini' file.
Each action need a unique name and a assigned key or screen coordinates.


## Actions
Actions are defined in the `config/actions.ini` file.
They assign a name to an interaction with the keyboard or mouse.
Each action is prefixed with `Click` (for mouse clicks) or `Push` (for key presses).
The corresponding pixel coordinates or key is then assigned via the '=' character:

```ini
ClickWindowsStartmenuButton=1928,0
PushTheKeyA={A}
```
- Pixel Coordinates (x,y) are seperated by a COMMA `,` (not a dot!)
- A KEY is represented by typing its value in curly brackets `{}` (see example above)
- Comments may inserted after newline/linebreaks if they are prefixed with a semicolon (`;`)
  Only ever start comments at the beginning of a new line! 
- Do NOT use whitespaces anywhere (except for comments)

Additional hint:
If you are familiar with the .ini format, you may notice that the first `[Actions]` "section"
is the only  section. Do NOT insert your own `[section]`s into the file! 


## Scripts
Scripts are a list of actions that should execute in sequence.
Scripts are simply  text (.txt) files. They contain one action per line, referenced by its name (from config/actions.ini).

Rules for scripts:
* Empty lines are allowed. 
* Comments can be started at the beginning of each line by prefixing them with a semicolon `;`
* The files need a `.txt` extension
* the filename must NOT contain spaces!
* the filename should only contain ASCII characters. 
  Other character sets may work, but were not tested.

This is a example script file `scripts/exampleScript.txt`:
```ini
; this is an example script
; with a comment in the first two lines

ClickWindowsStartmenuButton
PushTheKeyA
PushTheKeyA
PushTheKeyA
```
This example script would open the windows startmenu and press A three times.

## Script-to-Hotkey-Assignment & KeyMapping
If you assign a script to a hotkey, the script (= sequence of actions) will be 
executed every time that hotkey is pressed.

Hotkey-Assignment is done via `config/hotkey.ini`.
Just enter the name of the script (including the .txt extension) after the 
equals operator '=' of the hotkey that you want to assign.
Example:

```ini
HotKey1=exampleScript.txt
```
By default each hotkey is mapped as a function key with the same number.
That means `HotKey1` is mapped to `F1`, `HotKey2` is mapped to `F2`, ...
(This behaviour can be changed in `config/main.ini`)

# Running & Stopping
Make sure the configuration files are valid before starting the programm.
Just click ScriptActions.exe to launch a new instance.
You will see a new tray icon. When hover your cursor above it, it should read `ScriptActions`.
It will run until it recieves the Exit-Hotkey `F11` or you right click the tray icon and select 'Quit'.

Warning: Do NOT launch two instances of ScriptActions. They will interfere with each other!

### Changing Configuration during runtime
The programm will try to hot reload scripts, actions and pretty much everything during runtime.
Configuration changes will therefore directly affect running instances.
To avoid confusion, you should stop/quit the program before editing the configuration.

### Handling Zombi Procecess
If you disabled the tray icon, or the program does not respond to the exit hotkey (`F11`), you can no longer close the programm without the task manager.
Search for 'ScriptAction.exe' in the task manager end force quit the programm.



