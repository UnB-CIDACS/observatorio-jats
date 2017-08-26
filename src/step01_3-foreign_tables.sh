#
# Standard procedures to use CSV as a commom SQL table, to link or populate your database.
# See also step01_2-csv2foreign_tables.sql
#

# # # # # # STEP-1_3.1
cd /tmp
#rm -r obsjats
mkdir obsjats

# # # # # # STEP-1_3.2

# tmpcsv_pmc_ids
#wget -c ftp://ftp.ncbi.nlm.nih.gov/pub/pmc/PMC-ids.csv.gz
#gunzip PMC-ids.csv.gz

# tmpcsv_families
wget -c https://raw.githubusercontent.com/ppKrauss/licenses/master/data/families.csv

# tmpcsv_licenses
wget -c https://raw.githubusercontent.com/ppKrauss/licenses/master/data/licenses.csv

# tmpcsv_implieds
wget -c https://raw.githubusercontent.com/ppKrauss/licenses/master/data/implieds.csv

# tmpcsv__dftlic_sciAuthorities
wget -c https://raw.githubusercontent.com/ppKrauss/openCoherence/master/data/samples/sciDocs/dftLicences-sciAuthorities.csv

# tmpcsv__sciRepos
wget -c https://raw.githubusercontent.com/ppKrauss/openCoherence/master/data/sciRepos.csv

# tmpcsv__xpathTransducers
wget -c https://raw.githubusercontent.com/ppKrauss/openCoherence/master/data/xpathTransducers.csv

# # # # # # STEP-1_4

# run SQL for migration (load csv into definitive tables)
