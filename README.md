
# kill-process
Bash script to kill high CPU process, long running process and too much consuming memory process. 

[![Software License][ico-license]](LICENSE.md)

Table of Contents
=================

  * [kill-process](#kill-process)
  * [Table of Contents](#table-of-contents)
  * [Prerequisites](#prerequisites)
  * [Install](#install)
  * [Usage](#usage)
  * [Example](#example)
  * [Screenshots](#screenshots)
  * [Contributing](#contributing)
  * [Credits](#credits)
  * [About Padosoft](#about-padosoft)
  * [License](#license)

# Prerequisites

bash

# Install

This package can be installed easy.

``` bash
cd /root/myscript
git clone https://github.com/padosoft/kill-process.git
cd kill-process
chmod +x killprocess.sh
```

If you want to set your value and override default var values create a killprocess.config file by coping the given template killprocess.config.template, open in your favorite editor and make changes:

``` bash
cp /root/myscript/kill-process/killprocess.config.template /root/myscript/kill-process/killprocess.config 

nano /root/myscript/kill-process/killprocess.config
```

If you want to run programmatically, add it to cronjobs manually or execute install script:

``` bash
cd /root/myscript/kill-process
chmod +x install.sh
bash install.sh
```


# Usage
``` bash
bash killprocess.sh [dry|kill|--help] [top|ps] [cpu|time|mem]
```

## Example
``` bash
bash killprocess.sh dry
bash killprocess.sh dry top
bash killprocess.sh kill top cpu
bash killprocess.sh dry ps mem
bash killprocess.sh kill ps mem
```
For help:
``` bash
bash killprocess.sh 
bash killprocess.sh --help
```

# Screenshots

Here is a screenshot with command kill

![demo](https://raw.githubusercontent.com/padosoft/kill-process/master/resources/img/screen1.png)

Here is a screenshot with command dry (dry run and not kill)

![demo](https://raw.githubusercontent.com/padosoft/kill-process/master/resources/img/screen2.png)

# Contributing

Please see [CONTRIBUTING](CONTRIBUTING.md) and [CONDUCT](CONDUCT.md) for details.


# Credits

- [Lorenzo Padovani](https://github.com/lopadova)
- [Padosoft](https://github.com/padosoft)
- [All Contributors](../../contributors)

# About Padosoft
Padosoft is a software house based in Florence, Italy. Specialized in E-commerce and web sites.

# License

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.

[ico-license]: https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square
