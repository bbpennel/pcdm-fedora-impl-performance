echo "====Cleaning up===="
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/nColl
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/nColl/fcr:tombstone

echo "====Basic hierarchy construction===="
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-collection.ttl 127.0.0.1:8080/fcrepo/rest/nColl
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-collection.ttl 127.0.0.1:8080/fcrepo/rest/nColl/nFolder

echo "====Create an aggregate object===="
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/nColl/nFolder/nAgg

curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/nColl/nFolder/nAgg/file0
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/nColl/nFolder/nAgg/file1
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/nColl/nFolder/nAgg/file2

echo "PREFIX cdr: <http://cdr.lib.unc.edu#> INSERT { <> cdr:primaryObject <http://127.0.0.1:8080/fcrepo/rest/nColl/nFolder/nAgg/file0> } WHERE {}
" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/nColl/nFolder/nAgg/fcr:metadata

curl -is -X PUT -H "Content-Type: image/jpeg" --data-binary @page0.jpg 127.0.0.1:8080/fcrepo/rest/nColl/nFolder/nAgg/file0/data-file
curl -is -X PUT -H "Content-Type: image/jpeg" --data-binary @page1.jpg 127.0.0.1:8080/fcrepo/rest/nColl/nFolder/nAgg/file1/data-file
curl -is -X PUT -H "Content-Type: image/jpeg" --data-binary @page2.jpg 127.0.0.1:8080/fcrepo/rest/nColl/nFolder/nAgg/file2/data-file

curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/nColl/nFolder/nAgg/file0/data-file/fcr:metadata
curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/nColl/nFolder/nAgg/file1/data-file/fcr:metadata
curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/nColl/nFolder/nAgg/file2/data-file/fcr:metadata


echo "====Creating a simple file object===="
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/nColl/nFolder/nSimple

curl -is -X PUT -H "Content-Type: image/jpeg" --data-binary @page0.jpg 127.0.0.1:8080/fcrepo/rest/nColl/nFolder/nSimple/data-file
curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/nColl/nFolder/nSimple/data-file/fcr:metadata

echo "Adding MODS metadata"
curl -is -X PUT -H "Content-Type: text/xml" --data-binary @mods.xml 127.0.0.1:8080/fcrepo/rest/nColl/nFolder/nSimple/desc-mods
curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @desc-file.ru 127.0.0.1:8080/fcrepo/rest/nColl/nFolder/nSimple/desc-mods/fcr:metadata


# echo "====Move testing===="
# curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-collection.ttl 127.0.0.1:8080/fcrepo/rest/nColl/nDest/
#
# echo
# echo "Move folder to destination"
# curl -is -X MOVE -H "Destination: http://127.0.0.1:8080/fcrepo/rest/nColl/nDest/nFolder" http://127.0.0.1:8080/fcrepo/rest/nColl/nFolder/
# curl -is -X MOVE -H "Destination: http://127.0.0.1:8080/fcrepo/rest/nColl/file1" http://127.0.0.1:8080/fcrepo/rest/nColl/nDest/nFolder/nAgg/file1/