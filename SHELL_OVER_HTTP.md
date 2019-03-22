# Shell Terminal Over HTTP

[shellinabox](https://github.com/shellinabox/shellinabox) was used to setup a shell terminal over a http request where a user can view a terminal in a browser environment.
This opens up the current environment to be accessible from any modern browser.

## Machine installation

To setup shellinabox simply install the software (we used `apt-get`)

```
sudo apt-get -y --force-yes install shellinabox
```

Once installed exit the `/etc/default/shellinabox` setup to match the following text below

```
SHELLINABOX_DAEMON_START=1
SHELLINABOX_PORT=19110
SHELLINABOX_ARGS="--no-beep -t | --disable-ssl --localhost-only"
```

After updating the shellinabox setup script restart shellinabox

```
sudo /etc/init.d/shellinabox restart
```

Shellinabox should now be automatically running on port `19110` of your machine, to open it up publicly us a ngrok service or the like to forward port `19110` to a tunnel. 🎊
