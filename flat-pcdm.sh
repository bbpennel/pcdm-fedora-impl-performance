# PCDM construction with flat structure
echo "====Cleaning up===="
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/pColl
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/pColl/fcr:tombstone
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/objects/pFolder/
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/objects/pFolder/fcr:tombstone
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/objects/pAgg/
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/objects/pAgg/fcr:tombstone
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/objects/pfile0/
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/objects/pfile0/fcr:tombstone
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/objects/pfile1/
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/objects/pfile1/fcr:tombstone
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/objects/pfile2/
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/objects/pfile2/fcr:tombstone
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/objects/pSimple/
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/objects/pSimple/fcr:tombstone
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/objects/pDest/
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/objects/pDest/fcr:tombstone

echo "====Constructing base collection for pcdm flat structure===="
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-collection.ttl 127.0.0.1:8080/fcrepo/rest/pColl
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-indirect-to-parent.ttl 127.0.0.1:8080/fcrepo/rest/pColl/members/

echo "====Creating objects container if it doesn't exist===="
curl -is -X PUT 127.0.0.1:8080/fcrepo/rest/objects

echo "====Adding intermediate folder===="
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-collection.ttl 127.0.0.1:8080/fcrepo/rest/objects/pFolder/
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-indirect-to-parent.ttl 127.0.0.1:8080/fcrepo/rest/objects/pFolder/members/

# Attach proxy to add folder to collection
echo "
@prefix ore: <http://www.openarchives.org/ore/terms/>
<> ore:proxyFor </fcrepo/rest/objects/pFolder/> ;
   ore:proxyIn </fcrepo/rest/pColl/> .
" | curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @- 127.0.0.1:8080/fcrepo/rest/pColl/members/folderProxy



echo "====Building aggregate object===="
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/objects/pAgg/
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-indirect-to-parent.ttl 127.0.0.1:8080/fcrepo/rest/objects/pAgg/members/

# Attach proxy to add aggregate to folder
echo "
@prefix ore: <http://www.openarchives.org/ore/terms/>
<> ore:proxyFor </fcrepo/rest/objects/pAgg/> ;
   ore:proxyIn </fcrepo/rest/objects/pFolder/> .
" | curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @- 127.0.0.1:8080/fcrepo/rest/objects/pFolder/members/aggProxy

curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/objects/pfile0/
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/objects/pfile1/
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/objects/pfile2/

