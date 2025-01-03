import importlib.util
import subprocess
import sys

def install(package):
    subprocess.check_call([sys.executable, "-m", "pip", "install", package])

# Dictionary mapping required package names to import names
package_mapping = {
    "console-menu": "consolemenu",
    "bottombar": "bottombar"
}

# Check for missing packages
missing_packages = []
for required_package, import_name in package_mapping.items():
    spec = importlib.util.find_spec(import_name)
    if spec is None:
        missing_packages.append(required_package)

# If missing packages are found, ask the user whether to install them
if missing_packages:
    print("The following packages are required but not installed:")
    for package in missing_packages:
        print(f"- {package}")
    install_input = input("Do you want to install them? (yes/no): ").strip().lower()
    if install_input == "yes" or install_input == "y":
        for package in missing_packages:
            print(f"Installing '{package}'...")
            install(package)
    else:
        print("Missing packages were not installed. Exiting.")
        sys.exit()

import os
import shutil
import threading
import subprocess
from consolemenu import *
from consolemenu.items import *
from consolemenu.screen import Screen
import bottombar as bb
from datetime import datetime
import random


logo = """

\033[1m\033[94m          _____ \033[0m_\033[94m _\033[0m             sssssssssssssssssssssssssssssssssss
\033[94m\033[1m\033[94m _ __ ___|  ___\033[0m(_)\033[94m | ___\033[0m       sssssssssssssssssssssssssssssssssss   
\033[1m\033[94m| '__/ _ \ |_  | | |/ __|\033[0m      sssssssssssssssssssssssssssssssssss
\033[1m\033[94m| | |  __/  _| | | | (__ \033[0m      sssssssssssssssssssssssssssssssssss
\033[1m\033[94m|_|  \___|_|   |_|_|\___|\033[0m      sssssssssssssssssssssssssssssssssss

"""  # Just fancy refilc logo

# Convert the string into a list of characters
char_list = list(logo)

# Function to check if a star is adjacent to another star
def is_adjacent_star(index):
    for i in range(max(0, index - 4), min(len(char_list), index + 5)):
        if char_list[i] == '🟊' and abs(index - i) < 4:
            return True
    return False

# Loop through the list and replace 'S' with a star with 10% chance
for i in range(len(char_list)):
    if char_list[i] == 's' and random.random() < 0.10:
        if not is_adjacent_star(i):
            char_list[i] = '🟊'
            
for i in range(len(char_list)):
    if char_list[i] == 's':
            char_list[i] = ' '

# Join the characters back into a string
modified_logo = ''.join(char_list)

menu = ConsoleMenu(modified_logo, "\033[1mTools to help with your development \033[91m<3\033[0m")
settings_menu = ConsoleMenu()

# Variable to hold verbose state
verbose_value = True  # Default to True

def settings():
    settings_menu.show()

