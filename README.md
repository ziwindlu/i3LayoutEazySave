# Easy save i3wm layout

## Usage

save layout

``` shell
git clone https://github.com/ziwindlu/i3LayoutEazySave.git
cd i3LayoutEazySave
bash savei3.sh <workspace_num>
```

restore layout

``` shell
bash ~/.config/i3/sh/workspace_num.sh
```

## Usage Tips

You can restore multiple layouts at once with this simple script

``` shell
#!/bin/bash

for var in  ~/.config/i3/sh/*
do
		bash ${var}
done
```

## feature

- [x] multiple monitor support
- [x] The recovery script automatically starts started applications(imperfect)

## todo

- [x] README internationalization
