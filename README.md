# Getting Started - Basic Concepts
ScriptActions is a Windows Tool that can be used to __*quickly move & click the mouse to/at different screen coordinates or press buttons*__.
Each instruction/interaction is called an action. Those can be combined into scripts, which can then be assigned to hotkeys.
Pressing a hotkey will result in the execution of a script, which means that all of its actions will be run in sequence.

## Actions
Actions are defined in the `config/actions.ini` file.
They assign a name to an interaction with the keyboard or mouse.
Each action is prefixed with `Click` (for mouse clicks) or `Push` (for key presses). 
The rest of the name is up to you.
The corresponding pixel coordinates or key is then assigned via the '=' character:

```ini
[Actions]
ClickWindowsStartmenuButton=1928,0
PushTheKeyA={A}
; this is a comment
```
Rules for actions:
- Pixel Coordinates (x,y) are seperated by a COMMA `,` (not a dot!)
  To find the correct coordinates, you might find the included MouseCoordRec tool helpfull. (More info below)
- A KEY is represented by typing its value in curly brackets `{}` (see example above)
- Comments may inserted after newline/linebreaks if they are prefixed with a semicolon (`;`)
  Only ever start comments at the beginning of a new line! 
- _Do *NOT* use whitespaces_ (except for comments)


*Additional hints:*
If you are familiar with the .ini format, you may notice that the first `[Actions]` "section"
is the only section. Do NOT insert any custom `[section]`s into the file! (This applies to the rest of the config files as well)



## Scripts
Scripts are a list of actions that should execute in sequence.
Scripts are simply text (.txt) files. They contain one action per line, referenced by its name (from `config/actions.ini``).


Rules for scripts:
* Empty lines are allowed. 
* Comments can be started at the beginning of each line by prefixing them with a semicolon `;`
* The _files need a `.txt` extension_
* the __filename must *NOT* contain spaces!__
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
*This example script would open the windows startmenu and press A three times.*

## Script-to-Hotkey-Assignment & KeyMapping
If you assign a script to a hotkey, the script (= sequence of actions) will be 
executed every time that hotkey is pressed.

__Hotkey-Assignment is done via `config/hotkey.ini`.__
Just enter the name of the script (including the .txt extension) after the 
equals operator '=' of the hotkey that you want to assign.
Example:

```ini
[HotKey]
HotKey1=
HotKey2=exampleScript.txt
HotKey3=
...
```

__*Deault Mapping*__
By default each hotkey is mapped as a function key with the same number.
That means `HotKey1` is mapped to `F1`, `HotKey2` is mapped to `F2`, ...
*(This behaviour can be changed in `config/main.ini`)*

The example provided above would run exampleScript everytime when F2 is pressed.
(Asuming that no other configuration values where changed)

# Running & Stopping
1. Make sure the configuration files are valid before starting the program and that the current directory is writable.
   (ScriptActions will create a logfile in it´s current directory.)
2. Double Click ScriptActions.exe to launch a new instance.
   You will see a new tray icon. 
   When hover your cursor above it, it should read `ScriptActions`.
3. It will run until it recieves the __Exit-Hotkey `F11`__ or you right click the tray icon and select 'Quit'.

*__Warning: Do NOT launch two instances of ScriptActions.__ They will interfere with each other!*

### Changing Configuration during runtime
The programm will try to hot reload scripts, actions and pretty much everything during runtime.
Configuration changes will therefore directly affect running instances.
To avoid confusion, you should __stop/quit the program before editing the configuration.__

### Handling Zombi Procecess
If you disabled the tray icon, or the program does not respond to the exit hotkey (`F11`), you can no longer close the programm without the task manager.
Search for 'ScriptAction.exe' in the task manager end force quit the programm.

# Advanced Configuration
## Check for a target process
In many cases you might want ScriptActions to run only when a specific other programm/process runs. 
You can configure ScriptActions to automatically look and wait for a specific process on launch.
ScriptActions will then automatically quit, when the target proces exists.
But: ScriptActions __will NOT autofocus the window of the target process__ (if it even has one)!


To enable the 'target process' functionality, open the `config/main.ini` file and change the values of the `[General]` section.
```ini
[General]
TargetProcess='PROCESSNAME.exe'
ExitOnTargetWindowMissing=True
HotkeyWaitForTargetWindow=True
```
*Please note, that the PROCESSNAME needs to be the actual name shown in task managers details section!
The window title (which is usually shown in the task managers process section does NOT work)*


## Configure Delays
Sometimes, actions happen to fast. A window may take some time to load, but ScriptActions will not wait and execute the next action anyway.
To overcome this, you may specify __GLOBAL__ delays in `config/main.ini` for MouseClicks & KeyPresses:
```ini
[Simulation]
MouseClickDelay= 15
SendKeyDelay= 5 
SendKeyDownDelay= 1 
```
*At the moment, delays can only be changed globaly, and will affect all scripts/actions*

## Remapping Hotkes
Hotkeys are by default mapped to function keys. That means each HotKey nr. corresponds to a function key with that number.
For Example: *`Hotkey1` is `F1`, `Hotkey2` is `F2`and so on.*
To change the mapping, edit the `[HotKey]` section in `config/main.ini`.
Assign each key by entering its name/value in curly brackets (`{}`)
```ini
[Simulation]
[HotKey]
HotKey1={F1}
HotKey2={F2}
...
HotKey10={F10}
HotKeyExit={F11}
```
__Important: You should NEVER remap `HotKeyExit` (`F11`)!__

## Hiding running instances
Running instances can be hidden by disabling the system tray icon.
See the `[Tray]` section in `config/main.ini`. __We do NOT recommend doing this.__

# Building the project
The only requirement is [AutoItv3](https://www.autoitscript.com/site/) and a windows machine.
Install AutoIt, then right click `ScriptActions.au3` in file explorer and select `Compile Script` from the menu.

# Extras: MouseCoordRec
`extras/MouseCoordRec.exe` is a mouse coordinate recorder. It may be helpfull when you want to determine multiple mouse coordinates.
Please *__quit any running instance of ScriptActions before using MouseCoordRec!*__

1. Make sure that you have write permissions in the directory where to program is located.
2. Open the program in the usual way (by double clicking it). 
3. ou should see a tray icon. If you hover the cursor above it, it should read 'MouseCoordRec'.
4. You can now press __SPACE__ (spacebar) to capture the coordinates of your mouse coursors current position.
   They will be written to a file called 'coords.txt' (in the programs current directory).
   A new entry (new line) will be added each time new coordinates are recorded. This way, you can capture a whole 'click path'
5. When you are done, you may exit the program by pressing `F1` or right clicking the tray icon and choosing 'Quit' from the menu
