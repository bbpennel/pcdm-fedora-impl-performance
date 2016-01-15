echo "====Cleaning up===="
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/hColl
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/hColl/fcr:tombstone

echo "====Constructing base collection for pcdm hierarchical structure===="
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-collection.ttl 127.0.0.1:8080/fcrepo/rest/hColl
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @direct-has-member.ru 127.0.0.1:8080/fcrepo/rest/hColl/m/

echo "====Adding intermediate folder===="
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-collection.ttl 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @direct-has-member.ru 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/

echo "====Adding aggregate===="
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hAgg/
echo
echo "Establishing aggregate proxy"
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @direct-has-member.ru 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hAgg/m/

curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hAgg/m/file0/
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hAgg/m/file1/
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hAgg/m/file2/

# Establish the files
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @direct-has-file.ru 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hAgg/m/file0/files/
curl -is -X PUT -H "Content-Type: image/jpeg" --data-binary @cover.jpg 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hAgg/m/file0/files/data-file
curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hAgg/m/file0/files/data-file/fcr:metadata

curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @direct-has-file.ru 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hAgg/m/file1/files/
curl -is -X PUT -H "Content-Type: image/jpeg" --data-binary @page0.jpg 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hAgg/m/file1/files/data-file
curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hAgg/m/file1/files/data-file/fcr:metadata

curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @direct-has-file.ru 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hAgg/m/file2/files/
curl -is -X PUT -H "Content-Type: image/jpeg" --data-binary @page0.jpg 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hAgg/m/file2/files/data-file
curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hAgg/m/file2/files/data-file/fcr:metadata

echo "====Create simple object===="
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hSimple/
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @direct-has-file.ru 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hSimple/files/
curl -is -X PUT -H "Content-Type: image/jpeg" --data-binary @cover.jpg 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hSimple/files/data-file
curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hSimple/files/data-file/fcr:metadata

echo "Adding MODS metadata"
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @direct-aggregates.ru 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hSimple/aggr/
curl -is -X PUT -H "Content-Type: text/xml" --data-binary @mods.xml 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hSimple/aggr/desc-mods
curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @desc-file.ru 127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/m/hSimple/aggr/desc-mods/fcr:metadata

# echo "====Move testing===="
# curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-collection.ttl 127.0.0.1:8080/fcrepo/rest/hColl/m/hDest/
# curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @direct-has-member.ru 127.0.0.1:8080/fcrepo/rest/hColl/m/hDest/m/
#
# curl -is -X MOVE -H "Destination: http://127.0.0.1:8080/fcrepo/rest/hColl/m/hDest/m/hFolder" http://127.0.0.1:8080/fcrepo/rest/hColl/m/hFolder/
# curl -is -X MOVE-H "Destination: http://127.0.0.1:8080/fcrepo/rest/hColl/m/file1" http://127.0.0.1:8080/fcrepo/rest/hColl/m/hDest/m/hFolder/m/hAgg/m/file1/