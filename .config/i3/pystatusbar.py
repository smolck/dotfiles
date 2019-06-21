from i3pystatus import Status

status = Status()

# Displays clock like this:
# Tue 30 Jul 11:59:46 PM KW31
#                          ^-- calendar week
status.register("clock",
                format="%a %-d %b %X KW%V",
                color="#ff8080")

# Shows CPU temperature, if you have a Intel CPU
status.register("temp",
                format="{temp:.0f}°C",
                color="#62d196")

# Shows disk usage of /
# Format: 42/128G [86G]
status.register("disk",
                path="/",
                format="{used}/{total}G [{avail}G]",
                color="#63f2f1")

# Shows audio level
status.register("alsa",
                format="Volume {volume}%",
                color="#c991e1")

# Shows screen brightness
status.register("backlight",
                format="Brightness {percentage}%",
                color="#63f2f1",
                backlight="intel_backlight")

# Note: the network module requires PyPI package netifaces
status.register("network",
                interface="eth0",
                format_up="{v4cidr}",
                format_down="")

# Note: requires both netifaces and basiciw (for essid and quality)
status.register("network",
                interface="wlp5s0",
                format_up="{essid} {quality}%",
                color_up="#62d196")


# Shows battery status
status.register("battery",
                format="{status}{consumption:.2f}W {percentage:.2f}% " +
                "{remaining:%E%hh:%Mm}",
                full_color="#c991e1",
                color="#c991e1",
                charging_color="#c991e1",
                alert=True,
                alert_percentage=5,
                status={
                    "DIS": "↓",
                    "CHR": "↑",
                    "FULL": "",
                },)

# Shows memory usage
status.register("mem",
                format="{used_mem}GB/{total_mem}GB {percent_used_mem}%",
                color="#ff8080",
                divisor=1024**3)

status.run()
