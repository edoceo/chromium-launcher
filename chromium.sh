#!/bin/bash

# Chromium Laucher
# Starts Chromium, but uses it's own dir for profiles
# Typically located in ~/Chrome/

cd $(dirname $(readlink -f $0))

list=$(
    echo "<item>"$(readlink -f ~/.config/chromium)"</item>"
    for f in *
    do
        if [ -d $f ]
        then
            echo "<item>$f</item>"
        fi
    done
)


export MAIN_DIALOG="
<window decorated=\"true\" icon-name=\"chromium-browser\" resizable=\"false\" title=\"Chromium Launcher\" window_position=\"2\">
<vbox>
<frame chrome>
<text>
    <label>Select the Profile Directory</label>
</text>
</frame>
<hbox>
    <combobox><variable>CHROME_PROFILE</variable>
    $list
    </combobox>
</hbox>
<hbox>
    <button>
        <label>Incognito</label>
        <action>chromium --incognito >/dev/null 2>&1 &</action>
        <action>EXIT:done</action>
    </button>
    <button>
        <label>Kiosk</label>
        <action>chromium --kiosk >/dev/null 2>&1 &</action>
        <action>EXIT:done</action>
    </button>
    <button>
        <label>Launch</label>
        <action>chromium --user-data-dir=\$CHROME_PROFILE >/dev/null 2>&1 &</action>
        <action>EXIT:done</action>
    </button>
</hbox>
</vbox>
</window>
"

gtkdialog \
    --center \
    --program=MAIN_DIALOG \
    >/dev/null