def build():
    with bb.add("\033[94mWaiting for process\033[0m", label='Status', right=False, refresh=1):
        with bb.add("🐈 meow", right=True, refresh=1):
            # Clear the screen
            Screen.clear()
            
            # Execute the build command and capture its output
            build_command = "cd refilc && flutter build apk --release --dart-define=APPVER=$(cat pubspec.yaml | grep version: | cut -d' ' -f2 | cut -d+ -f1) --no-tree-shake-icons"
            process = subprocess.Popen(build_command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

            # Capture the output of the build command
            output_lines = []
            for line in process.stdout:
                decoded_line = line.decode().strip()
                output_lines.append(decoded_line)
                print(decoded_line)
            
            # Wait for the process to finish
            process.wait()
            
            # Save the output to a file
            now = datetime.now()
            dt_string = now.strftime("%Y-%m-%d_%H-%M-%S")
            with open("tool_logs/build/build_" + dt_string + ".log", "a") as f:
                for line in output_lines:
                    f.write(line + '\n')

            with bb.add("\nBuild done, press enter to continue \033[93m(Logs can be found at tool_logs/build/)\033[93m", label='Status', right=False, refresh=1):
                input()

def pub_fix():
    with bb.add("\033[94mWaiting for process\033[0m", label='Status', right=False, refresh=1):
        with bb.add("🐈 mrrp", right=True, refresh=1):
            # List of directories
            directories = [
                "refilc",
                "refilc_kreta_api",
                "refilc_mobile_ui",
                "refilc_plus"
            ]
            
            # Open a single log file for all directories
            now = datetime.now()
            dt_string = now.strftime("%Y-%m-%d_%H-%M-%S")
            with open(f"tool_logs/pub_fix/pub_fix_{dt_string}.log", "a") as f:
                # Iterate through directories
                for directory in directories:
                    f.write(f"\n\nCleaning logs for {directory}:\n")
                    
                    # Execute the build command and capture its output
                    os.chdir(directory)
                    clean_process = subprocess.Popen("flutter clean", shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

                    # Capture the output of the clean command
                    output_lines = []
                    for line in clean_process.stdout:
                        decoded_line = line.decode().strip()
                        output_lines.append(decoded_line)
                        f.write(decoded_line + '\n')
                        print(decoded_line)
                    
                    # Wait for the clean process to finish
                    clean_process.wait()

                    # Execute the pub get command and capture its output
                    pub_get_process = subprocess.Popen("flutter pub get", shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

                    # Capture the output of the pub get command
                    for line in pub_get_process.stdout:
                        decoded_line = line.decode().strip()
                        output_lines.append(decoded_line)
                        f.write(decoded_line + '\n')
                        print(decoded_line)
                    
                    # Wait for the pub get process to finish
                    pub_get_process.wait()
                    
                    # Go back to the parent directory
                    os.chdir("..")
                    
            with bb.add("\nFixing done, press enter to continue \033[93m(Logs can be found at tool_logs/pub_fix/)\033[93m", label='Status', right=False, refresh=1):
                input()
                
def fix_d8dx():
    # Determine appropriate commands based on the platform
    with bb.add("\033[94mWaiting for process\033[0m", label='Status', right=False, refresh=1):
        with bb.add("🐈 mrrp", right=True, refresh=1):
            if os.name == 'posix':  # For Unix/Linux/Mac OS
                build_tools_dir = os.path.join(os.environ.get('ANDROID_SDK', ''), 'build-tools', '31.0.0')
                cmd_cd = f"cd {build_tools_dir}"
                cmd_mv_d8 = "mv -v d8 dx"
                cmd_cd_lib = "cd lib"
                cmd_mv_d8_jar = "mv -v d8.jar dx.jar"
            elif os.name == 'nt':  # For Windows
                    build_tools_dir = os.path.join(os.environ.get('ANDROID_SDK', ''), 'build-tools', '31.0.0')
                    cmd_cd = f"cd /d {build_tools_dir}"
                    cmd_mv_d8 = "move /Y d8 dx"
                    cmd_cd_lib = "cd lib"
                    cmd_mv_d8_jar = "move /Y d8.jar dx.jar"
            else:
                print("Unsupported platform.")
                return
    
    # Execute the commands and capture their output
    outputs = []
    commands = [cmd_cd, cmd_mv_d8, cmd_cd_lib, cmd_mv_d8_jar]
    for cmd in commands:
        output = subprocess.run(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, encoding='utf-8')
        outputs.append(output.stdout)
        print(output.stdout)  # Print the output
        
    # Save the output to a log file
    now = datetime.now()
    dt_string = now.strftime("%d-%m-%Y_%H-%M-%S")
    log_file_path = "tool_logs/d8dx_fix/d8dx_fix_" + dt_string + ".log"
    with open(log_file_path, "a") as f:
        for output in outputs:
            f.write(output)
    
    with bb.add("\nFixing done, press enter to continue \033[93m(Logs can be found at " + log_file_path + ")\033[93m", label='Status', right=False, refresh=1):
        if os.name == 'posix':  # For Unix/Linux/Mac OS
            with bb.add("🐈", right=True, refresh=1):
                input()
        elif os.name == 'nt':  # For Windows
            with bb.add("fuck microsooft", right=True, refresh=1):
                input()


def toggle_verbose():
    global verbose_value
    verbose_value = not verbose_value
    # Update verbose menu item text based on the new state
    verbose_item.text = "Toggle verbose output [X]" if verbose_value else "Toggle verbose output [ ]"


# Main menu items
build_item = FunctionItem("🛠 ~ Build", build)
pub_fix_item = FunctionItem("🟊 ~ Fix pub", pub_fix)
d8dx_fix_item = FunctionItem("🟊 ~ Fix d8dx", fix_d8dx)
settings_item = FunctionItem("⚙ ~ Settings", settings)

menu.append_item(build_item)
menu.append_item(pub_fix_item)
menu.append_item(d8dx_fix_item)
menu.append_item(settings_item)

# Settings menu items
verbose_item = FunctionItem("Toggle verbose output [X]" if verbose_value else "Toggle verbose output [ ]", toggle_verbose)
settings_menu.append_item(verbose_item)

if __name__ == "__main__":
    menu.show()
