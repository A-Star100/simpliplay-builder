# simpliplay-builder
A simple collection of shellscript(s) that install all dependencies needed to compile every version of SimpliPlay. Most dependencies will be quite large, so you'll have a choice on what to pick.

## How to use
You'll find 4 shellscripts. Change the ownership of the ones you want to execute, for example:
```shell
chmod +x shellscript.sh
```

Once you've done that, you can now choose which one you want to execute. All of their names are self-explanatory, but the flags is what we're interested in.

For `android-tools.sh`, you can use 3 types of flags:

```shell
./android-tools.sh --androidstudio --flutter --repo
```
and one more that is usable in every shellscript:

```shell
./shellscript.sh --all
```
(for people who don't want to type so many different flags, however this flag will ignore all confirmations and force install everything).

If you don't want to force install everything, but want to be asked for confirmation, just execute the script without any flags like this:

```shell
./shellscript.sh
```

For `ios-tools.sh`, you can use 2 types of flags:
```shell
./ios-tools.sh --xcode --repo
```

, for `desktop-tools.sh`, you can use 2 types of flags:

```shell
./desktop-tools.sh --electron --repo
```

and for `all.sh`, you can use 3 types of flags:

```shell
./install-all.sh --android --ios --desktop
```

____________________________________________

Keep in mind that these tools can be **quite large**. XCode by itself is **16 GB**, and that's only the space for the app! You'll need at least **40 GB** of free space to install everything needed to use XCode!

