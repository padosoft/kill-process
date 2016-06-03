
# kill-process
Bash script to kill high CPU and long running process. 

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

If you want to run programmatically, add it to cronjobs manually or execute install script:

``` bash
cd /root/myscript/kill-process
chmod +x install.sh
bash install.sh
```


# Usage
``` bash
bash killprocess.sh [dry|kill|--help] [top|ps] [cpu|time]
```

## Example
``` bash
bash killprocess.sh dry
bash killprocess.sh dry top
bash killprocess.sh kill top cpu
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
