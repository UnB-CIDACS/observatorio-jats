#
# Standard procedures to use CSV as a commom SQL table, to link or populate your database.
# See also step01_2-csv2foreign_tables.sql
#

# # # # # # STEP-1_3.1

#... supondo ainda na pasta observatoio-jats...

if [ -d obsjats ]; then
  read -p "Apagar tudo do tmp/obsjats? (S/N)" yn
  case $yn in
      [YySs]* ) rm -r /tmp/obsjats; mkdir /tmp/obsjats; break;;
      [Nn]* ) break;;
      * ) echo "Please answer yes or no.";;
  esac
else
  mkdir /tmp/obsjats
fi
cp data/caches/issn_using_meta.csv /tmp/obsjats
cd /tmp/obsjats

# # # # # # STEP-1_3.2

# tmpcsv_families
wget -c https://raw.githubusercontent.com/ppKrauss/licenses/master/data/families.csv

# tmpcsv_licenses
wget -c https://raw.githubusercontent.com/ppKrauss/licenses/master/data/licenses.csv

# tmpcsv_license_urls
wget -c https://raw.githubusercontent.com/ppKrauss/licenses/master/data/license_urls.csv

# tmpcsv_implieds
wget -c https://raw.githubusercontent.com/ppKrauss/licenses/master/data/implieds.csv

# tmpcsv_dftlic_sciAuthorities
wget -c https://raw.githubusercontent.com/ppKrauss/openCoherence/master/data/samples/sciDocs/dftLicences-sciAuthorities.csv

# tmpcsv_sciRepos
wget -c https://raw.githubusercontent.com/ppKrauss/openCoherence/master/data/sciRepos.csv

# tmpcsv_xpathTransducers
wget -c https://raw.githubusercontent.com/ppKrauss/openCoherence/master/data/xpathTransducers.csv

## medium sized

# tmpcsv_world_cities
wget -c https://raw.githubusercontent.com/datasets/world-cities/master/data/world-cities.csv

## bigdata

# tmpcsv_doaj
wget -c -O doaj.csv https://doaj.org/csv
# awk 'NR>1' doaj.csv > doaj_noHeader.csv

# tmpcsv_pmc_ids
wget -c ftp://ftp.ncbi.nlm.nih.gov/pub/pmc/PMC-ids.csv.gz
gunzip PMC-ids.csv.gz


# # # # # # STEP-1_4

# run SQL for migration (load csv into definitive tables)
