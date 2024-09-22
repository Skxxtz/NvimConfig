# NVIM BINDS
> leader | space

## Nvim Binds 
### Modes
| Bind | Bind | Abbreviation |
| --------------- | --------------- | --------------- | 
| ESC | Normal Mode   | n |
| v | Visual Mode   | v |
| i, a, I, A, o, O, | Insert Mode   | i |

### Editor Commands
| Mode | Modifier | Bind | Explanation |
| --------------- | --------------- | --------------- | --------------- |
| n | | o | Insert line below and write to it |
| n | | O | Insert line above and write to it |
| n | | q | Record macro into buffer |
| n | | @buffer | Replace buffer |
| n | | = | Indent line(s) |
| n | | u | Undo |
| n | Ctrl | r | Redo |

### Replacing and Deleting
| Mode | Modifier | Bind | Explanation |
| --------------- | --------------- | --------------- | --------------- |
| n | | I | Insert at end of line|
| n | | A | Insert at start of line|
| n | | D | Delete line to end|
| n | | dd| Delete entire line |
| n | | dw | Delete word to end |
| n | | diw | Delete entire word |
| n | | C | Replace line to end |
| n | | cc | Replace entire line |
| n | | cw | Replace word to end |
| n | | ciw | Replace entire word |
| n | | p | Paste from internal buffer |
| n | | P | Paste in line above from internal buffer |
| n | | y | Yank into internal buffer |
| n | | s | Remove char under cursor and enter insert mode |
| n | | di | Delete inside of following delimiter |
| n | | va | Remove the whole block with delimiter and inside |

### Movement
| Mode | Modifier | Bind | Explanation |
| --------------- | --------------- | --------------- | --------------- |
| n | | gg | Move cursor to top of code |
| n | | G | Move cursor to bottom of code |
| n | | $ | Move cursor to end of line |
| n | | 0 | Move cursor to start of line |
| n | | h | Move cursor left|
| n | | j | Move cursor down |
| n | | k | Move cursor up |
| n | | l | Move cursor right|
| n | | H | Move cursor to top of editor|
| n | | L | Move cursor to bottom of editor|
| n | | w | Skip to next word |
| n | | b | Go to previous word |
| n | | e | Go to end of word |
| n | | % | Go to closing/opening brackets |
| n | | { | Go to start of block|
| n | | } | Go to end of block|
| n | | zz | Bring cursor to middle without movin lines |


### Visual Mode
| Mode | Modifier | Bind | Explanation |
| --------------- | --------------- | --------------- | --------------- |
| n | | v | Enter visual mode |
| n | | V | Enter whole line visual mode |
| n | Ctrl | v | Enter visual block mode |
| n | | vi | Select inside of following delimiter |
| n | | va | Select the whole block with delimiter and inside |

### : Commands
| Mode | Modifier | Bind | Explanation |
| --------------- | --------------- | --------------- | --------------- |
| n | : | ! | Execute terminal command |
| n | : | w | Write changes |
| n | : | qa | Quit all |
| n | : | qa! | Force quit all |
| n | : | Ex | Netrw |


## Custom Binds
### LSP
| Mode | Modifier | Bind | Explanation |
| --------------- | --------------- | --------------- | --------------- |
| n | | gd | Go to definition |
| n | | gD | Go to declaration |
| n | | K | Info |
| n | | gi | Go to implementation |
| n | leader | wa | Add workspace folder |
| n | leader | wr| Remove workspace folder |
| n | leader | wl| List workspace folders |
| n | leader | D | Go to type definition |
| n | leader | rn | Rename |
| n,v | leader | ca | Code action |
| n | | gr | Go to references |
| n,v | leader | f | Format buffer |

### Editor Commands
| Mode | Modifier | Bind | Explanation |
| --------------- | --------------- | --------------- | --------------- |
| n | leader | pv | Netrw |
| v | | K | Move line(s) up |
| v | | J | Move line(s) down |
| n | | J | Join line below to this one |
| n | | n | Next search result |
| n | | N | Previous search result |
| n | leader | p | Paste without loosing paste buffer |
| n,v | leader | y | Yank into system clipboard |
| n | Ctrl-k |  | cnext zz |
| n | Ctrl-j |  | cprev zz |
| n | leader | k | lnext zz |
| n | leader | j | lprev zz |
| n | leader | s | Replace all occurrences for work under cursor |
| n | leader | x | Make current file executable |
| n | | Q | UNBOUND |
| n | | K | Insert line above |
| n | | J | Insert line below |
| n | | Tab | Change Theme |

### Git Binds
| Mode | Modifier | Bind | Explanation |
| --------------- | --------------- | --------------- | --------------- |
| n | leader | gc | Git commit with message |
| n | leader | gp | Git push |
| n | leader | get | Git pull |


