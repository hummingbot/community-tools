# PR Generator

This script enables user to easily clone pull request from hummingbot repository.

---

## How To Use
When using the script, it clones the hummingbot's main or forked repository. Creates folders and log files where you can check if an error occurred. This approach helps community to easily check in development pull requests if they want to have a use or ran tests.

### Enter respository, branch and folder name

```
Enter the profile of repository to clone (default: hummingbot) >>
Enter branch name to checkout(default: development) >>
Enter folder name (default: hummingbot) >>
```

- Press `return` key to use default values:
  - `humminbgot` respository is selected
  - `development` branch is selected
  - `hummingbot` folder is created
    - if there is existing `hummingbot` folder, creates `hummingbot(1)`


### Output

```
Repository: https://github.com/hummingbot/hummingbot
Checkout branch: development
Directory: /Users/rapcomia/github/hummingbot/hummingbot
Proceed? (default: yes) >>

Cloning GitHub files to 'hummingbot', downloading.. done!
Checking for available hummingbot env, this will take few minutes.. done!
Conda activate hummingbot successfull! compiling files.. done!

===============  HUMMINGBOT SUCCESSFULLY INSTALLED ===============


ℹ️  Repository: https://github.com/hummingbot/hummingbot
ℹ️  Branch: development
ℹ️  Commit: d95109e2275162f10b224d3638e50b677e746a29


Do you want to start the Hummingbot client (default: yes) >>
```

- Displays the repository and checkout branch 
- Displays the directory where the folder is located
- Hide the cloning, installation and compiling process
- Inform user that Hummingbot is successfully installed ready to be use!

When user select `no` on the prompt below, it will display the directory where the folder is located and adds instruction how to launch the hummingbot client 
```
Do you want to start the Hummingbot client (default: yes) >> no

To start Hummingbot client:
1. Go to /Users/rapcomia/github/hummingbot/hummingbot
2. Run 'conda activate hummingbot'
3. Run './start'
```

### Error logging

```
===============  HUMMINGBOT PRGENTR ===============


ℹ️  Press [ENTER] for default values:


Enter the profile of repository to clone (default: hummingbot) >> this-is-a-test-only
Enter branch name to checkout(default: development) >>
Enter folder name (default: hummingbot) >>

Repository: https://github.com/this-is-a-test-only/hummingbot
Checkout branch: development
Directory: /Users/rapcomia/github/hummingbot/hummingbot
Proceed? (default: yes) >>

Cloning GitHub files to 'hummingbot', downloading..


⚠️  Error found, please check 'logs_hummingbot.log' for more info


(base) rapcmia@mishka hummingbot %

```

- When an error occurred in the process, creates a `logs_FOLDER_NAME.log` on the directory where `prgen` is used
- On the example above, we used the default (hummingbot) thats why the `logs_hummingbot.log` is the name
- Below is a sample of a log file when error occurred. Added timestamps 

```
2023-09-15 21:38:38: Cloning into 'hummingbot'...
remote: Repository not found.
fatal: repository 'https://github.com/this-is-a-test-only/hummingbot/' not found 
)
2023-09-15 21:41:22: Cloning into 'hummingbot'...
fatal: Remote branch this-is-a-test-branch not found in upstream origin 
)
```