# Assign primary object
echo
echo "Assigning primary object to aggregate"
echo "PREFIX cdr: <http://cdr.lib.unc.edu#> 
INSERT { <> cdr:primaryObject <http://127.0.0.1:8080/fcrepo/rest/objects/pfile0> } WHERE {}
" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/objects/pAgg/fcr:metadata

echo
echo "Establishing aggregate members proxy"
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-indirect-to-parent.ttl 127.0.0.1:8080/fcrepo/rest/objects/pAgg/members/

# Create the proxies for individual objects
echo
echo "Adding child member proxies to aggregate"
echo "@prefix ore: <http://www.openarchives.org/ore/terms/>
<> ore:proxyFor </fcrepo/rest/objects/pfile0> ;
   ore:proxyIn  </fcrepo/rest/objects/pAgg> .
" | curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @- 127.0.0.1:8080/fcrepo/rest/objects/pAgg/members/file0Proxy
echo "@prefix ore: <http://www.openarchives.org/ore/terms/>
<> ore:proxyFor </fcrepo/rest/objects/pfile1> ;
   ore:proxyIn  </fcrepo/rest/objects/pAgg> .
" | curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @- 127.0.0.1:8080/fcrepo/rest/objects/pAgg/members/file1Proxy
echo "@prefix ore: <http://www.openarchives.org/ore/terms/>
<> ore:proxyFor </fcrepo/rest/objects/pfile2> ;
   ore:proxyIn  </fcrepo/rest/objects/pAgg> .
" | curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @- 127.0.0.1:8080/fcrepo/rest/objects/pAgg/members/file2Proxy


# Establish the files
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @direct-has-file.ru 127.0.0.1:8080/fcrepo/rest/objects/pfile0/files/
curl -is -X PUT -H "Content-Type: image/jpeg" --data-binary @cover.jpg 127.0.0.1:8080/fcrepo/rest/objects/pfile0/files/data-file
curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/objects/pfile0/files/data-file/fcr:metadata

curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @direct-has-file.ru 127.0.0.1:8080/fcrepo/rest/objects/pfile1/files/
curl -is -X PUT -H "Content-Type: image/jpeg" --data-binary @page0.jpg 127.0.0.1:8080/fcrepo/rest/objects/pfile1/files/data-file
curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/objects/pfile1/files/data-file/fcr:metadata

curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @direct-has-file.ru 127.0.0.1:8080/fcrepo/rest/objects/pfile2/files/
curl -is -X PUT -H "Content-Type: image/jpeg" --data-binary @page1.jpg 127.0.0.1:8080/fcrepo/rest/objects/pfile2/files/data-file
curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/objects/pfile2/files/data-file/fcr:metadata


echo "====Create simple object===="
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/objects/pSimple/
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @direct-has-file.ru 127.0.0.1:8080/fcrepo/rest/objects/pSimple/files/
curl -is -X PUT -H "Content-Type: image/jpeg" --data-binary @cover.jpg 127.0.0.1:8080/fcrepo/rest/objects/pSimple/files/data-file
curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/objects/pSimple/files/data-file/fcr:metadata

echo "Adding MODS metadata"

curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @direct-aggregates.ru 127.0.0.1:8080/fcrepo/rest/objects/pSimple/aggr/
curl -is -X PUT -H "Content-Type: text/xml" --data-binary @mods.xml 127.0.0.1:8080/fcrepo/rest/objects/pSimple/aggr/pdesc-mods
curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @desc-file.ru 127.0.0.1:8080/fcrepo/rest/objects/pSimple/aggr/pdesc-mods/fcr:metadata

echo "Adding simple object to folder"
echo "
@prefix ore: <http://www.openarchives.org/ore/terms/>
<> ore:proxyFor </fcrepo/rest/objects/pSimple/> ;
   ore:proxyIn </fcrepo/rest/objects/pFolder/> .
" | curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @- 127.0.0.1:8080/fcrepo/rest/objects/pFolder/members/simpleProxy

# echo
# echo "====Move testing===="
# curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-collection.ttl 127.0.0.1:8080/fcrepo/rest/objects/pDest/
# curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-indirect-to-parent.ttl 127.0.0.1:8080/fcrepo/rest/objects/pDest/members/
#
# echo "
# @prefix ore: <http://www.openarchives.org/ore/terms/>
# <> ore:proxyFor </fcrepo/rest/objects/pDest/> ;
#    ore:proxyIn </fcrepo/rest/pColl/> .
# " | curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @- 127.0.0.1:8080/fcrepo/rest/pColl/members/destProxy
#
# curl -is -X MOVE -H "Destination: http://127.0.0.1:8080/fcrepo/rest/objects/pDest/members/folderProxy" http://127.0.0.1:8080/fcrepo/rest/pColl/members/folderProxy
# echo "PREFIX ore: <http://www.openarchives.org/ore/terms/>
# DELETE {
#   <> ore:proxyIn </fcrepo/rest/pColl/> .
# } INSERT {
#   <> ore:proxyIn </fcrepo/rest/objects/pDest/> .
# } WHERE {
# }" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- http://127.0.0.1:8080/fcrepo/rest/objects/pDest/members/folderProxy
#
# curl -is -X MOVE -H "Destination: http://127.0.0.1:8080/fcrepo/rest/pColl/members/file1Proxy" http://127.0.0.1:8080/fcrepo/rest/objects/pAgg/members/file1Proxy
# echo "PREFIX ore: <http://www.openarchives.org/ore/terms/>
# DELETE {
#   <> ore:proxyIn </fcrepo/rest/objects/pAgg/> .
# } INSERT {
#   <> ore:proxyIn </fcrepo/rest/pColl/> .
# } WHERE {
# }" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- http://127.0.0.1:8080/fcrepo/rest/pColl/members/file1Proxy