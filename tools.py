import os
import shutil
import threading
import subprocess
from consolemenu import *
from consolemenu.items import *
from consolemenu.screen import Screen
import bottombar as bb

logo = """

\033[1m\033[94m          _____ \033[0m_\033[94m _\033[0m
\033[94m\033[1m\033[94m _ __ ___|  ___\033[0m(_)\033[94m | ___\033[0m
\033[1m\033[94m| '__/ _ \ |_  | | |/ __|\033[0m
\033[1m\033[94m| | |  __/  _| | | | (__ \033[0m
\033[1m\033[94m|_|  \___|_|   |_|_|\___|\033[0m

"""  # Just fancy refilc logo

menu = ConsoleMenu(logo, "Tools to help with your development <3")
settings_menu = ConsoleMenu()

# Variable to hold verbose state
verbose_value = True  # Default to True

def settings():
    settings_menu.show()


def build():
    # Clear the screen
    Screen.clear()
    
    # Execute the build command and capture its output
    build_command = "cd refilc && flutter build apk"
    process = subprocess.Popen(build_command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    
    # Print "Building..." at the bottom of the terminal
    with bb.add("asd", label='time', right=True, refresh=1):

    
    # Print the output of the build command
    for line in process.stdout:
        print(line.decode().strip())
    
    # Wait for the process to finish
    process.wait()

    # Clear the "Building..." message
    print(" " * 10, end="\r")


def toggle_verbose():
    global verbose_value
    verbose_value = not verbose_value
    # Update verbose menu item text based on the new state
    verbose_item.text = "Toggle verbose output [X]" if verbose_value else "Toggle verbose output [ ]"


# Main menu items
build_item = FunctionItem("🛠 ~ Build", build)
settings_item = FunctionItem("⚙ ~ Settings", settings)
menu.append_item(build_item)
menu.append_item(settings_item)

# Settings menu items
verbose_item = FunctionItem("Toggle verbose output [X]" if verbose_value else "Toggle verbose output [ ]", toggle_verbose)
settings_menu.append_item(verbose_item)

if __name__ == "__main__":
    menu.show()
