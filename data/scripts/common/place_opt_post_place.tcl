global STAGE
puts "ICTC:: Save placeOnly dbs"
saveDesign SAVED/${STAGE}_placeOnly.invs
timeDesign -preCTS -pathReports -slackReports -numPaths 1000 -prefix croc_place -outDir ./rpt/${STAGE}/${STAGE}_setup_placeOnly

