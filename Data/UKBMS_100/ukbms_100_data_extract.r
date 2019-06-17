R --vanilla

library(RPostgreSQL)
library(sf)
library(data.table)

dbcon <- dbConnect(dbDriver('PostgreSQL'),dbname='ebms_v2_0',host='localhost',port=5433,user='postgres', password='postgres')

dbSendStatement(dbcon,"SET work_mem TO \'1GB\';")
dbSendStatement(dbcon,"SET maintenance_work_mem TO \'1GB\';")

grass_indQ <- paste0("SELECT *
                  FROM
                  ebms.b_species_id
                  WHERE
                  species_acpt_sci_name IN
                  (\'Ochlodes sylvanus\',\'Anthocharis cardamines\',\'Lycaena phlaeas\',\'Polyommatus icarus\',\'Lasiommata megera\',\'Coenonympha pamphilus\',\'Maniola jurtina\',\'Erynnis tages\',
                  \'Thymelicus acteon\',\'Spialia sertorius\',\'Cupido minimus\',\'Phengaris arion\',\'Phengaris nausithous\',\'Lysandra bellargus\',\'Cyaniris semiargus\',\'Lysandra coridon\',
                  \'Euphydryas aurinia\');")

grass_ind_spR <- data.table::data.table(dbGetQuery(dbcon, grass_indQ))[order(species_acpt_sci_name),]


## Count
countQ <-
'SELECT
  c.visit_id,
  s.site_id,
  s.bms_id,
  s.transect_id,
  s.section_id,
  EXTRACT(YEAR from v.visit_date) as year,
  EXTRACT(MONTH from v.visit_date) as month,
  EXTRACT(DAY from v.visit_date) as day,
  sp.species_acpt_sci_name as species_name,
  c.butterfly_count
FROM
  ebms.b_count as c
  LEFT JOIN ebms.m_visit as v ON (c.visit_id = v.visit_id)
  LEFT JOIN ebms.m_site as s ON (c.site_id = s.site_id),
  ebms.b_species_id as sp
WHERE
  sp.species_acpt_sci_name IN (\'Ochlodes sylvanus\', \'Anthocharis cardamines\',
                              \'Lycaena phlaeas\', \'Polyommatus icarus\',
                              \'Lasiommata megera\', \'Coenonympha pamphilus\',
                              \'Maniola jurtina\', \'Erynnis tages\',
                              \'Thymelicus acteon\', \'Spialia sertorius\',
                              \'Cupido minimus\', \'Phengaris arion\',
                              \'Phengaris nausithous\', \'Lysandra bellargus\',
                              \'Cyaniris semiargus\', \'Lysandra coridon\',
                              \'Euphydryas aurinia\') AND
  c.species_id = sp.species_id AND
  sp.aggregate = false AND
  EXTRACT(YEAR from v.visit_date) >= 1990 AND
  EXTRACT(YEAR from v.visit_date) <= 2017 AND
  v.completed = TRUE AND
  s.monitoring_type IN (\'31\',\'2\')
ORDER BY
  year,
  month,
  day,
  s.transect_id,
  c.species_id;'

ebms_countR <- data.table::data.table(dbGetQuery(dbcon,countQ))
ebms_countR <- ebms_countR[butterfly_count > 0, ]

## Transect details
transect_coordQ <-
'SELECT
  s.bms_id,
  s.site_id,
  s.transect_id,
  s.section_id,
  s.section_length,
  s.transect_length,
  round(ST_X(g.centroid_geom)) as section_lon,
  round(ST_Y(g.centroid_geom)) as section_lat,
  g.section_geom_true
FROM
  ebms.m_site as s
  LEFT JOIN ebms.m_site_geo as g ON (s.site_id = g.site_id)
WHERE
  s.monitoring_type IN (\'31\',\'2\')
ORDER BY
  bms_id,
  transect_id,
  section_id;'

section_coordR <- data.table::data.table(dbGetQuery(dbcon,transect_coordQ))

fwrite(section_coordR[ site_id %in% unique(section_coordR[ bms_id == 'UKBMS' & !is.na(section_lat), site_id])[1:100], ], "output/ukbms_coord.csv")
fwrite(ebms_countR[site_id %in% unique(section_coordR[ bms_id == 'UKBMS' & !is.na(section_lat), site_id])[1:100], ], "output/ukbms_count.csv")
