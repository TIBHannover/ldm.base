# Leibniz Data Manager in a Box

The Leibniz Data Manager ist a Research Data Management System based on [CKAN](https://ckan.org/). It currently offers the following functions for the visualization of research data:

* Supports data collections and publications with different formats
* Different views on the same data set (2D and 3D support)
* Visualization of Auto CAD files
* Jupyter Notes for demonstrating live code
* RDF Description of data collections

This project creates Leibniz Data Manager in a VirtualBox with
* [Git](https://git-scm.com/downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

The project is based on [SDM-TIB/TIB_Data_Manager](https://github.com/SDM-TIB/TIB_Data_Manager)  which creates Leibniz Data Manager with Docker.

## Installation

Run the following steps in Terminal (Linux/macOS) or GitBash (Windows):
```
git clone https://git.tib.eu/boxes/leibniz-data-manager-box.git
cd leibniz-data-manager-box
vagrant up
```

After installation has finished (about 15min), call Leibniz Data Manager in a browser with
```
http://192.168.98.106:5000/
```

## Default credentials

Login for web application
```
ckan = admin:admin
db = ckan:ckan
```

Login for VirtualBox
```
vagrant ssh
```
