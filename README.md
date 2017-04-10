# raspbian-zwave-bootstrap

> A quick bootstrap script to build environment for running openzwave on Raspbian

### Usage

Download and run the script as a root user

```shell
wget -q -O - https://raw.githubusercontent.com/techgaun/raspbian-zwave-bootstrap/master/bootstrap.sh | sudo bash
```

### Information

- A user `techgaun` is added to the system by default
- The openzwave and python-openzwave is compiled at `/opt/techgaun` directory by default
- Override the user by passing `ZWAVE_USER` envvar
- Override the root directory by passing `ROOT_DIR` envvar

Example of overriding will look as:


```shell
wget -q -O - https://raw.githubusercontent.com/techgaun/raspbian-zwave-bootstrap/master/bootstrap.sh | \
  ZWAVE_USER=someuser ROOT_DIR=/opt/custompath sudo bash
```
