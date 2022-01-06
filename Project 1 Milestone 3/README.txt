Sam Brandt
Professor Kalpakis
CMSC 461
November 30, 2021

The scripts can all be exececuted by loading them into an instance of MySQL Workbench
and running them directly in the application interface or by running them from a MySQL
command line like this:

mysql -h hostname -u user database < path/to/[filename]

All of my tests were done using the former method so I can guarentee no
success with the later.

Before using the Jupyter Notebook, run createAll.sql and loadAll.sql to
populate the user interface.

The data by default will have place_ids 1, 3, 5
as residences and 2, 4, 6 as health centers. place_ids 1-3 will be in Megapolis, Oheyo
and all of their coordinates will be close to (0, 0), and places 4-6 will be in
The Primary Keys, Floorida and all of their coordinates will be close to (1337, 2021).
PINs 1-6 will be split between residences 1 and 3 and PINs 7-12 will all live in
residence 5. PINs 1-6 will all be registered for health center 2 in December 2021 and
PINs 7-12 will be split between health centers 4 and 6 and split between January and February 2022.
Hopefully this information will make testing easier!