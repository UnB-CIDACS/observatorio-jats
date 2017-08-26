#
# Standard procedures to use CSV as a commom SQL table, to link or populate your database.
# See also step01_2-csv2foreign_tables.sql
#

# # # # # # STEP-1_3.1
cd /tmp
if [ -d obsjats ]; then
  read -p "Apagar tudo do tmp/obsjats? (S/N)" yn
  case $yn in
      [YySs]* ) rm -r obsjats; break;;
      [Nn]* ) break;;
      * ) echo "Please answer yes or no.";;
  esac
fi
mkdir obsjats
cd obsjats

# # # # # # STEP-1_3.2

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

## bigdata

# tmpcsv_doaj
wget -c -O doaj.csv https://doaj.org/csv
# awk 'NR>1' doaj.csv > doaj_noHeader.csv

# tmpcsv_pmc_ids
wget -c ftp://ftp.ncbi.nlm.nih.gov/pub/pmc/PMC-ids.csv.gz
gunzip PMC-ids.csv.gz


# # # # # # STEP-1_4

# run SQL for migration (load csv into definitive tables)
