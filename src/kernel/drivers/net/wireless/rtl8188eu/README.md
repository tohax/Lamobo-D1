rtl8188eu
=========

Realtek rtl8188eu Wifi driver support for Linux kernels beyond
version 3.9.

The Realtek drivers for the rtl8133eu are no longer supported 
in Linux kernels after 3.9 because of kernel API changes.  This 
repository is meant to provide changes to the last supported 
rtl8188eu drivers so they continue to function in newer Linux
kernels.

The latest Linux kernels do support the rtl8188eu in the 
drivers/staging directory.  However, this driver lacks concurrent
support for the dual MAC in the rtl8188eu chipset as well as the
/proc/net/rtl8188eu file system which contains status and 
debugging information required by some runtime tools.  This 
drivers maintins this important functionality in the newer
Linux kernels.

The basis for this source code is from the following Realtek
driver source code file:

rtl8188EUS_rtl8189ES_linux_v4.1.8_9499.20131104.tar.gz

IMPORTANT: The code in this repository is not supported and is
offerred only in the hope that it may be useful to others wishing 
to support their rtl8188eu devices in newer Linux kernels.  

