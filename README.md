# Sairento-Step The Complete Windows Persistence Framework


A lightweight, menu‑driven batch script that deploys common persistence mechanisms on Windows machines. Ideal for red teaming, CTF challenges, or authorised security assessments.


## ✨ Features

- **Interactive menu** – choose persistence techniques with a single keystroke  
- **No dependencies** – pure batch, runs on any Windows machine (Tested On Windows 10,11)  
- **Multiple persistence methods**  
- **Quick install & remove** – install persistence, then optionally remove it when done (Will be included in new version)  
- **Lightweight & portable** – single `.bat` file, no admin rights required for some options (elevation recommended for some)

## 📋 Persistence Options (Menu)
```
1. Registry-Runkey (HKCU) 
2. Registry-Winlogon (HKCU) 
3. Registry-ScreenSaver (HKCU) 
4. Url-File Creation + DLL URL Exec Help (.URL)
5. Registry-Werfault (Admin - HKLM)
6. Bring Your Own Protocol Handler + URL-File
7. WMI Stealth Persistence
```


> 💡 **Customisation** – Each Techniques reads specific variables and can be customized.

## 🚀 Getting Started

### 1. Clone the repository

```cmd
git clone https://github.com/EynaExp/Sairento-Step
```

Or simply copy `Sairento-Step.bat` to the target Windows machine.

### 2. Go to the repository folder

```cmd
cd Sairento-Step/
```

### 3. Execute the batch file

```cmd
./Sairento-Step.bat
```
Or simply Double Click the file

### 4.Enjoy using the framework

```cmd
⣇⣿⠘⣿⣿⣿⡿⡿⣟⣟⢟⢟⢝⠵⡝⣿⡿⢂⣼⣿⣷⣌⠩⡫⡻⣝⠹⢿⣿⣷
⡆⣿⣆⠱⣝⡵⣝⢅⠙⣿⢕⢕⢕⢕⢝⣥⢒⠅⣿⣿⣿⡿⣳⣌⠪⡪⣡⢑⢝⣇
⡆⣿⣿⣦⠹⣳⣳⣕⢅⠈⢗⢕⢕⢕⢕⢕⢈⢆⠟⠋⠉⠁⠉⠉⠁⠈⠼⢐⢕⢽
⡗⢰⣶⣶⣦⣝⢝⢕⢕⠅⡆⢕⢕⢕⢕⢕⣴⠏⣠⡶⠛⡉⡉⡛⢶⣦⡀⠐⣕⢕
⡝⡄⢻⢟⣿⣿⣷⣕⣕⣅⣿⣔⣕⣵⣵⣿⣿⢠⣿⢠⣮⡈⣌⠨⠅⠹⣷⡀⢱⢕
⡝⡵⠟⠈⢀⣀⣀⡀⠉⢿⣿⣿⣿⣿⣿⣿⣿⣼⣿⢈⡋⠴⢿⡟⣡⡇⣿⡇⡀⢕
⡝⠁⣠⣾⠟⡉⡉⡉⠻⣦⣻⣿⣿⣿⣿⣿⣿⣿⣿⣧⠸⣿⣦⣥⣿⡇⡿⣰⢗⢄
⠁⢰⣿⡏⣴⣌⠈⣌⠡⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣬⣉⣉⣁⣄⢖⢕⢕⢕      By Eyna.
⡀⢻⣿⡇⢙⠁⠴⢿⡟⣡⡆⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣵⣵⣿
⡻⣄⣻⣿⣌⠘⢿⣷⣥⣿⠇⣿⣿⣿⣿⣿⣿⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣷⢄⠻⣿⣟⠿⠦⠍⠉⣡⣾⣿⣿⣿⣿⣿⣿⢸⣿⣦⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟
⡕⡑⣑⣈⣻⢗⢟⢞⢝⣻⣿⣿⣿⣿⣿⣿⣿⠸⣿⠿⠃⣿⣿⣿⣿⣿⣿⡿⠁⣠
⡝⡵⡈⢟⢕⢕⢕⢕⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⣀⣈⠙
⡝⡵⡕⡀⠑⠳⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢉⡠⡲⡫⡪⡪⡣
==============================
    Persistence Main Menu
==============================
1. Registry-Runkey (HKCU)
2. Registry-Winlogon (HKCU)
3. Registry-ScreenSaver (HKCU)
4. Url-File Creation + DLL URL Exec Help (.URL)
5. Registry-Werfault (Admin - HKLM)
6. Bring Your Own Protocol Handler + URL-File
7. WMI Stealth Persistence
8. Guides For Persistence
9. Exit
==============================
```



## 🔧 Requirements

- **OS:** Windows (x86/x64)
- **Privileges:**  
  - Each Techniques requires different Privilege writen on it
- **Batch execution:** Command Prompt (`.bat` files must be allowed by execution policy – no PowerShell needed)

## ⚠️ Disclaimer

**This tool is intended for authorised security testing, educational purposes, and CTF competitions only.**  
Do not use it on systems you do not own or have explicit permission to test. Unauthorised use may violate local laws and organisational policies. The author assumes no liability for misuse.

## 🧹 Removal (Coming soon...)

Run the script again and select option **7 – Remove all persistence**. This deletes:
- The scheduled task
- The registry Run entry
- The Startup folder copy
- The WMI subscription
- The installed service
- The Winlogon Userinit modification (restores default)

Alternatively, manually remove entries using `schtasks`, `reg delete`, `wmic`, etc.

## 🤝 Contributing

Pull requests are welcome!  
If you have a new persistence technique or improvement, please:

1. Fork the repo
2. Create a feature branch (`git checkout -b new-persistence`)
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

Please keep the script **pure batch** and compatible with Windows 7+.

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

## 📬 Contact

Project Link: https://github.com/EynaExp/Sairento-Step

---

**Happy (authorised) persisting!** 🎯


