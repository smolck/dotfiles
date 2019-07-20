import os


def main():
    stat = None
    try:
        stat = os.statvfs("/")
    except Exception:
        return

    available = (stat.f_bsize * stat.f_bavail) / 1024**3
    total = (stat.f_bsize * stat.f_blocks) / 1024 ** 3
    used = (stat.f_bsize * (stat.f_blocks - stat.f_bfree)) / 1024 ** 3

    available, total, used = round(available, 2), round(total, 2), round(used,
                                                                         2)

    print("{used}/{total}G [{available}G]".format(used=used, total=total,
                                                  available=available))


main()
